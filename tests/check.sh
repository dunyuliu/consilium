#!/usr/bin/env bash
# tests/check.sh — structural-invariant checks for consilium itself.
# Pure bash, no dependencies. Runs the same checks locally and in CI.
#
# Verifies:
#   1. Every agents/*.md has well-formed frontmatter (name, description,
#      tools, model), name matches the filename stem, and model is one
#      of {opus, sonnet, haiku}.
#   2. Every commands/*.md Invokes an agent that actually exists.
#   3. The README commands table lists exactly the commands present on
#      disk.
#   4. Every agent file is mentioned at least once in the README.
#   5. Every README backtick-quoted agent-shaped reference resolves to
#      an existing agent file (catches stale references from past
#      renames). Command stems and NON_AGENT_TERMS are skipped.
#   6. The README model table lists every agent exactly once, under the
#      model its own frontmatter declares, with no stale rows.
#   7. Every agent has a README roster-table row and a Layout-tree line.
#   8. Agent references inside agents/*.md and commands/*.md bodies resolve.
#   9. Every eval fixture's line_range still brackets its declared anchor.
#  10. The rule-19 write-surface ownership table is complete and exclusive.
#  11. Every write-surface owner declares isolation as its first section.
#  12. PATHWAY_FORWARD.md is current and every VERIFIED claim cites a command.
#  13. Every agent declares a communication-discipline section.
#  14. Every agent declares tool economy (section presence only).
#  15. Every fixture ships pass/fail sample reports that grade as labelled.
#  16. Fixture criteria are linted: no contradictions, no sentence-length keywords.
#
# Checks 6 and 7 exist because check 4 passes on a bare mention: an agent
# could be absent from the model table, the roster, or the tree with the
# gate green. Every check here was negative-tested when added — a check
# that has never failed is not known to be a gate.
#
# Usage: bash tests/check.sh
# Exit code: 0 if all checks pass, 1 otherwise.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_DIR"

pass_count=0
fail_count=0

fail() {
    echo "  FAIL: $1" >&2
    fail_count=$((fail_count + 1))
}
ok() {
    pass_count=$((pass_count + 1))
}

# Build the canonical list of agent names from the filesystem.
mapfile -t AGENTS < <(find agents -maxdepth 1 -name '*.md' -printf '%f\n' | sed 's/\.md$//' | sort)
mapfile -t COMMANDS < <(find commands -maxdepth 1 -name '*.md' -printf '%f\n' | sed 's/\.md$//' | sort)

is_agent() {
    local needle="$1"
    local a
    for a in "${AGENTS[@]}"; do
        [ "$a" = "$needle" ] && return 0
    done
    return 1
}

is_command() {
    local needle="$1"
    local c
    for c in "${COMMANDS[@]}"; do
        [ "$c" = "$needle" ] && return 0
    done
    return 1
}

# Hyphenated terms that are legitimately backticked in prose and are not
# agent references. Keep this list short and specific: every entry is a hole
# in Check 5, so add one only when the term is genuinely unavoidable.
NON_AGENT_TERMS=(
    pre-push        # git hook wired by install.sh
    post-merge      # git hook wired by install.sh
    no-verify       # git push flag
    fast-check      # JS property-testing library (agents/iris-vermeulen.md)
)

is_non_agent_term() {
    local needle="$1"
    local t
    for t in "${NON_AGENT_TERMS[@]}"; do
        [ "$t" = "$needle" ] && return 0
    done
    return 1
}

