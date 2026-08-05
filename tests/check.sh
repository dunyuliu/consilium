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
#  17. Every PATHWAY_FORWARD.md evidence command still prints what is recorded.
#  18. No fixture input contains fixture-authoring language (answer-key leak).
#  19. No must_not_find guard is an imperative (rule 25: guards are declarative).
#  20. Every agent holding the Agent tool warns about dispatch cost, and no
#      agent without it does.
#  21. No PATHWAY_FORWARD.md evidence command reaches the network.
#  22. Every case `tier:` value is one the tooling actually consumes.
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
echo "Check 17: PATHWAY_FORWARD.md evidence commands still print what is recorded"
# Rule 21a. A VERIFIED claim is only as good as its last run; Check 12 verifies a
# claim CITES a command, never that the command still says so.
#
# The first attempt at this check blocked the whole suite and was reverted. Root
# cause was not the parser: check.sh runs under `set -e`, and an evidence command
# exiting nonzero (grep finding nothing is routine) killed the run before the
# Summary line printed. Evidence commands are therefore run with errexit
# suspended and their exit status deliberately ignored — the contract is what a
# command PRINTS, not whether it succeeded.
#
# Two exemptions, both reported rather than silent:
#   * a fence with no command line records an absence of evidence (a never-audited
#     row); the parser does not emit it, so there is nothing to run.
#   * a command that invokes `bash tests/check.sh` would recurse into this check.
# A fence with more than one command line FAILS: line-oriented parsing cannot
# reconstruct multi-line shell, and joining fragments with `;` produces `do;`,
# which is what broke attempt 1. One line per command is the contract.
if [ ! -f "$BOARD" ]; then
    fail "$BOARD missing — rule 21a has nothing to execute"
else
    ev_rows=0
    is_shallow=$(git rev-parse --is-shallow-repository 2>/dev/null || echo false)
    while IFS=$'\037' read -r ev_id ev_n ev_cmd ev_res; do
        [ -z "$ev_id" ] && continue
        ev_rows=$((ev_rows + 1))
        if [ "$ev_n" -gt 1 ]; then
            fail "$ev_id: evidence command spans $ev_n lines — rule 21a requires one line so it can be re-run"
            continue
        fi
        case "$ev_cmd" in
            *"bash tests/check.sh"*)
                echo "  self-referential, not re-run: $ev_id"
                ok; continue ;;
        esac
        # A shallow clone has no tags and one commit, so any command reading
        # history produces output that cannot match what a full clone recorded.
        # CI hit exactly this: `git show --stat v1.10.0` found no tag, and
        # `evals/run.sh list` reported 20 stale cases instead of 13 because
        # `git log -1 -- agents/X.md` returns the tip commit for every file.
        # Skipping is named in the output rather than silent — an exemption that
        # leaves no trace is indistinguishable from a check that passed.
        if [ "$is_shallow" = "true" ]; then
            case "$ev_cmd" in
                *"git "*|*"run.sh list"*|*"run.sh smoke"*)
                    echo "  shallow clone, history-dependent evidence not re-run: $ev_id"
                    ok; continue ;;
            esac
        fi
        ev_expected=$(printf '%s' "$ev_res" | tr '\036' '\n')
        set +e
        ev_actual=$(bash -c "$ev_cmd" 2>&1)
        set -e
        if [ "$ev_actual" = "$ev_expected" ]; then
            ok
        else
            fail "$ev_id: recorded evidence no longer reproduces — re-run and paste what it printed"
            printf '        command:  %s\n' "$ev_cmd"
            printf '        recorded: %s\n' "$(printf '%s' "$ev_expected" | tr '\n' '|')"
            printf '        actual:   %s\n' "$(printf '%s' "$ev_actual" | tr '\n' '|')"
        fi
    done < <(awk -f tests/parse_board.awk -v section=evidence "$BOARD")
    [ "$ev_rows" -gt 0 ] || fail "no evidence commands parsed from $BOARD — the parser or the format changed"
fi

