#!/usr/bin/env bash
# evals/run.sh — stage and grade an eval case (PROJECT_RULES.md rule 5).
#
#   bash evals/run.sh stage <case-id>              # isolate input/, print the prompt
#   bash evals/run.sh grade <case-id> <report.md>  # score a report against case.yaml
#   bash evals/run.sh list                         # cases and whether they have run
#   bash evals/run.sh smoke                        # the fast tier — run after any prompt edit
#
# WHY STAGING EXISTS AT ALL — this is the load-bearing part, not the grading.
#
# Two failure modes occurred that no wording in a prompt could prevent:
#
#   * Answer-key leakage (haruto-001, 2026-07-31). case.yaml holds `expected`
#     and `must_not_find`; the case README describes every planted defect.
#     Both sit in the PARENT of input/. An agent pointed at the case directory
#     read them, and nothing in its output looked wrong — leakage is invisible
#     in the result, which is what makes it dangerous.
#   * Read-only violation (victor-001, same day). A dispatched specialist
#     imported a fixture module, writing __pycache__/ into input/.
#
# Both have the same fix and it is not a better sentence in the brief:
# hand the agent an isolated COPY, outside the repo, with no answer key
# anywhere above it. Read-only-by-instruction is an honour system, and an
# honour system is not a gate.
#
# WHAT THIS SCRIPT DOES NOT DO: invoke the agent. That needs API access and
# tokens, so it cannot run in free CI, and pretending otherwise would be a
# fake gate. The human or orchestrator invokes; this script isolates the
# inputs beforehand and applies evals/README.md's pass criterion afterwards —
# mechanically, identically, every time.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CASES_DIR="$REPO_DIR/evals/cases"
STAGE_ROOT="${TMPDIR:-/tmp}/consilium-evals"

die() { echo "error: $1" >&2; exit 2; }

resolve_case() {
    local id="$1" hit
    [ -d "$CASES_DIR/$id" ] && { echo "$CASES_DIR/$id"; return; }
    hit=$(find "$CASES_DIR" -maxdepth 1 -type d -name "${id}*" | head -1)
    [ -n "$hit" ] || die "no case matching '$id' in evals/cases/"
    echo "$hit"
}

# --- stage -----------------------------------------------------------------
cmd_stage() {
    local dir; dir="$(resolve_case "$1")"
    local id; id="$(basename "$dir")"
    [ -d "$dir/input" ] || die "$id has no input/ directory"

    local dest="$STAGE_ROOT/$id"
    rm -rf "$dest"; mkdir -p "$dest"
    cp -R "$dir/input/." "$dest/"

    # Anything the agent must not see must not be reachable from the copy.
    #
    # `case.yaml` is stripped only at the TOP of the staged tree. The answer key
    # lives in the PARENT of input/ and is never copied here anyway, so this is
    # belt-and-braces; matching at any depth is not. lian-001's input is a
    # fixture ABOUT fixtures and ships a mock `evals/cases/tam-001/case.yaml`
    # as scenery — an unbounded `find -name case.yaml` deleted it, silently
    # handing the agent a different scenario than the author wrote, and one that
    # happens to be exactly the "no fixture" condition the case turns on.
    # Found 2026-08-04 by Check 18.
    find "$dest" -maxdepth 1 -name 'case.yaml' -exec rm -rf {} + 2>/dev/null || true
    find "$dest" -name '__pycache__' -exec rm -rf {} + 2>/dev/null || true

    echo "staged: $dest"
    echo
    echo "--- prompt (append the isolation clause below verbatim) ---"
    sed -n '/^prompt:/,/^[a-z_]*:/p' "$dir/case.yaml" \
        | sed '1d;$d' | sed 's/^  //'
    echo
    echo "Treat $dest as the entire project. Read ONLY files inside it."
    echo "STRICT: read-only — do not create, edit, or delete anything there."
    echo
    echo "--- agent ---"
    grep -m1 '^agent:' "$dir/case.yaml" | sed 's/^agent: *//'
    echo
    echo "Then: bash evals/run.sh grade $id <report-file>"
}