# --- Check 1: agent frontmatter ----------------------------------------
echo "Check 1: agent frontmatter"
for stem in "${AGENTS[@]}"; do
    f="agents/$stem.md"

    fm="$(awk 'BEGIN{c=0} /^---$/{c++; next} c==1{print} c==2{exit}' "$f")"
    if [ -z "$fm" ]; then
        fail "$f: no frontmatter block found"
        continue
    fi

    missing=0
    for key in name description tools model; do
        if ! grep -q "^${key}: " <<<"$fm"; then
            fail "$f: missing frontmatter key '$key'"
            missing=1
        fi
    done
    [ "$missing" -eq 1 ] && continue

    name_val=$(grep '^name: ' <<<"$fm" | head -1 | sed 's/^name: *//')
    if [ "$name_val" != "$stem" ]; then
        fail "$f: name '$name_val' does not match filename stem '$stem'"
        continue
    fi

    model_val=$(grep '^model: ' <<<"$fm" | head -1 | sed 's/^model: *//')
    case "$model_val" in
        opus|sonnet|haiku) ok ;;
        *) fail "$f: model '$model_val' not in {opus, sonnet, haiku}" ;;
    esac
done

# --- Check 2: command Invoke references resolve ------------------------
echo "Check 2: command files invoke existing agents"
for stem in "${COMMANDS[@]}"; do
    f="commands/$stem.md"
    refs=$(grep -oE 'Invoke `[a-z-]+`' "$f" | sed 's/Invoke `//; s/`$//' || true)
    if [ -z "$refs" ]; then
        fail "$f: no Invoke \`agent\` line found"
        continue
    fi
    for ref in $refs; do
        if is_agent "$ref"; then
            ok
        else
            fail "$f: invokes nonexistent agent '$ref'"
        fi
    done
done

# --- Check 3: README commands table matches disk -----------------------
echo "Check 3: README commands table matches commands/ on disk"
readme_cmds=$(grep -oE '\| `/[a-z-]+`' README.md | grep -oE '/[a-z-]+' | sed 's|^/||' | sort -u)
disk_cmds=$(printf '%s\n' "${COMMANDS[@]}" | sort -u)
if [ "$readme_cmds" = "$disk_cmds" ]; then
    ok
else
    fail "README commands table out of sync with commands/ on disk"
    echo "  on disk only:" >&2
    comm -13 <(echo "$readme_cmds") <(echo "$disk_cmds") | sed 's/^/    /' >&2
    echo "  in README only:" >&2
    comm -23 <(echo "$readme_cmds") <(echo "$disk_cmds") | sed 's/^/    /' >&2
fi

# --- Check 4: every agent is mentioned in README -----------------------
echo "Check 4: every agent appears in README"
for stem in "${AGENTS[@]}"; do
    if grep -q "$stem" README.md; then
        ok
    else
        fail "agents/$stem.md not mentioned in README"
    fi
done

# --- Check 5: backtick-quoted agent-shaped references in README resolve
#
# An "agent-shaped" reference is a backtick-quoted token matching exactly
# the lowercase first-last pattern used by consilium agent filenames:
# one hyphen, alphabetic on both sides, nothing else. Tokens with two or
# more hyphens (e.g. claim-vs-abstract, end-to-end) are not agent-shaped
# and are ignored.
#
# Two classes of token are agent-shaped but legitimately not agents: command
# stems (`enforce-rules`) and a short allowlist of technical terms
# (`pre-push`). Both are skipped. Without this the check false-positives on
# correct prose, which trains the reader to work around the gate rather than
# trust it — it blocked twice during the v1.2.0 cycle for exactly this.
echo "Check 5: README backtick agent references resolve"
mapfile -t refs < <(grep -oE '`[a-z]+-[a-z]+`' README.md \
    | sed 's/^`//; s/`$//' \
    | sort -u)
for ref in "${refs[@]}"; do
    if is_agent "$ref"; then
        ok
    elif is_command "$ref" || is_non_agent_term "$ref"; then
        continue    # legitimately backticked, not an agent reference
    else
        fail "README references '$ref' but no agents/$ref.md exists"
    fi
done