echo
echo "Check 18: no fixture input contains fixture-authoring language"
# Rule 5. `evals/run.sh stage` isolates input/ from case.yaml and the case
# README, because an agent that reads the answer key produces output in which
# nothing looks wrong. It cannot help when the answer key is INSIDE input/:
# staging copies input/ verbatim, by definition.
#
# haruto-001 — the fixture whose 2026-07-31 leak is the reason staging exists —
# shipped an input/README.md reading "release_notes_v0.2.0.md is deliberately
# absent ... This is the planted defect the agent is supposed to surface." Its
# second run is recorded as "scoped to input/, PASS". Scoping to input/ was the
# fix; the answer key was in input/.
#
# WHAT THIS CHECKS, EXACTLY: that no staged file contains a phrase only someone
# writing ABOUT the fixture would write. It cannot detect a leak phrased in the
# project's own voice — that stays a review responsibility, and the name of this
# check is deliberately narrow so it is not mistaken for the broader guarantee.
# The phrase list is deliberately only those an author writes ABOUT a fixture,
# addressed at a reader. `must_not_find` and `case.yaml` were tried and removed:
# lian-001's input is a fixture ABOUT fixtures and legitimately contains a mock
# case.yaml with a must_not_find key. Flagging it was a false positive, and a
# check that fails on correct content is not a gate, it is an obstacle.
LEAK_PHRASES='planted defect|deliberately absent|answer key|the agent is supposed to|eval fixture|this eval|for the .*-00[0-9] eval'
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir")
    [ -d "$case_dir/input" ] || continue
    # `|| true` is load-bearing: grep exits 1 when it finds nothing, which is
    # the NORMAL case here, and under `set -e` the assignment inherits that
    # status and kills the suite before the Summary line. Same failure that
    # blocked Check 17's first attempt.
    hit=$(grep -rIl -iE "$LEAK_PHRASES" "$case_dir/input" 2>/dev/null || true)
    hit=$(printf '%s\n' "$hit" | head -1)
    if [ -n "$hit" ]; then
        phrase=$(grep -rIh -ioE "$LEAK_PHRASES" "$hit" 2>/dev/null | head -1 || true)
        fail "$id: ${hit#"$case_dir"} leaks the answer key to the staged copy (\"$phrase\")"
    else
        ok
    fi
done

echo
echo "Check 19: must_not_find guards are declarative, not imperative"
# Rule 25. Negating an imperative PREFIXES it — "do not rotate the token"
# contains "rotate the token" — so an imperative guard fires on a correct
# report that declines to do the thing. Negating a declarative INFIXES the
# negation: "must not be rotated" does not contain "must be rotated".
#
# The containment is definitional for the imperative form, not a heuristic:
# prefixing anything to a string always leaves the string present.
#
# Found 2026-08-05 while authoring anya-002, whose own first draft had three
# imperative guard families. A sweep then found 31 more across 15 cases.
#
# WHAT THIS CHECKS, EXACTLY: that no guard begins with one of the verbs below.
# The list is finite, so a guard opening with a verb not on it passes — this is
# named narrowly for that reason and is not the general claim that every guard
# survives its negation, which is not mechanizable (see PF-011).
#
# `cutting` is deliberately absent: "cutting rina-solberg.md is safe" is
# declarative and negates cleanly. An -ing form is a gerund, not an imperative.
IMPERATIVES='rotate|remove|redact|delete|switch|rewrite|drop|add|commit|scrub|purge|revoke|change|update|fix|recommend|suggest|backfill|back-fill|merge|refactor|loosen|tighten|edit|implement|patch|apply|replace|ignore|skip|widen|restore|check|use|write'
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir"); cy="$case_dir/case.yaml"
    [ -f "$cy" ] || continue
    bad=$(awk -f evals/parse_case.awk -v section=must_not_find "$cy" \
        | cut -d'|' -f5- | tr '\037' '\n' \
        | grep -iE "^($IMPERATIVES)\b" | head -1 || true)
    if [ -n "$bad" ]; then
        fail "$id: must_not_find guard \"$bad\" is imperative — a correct report saying \"do not $bad\" would trip it. Rewrite declaratively (rule 25)."
    else
        ok
    fi
done