# --- grade -----------------------------------------------------------------
# Applies evals/README.md's criterion exactly: every `expected` entry must
# match AND no `must_not_find` entry may match. No partial credit — that is
# explicitly out of scope, and inventing a second criterion here would be a
# rule-5 violation by the grader itself.
cmd_grade() {
    local dir; dir="$(resolve_case "$1")"
    local id; id="$(basename "$dir")"
    local report="$2"
    [ -f "$report" ] || die "report file not found: $report"

    local body; body="$(tr '[:upper:]' '[:lower:]' < "$report")"
    local fails=0 checks=0

    # Leakage first: a run that saw the answer key has no verdict at all.
    #
    # The terms are evidence of leakage only when they are NOT in what the agent
    # was given. `nadia-002` reviews a run against a criteria file, so its input
    # legitimately contains `must_not_find` — and a correct report naming the
    # section by its real name was being VOIDed for using the vocabulary of the
    # thing it was asked to review. Found 2026-08-05 while authoring that case:
    # the detector was punishing a correct report, the same shape as the
    # thirty-one imperative guards fixed the same day, this time in the grader.
    #
    # So a term found in the case's own input/ proves nothing and is dropped
    # from the pattern. This does not weaken rule 5: a term that is NOT in the
    # input still voids, which is exactly the haruto-001 and victor-001 case.
    local leak_terms='case\.yaml|must_not_find|planted defect'
    local t kept=''
    for t in 'case\.yaml' 'must_not_find' 'planted defect'; do
        if grep -rqiE -- "$t" "$dir/input" 2>/dev/null; then continue; fi
        kept="${kept:+$kept|}$t"
    done
    leak_terms="$kept"
    if [ -n "$leak_terms" ] && grep -qiE "$leak_terms" "$report"; then
        echo "VOID — the report references the answer key (case.yaml / must_not_find /"
        echo "       'planted defect'). Per rule 5 a leaked run has no verdict."
        echo "       Re-run against a staged copy: bash evals/run.sh stage $id"
        exit 1
    fi

    echo "grading $id against $(basename "$report")"
    echo

    # expected: kind:keyword -> any_of ; kind:location -> file + a line in range
    while IFS='|' read -r kind file lo hi terms; do
        [ -z "$kind" ] && continue
        checks=$((checks + 1))
        local matched=0 detail=""

        while IFS= read -r term; do
            [ -z "$term" ] && continue
            if printf '%s' "$body" | grep -qF -- "$(printf '%s' "$term" | tr '[:upper:]' '[:lower:]')"; then
                matched=1; detail="$term"; break
            fi
        done < <(printf '%s\n' "$terms" | tr '\037' '\n')

        if [ "$kind" = "location" ]; then
            local file_ok=0 line_ok=0
            printf '%s' "$body" | grep -qF -- "$(printf '%s' "$file" | tr '[:upper:]' '[:lower:]')" && file_ok=1
            local n
            for ((n=lo; n<=hi; n++)); do
                if printf '%s' "$body" | grep -qE "(:|line )$n\b"; then line_ok=1; break; fi
            done
            # A report may cite a RANGE ("file.py:13-18") that brackets the
            # expected lines without naming one of them. Overlap counts: the
            # criterion is "did it point at the right place", not "did it
            # phrase the location the way the fixture author happened to".
            # Found 2026-08-04 when a correct mira-001 run graded FAIL.
            if [ "$line_ok" = 0 ]; then
                while IFS=- read -r a b; do
                    [ -z "$b" ] && continue
                    if [ "$a" -le "$hi" ] && [ "$b" -ge "$lo" ]; then line_ok=1; break; fi
                done < <(printf '%s' "$body" | grep -oE '[0-9]+-[0-9]+')
            fi
            if [ "$file_ok" = 1 ] && [ "$line_ok" = 1 ] && [ "$matched" = 1 ]; then
                echo "  PASS  location $file:$lo-$hi  (keyword: $detail)"
            else
                echo "  FAIL  location $file:$lo-$hi  file=$file_ok line-in-range=$line_ok keyword=$matched"
                fails=$((fails + 1))
            fi
        else
            if [ "$matched" = 1 ]; then
                echo "  PASS  keyword  (matched: $detail)"
            else
                echo "  FAIL  keyword  — none of the any_of terms appear"
                fails=$((fails + 1))
            fi
        fi
    done < <(awk -f "$SCRIPT_DIR/parse_case.awk" -v section=expected "$dir/case.yaml")

    # must_not_find: ANY hit fails the case.
    while IFS='|' read -r _kind _f _lo _hi terms; do
        [ -z "$terms" ] && continue
        checks=$((checks + 1))
        local hit=""
        while IFS= read -r term; do
            [ -z "$term" ] && continue
            if printf '%s' "$body" | grep -qF -- "$(printf '%s' "$term" | tr '[:upper:]' '[:lower:]')"; then
                hit="$term"; break
            fi
        done < <(printf '%s\n' "$terms" | tr '\037' '\n')
        if [ -n "$hit" ]; then
            echo "  FAIL  must_not_find — report contains: \"$hit\""
            fails=$((fails + 1))
        else
            echo "  PASS  must_not_find"
        fi
    done < <(awk -f "$SCRIPT_DIR/parse_case.awk" -v section=must_not_find "$dir/case.yaml")

    # --- declared defects: diagnostic only, never part of the verdict --------
    # Rule 5 admits exactly one eval pass criterion, so this cannot move it.
    # What it CAN do is make an uncredited-but-correct finding visible. Several
    # cases carry real defects that are not in `expected` — found while auditing
    # the inputs (PF-011) and declared rather than deleted, because an
    # undeclared true defect makes a thorough audit score no better than a
    # shallow one. Before this block those defects were recorded in prose that
    # nothing read.
    local dd_total=0 dd_hit=0 dd_out=""
    while IFS='|' read -r _k dfile _lo _hi dterms; do
        [ -z "$dterms" ] && continue
        dd_total=$((dd_total + 1))
        local dmatch=""
        while IFS= read -r term; do
            [ -z "$term" ] && continue
            if printf '%s' "$body" | grep -qF -- "$(printf '%s' "$term" | tr '[:upper:]' '[:lower:]')"; then
                dmatch="$term"; break
            fi
        done < <(printf '%s\n' "$dterms" | tr '\037' '\n')
        if [ -n "$dmatch" ]; then
            dd_hit=$((dd_hit + 1))
            dd_out="$dd_out  mentioned      ${dfile:-defect} (\"$dmatch\")"$'\n'
        else
            dd_out="$dd_out  NOT mentioned  ${dfile:-defect}"$'\n'
        fi
    done < <(awk -f "$SCRIPT_DIR/parse_case.awk" -v section=declared_defects "$dir/case.yaml")

    if [ "$dd_total" -gt 0 ]; then
        echo
        echo "declared defects: $dd_hit of $dd_total mentioned  (diagnostic — not part of the verdict)"
        printf '%s' "$dd_out"
        echo "  NOT MEASURED: findings that match no declared defect. A report is prose;"
        echo "  findings are not delimited, and counting rows counts non-findings — that"
        echo "  exact error has already been made twice in this suite. Precision is read,"
        echo "  not computed."
    fi

    echo
    if [ "$checks" -eq 0 ]; then
        echo "INCONCLUSIVE — no criteria parsed from $id/case.yaml"
        exit 1
    fi
    if [ "$fails" -eq 0 ]; then
        echo "PASS — $checks criteria, 0 failed"
        echo
        echo "Grading is necessary, not sufficient. It cannot see precision: a report"
        echo "that finds the planted defect and four things that are not there scores"
        echo "identically to a clean one. Read the report before recording a verdict."
    else
        echo "FAIL — $checks criteria, $fails failed"
    fi
    [ "$fails" -eq 0 ]
}