# --- Check 6: README model table lists every agent, with the right model ---
#
# PROJECT_RULES.md rule 12. Check 4 only proves an agent is *mentioned*
# somewhere in the README, which passes even when the model table is missing
# a row — that gap let two agents drift out of the table before this existed.
# Here we parse the table rows (| opus | `a`, `b`, ... |) and require every
# agent to appear exactly once, under the model its own frontmatter declares.
echo "Check 6: README model table matches agent frontmatter"
declare -A readme_model=()
table_dupes=0
while IFS= read -r line; do
    model=$(printf '%s' "$line" | sed -E 's/^\| *([a-z0-9.-]+) *\|.*/\1/')
    case "$model" in
        opus|sonnet|haiku) ;;
        *) continue ;;
    esac
    for name in $(printf '%s' "$line" | grep -oE '`[a-z]+-[a-z]+`' | tr -d '`'); do
        if [ -n "${readme_model[$name]:-}" ]; then
            fail "README model table lists '$name' more than once"
            table_dupes=$((table_dupes + 1))
        fi
        readme_model[$name]="$model"
    done
done < <(grep -E '^\| *(opus|sonnet|haiku) *\|' README.md)

if [ "${#readme_model[@]}" -eq 0 ]; then
    fail "README model table not found (expected rows like '| opus | \`agent-name\` |')"
fi

for stem in "${AGENTS[@]}"; do
    declared=$(sed -n 's/^model: *//p' "agents/$stem.md" | head -1 | tr -d '[:space:]')
    listed="${readme_model[$stem]:-}"
    if [ -z "$listed" ]; then
        fail "agents/$stem.md missing from the README model table"
    elif [ "$listed" != "$declared" ]; then
        fail "agents/$stem.md declares model '$declared' but README lists it under '$listed'"
    else
        ok
    fi
done

# Every name in the table must be a real agent (catches a stale row after a
# rename or removal).
for name in "${!readme_model[@]}"; do
    if is_agent "$name"; then
        ok
    else
        fail "README model table lists '$name' but no agents/$name.md exists"
    fi
done

# --- Check 7: every agent has a roster row and a Layout-tree line ----------
#
# The other half of rule 12. Check 6 covers the model table; an agent could
# still be in the model table and missing from the team roster that tells a
# reader what it does, or absent from the Layout tree.
#
# Roster row: a table line whose FIRST cell is exactly the backticked agent
# name — `| \`lars-eriksson\` | Code auditor ... |`. The model table is
# excluded because its first cell is a model name, not an agent.
# Layout line: a tree line naming <agent>.md.
echo "Check 7: every agent has a README roster row and Layout entry"
for stem in "${AGENTS[@]}"; do
    if grep -qE "^\| *\`$stem\` *\|" README.md; then
        ok
    else
        fail "agents/$stem.md has no README roster-table row"
    fi
    if grep -qE "^│.*$stem\.md" README.md; then
        ok
    else
        fail "agents/$stem.md missing from the README Layout tree"
    fi
done

