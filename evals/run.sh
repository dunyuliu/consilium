#!/usr/bin/env bash
# evals/run.sh — stage and grade an eval case (PROJECT_RULES.md rule 5).
#
#   bash evals/run.sh stage <case-id>              # isolate input/, print the prompt
#   bash evals/run.sh grade <case-id> <report.md>  # score a report against case.yaml
#   bash evals/run.sh list                         # cases and whether they have run
#   bash evals/run.sh smoke                        # the fast tier — run after any prompt edit
#   bash evals/run.sh score [--record]             # one number: how much of the suite still means anything
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

# --- rule 25d: prompt-SHA provenance for "Run (...)" records ----------------
# A record written under rule 25d reads:
#   Run (<date>, <agent>, prompt <short-SHA>). <VERDICT> — <k> criteria, <m> failed.
# Records written before 25d landed name no SHA and are NEVER backfilled — an
# invented SHA is a guess wearing a receipt (PF-027). A SHA-bearing record is
# always compared by SHA: match -> CURRENT, mismatch -> STALE.
#
# A SHA-less (legacy) record falls back to the date comparison this repo ran
# before 25d landed, but ONLY when that fallback can actually order the two
# events. Measured 2026-09-16 (session log, finding 26): of the legacy records
# with a run history, every one whose date differs from its agent prompt's
# last-commit date is EARLIER (14 cases) or LATER (10 cases) — never same-day
# in this corpus, i.e. PF-024's blind spot (same-day edit, no way to order by
# date) has zero known members here, and reserving UNKNOWN PROVENANCE for
# every legacy record regardless of date converted those 14 true STALE
# positives into shrugs. So:
#   - date differs, legacy record EARLIER than the prompt's last commit
#     -> STALE, exactly as the pre-25d comparison called it.
#   - date differs, legacy record LATER than the prompt's last commit
#     -> the record postdates every known prompt edit, so nothing here
#     contradicts it; reported as CURRENT (no SHA to sample-count, but
#     nothing proves it stale either).
#   - date EQUAL to the prompt's last commit -> the one case a date genuinely
#     cannot order (same-day edit-then-dispatch). This is the only case
#     UNKNOWN PROVENANCE is reserved for now.
agent_current_sha() {
    # $1 = agent name as it appears in case.yaml's `agent:` field.
    git -C "$REPO_DIR" log -1 --format=%h -- "agents/$1.md" 2>/dev/null || true
}

agent_current_date() {
    # $1 = agent name. Date (YYYY-MM-DD) of the prompt file's last commit —
    # the same value the pre-25d date comparison called "prompt changed".
    git -C "$REPO_DIR" log -1 --format=%ad --date=short -- "agents/$1.md" 2>/dev/null || true
}

run_record_lines() {
    # $1 = case.yaml path. One raw physical line per "Run (...)" record —
    # every record observed so far fits its date/agent/SHA/verdict on the
    # first physical line even when the surrounding prose wraps.
    grep -iE 'run \(' "$1" 2>/dev/null || true
}

run_record_date() {
    printf '%s' "$1" | grep -oE '20[0-9]{2}-[0-9]{2}-[0-9]{2}' | head -1 || true
}

run_record_sha() {
    # Empty for a legacy record with no ", prompt <sha>)" clause.
    printf '%s' "$1" | grep -oE 'prompt [0-9a-f]{4,40}\)' | head -1 \
        | sed -E 's/^prompt //; s/\)$//' || true
}

run_record_verdict() {
    printf '%s' "$1" | grep -oE '\b(PASS|FAIL|VOID)\b' | head -1 || true
}