# --- smoke ---------------------------------------------------------------
# The tier to run after any prompt edit; the full suite before a release.
#
# MEMBERSHIP IS FIXED, by `tier: smoke` in the case, and deliberately so. It was
# considered whether smoke should instead select the STALE cases, so the cheapest
# re-run targets the verdicts that no longer describe the current prompts. It
# should not:
#
#   * A tier whose membership moves with history cannot be compared across
#     edits. "Smoke was green before my change and green after" only means
#     something if it was the same smoke.
#   * Staleness is a coverage question, not a speed one, and it grows: thirteen
#     cases are stale today, which is not a fast tier.
#
# What smoke DOES owe the person about to run it is the state of its own
# baselines, so the marker is printed beside each member. The id stays in column
# one; `cut -d" " -f1` still works.
cmd_smoke() {
    local d id agent last touched mark
    for d in "$CASES_DIR"/*/; do
        grep -q '^tier: smoke' "$d/case.yaml" 2>/dev/null || continue
        id="$(basename "$d")"
        agent="$(grep -m1 '^agent:' "$d/case.yaml" 2>/dev/null | sed 's/^agent: *//')"
        last="$(grep -oiE 'run \(20[0-9]{2}-[0-9]{2}-[0-9]{2}' "$d/case.yaml" 2>/dev/null \
                | grep -oE '20[0-9]{2}-[0-9]{2}-[0-9]{2}' | sort | tail -1 || true)"
        if [ -z "$last" ]; then
            mark="  (NEVER RUN — no baseline to compare against)"
        else
            touched="$(git -C "$REPO_DIR" log -1 --format=%ad --date=short \
                       -- "agents/${agent}.md" 2>/dev/null || true)"
            if [ -n "$touched" ] && [[ "$last" < "$touched" ]]; then
                mark="  (STALE baseline — ran $last, prompt changed $touched)"
            else
                mark=""
            fi
        fi
        printf '%s%s\n' "$id" "$mark"
    done
}