# --- Check 8: agent-to-agent references inside prompt bodies resolve ------
#
# PROJECT_RULES.md rule 17. Check 5 scans README.md only, so a rename could
# break every routing line inside agents/*.md and commands/*.md silently —
# and routing is the one cross-reference that changes agent behaviour rather
# than just documentation.
#
# The same skip rules as Check 5 apply. Measured before writing this: of 22
# backticked hyphen-tokens across all prompt bodies, exactly one was neither
# an agent nor a command, so the naive scan is accurate enough to be a gate
# without a large allowlist.
echo "Check 8: agent references inside agents/ and commands/ bodies resolve"
for f in agents/*.md commands/*.md; do
    mapfile -t body_refs < <(grep -oE '`[a-z]+-[a-z]+`' "$f" \
        | sed 's/^`//; s/`$//' \
        | sort -u)
    for ref in "${body_refs[@]:-}"; do
        [ -z "$ref" ] && continue
        # An agent naming itself is fine; so is any real agent or command.
        if is_agent "$ref"; then
            ok
        elif is_command "$ref" || is_non_agent_term "$ref"; then
            continue
        else
            fail "$f references '$ref' but no agents/$ref.md exists"
        fi
    done
done

# --- Check 9: eval fixture line_range still brackets its planted defect ----
#
# PROJECT_RULES.md rule 5. A `kind: location` entry asserts the agent must
# cite a line inside line_range. If the fixture's input file is edited, that
# range silently stops matching the defect — and the case then FAILS a
# correct answer, which is worse than no test.
#
# Incident (2026-07-31): sophia-001 asserted ingest.py:[27,30] while the
# planted `* 1000.0` sat at :32. Found by running the case, not by reading
# it. This check makes that class mechanical.
#
# Verifies, per location entry: the referenced input file exists, and the
# entry's `anchor:` — a literal string from the input file — sits inside
# line_range. The anchor is a separate field on purpose: `keywords:` are
# strings the AGENT'S REPORT must contain, and evals/README.md explicitly
# warns against planting those in the input ("you're testing string-match,
# not detection"). Checking the range against report keywords was this
# check's first design and it was wrong; entries with no anchor are skipped.
echo "Check 9: eval fixture line_range brackets its planted defect"
LOC_AWK='
function flush() {
    if (inloc && f != "" && s != "") print f "|" s "|" e "|" kw
    inloc=0; f=""; s=""; e=""; kw=""; inkw=0
}
/^  - kind:/            { flush(); inloc = ($3 == "location"); next }
/^[a-z_]+:/             { flush(); next }
inloc && /^    file:/   { f=$2; inkw=0; next }
inloc && /^    line_range:/ { line=$0; sub(/#.*/, "", line); gsub(/[^0-9,]/, "", line);
                              split(line, a, ","); s=a[1]; e=a[2]; inkw=0; next }