# Classifies one case's run history against its agent's current prompt SHA.
# Prints one '|'-delimited line: STATUS|N|DATE|V1|V2|CUR_SHA|OLD_SHA
#   STATUS: NEVER | UNKNOWN | STALE | CURRENT | CONTESTED_UNSETTLED
#   N:      count of Run(...) records naming the CURRENT sha (sample count,
#           rule 25d — never a stored field, always derived by counting)
#   OLD_SHA: for a STALE sha-mismatch, the mismatched sha. For a STALE
#           legacy-date fallback, "date:<record-date>->_<prompt-date>" —
#           still plain text, never a fabricated sha (see header above).
classify_case() {
    local d="$1" agent contested=0 cur_sha cur_date lines
    agent="$(grep -m1 '^agent:' "$d/case.yaml" 2>/dev/null | sed 's/^agent: *//')"
    if grep -q '^contested: true' "$d/case.yaml" 2>/dev/null; then contested=1; fi
    cur_sha="$(agent_current_sha "$agent")"
    cur_date="$(agent_current_date "$agent")"
    lines="$(run_record_lines "$d/case.yaml")"

    if [ -z "$lines" ]; then
        echo "NEVER|0||||$cur_sha|"
        return
    fi

    local n_cur=0 n_stale=0
    local last_cur_date="" last_stale_sha="" last_legacy_date=""
    local v1="" v2=""
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        local sha date verdict
        sha="$(run_record_sha "$line")"
        date="$(run_record_date "$line")"
        verdict="$(run_record_verdict "$line")"
        if [ -z "$sha" ]; then
            # Legacy record — no SHA was ever recorded. Track only the most
            # recent one; an earlier legacy run superseded by a later run
            # (or by a later SHA-bearing run, handled below) doesn't matter.
            last_legacy_date="$date"
        elif [ "$sha" = "$cur_sha" ]; then
            n_cur=$((n_cur + 1))
            last_cur_date="$date"
            if [ -z "$v1" ]; then
                v1="$verdict"
            elif [ "$verdict" != "$v1" ] && [ -z "$v2" ]; then
                v2="$verdict"
            fi
        else
            n_stale=$((n_stale + 1))
            last_stale_sha="$sha"
        fi
    done <<< "$lines"

    if [ "$contested" = 1 ]; then
        # A contested case is never reported settled on one current-SHA
        # sample, and a disagreement between two current-SHA samples is
        # reported as a split, not resolved by a tiebreaker (rule 25d).
        if [ "$n_cur" -ge 2 ] && [ -z "$v2" ]; then
            echo "CURRENT|$n_cur|$last_cur_date|$v1||$cur_sha|"
        else
            echo "CONTESTED_UNSETTLED|$n_cur|$last_cur_date|$v1|$v2|$cur_sha|"
        fi
        return
    fi

    if [ "$n_cur" -gt 0 ]; then
        echo "CURRENT|$n_cur|$last_cur_date|$v1||$cur_sha|"
        return
    fi
    if [ "$n_stale" -gt 0 ]; then
        echo "STALE|0||||$cur_sha|$last_stale_sha"
        return
    fi
    if [ -n "$last_legacy_date" ]; then
        # No SHA-bearing record at all. Fall back to the date comparison —
        # see the header above for exactly which of the three cases this is.
        if [ -n "$cur_date" ] && [ "$last_legacy_date" = "$cur_date" ]; then
            echo "UNKNOWN|0|$last_legacy_date|||$cur_sha|"
        elif [ -n "$cur_date" ] && [[ "$last_legacy_date" < "$cur_date" ]]; then
            echo "STALE|0||||$cur_sha|date:${last_legacy_date}->${cur_date}"
        else
            echo "LEGACY_CURRENT|0|$last_legacy_date|||$cur_sha|"
        fi
        return
    fi
    echo "NEVER|0||||$cur_sha|"
}

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

    # A symlink defeats the whole mechanism. `cp -R` copies the link itself, so
    # an ABSOLUTE symlink in input/ resolves from the staged copy straight back
    # to whatever it names — including the case.yaml one directory above input/.
    # Demonstrated 2026-08-05: a staged `leak.md` printed the full `expected:`
    # block, and a link to /etc/hostname read the host's name. Staging exists to
    # make the answer key unreachable; one symlink makes it reachable again.
    #
    # Refusing beats dereferencing. `cp -RL` would inline the target's CONTENT
    # into the staged copy, which leaks the same bytes while looking clean. No
    # fixture needs a symlink, so the honest answer is to stop.
    local link
    link=$(find "$dir/input" -type l -print -quit 2>/dev/null || true)
    if [ -n "$link" ]; then
        die "$id: input/ contains a symlink (${link#"$dir/input/"}) — staging copies links verbatim, so an absolute link reads straight back out of the isolated copy. Replace it with a real file."
    fi

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
    local agent; agent="$(grep -m1 '^agent:' "$dir/case.yaml" | sed 's/^agent: *//')"
    echo "$agent"
    echo
    echo "Then: bash evals/run.sh grade $id <report-file>"
    echo
    # Rule 25d. The prompt SHA is knowable exactly here, at dispatch, and
    # nowhere afterwards: once the prompt moves, a verdict recorded without one
    # can only be compared by DATE, which cannot order a same-day edit against
    # a same-day run. Printing the record line with the SHA already in it is
    # the whole fix — nine of ten existing verdicts fall back to the date
    # because nobody had the SHA in front of them when they wrote the record.
    echo "--- paste this into the case's notes: when you have a verdict (rule 25d) ---"
    echo "  Run ($(date -u +%Y-%m-%d), via $agent, prompt $(agent_current_sha "$agent")): VERDICT - N criteria, M failed."
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
    # A FOREIGN case path is a recommendation, not a leak. `nadia-002` asks the
    # agent to review a graded run and recommend criterion edits, and a
    # recommendation cannot be written without naming the file the edit lands in
    # — its report cited `evals/cases/tomas-004/case.yaml:20`, the canonical path
    # of the FICTIONAL case in its own scenario, annotated "(staged here as
    # case_criteria.yaml)". That VOIDed on 2026-08-27: the second instance of
    # this detector punishing a correct report, on the same fixture as the first.
    #
    # The 2026-08-05 fix drops a term present in the case's own input/, which
    # covered `must_not_find` (nadia-002's input contains it) and not
    # `case.yaml` (it does not). So the distinction has to be made on the path:
    # `<other-case>/case.yaml` is somebody else's file, while a BARE `case.yaml`
    # or this case's own path is what an agent writes after reading the answer
    # key. Foreign paths are scrubbed before the check; nothing else is.
    local scrubbed; scrubbed="$(mktemp)"
    sed -E "s#[A-Za-z0-9_.-]*${id}[A-Za-z0-9_.-]*/case\.yaml#SELF_CASE_YAML#g; \
            s#[A-Za-z0-9_.-]+/case\.yaml#FOREIGN_CASE_REF#g" "$report" > "$scrubbed"

    local leak_terms='case\.yaml|must_not_find|planted defect'
    local t kept=''
    for t in 'case\.yaml' 'must_not_find' 'planted defect'; do
        if grep -rqiE -- "$t" "$dir/input" 2>/dev/null; then continue; fi
        kept="${kept:+$kept|}$t"
    done
    kept="${kept:+$kept|}SELF_CASE_YAML"
    leak_terms="$kept"
    if [ -n "$leak_terms" ] && grep -qiE "$leak_terms" "$scrubbed"; then
        rm -f "$scrubbed"
        echo "VOID — the report references the answer key (case.yaml / must_not_find /"
        echo "       'planted defect'). Per rule 5 a leaked run has no verdict."
        echo "       Re-run against a staged copy: bash evals/run.sh stage $id"
        exit 1
    fi
    rm -f "$scrubbed"

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
# A verdict is only about the prompt that produced it. A SHA-bearing "Run
# (...)" line names the prompt file's SHA at dispatch time and `list`
# compares it against `agents/<agent>.md`'s SHA now, so a same-day
# edit-then-dispatch (invisible to a date compare, PF-024) is caught.
#
# Records that existed before rule 25d landed name no SHA, and rule 25d
# forbids backfilling one — annotating a verdict with a SHA nobody recorded
# is inventing data. Such a record falls back to the date comparison this
# repo ran before 25d, but only where a date can actually order the two
# events — see the header above `classify_case` for the measurement that
# settled this (session log, finding 26 / PF-027 follow-up):
#   - legacy date EARLIER than the prompt's last commit -> STALE.
#   - legacy date LATER -> CURRENT (nothing known contradicts it).
#   - legacy date EQUAL -> UNKNOWN PROVENANCE, the one case a date genuinely
#     cannot order.
#
# A `contested: true` case cites its sample count next to the verdict and is
# never reported settled on a single current-SHA sample; two current-SHA
# samples that disagree print as an unresolved split, not a tiebreak.
cmd_list() {
    printf '%-42s %-22s %s\n' CASE AGENT "RUN RECORD"
    for d in "$CASES_DIR"/*/; do
        local id agent status n date v1 v2 cur_sha old_sha run
        id="$(basename "$d")"
        agent="$(grep -m1 '^agent:' "$d/case.yaml" 2>/dev/null | sed 's/^agent: *//')"
        IFS='|' read -r status n date v1 v2 cur_sha old_sha <<< "$(classify_case "$d")"
        case "$status" in
            NEVER)
                run="NEVER RUN" ;;
            UNKNOWN)
                run="run $date (no prompt SHA, same day as the prompt's last change — provenance indeterminate, rule 25d)" ;;
            STALE)
                case "$old_sha" in
                    date:*)
                        local legd touchd
                        legd="${old_sha#date:}"; legd="${legd%%->*}"
                        touchd="${old_sha##*->}"
                        run="STALE — verdict dated $legd (no prompt SHA), prompt changed $touchd (date fallback, rule 25d)" ;;
                    *)
                        run="STALE — verdict at prompt $old_sha, agent's prompt is now $cur_sha" ;;
                esac
                ;;
            LEGACY_CURRENT)
                run="run $date (no prompt SHA, dated after the prompt's last change — current, date fallback, rule 25d)" ;;
            CURRENT)
                local plural="s"
                [ "$n" = 1 ] && plural=""
                run="run $date (SHA $cur_sha current, n=$n sample${plural})" ;;
            CONTESTED_UNSETTLED)
                if [ "$n" -eq 0 ]; then
                    run="CONTESTED — no sample at current SHA $cur_sha yet; not settled (rule 25d)"
                elif [ "$n" -eq 1 ]; then
                    run="CONTESTED — 1 sample at current SHA $cur_sha ($v1); needs a second dispatch (rule 25d)"
                else
                    run="CONTESTED — SPLIT at current SHA $cur_sha: $v1 vs $v2 (n=$n), unresolved"
                fi
                ;;
            *)
                run="?" ;;
        esac
        printf '%-42s %-22s %s\n' "$id" "${agent:-?}" "$run"
    done
}

