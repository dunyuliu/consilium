#!/usr/bin/env bash
# evals/run.sh — stage and grade an eval case (PROJECT_RULES.md rule 5).
#
#   bash evals/run.sh stage <case-id>              # isolate input/, print the prompt
#   bash evals/run.sh grade <case-id> <report.md>  # score a report against case.yaml
#   bash evals/run.sh list                         # cases and whether they have run
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
    find "$dest" \( -name 'case.yaml' -o -name '__pycache__' \) -exec rm -rf {} + 2>/dev/null || true

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
    if grep -qiE 'case\.yaml|must_not_find|planted defect' "$report"; then
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
        done < <(printf '%s' "$terms" | tr '\037' '\n')

        if [ "$kind" = "location" ]; then
            local file_ok=0 line_ok=0
            printf '%s' "$body" | grep -qF -- "$(printf '%s' "$file" | tr '[:upper:]' '[:lower:]')" && file_ok=1
            local n
            for ((n=lo; n<=hi; n++)); do
                if printf '%s' "$body" | grep -qE "(:|line )$n\b"; then line_ok=1; break; fi
            done
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
        done < <(printf '%s' "$terms" | tr '\037' '\n')
        if [ -n "$hit" ]; then
            echo "  FAIL  must_not_find — report contains: \"$hit\""
            fails=$((fails + 1))
        else
            echo "  PASS  must_not_find"
        fi
    done < <(awk -f "$SCRIPT_DIR/parse_case.awk" -v section=must_not_find "$dir/case.yaml")

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

# --- list ------------------------------------------------------------------
cmd_list() {
    printf '%-42s %-22s %s\n' CASE AGENT "RUN RECORD"
    for d in "$CASES_DIR"/*/; do
        local id agent run
        id="$(basename "$d")"
        agent="$(grep -m1 '^agent:' "$d/case.yaml" 2>/dev/null | sed 's/^agent: *//')"
        if grep -qiE 'first run \(|second run \(' "$d/case.yaml" 2>/dev/null; then
            run="run"
        else
            run="NEVER RUN"
        fi
        printf '%-42s %-22s %s\n' "$id" "${agent:-?}" "$run"
    done
}

case "${1:-}" in
    stage) [ $# -ge 2 ] || die "usage: run.sh stage <case-id>"; cmd_stage "$2" ;;
    grade) [ $# -ge 3 ] || die "usage: run.sh grade <case-id> <report-file>"; cmd_grade "$2" "$3" ;;
    list)  cmd_list ;;
    *) echo "usage: run.sh {stage <case>|grade <case> <report>|list}" >&2; exit 2 ;;
esac