inloc && /^    anchor:/ { line=$0; sub(/^    anchor: */, "", line); sub(/ *#.*$/, "", line);
                          gsub(/^"|"$/, "", line); kw=line; inkw=0; next }
inloc && /^    keywords:/ { inkw=0; next }
inloc && /^    [a-z_]+:/ { inkw=0 }
END { flush() }'

for case_yaml in evals/cases/*/case.yaml; do
    case_dir=$(dirname "$case_yaml")
    while IFS='|' read -r loc_file lo hi kws; do
        [ -z "$loc_file" ] && continue
        target="$case_dir/input/$loc_file"
        if [ ! -f "$target" ]; then
            fail "$case_yaml: location entry names '$loc_file', missing at $target"
            continue
        fi
        if [ -z "$kws" ]; then
            ok      # no anchor declared; range staleness is unverifiable here
            continue
        fi
        if sed -n "${lo},${hi}p" "$target" | grep -qF -- "$kws"; then
            ok
        else
            fail "$case_yaml: anchor '$kws' not found in $loc_file lines $lo-$hi — stale range?"
        fi
    done < <(awk "$LOC_AWK" "$case_yaml")
done

# --- Check 10: one owner per write surface --------------------------------
#
# PROJECT_RULES.md rule 19. Boundaries written only in prose cannot be
# checked, and two agents quietly holding the same surface is how a project
# ends up with two rule books under different filenames (2026-07-31).
#
# Parses the ownership table in PROJECT_RULES.md and asserts:
#   a. every listed owner is a real agent
#   b. every listed owner actually holds Edit or Write
#   c. every agent holding Edit or Write is listed as some surface's owner
#      (an unscoped writer is a boundary waiting to be crossed)
#   d. no surface is listed twice
echo "Check 10: write-surface ownership table is complete and exclusive"
declare -A surface_owner=()
declare -A is_owner=()
while IFS= read -r row; do
    surface=$(printf '%s' "$row" | awk -F'|' '{print $2}' | sed 's/^ *//; s/ *$//')
    owner=$(printf '%s' "$row" | awk -F'|' '{print $3}' | grep -oE '[a-z]+-[a-z]+' | head -1)
    [ -z "$owner" ] && continue
    if [ -n "${surface_owner[$surface]:-}" ]; then
        fail "rule 19 table lists surface '$surface' more than once"
    fi
    surface_owner[$surface]="$owner"
    if is_agent "$owner"; then ok; else fail "rule 19 table names '$owner', no such agent"; continue; fi
    if grep -q '^tools:.*\(Edit\|Write\)' "agents/$owner.md"; then
        ok
    else
        fail "rule 19 gives '$owner' a write surface but its tools include neither Edit nor Write"
    fi
    is_owner[$owner]=1
done < <(sed -n '/^## 19\./,/^## 18\./p' PROJECT_RULES.md | grep -E '^\| .* \| `[a-z]+-[a-z]+` *\|')

if [ "${#surface_owner[@]}" -eq 0 ]; then
    fail "rule 19 ownership table not found or unparseable in PROJECT_RULES.md"
fi

for stem in "${AGENTS[@]}"; do
    if grep -q '^tools:.*\(Edit\|Write\)' "agents/$stem.md"; then
        if [ -n "${is_owner[$stem]:-}" ]; then
            ok
        else
            fail "agents/$stem.md holds Edit/Write but owns no surface in rule 19 — unscoped writer"
        fi
    fi
done

# --- Check 11: every write-surface owner declares isolation first ---------
#
# PROJECT_RULES.md rule 20. Containment stated at line 80 — after the agent
# has read its mission — is advice; stated first it is a precondition. An
# audit on 2026-07-31 found 2 of 9 writers declared isolation at all, both
# buried, and five (including the refactorer and the release engineer) had
# no containment statement anywhere.
echo "Check 11: write-surface owners declare isolation as their first section"
for owner in "${!is_owner[@]}"; do
    first_heading=$(grep -m1 '^## ' "agents/$owner.md" || true)
    if [ -z "$first_heading" ]; then
        fail "agents/$owner.md has no '##' sections at all"
    elif printf '%s' "$first_heading" | grep -qi '^## Isolation'; then
        ok
    else
        fail "agents/$owner.md holds a write surface but its first section is '$first_heading' — isolation must come first (rule 20)"
    fi
done

# --- Check 12: PATHWAY_FORWARD.md is current and every claim cites a command
#
# PROJECT_RULES.md rule 21. Release notes are append-only history and go stale
# by design; the board is the present tense. A claim that was true when written
# decays silently — v1.7.0 shipped a pre-commit hook that was never committed,
# and nothing re-checked it for four days because nothing existed whose job was
# to re-check.
#
# The gate never reddens on a date alone: it reddens on an OVERDUE item with no
# recorded decision. Writing one deferral line clears it. A blank last-checked
# means never audited — permitted and reported, never silently backfilled,
# because an unaudited surface must stay visible.
echo "Check 12: PATHWAY_FORWARD.md is current and every claim cites a command"
BOARD="PATHWAY_FORWARD.md"
if [ ! -f "$BOARD" ]; then
    fail "$BOARD missing — rule 21 requires a living inspection log"
else
    # epoch-days via awk (days_from_civil); `date -d` is GNU-only.
    days() { awk -v d="$1" 'BEGIN{
        split(d,a,"-"); y=a[1]; m=a[2]; dd=a[3];
        if (m<=2) y--;
        era=int((y>=0?y:y-399)/400); yoe=y-era*400;
        doy=int((153*(m+(m>2?-3:9))+2)/5)+dd-1;
        doe=yoe*365+int(yoe/4)-int(yoe/100)+doy;
        print era*146097+doe-719468 }'; }
    today_d=$(days "$(date -u +%Y-%m-%d)")

    board_rows=0
    declare -A item_state=() item_cmd=()
    while IFS='|' read -r id st hc hr; do
        [ -z "$id" ] && continue
        item_state[$id]="$st"; item_cmd[$id]="$hc"
    done < <(awk -f tests/parse_board.awk -v section=items "$BOARD")

    declare -A defer_until=() defer_count=()
    while IFS='|' read -r id un; do
        [ -z "$id" ] && continue
        defer_until[$id]="$un"
        defer_count[$id]=$(( ${defer_count[$id]:-0} + 1 ))
    done < <(awk -f tests/parse_board.awk -v section=defer "$BOARD")

    while IFS='|' read -r id area st last iv; do
        [ -z "$id" ] && continue
        board_rows=$((board_rows + 1))
        err=""
        case "$st" in VERIFIED|OPEN|BROKEN|DEFERRED) ;; *) err="bad state '$st'" ;; esac
        if [ -z "${item_state[$id]:-}" ]; then
            err="${err:-no matching '### $id' block}"
        elif [ "${item_state[$id]}" != "$st" ]; then
            err="${err:-table says $st, block says ${item_state[$id]}}"
        fi
        if [ -z "$last" ]; then
            # never audited: information, not an error — but cannot be VERIFIED
            [ "$st" = "VERIFIED" ] && err="${err:-VERIFIED with no last-checked date}"
            if [ -z "$err" ]; then
                echo "  NEVER AUDITED: $id ($area)"
                ok
            else
                fail "$id: $err"
            fi
            continue
        fi
        if ! printf '%s' "$last" | grep -qE '^20[0-9]{2}-[0-9]{2}-[0-9]{2}$'; then
            err="${err:-last-checked '$last' is not YYYY-MM-DD}"
        elif [ "$(days "$last")" -gt "$today_d" ]; then
            err="${err:-last-checked is in the future}"
        fi
        [ "$st" = "VERIFIED" ] && [ "${item_cmd[$id]:-0}" != "1" ] \
            && err="${err:-VERIFIED but its block records no command}"
        if printf '%s' "$iv" | grep -qE '^[0-9]+$' && [ "$iv" -ge 1 ] && [ "$iv" -le 90 ]; then
            if [ -z "$err" ]; then
                due=$(( $(days "$last") + iv ))
                if [ "$st" = "DEFERRED" ]; then
                    if [ -z "${defer_until[$id]:-}" ]; then
                        err="DEFERRED with no deferral-log row"
                    elif [ "${defer_count[$id]}" -gt 2 ]; then
                        err="deferred ${defer_count[$id]} times — that is a decision, not a deferral"
                    elif [ "$(days "${defer_until[$id]}")" -lt "$today_d" ]; then
                        err="deferral lapsed on ${defer_until[$id]}"
                    fi
                elif [ "$today_d" -gt "$due" ]; then
                    err="overdue by $(( today_d - due ))d — re-run the command in its block, or defer it in writing"
                fi
            fi
        else
            err="${err:-interval '$iv' not an integer in 1..90}"
        fi
        if [ -n "$err" ]; then fail "$id: $err"; else ok; fi
    done < <(awk -f tests/parse_board.awk -v section=board "$BOARD")

    [ "$board_rows" -eq 0 ] && fail "$BOARD has no parseable board rows"