# --- score -----------------------------------------------------------------
# ONE NUMBER for the whole suite, so a change to this repo can be compared with
# the one before it instead of argued about.
#
# WHAT IT MEASURES, EXACTLY: the fraction of cases whose recorded verdict still
# describes the prompt that case currently grades. Nothing else. It says
# nothing about whether any agent is good — see evals/README.md on what this
# suite has actually caught.
#
# IT IS NOT DEBT AND NOT A TARGET. A verdict goes stale the moment its prompt
# is improved, so the number falls when the work goes well and rises when the
# prompts sit still. Raising it means paying a human to re-paste staged prompts
# into live sessions, which buys currency of a measurement that was never
# load-bearing. Report it; do not chase it.
#
# WHAT IT CANNOT MEASURE, AND WHY. Scoring agent quality would need the agents
# run, and this script deliberately does not invoke them (see the header: that
# needs API access, cannot run in free CI, and a fake gate is worse than none).
# There are no stored agent outputs to grade — samples/pass.md and fail.md are
# synthetic reports written by the fixture author to prove the criteria execute,
# so grading them measures the criteria, not the agent. Any "score" derived from
# them would move only when someone edited a sample, which is the shape of a
# number that looks like evidence and is not.
#
# NOT A GATE, deliberately. Rule 10 requires a fixture to land BEFORE the fix it
# guards, so a new fixture is legitimately NEVER RUN on the commit that adds it
# and correctly lowers this number. Failing the build on a drop would forbid the
# ordering the rules require. It records and reports the delta; acting on it is
# a human decision.
#
# The row is appended to evals/results.tsv, which is tracked: the point is
# comparison across commits, and an untracked file cannot be compared with what
# a previous commit recorded.
#
# MEASURING DOES NOT WRITE. `score` is read-only; `score --record` appends. The
# first version wrote on every invocation and that is a treadmill: running it on
# a new commit dirties the tree, committing the row creates another commit, and
# the next run dirties again, forever. A command whose only side effect is to
# make the next run necessary is not a measurement. Record deliberately, when
# there is a change worth comparing against.
cmd_score() {
    local record=0
    [ "${1:-}" = "--record" ] && record=1
    local d id status n date v1 v2 cur_sha old_sha
    local total=0 current=0 stale=0 never=0 unknown=0 contested_unsettled=0
    for d in "$CASES_DIR"/*/; do
        [ -f "$d/case.yaml" ] || continue
        total=$((total + 1))
        id="$(basename "$d")"
        IFS='|' read -r status n date v1 v2 cur_sha old_sha <<< "$(classify_case "$d")"
        case "$status" in
            NEVER)                       never=$((never + 1)) ;;
            UNKNOWN)                     unknown=$((unknown + 1)) ;;
            STALE)                       stale=$((stale + 1)) ;;
            CURRENT|LEGACY_CURRENT)      current=$((current + 1)) ;;
            CONTESTED_UNSETTLED)         contested_unsettled=$((contested_unsettled + 1)) ;;
        esac
    done

    [ "$total" -gt 0 ] || die "no cases with a case.yaml under $CASES_DIR"
    local pct=$(( current * 100 / total ))
    local today commit results prev prev_pct delta
    today="$(date -u +%Y-%m-%d)"
    commit="$(git -C "$REPO_DIR" rev-parse --short HEAD 2>/dev/null || echo unknown)"
    results="$REPO_DIR/evals/results.tsv"

    # ONE ROW PER COMMIT, not per invocation. The score for a given commit is
    # deterministic, so a second run of this command must not add a second row —
    # that would make "delta vs last recorded row" mean "delta since I last typed
    # this", which is not the question anyone is asking. A re-run on the same
    # commit replaces its row, and the delta is always measured against the last
    # row belonging to a DIFFERENT commit.
    prev_pct=""
    if [ -f "$results" ]; then
        prev="$(grep -v '^#' "$results" | grep -v "$(printf '\t')${commit}$(printf '\t')" | tail -1 || true)"
        [ -n "$prev" ] && prev_pct="$(printf '%s' "$prev" | cut -f7)"
        if [ "$record" = 1 ]; then
            grep -v "$(printf '\t')${commit}$(printf '\t')" "$results" > "$results.tmp" || true
            mv "$results.tmp" "$results"
        fi
    elif [ "$record" = 1 ]; then
        printf '# date\tcommit\tcurrent\tstale\tnever_run\ttotal\tpct_current\n' > "$results"
    fi
    if [ "$record" = 1 ]; then
        printf '%s\t%s\t%d\t%d\t%d\t%d\t%d\n' \
            "$today" "$commit" "$current" "$stale" "$never" "$total" "$pct" >> "$results"
    fi

    echo "verdict currency: $current/$total verdicts recorded against the current prompt (${pct}%)"
    echo "  (currency only — this says nothing about agent quality; it falls whenever a prompt improves)"
    echo "  stale (verdict names a prompt SHA that no longer matches):  $stale"
    echo "  never run:                                                 $never"
    echo "  unknown provenance (legacy verdict, no prompt SHA, rule 25d): $unknown"
    echo "  contested, not settled on a single current-SHA sample:     $contested_unsettled"
    if [ -n "$prev_pct" ]; then
        delta=$(( pct - prev_pct ))
        if   [ "$delta" -gt 0 ]; then echo "  delta vs previous commit: +${delta} points (not a goal)"
        elif [ "$delta" -lt 0 ]; then echo "  delta vs previous commit: ${delta} points (expected after a prompt edit)"
        else                          echo "  delta vs previous commit: unchanged"
        fi
    else
        echo "  delta vs previous commit: (no earlier row)"
    fi
    if [ "$record" = 1 ]; then
        echo "recorded in evals/results.tsv"
    else
        echo "(read-only; pass --record to append this row to evals/results.tsv)"
    fi
}

case "${1:-}" in
    stage) [ $# -ge 2 ] || die "usage: run.sh stage <case-id>"; cmd_stage "$2" ;;
    grade) [ $# -ge 3 ] || die "usage: run.sh grade <case-id> <report-file>"; cmd_grade "$2" "$3" ;;
    list)  cmd_list ;;
    smoke) cmd_smoke ;;
    score) shift; cmd_score "${1:-}" ;;
    *) echo "usage: run.sh {stage <case>|grade <case> <report>|list|smoke|score [--record]}" >&2; exit 2 ;;
esac