echo
echo "Check 20: the dispatch-cost warning tracks the Agent tool exactly"
# Rule 23. Checks 13 and 14 verify that the discipline sections EXIST. That was
# noted as a limit during the PF-009 audit — `## Communication discipline` is
# byte-identical across all 21 agents, so Check 13 proves 21 copies of a
# paragraph exist rather than 21 considered declarations.
#
# Auditing the content settled it the other way: uniformity is correct here.
# Reading files and reporting costs the same whoever is doing it. There is
# exactly ONE axis on which the economics genuinely differ — whether the agent
# spawns subagents, which costs ~10x doing the work itself — and the prompts
# already differentiate on precisely that axis and nothing else.
#
# So the useful invariant is not "these sections differ per agent", it is that
# the ONE real difference stays aligned with the capability that causes it. A
# new Agent-holder that ships without the warning is the failure this catches;
# an agent that carries the warning without the tool is documentation of a
# capability it does not have.
for agent_file in agents/*.md; do
    stem=$(basename "$agent_file" .md)
    has_tool=$(sed -n '1,/^---$/p' "$agent_file" | grep -m1 '^tools:' | grep -c 'Agent' || true)
    has_warn=$(awk '/^## Tool economy/{f=1;next} /^## /{f=0} f' "$agent_file" \
        | grep -c 'Dispatching multiplies this' || true)
    if [ "$has_tool" = 1 ] && [ "$has_warn" = 0 ]; then
        fail "$stem: holds the Agent tool but its tool-economy section carries no dispatch-cost warning (rule 23)"
    elif [ "$has_tool" = 0 ] && [ "$has_warn" != 0 ]; then
        fail "$stem: warns about dispatch cost but does not hold the Agent tool"
    else
        ok
    fi
done

echo
echo "Check 21: no evidence command reaches the network"
# Rule 2. Check 17 executes every fenced evidence command on every suite run, so
# an evidence command IS part of the gate. A gate that needs the network fails in
# a clone behind a firewall, on a machine with no route out, or when a public API
# rate-limits — and it fails for a reason that has nothing to do with the
# repository being wrong. CI was red for twenty-two commits on exactly that kind
# of environmental dependency (a shallow checkout, PF-016), which is why this one
# is closed before it is ever opened rather than after.
#
# The temptation is concrete: CI status IS readable from this repository with
# `curl` against the public API, and it was deliberately recorded as a MANUAL
# procedure in PF-016 rather than as that row's evidence. This check is what
# stops a later edit from quietly promoting it.
#
# WHAT THIS CHECKS, EXACTLY: that no evidence command names a network tool or a
# URL scheme. It is complete for that, and it is not the general claim that every
# evidence command is environment-independent — that is not mechanizable, and the
# axes already tested by hand (working directory, locale, timezone, shallow
# clone, GNU vs BSD padding) are recorded on PF-016 instead.
NET_TOOLS='(^|[|;& ])(curl|wget|nc|ncat|telnet|ssh|scp|rsync|ftp|ping)([ |;&]|$)|https?://'
for_each_evidence_net=0
while IFS=$'\037' read -r ev_id ev_n ev_cmd _ev_res; do
    [ -z "$ev_id" ] && continue
    for_each_evidence_net=$((for_each_evidence_net + 1))
    if printf '%s' "$ev_cmd" | grep -qE "$NET_TOOLS"; then
        fail "$ev_id: evidence command reaches the network — Check 17 runs it on every suite pass, so the gate would need a route out (rule 2)"
    else
        ok
    fi
done < <(awk -f tests/parse_board.awk -v section=evidence "$BOARD")
[ "$for_each_evidence_net" -gt 0 ] || fail "no evidence commands parsed for the network check"

echo
echo "Check 22: every case tier is a tier the tooling consumes"
# `evals/run.sh smoke` selects on `^tier: smoke` and nothing reads any other
# value. `dunyu-001` carried `tier: dev` with a considered justification beside
# it, and nothing anywhere has ever acted on it — metadata that reads as
# meaningful and is inert. That is worse than no metadata: it invites the next
# author to add `tier: slow` and believe something will honour it.
#
# WHAT THIS CHECKS, EXACTLY: that every `tier:` value appears in KNOWN_TIERS
# below. Adding a tier to the tooling means adding it here in the same change,
# which is the point — the list is the contract between the cases and the runner.
KNOWN_TIERS='smoke'
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir"); cy="$case_dir/case.yaml"
    [ -f "$cy" ] || continue
    tier=$(grep -m1 '^tier:' "$cy" 2>/dev/null | sed 's/^tier: *//; s/ *#.*$//; s/ *$//' || true)
    if [ -z "$tier" ]; then
        ok                      # no tier is fine: the case is full-suite only
    elif printf '%s\n' $KNOWN_TIERS | grep -qxF -- "$tier"; then
        ok
    else
        fail "$id: tier '$tier' is not consumed by any tool — known tiers are: $KNOWN_TIERS"
    fi
done

echo
echo "Summary: $pass_count passed, $fail_count failed"
[ "$fail_count" -eq 0 ] || exit 1