fi


# --- Check 13: every agent carries a communication-discipline section --------
#
# PROJECT_RULES.md rule 22. Terse output is a universal contract here, not a
# per-agent preference: the user's own harness injects "BE CONCISE" on every
# prompt, and an agent that pads defeats that at one remove. All 20 agents
# carried this section when the check was written; nothing guaranteed the 21st
# would, which is the only reason a habit needs a gate.
#
# Checks presence, not prose — a section can be present and vacuous. That limit
# is stated rather than papered over.
echo "Check 13: every agent declares communication discipline"
for stem in "${AGENTS[@]}"; do
    if grep -qE '^## Communication discipline' "agents/$stem.md"; then
        ok
    else
        fail "agents/$stem.md has no '## Communication discipline' section (rule 22)"
    fi
done

# --- Check 14: agents that can dispatch declare what a dispatch costs -------
#
# PROJECT_RULES.md rule 23. A dispatch costs ~10x doing the work yourself and
# the multiplier is structural: the API re-bills the whole conversation on
# every tool call, so cost grows with the square of tool calls, not with prompt
# size. Measured here: <7 tool calls ~19k tokens, >10 ~75k, against ~2k to read
# a file directly. An orchestrator that does not know this spends 20k
# confirming what it could have read in 2k.
echo "Check 14: every agent declares tool economy"
for stem in "${AGENTS[@]}"; do
    if grep -qE '^## Tool economy' "agents/$stem.md"; then
        ok
    else
        fail "agents/$stem.md declares no tool economy (rule 23)"
    fi