# --- list ------------------------------------------------------------------
# A verdict is only about the prompt that produced it. When an agent's file
# changes after its last recorded run, the recorded PASS describes an agent that
# no longer exists — and nothing said so at the point of use. The 2026-08-04
# slimming pass left 13 of 25 cases in exactly that state and it was visible only
# on the board (PF-012). Comparing per-agent beats a global cutoff: an agent
# untouched since its run is not stale just because a different one changed.
cmd_list() {
    printf '%-42s %-22s %s\n' CASE AGENT "RUN RECORD"
    for d in "$CASES_DIR"/*/; do
        local id agent run last touched
        id="$(basename "$d")"
        agent="$(grep -m1 '^agent:' "$d/case.yaml" 2>/dev/null | sed 's/^agent: *//')"
        last="$(grep -oiE 'run \(20[0-9]{2}-[0-9]{2}-[0-9]{2}' "$d/case.yaml" 2>/dev/null \
                | grep -oE '20[0-9]{2}-[0-9]{2}-[0-9]{2}' | sort | tail -1 || true)"
        # `|| true` is load-bearing: grep exits 1 for a case with no run record,
        # which is the NORMAL case here, and under `set -euo pipefail` the
        # assignment inherits that status and kills the loop after the header.
        # Third time this trap has been hit in this file's family (Checks 17, 18).
        if [ -z "$last" ]; then
            run="NEVER RUN"
        else
            touched="$(git -C "$REPO_DIR" log -1 --format=%ad --date=short \
                       -- "agents/${agent}.md" 2>/dev/null)"
            if [ -n "$touched" ] && [[ "$last" < "$touched" ]]; then
                run="STALE — ran $last, prompt changed $touched"
            else
                run="run $last"
            fi
        fi
        printf '%-42s %-22s %s\n' "$id" "${agent:-?}" "$run"
    done
}

case "${1:-}" in
    stage) [ $# -ge 2 ] || die "usage: run.sh stage <case-id>"; cmd_stage "$2" ;;
    grade) [ $# -ge 3 ] || die "usage: run.sh grade <case-id> <report-file>"; cmd_grade "$2" "$3" ;;
    list)  cmd_list ;;
    smoke) cmd_smoke ;;
    *) echo "usage: run.sh {stage <case>|grade <case> <report>|list|smoke}" >&2; exit 2 ;;
esac