done

# --- Check 15: every fixture's criteria are provably executable --------------
#
# PROJECT_RULES.md rule 25. A case ships two sample reports — samples/pass.md
# which MUST grade PASS, and samples/fail.md which MUST grade FAIL. The grader
# is run against both and the verdicts checked.
#
# This exists because the grader shipped with a bug for its entire life:
# `printf '%s'` emits no trailing newline, so `while read` silently dropped the
# LAST keyword of every any_of list. Every grade recorded before 2026-08-04 ran
# with its final term ignored. A must-pass sample containing only that last
# keyword would have failed on day one and exposed it immediately.
#
# It also turns each criterion from an intention into executable proof: an
# author who cannot write a report that passes their own criteria has not
# written criteria that test what they think.
echo "Check 15: fixture criteria are provably executable"
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir")
    [ -f "$case_dir/case.yaml" ] || continue
    if [ ! -f "$case_dir/samples/pass.md" ] || [ ! -f "$case_dir/samples/fail.md" ]; then
        fail "$id: missing samples/pass.md and/or samples/fail.md (rule 25)"
        continue
    fi
    if bash evals/run.sh grade "$id" "$case_dir/samples/pass.md" >/dev/null 2>&1; then
        ok
    else
        fail "$id: samples/pass.md does not grade PASS — the criteria reject a report written to satisfy them"
    fi
    if bash evals/run.sh grade "$id" "$case_dir/samples/fail.md" >/dev/null 2>&1; then
        fail "$id: samples/fail.md grades PASS — the criteria accept a report that should fail"
    else
        ok
    fi
done

# --- Check 16: criteria linter ----------------------------------------------
#
# PROJECT_RULES.md rule 25. Six of the twelve fixture defects found on
# 2026-08-04 were one of two shapes, both mechanically detectable:
#
#   * ENUMERATED PARAPHRASES — an any_of list of full sentences can never be
#     exhaustive. "do not merge" missed "does not merge"; "send it back"
#     missed "send back"; seven variants of "rina has no fixture" missed
#     "zero fixtures". Anchor on the shortest distinctive token instead.
#   * CONTRADICTORY CRITERIA — a term appearing in both `expected` and
#     `must_not_find`, so satisfying one trips the other. ziyan-001 had this
#     and nothing could see it until Check 15 executed the criteria.
#
# The word cap is deliberately loose: it flags sentences, not phrases. A
# four-word technical term is fine; a clause is a guess about phrasing.
echo "Check 16: fixture criteria are linted"
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir"); cy="$case_dir/case.yaml"
    [ -f "$cy" ] || continue
    exp_terms=$(awk -f evals/parse_case.awk -v section=expected "$cy" | cut -d'|' -f5- | tr '\037' '\n')
    mnf_terms=$(awk -f evals/parse_case.awk -v section=must_not_find "$cy" | cut -d'|' -f5- | tr '\037' '\n')

    # (a) an expected term must not also be a must_not_find term
    clash=0
    while IFS= read -r t; do
        [ -z "$t" ] && continue
        if printf '%s\n' "$mnf_terms" | grep -qxF -- "$t"; then
            fail "$id: \"$t\" is both an expected keyword and a must_not_find guard"
            clash=1
        fi
    done <<< "$exp_terms"
    [ "$clash" -eq 0 ] && ok

    # (b) expected any_of entries should be tokens, not sentences
    long=$(printf '%s\n' "$exp_terms" | awk 'NF>=6' | head -1)
    if [ -n "$long" ]; then
        fail "$id: expected keyword is a sentence, not a token: \"$long\" — anchor on the shortest distinctive phrase"
    else
        ok
    fi
done

echo
echo "Summary: $pass_count passed, $fail_count failed"
[ "$fail_count" -eq 0 ] || exit 1
