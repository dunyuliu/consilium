#!/usr/bin/env bash
# tests/check.sh — structural-invariant checks for consilium itself.
# Pure bash, no dependencies. Runs the same checks locally and in CI.
#
# Verifies:
#   1. Every agents/*.md has well-formed frontmatter (name, description,
#      tools, model), name matches the filename stem, and model is one
#      of {opus, fable, sonnet, haiku}.
#   2. Every commands/*.md Invokes an agent that actually exists.
#   3. The README commands table lists exactly the commands present on
#      disk.
#   4. (retired 2026-09-17 — README agent listing, subsumed by Checks 6 and 7.)
#   5. (retired 2026-09-18 — README agent-shaped references, merged into
#      Check 8, which ran the identical scan over every other document and
#      names the file in its failure message.)
#   6. The README model table lists every agent exactly once, under the
#      model its own frontmatter declares, with no stale rows.
#   7. Every agent has a README roster-table row and a Layout-tree line.
#   8. Every backtick-quoted agent-shaped reference in README.md, CLAUDE.md,
#      agents/*.md and commands/*.md resolves to an agent that exists.
#   9. Every eval fixture's line_range still brackets its declared anchor.
#  10. The rule-19 write-surface ownership table is complete and exclusive.
#  11. Every write-surface owner declares isolation as its first section.
#  12. PATHWAY_FORWARD.md is current and every VERIFIED claim cites a command.
#  13. Every agent declares a communication-discipline section.
#  14. Every agent declares tool economy (section presence only).
#  15. Every fixture ships pass/fail sample reports that grade as labelled.
#  16. Fixture criteria are linted: no contradictions, no sentence-length keywords.
#  17. (retired 2026-09-17 with the 21a amendment — board evidence byte-diffed.)
#  18. No fixture input contains fixture-authoring language (answer-key leak).
#  19. No must_not_find guard is an imperative (rule 25: guards are declarative).
#  20. Every agent holding the Agent tool warns about dispatch cost, and no
#      agent without it does.
#  21. (retired 2026-09-17 with the 21a amendment — gate kept off the network.)
#  22. Every case `tier:` value is one the tooling actually consumes.
#  23. No fixture input contains a symlink (it would read out of the staged copy).
#  24. An empty report fails every case (silence must not satisfy a case).
#  25. (retired 2026-09-17 with rule 13 — fixture count by agent headcount.)
#  26. No generated artefact has been written into a fixture input (rule 7).
#  27. Every release note has a matching tag (rule 15).
#  28. No release note that once existed has vanished (rule 8).
#  29. Only install.sh writes the Claude symlink directories (rule 14).
#  30. No expected keyword appears in ordinary finding-free review prose.
#  31. The repo root holds exactly the documents rule 1 whitelists, and the
#      one release note there is the newest tag's.
#  32. The README and CLAUDE questions blocks exist and share no question.
#  33. The release gate's rows and the documented note schema agree.
#  34. Exactly one board carries the project forward (rule 21).
#  35. Every tagged release has a release note, and every tag that is ON THE
#      REMOTE also has a GitHub Release (rule 15) — haruto's workflow tags
#      and pushes but does not itself run `gh release create`, so this
#      closes the gap that let 23 tagged releases exist with no Release
#      object behind them.
#  36. No tracked file contains a merge-conflict marker.
#
# Checks 6 and 7 are separate because a bare mention is not membership: an
# agent could be absent from the model table, the roster, or the tree with
# the gate green. Every check here was negative-tested when added — a check
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
# in Check 8, so add one only when the term is genuinely unavoidable.
NON_AGENT_TERMS=(
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
        opus|fable|sonnet|haiku) ok ;;
        *) fail "$f: model '$model_val' not in {opus, fable, sonnet, haiku}" ;;
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

# --- Check 6: README model table lists every agent, with the right model ---
#
# PROJECT_RULES.md rule 12. A bare mention anywhere in the README passes even
# when the model table is missing a row — that gap let two agents drift out
# of the table before this existed.
# Here we parse the table rows (| opus | `a`, `b`, ... |) and require every
# agent to appear exactly once, under the model its own frontmatter declares.
echo "Check 6: README model table matches agent frontmatter"
declare -A readme_model=()
table_dupes=0
while IFS= read -r line; do
    model=$(printf '%s' "$line" | sed -E 's/^\| *([a-z0-9.-]+) *\|.*/\1/')
    case "$model" in
        opus|fable|sonnet|haiku) ;;
        *) continue ;;
    esac
    for name in $(printf '%s' "$line" | grep -oE '`[a-z]+-[a-z]+`' | tr -d '`'); do
        if [ -n "${readme_model[$name]:-}" ]; then
            fail "README model table lists '$name' more than once"
            table_dupes=$((table_dupes + 1))
        fi
        readme_model[$name]="$model"
    done
done < <(grep -E '^\| *(opus|fable|sonnet|haiku) *\|' README.md)

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

# --- Check 8: agent-shaped references resolve, in every document ----------
#
# PROJECT_RULES.md rule 17. A rename can break every routing line inside
# agents/*.md and commands/*.md silently — and routing is the one
# cross-reference that changes agent behaviour rather than just documentation.
#
# An "agent-shaped" reference is a backtick-quoted token matching exactly the
# lowercase first-last pattern of a consilium agent filename: one hyphen,
# alphabetic on both sides. Tokens with two or more hyphens (claim-vs-abstract,
# end-to-end) are not agent-shaped and are ignored. Two classes are
# agent-shaped but legitimately not agents — command stems (`enforce-rules`)
# and NON_AGENT_TERMS (`post-merge`) — and are skipped. Without those skips the
# check false-positives on correct prose, which trains the reader to work
# around the gate rather than trust it; it blocked twice in the v1.2.0 cycle
# for exactly that. Measured before this was written: of 22 backticked
# hyphen-tokens across all prompt bodies, exactly one was neither an agent nor
# a command, so the naive scan is accurate enough to be a gate.
#
# CLAUDE.md joined the list when it landed (2026-09-16) and README.md when
# Check 5 merged in here (2026-09-18): a root document that names agents — who
# owns which surface, who to route a finding to — is the same hole as a prompt
# that does. A missing root document is Check 31's finding, not this one's, so
# it is skipped rather than erroring here.
echo "Check 8: agent-shaped references resolve in README, CLAUDE.md, agents/ and commands/"
for f in README.md CLAUDE.md agents/*.md commands/*.md; do
    [ -e "$f" ] || continue
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

    while IFS='|' read -r id area st last iv prio; do
        [ -z "$id" ] && continue
        board_rows=$((board_rows + 1))
        err=""
        case "$st" in VERIFIED|OPEN|BROKEN|DEFERRED|RETIRED) ;; *) err="bad state '$st'" ;; esac
        # Rule 21's priority. A row with no priority cannot be queued, and a
        # board that cannot be queued is an archive: state says how bad a row
        # is, never how much it matters now.
        # A RETIRED row describes a surface no longer tracked: it has no interval
        # and no command, so a priority on it would be decoration (2026-09-17).
        if [ "$st" != "RETIRED" ]; then
        case "$prio" in P1|P2|P3) ;; *) err="${err:-no priority — every row carries P1, P2 or P3 (rule 21)}" ;; esac
        fi
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
        elif [ "$st" != "RETIRED" ]; then
            # RETIRED rows carry no interval for the same reason they carry no
            # priority: nothing re-runs on a surface that is no longer tracked.
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
check15_n=0
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir")
    [ -f "$case_dir/case.yaml" ] || continue
    check15_n=$((check15_n + 1))
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
[ "$check15_n" -gt 0 ] || fail "no case.yaml found under evals/cases/*/ — Check 15 asserted nothing"

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
check16_n=0
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir"); cy="$case_dir/case.yaml"
    [ -f "$cy" ] || continue
    check16_n=$((check16_n + 1))
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
[ "$check16_n" -gt 0 ] || fail "no case.yaml found under evals/cases/*/ — Check 16 asserted nothing"

echo
echo "Check 18: no fixture input contains fixture-authoring language"
# Rule 5. `evals/run.sh stage` isolates input/ from case.yaml and the case
# README, because an agent that reads the answer key produces output in which
# nothing looks wrong. It cannot help when the answer key is INSIDE input/:
# staging copies input/ verbatim, by definition.
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
check18_n=0
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir")
    [ -d "$case_dir/input" ] || continue
    check18_n=$((check18_n + 1))
    # `|| true` is load-bearing: grep exits 1 when it finds nothing, which is
    # the NORMAL case here, and under `set -e` the assignment inherits that
    # status and kills the suite before the Summary line.
    hit=$(grep -rIl -iE "$LEAK_PHRASES" "$case_dir/input" 2>/dev/null || true)
    hit=$(printf '%s\n' "$hit" | head -1)
    if [ -n "$hit" ]; then
        phrase=$(grep -rIh -ioE "$LEAK_PHRASES" "$hit" 2>/dev/null | head -1 || true)
        fail "$id: ${hit#"$case_dir"} leaks the answer key to the staged copy (\"$phrase\")"
    else
        ok
    fi
done
[ "$check18_n" -gt 0 ] || fail "no case input/ directories found under evals/cases/*/ — Check 18 asserted nothing"

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
check19_n=0
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir"); cy="$case_dir/case.yaml"
    [ -f "$cy" ] || continue
    check19_n=$((check19_n + 1))
    bad=$(awk -f evals/parse_case.awk -v section=must_not_find "$cy" \
        | cut -d'|' -f5- | tr '\037' '\n' \
        | grep -iE "^($IMPERATIVES)\b" | head -1 || true)
    if [ -n "$bad" ]; then
        fail "$id: must_not_find guard \"$bad\" is imperative — a correct report saying \"do not $bad\" would trip it. Rewrite declaratively (rule 25)."
    else
        ok
    fi
done
[ "$check19_n" -gt 0 ] || fail "no case.yaml found under evals/cases/*/ — Check 19 asserted nothing"

echo
echo "Check 20: the dispatch-cost warning tracks the Agent tool exactly"
# Rule 23. Checks 13 and 14 verify only that the discipline sections EXIST, and
# those sections are byte-identical across agents — correctly so: reading and
# reporting cost the same whoever does it. Exactly one axis differs — whether
# the agent spawns subagents, at ~10x doing the work itself — so the invariant
# is that the one real difference stays aligned with the capability causing it.
# An Agent-holder without the warning is an unwarned dispatcher; the warning
# without the tool documents a capability the agent does not have.
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
check22_n=0
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir"); cy="$case_dir/case.yaml"
    [ -f "$cy" ] || continue
    check22_n=$((check22_n + 1))
    tier=$(grep -m1 '^tier:' "$cy" 2>/dev/null | sed 's/^tier: *//; s/ *#.*$//; s/ *$//' || true)
    if [ -z "$tier" ]; then
        ok                      # no tier is fine: the case is full-suite only
    elif printf '%s\n' $KNOWN_TIERS | grep -qxF -- "$tier"; then
        ok
    else
        fail "$id: tier '$tier' is not consumed by any tool — known tiers are: $KNOWN_TIERS"
    fi
done
[ "$check22_n" -gt 0 ] || fail "no case.yaml found under evals/cases/*/ — Check 22 asserted nothing"

echo
echo "Check 23: no fixture input contains a symlink"
# Rule 5, and the companion to Check 18. Check 18 stops the answer key being
# written INSIDE input/; this stops it being LINKED there.
#
# `evals/run.sh stage` copies input/ with `cp -R`, which copies a symlink as a
# symlink. An absolute link therefore resolves from the staged copy back to
# whatever it names — including the case.yaml one directory above input/.
# Demonstrated 2026-08-05: a staged `leak.md` printed the full `expected:` block
# and a link to /etc/hostname read the host's name. Staging exists to make the
# answer key unreachable; one symlink makes it reachable again.
#
# `stage` now refuses such a case, but that is late — the author finds out when
# somebody tries to run it. This fails at commit time instead.
check23_n=0
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir")
    [ -d "$case_dir/input" ] || continue
    check23_n=$((check23_n + 1))
    link=$(find "$case_dir/input" -type l -print -quit 2>/dev/null || true)
    if [ -n "$link" ]; then
        fail "$id: ${link#"$case_dir"} is a symlink — it would resolve out of the staged copy and defeat the isolation (rule 5)"
    else
        ok
    fi
done
[ "$check23_n" -gt 0 ] || fail "no case input/ directories found under evals/cases/*/ — Check 23 asserted nothing"

echo
echo "Check 24: an empty report fails every case"
# Rule 25. Check 15 proves a case's pass sample PASSES and its fail sample FAILS.
# Neither says what happens to a report that does no work at all — and every
# `must_not_find` guard is satisfied by silence, because an empty report cannot
# contain a forbidden phrase. So a case whose positive requirement is weak is
# passed by saying nothing.
#
# WHAT THIS CHECKS, EXACTLY: that grading an empty file against every case gives
# a non-PASS. It is complete for that. It does NOT establish that a weak report
# fails — "how much work does this report show" is not mechanizable, and
# `lars-002` was found by hand, not by this.
empty_report=$(mktemp) || die_msg=""
: > "$empty_report"
check24_n=0
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir")
    [ -f "$case_dir/case.yaml" ] || continue
    check24_n=$((check24_n + 1))
    verdict=$(bash evals/run.sh grade "$id" "$empty_report" 2>&1 | grep -cE '^PASS —' || true)
    if [ "$verdict" -gt 0 ]; then
        fail "$id: an EMPTY report passes this case — its guards are satisfied by silence and its expected criteria are too weak to require work (rule 25)"
    else
        ok
    fi
done
rm -f "$empty_report"
[ "$check24_n" -gt 0 ] || fail "no case.yaml found under evals/cases/*/ — Check 24 asserted nothing"


echo "Check 26: no generated artefact in a fixture input (rule 7)"
# Rule 7 says `evals/cases/*/input/` is read-only fixture data and is marked
# mechanical. Nothing mechanised it. Its stated procedure — "git status inside
# evals/ must be clean after any eval run" — is a thing a human remembers to do,
# which is the definition of not being a gate.
#
# A generated artefact under input/ is proof that an agent was pointed at the
# case directory rather than the staged copy — the read-only violation
# `evals/run.sh stage` exists to prevent. Untracked counts: `git status` on a
# clean tree does not see it. A tracked artefact is a committed mistake; an untracked one
# is the mistake still happening, on the machine where it happened.
check26_n=0
for case_dir in evals/cases/*/; do
    id=$(basename "$case_dir")
    [ -d "$case_dir/input" ] || continue
    check26_n=$((check26_n + 1))
    art=$(find "$case_dir/input" \( -name '__pycache__' -o -name '*.pyc' -o -name '*.pyo' \
            -o -name '.pytest_cache' -o -name 'node_modules' -o -name '.ipynb_checkpoints' \
            -o -name '*.egg-info' \) -print -quit 2>/dev/null || true)
    if [ -n "$art" ]; then
        fail "$id: ${art#"$case_dir"} is a generated artefact inside fixture input (rule 7) — something wrote through a read-only fixture, which means an agent ran against the case directory instead of a staged copy"
    else
        ok
    fi
done
[ "$check26_n" -gt 0 ] || fail "no case input/ directories found under evals/cases/*/ — Check 26 asserted nothing"

echo
echo "Check 27: every release note has a matching tag (rule 15)"
# Rule 15 is marked mechanical and was enforced by a human running one command
# after each release. That command was run by hand after every release of this
# session — which is precisely a rule that is mechanical in name and habit in
# practice, and habits lapse silently.
#
# SHALLOW/TAGLESS GUARD. `actions/checkout` fetches no tags by default, and a
# check that needs them turned CI red for twenty-two commits. Skipping is
# NAMED, never silent.
if [ -z "$(git tag --list 'v*' 2>/dev/null || true)" ]; then
    echo "  no tags in this clone — rule 15 not checkable here"
    ok
else
    # RULE 15a PRE-TAG GRACE, STATE-BASED. An earlier version of this grace
    # window was wall-clock (7 days from the note's first-add commit), which
    # made the gate non-deterministic — the same commit passed today and
    # would fail next week with no code change. Replaced with a rule keyed
    # only to tree state: the grace applies ONLY to the single NEWEST
    # release note present (by version), and ONLY until a newer one
    # supersedes it. An older, superseded, untagged note has no excuse left
    # and fails hard — this is what keeps "a note that never gets tagged
    # must still fail eventually" true.
    #
    # Deliberately NOT keyed to "the note's adding commit is HEAD": any commit
    # landing on top of the note would expire the grace immediately.
    newest_ver=$(
        for f in release_notes_v*.md docs/release_notes_v*.md; do
            [ -f "$f" ] || continue
            basename "$f" .md | sed 's/^release_notes_//'
        done | sort -V | tail -1
    )
    for note in release_notes_v*.md docs/release_notes_v*.md; do
        [ -f "$note" ] || continue
        ver=$(basename "$note" .md | sed 's/^release_notes_//')
        if git rev-parse -q --verify "refs/tags/$ver" >/dev/null 2>&1; then
            ok
        else
            if [ "$ver" = "$newest_ver" ]; then
                echo "  $note has no matching tag '$ver' yet, but it is the newest release note in the tree and not yet superseded — rule 15a's expected pre-tag window"
                ok
            else
                fail "$note has no matching tag '$ver' — a release note with no tag is not a release (rule 15)"
            fi
        fi
    done
fi

echo
echo "Check 28: no release note that once existed has vanished (rule 8)"
# Rule 8 is marked mechanical and had no mechanism. Release notes are the only
# history this project keeps outside git itself, and the rule says they are
# archived to docs/, never deleted.
#
# A note moved from the root to docs/ appears in the log as a deletion, so the
# test is on the BASENAME: a note may move, and must still exist somewhere.
if [ "$(git rev-parse --is-shallow-repository 2>/dev/null || echo true)" = "true" ]; then
    echo "  shallow clone — history not available, rule 8 not checkable here"
    ok
else
    # Scoped to real release notes (root + docs/). A bare '*release_notes_v*.md'
    # glob also matches SYNTHETIC notes inside evals/cases/*/input/, so deleting a
    # fixture tripped rule 8 as if a real note had been removed (2026-09-17).
    deleted=$(git log --diff-filter=D --name-only --format= -- 'release_notes_v*.md' 'docs/release_notes_v*.md' 2>/dev/null | sort -u || true)
    if [ -z "$deleted" ]; then
        ok
    else
        while IFS= read -r path; do
            [ -z "$path" ] && continue
            base=$(basename "$path")
            if [ -f "$base" ] || [ -f "docs/$base" ]; then
                ok
                continue
            fi
            # Captured before grepping, not piped: under `set -o pipefail` a
            # `grep -q` closes the pipe on its first match, git log takes
            # SIGPIPE, and the pipeline reports failure exactly when the match
            # succeeds. The bug is invisible until the branch should fire.
            del_msgs=$(git log --diff-filter=D --format=%B -- "$base" "docs/$base" </dev/null 2>/dev/null || true)
            if printf '%s' "$del_msgs" | grep -qi 'rule 8a'; then
                # Rule 8a permits deleting a note for a tag that never existed by
                # an act of release authority, and makes the commit message the
                # artifact: it must name the tag and how the conditions were
                # confirmed. Without this branch 8a was unexecutable -- the rule
                # allowed a deletion the gate then refused forever (2026-09-19).
                echo "  $base deleted under rule 8a — the deleting commit cites it"
                ok
            else
                fail "$base was deleted and exists in neither the root nor docs/ — release notes are archived, never removed (rule 8); a deletion under rule 8a must say so in its commit message"
            fi
        done <<< "$deleted"
    fi
fi

echo
echo "Check 29: only install.sh writes the Claude symlink directories (rule 14)"
# Rule 14 — "one installer, one canonical path" — was the last of the four rules
# marked mechanical with no mechanism. It is only PARTLY mechanizable, and this
# check is deliberately the part that is: no shell script other than install.sh
# may reference the Claude symlink directories under ~/.claude.
#
# The pattern is not written literally anywhere above, because the first draft of
# this check flagged tests/check.sh itself — a checker matching its own comment.
# Removing the literal beats adding an exemption: an exemption would also have
# excused a genuine second installer that happened to live in this file.
#
# It does NOT establish "one canonical path" in the broader sense — that a second
# checkout is not competing for the same links, or that a user has not wired
# something by hand. Those are judgment, and the rule now says so rather than
# carrying a label it cannot support.
for script in $(git ls-files '*.sh' | sort); do
    case "$script" in install.sh) continue ;; esac
    # Built from pieces so the literal never appears in this file — see above.
    _cd='claude/'
    if grep -q "${_cd}agents\|${_cd}commands" "$script" 2>/dev/null; then
        fail "$script references the Claude symlink directories — install.sh is the one installer (rule 14)"
    else
        ok
    fi
done

echo
echo "Check 30: no expected keyword appears in ordinary finding-free prose"
# The mirror of Check 19, on the other side of the case. Check 19 stops a
# `must_not_find` guard from firing on a CORRECT report. Nothing stopped an
# `expected` keyword from being satisfied by an INCORRECT one.
#
# Grading is substring matching, so a criterion cannot tell a finding from a
# mention — or from a denial. A keyword like "missing" is satisfied by the
# sentence saying nothing is missing, and short terms match inside longer words
# ("sh" inside "should").
#
# TERM-LEVEL, NOT WHOLE-CASE: grading each case against one hollow report
# catches only the most egregious, because a generic report cannot carry the
# domain words a finding-free report in that domain would use. Testing each
# term's NEGATION is the dead end PF-011 records. What is decidable is whether
# the term is a word ordinary review prose already contains.
#
# WHAT THIS CHECKS, EXACTLY: that no `expected` or `location` keyword appears in
# the corpus below. It is complete for that. It does NOT establish that a
# criterion requires the defect — a term absent from this corpus can still be
# domain-natural in a finding-free report ("heading" for a docs review), and
# `iris-001`'s second criterion was found by hand, not by this.
hollow_corpus=$(mktemp)
cat > "$hollow_corpus" <<'HOLLOW'
# Review

## Summary

I read every file that was provided and compared them against one another.
The structure is consistent, the naming is clear, and the implementation
matches what the documentation describes. It should be adequate as it
stands. Nothing is missing, nothing is absent, and I found no gap.

## Files reviewed

Each file was opened and read in full.

## Verdict

No issues found. No change is recommended and there is nothing further to
report. This looks correct to me and I would not alter it.
HOLLOW
for case_file in evals/cases/*/case.yaml; do
    id=$(basename "$(dirname "$case_file")")
    terms=$(awk '/^expected:/{f=1} /^(must_not_find|declared_defects|notes):/{f=0} f&&/^ *- "/{gsub(/^ *- "|"$/,""); print}' "$case_file")
    [ -z "$terms" ] && { ok; continue; }
    while IFS= read -r term; do
        [ -z "$term" ] && continue
        if grep -qiF -- "$term" "$hollow_corpus" 2>/dev/null; then
            fail "$id: expected keyword \"$term\" appears in ordinary finding-free review prose — this criterion can be satisfied by a report that found nothing (rule 25, expected side)"
        else
            ok
        fi
    done <<< "$terms"
done
rm -f "$hollow_corpus"

echo
echo "Check 31: the repo root holds exactly the documents rule 1 whitelists"
# PROJECT_RULES.md rule 1. The root list was prose for twenty releases and no
# check ever read the root, so the one thing it existed to catch went unnoticed
# for the life of the project: CLAUDE.md sat on the root whitelist
# `zofia-kaminska` hands every project she seeds and had never existed here.
# Her audit mode could not find it either — it checks the layout a project's
# own book states, and this book stated a different one (2026-09-16, rule 0).
#
# Parses the rule-1 table — first column, backticked — and compares it against
# the TRACKED files at the root. Three failure modes, all mechanical:
#   a. a tracked root file that is on no whitelist entry (sprawl)
#   b. a whitelisted document that does not exist (a rule about a file nobody
#      created is unenforceable, which is how this check came to be written)
#   c. anything other than exactly one release note at the root (rule 8
#      archives the older ones to docs/, it does not leave them here)
#   d. that single root release note being for some version other than the
#      newest v* tag. (c) alone was green through the whole of
#      v1.21.0 -> v1.22.0: the root held release_notes_v1.21.0.md while
#      v1.22.0's note sat in docs/ — exactly one note at the root, and the
#      wrong one. Counting never asked WHICH (2026-09-17).
#
# Tracked, not present on disk: an untracked scratch file at the root is a
# developer's business, and failing the gate on one would teach people to
# ignore this check. Dotfiles are excluded because .gitignore and .github/ are
# tool configuration, not documents, and rule 1 governs documents half-covering
# each other's ground. Directories are excluded for the same reason the rule
# lists them in prose rather than in the table.
mapfile -t ROOT_WHITELIST < <(sed -n '/^## 1\. /,/^## 2\. /p' PROJECT_RULES.md \
    | grep -E '^\| `[^`]+` *\|' \
    | awk -F'|' '{print $2}' \
    | tr -d ' `')

if [ "${#ROOT_WHITELIST[@]}" -eq 0 ]; then
    fail "rule 1's root whitelist table is missing or unparseable in PROJECT_RULES.md — the check cannot be run, which is a finding, not a pass"
elif ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "  not a git checkout — the tracked root file list is unavailable here"
    ok
else
    mapfile -t ROOT_FILES < <(git ls-files | grep -v '/' | grep -v '^\.' | sort)

    for f in "${ROOT_FILES[@]:-}"; do
        [ -z "$f" ] && continue
        matched=0
        for entry in "${ROOT_WHITELIST[@]}"; do
            # $entry is deliberately unquoted: the release-note row is a glob.
            case "$f" in $entry) matched=1; break ;; esac
        done
        if [ "$matched" -eq 1 ]; then
            ok
        else
            fail "$f is tracked at the repo root and matches no entry in rule 1's whitelist — a new root file needs an explicit ask (rule 1)"
        fi
    done

    for entry in "${ROOT_WHITELIST[@]}"; do
        case "$entry" in
            *'*'*)
                count=0
                the_one=""
                for f in "${ROOT_FILES[@]:-}"; do
                    case "$f" in $entry) count=$((count + 1)); the_one="$f" ;; esac
                done
                if [ "$count" -eq 1 ]; then
                    ok
                else
                    fail "rule 1 allows exactly one '$entry' at the root and $count are tracked there (rule 8 archives the rest to docs/)"
                fi
                # And it must be the CURRENT one. Same degradation shape as the
                # `not a git checkout` arm above and Checks 27/28: a clone with
                # no tags cannot answer this, and says so rather than passing
                # quietly.
                if [ "$count" -eq 1 ]; then
                    newest_tag=$(git tag --list 'v*' | sort -V | tail -1)
                    if [ -z "$newest_tag" ]; then
                        echo "  no v* tags in this clone — cannot tell which release note is current; not checkable here"
                        ok
                    else
                        case "$the_one" in
                            *"$newest_tag"*) ok ;;
                            *) fail "the root release note is '$the_one' but the newest tag is $newest_tag — the current release's note belongs at the root and the older one in docs/ (rule 8)" ;;
                        esac
                    fi
                fi
                ;;
            *)
                if [ -f "$entry" ]; then
                    ok
                else
                    fail "rule 1's whitelist names '$entry' at the root and it does not exist — a rule about a file nobody created is unenforceable (rule 1)"
                fi
                ;;
        esac
    done
fi

echo
echo "Check 32: the two questions blocks exist and share no question"
# PROJECT_RULES.md rule 1, "one audience, one job, one home" — the clause that
# was prose until the questions blocks landed and gave it something to hold.
#
# README.md carries the standing set (what this project keeps asking, and what
# asks it); CLAUDE.md carries the working form (what a change must answer, and
# when). The same question in both is the failure the clause names: it gets
# answered differently in each, and the copy that is wrong is never the one you
# are reading.
#
# WHAT THIS CHECKS, EXACTLY: that both blocks are present, neither is empty,
# and no question line appears verbatim in both after normalising case,
# markdown and trailing punctuation. It cannot see a paraphrase — two questions
# meaning one thing in different words pass, and that stays a reader's job.
# Named narrowly for that reason.
#
# The `|| true` on both assignments is load-bearing, and its absence is how
# this check's first draft behaved: under `pipefail` the trailing grep exits 1
# when a block is missing — the exact case this check exists to report — so the
# assignment inherited 1 and `set -e` killed the suite after printing this
# check's heading and before the Summary line. Silent death instead of a
# finding, which is rule 2 turned on the checker. Check 18 carries a comment
# on the same mechanism.
q_extract() {  # file, heading-regex -> normalised question lines
    awk -v h="$2" '
        $0 ~ h {inblock=1; next}
        inblock && /^## / {inblock=0}
        inblock && /\?/ {print}
    ' "$1" \
    | sed 's/^[-* ]*//; s/^|//; s/|.*$//; s/\*\*//g; s/`//g; s/^ *//; s/ *$//' \
    | tr '[:upper:]' '[:lower:]' \
    | grep '?' | sort -u
}
readme_qs=$(q_extract README.md '^## The questions' || true)
claude_qs=$(q_extract CLAUDE.md '^## Questions a change here must answer' || true)

if [ -z "$readme_qs" ]; then
    fail "README.md has no questions block, or it carries no question — rule 1 gives that document the standing set"
elif [ -z "$claude_qs" ]; then
    fail "CLAUDE.md has no questions block, or it carries no question — rule 1 gives that document the working form"
else
    ok
    shared=$(comm -12 <(printf '%s\n' "$readme_qs") <(printf '%s\n' "$claude_qs"))
    if [ -n "$shared" ]; then
        while IFS= read -r q; do
            [ -z "$q" ] && continue
            fail "\"$q\" is in both questions blocks — one audience, one job, one home (rule 1)"
        done <<< "$shared"
    else
        ok
    fi
fi

echo
echo "Check 33: the release gate's rows and the documented note schema agree"
# PROJECT_RULES.md rule 15b. The gate decides five rows against reality and the
# note schema in agents/haruto-nakamura.md tells whoever writes the note what
# those keys are. Two lists, one contract: a row added to the script and not
# the schema is a gate nobody was told about, and a row in the schema that the
# script does not parse is a promise nothing enforces.
#
# Order matters as well as membership — the schema is what a release note is
# written from, and a reader filling rows top to bottom should produce the
# order the gate reads.
#
# This does NOT check that the gate's rows are the right rows. It checks that
# the two documents cannot drift apart, which is the failure mode a second copy
# always has.
if [ ! -f tests/release_gate.sh ]; then
    fail "tests/release_gate.sh is missing — rule 15b names it as the gate every release runs"
else
    gate_rows=$(grep -E '^ROWS=\(' tests/release_gate.sh \
        | sed 's/^ROWS=(//; s/).*$//' | tr ' ' '\n' | grep -E '^[a-z]+$' || true)
    # The heading is indented: the schema lives in a fenced block inside a
    # numbered list item, so an anchored /^## / never matches it. The first
    # draft of this check did exactly that and reported the schema missing.
    schema_rows=$(awk '/^ *## Release gate *$/{f=1; next} f && /^ *```/{exit} f' \
        agents/haruto-nakamura.md \
        | sed -n 's/^ *- \([a-z][a-z]*\):.*/\1/p' || true)
    if [ -z "$gate_rows" ]; then
        fail "no ROWS=( ... ) list parsed from tests/release_gate.sh — the gate's contract is unreadable"
    elif [ -z "$schema_rows" ]; then
        fail "no release-gate rows parsed from agents/haruto-nakamura.md's note schema (rule 15b)"
    elif [ "$gate_rows" = "$schema_rows" ]; then
        ok
    else
        fail "release-gate rows differ between tests/release_gate.sh and haruto's note schema (rule 15b)"
        printf '        gate:   %s\n' "$(printf '%s' "$gate_rows" | tr '\n' ' ')"
        printf '        schema: %s\n' "$(printf '%s' "$schema_rows" | tr '\n' ' ')"
    fi
fi

echo
echo "Check 34: exactly one board carries the project forward"
# PROJECT_RULES.md rule 21. Check 31 keeps the ROOT clean, so a TODO.md beside
# the board already fails — and a docs/STATUS.md or a BACKLOG.md one directory
# down passed everything. A second to-do file does not announce itself: both
# get written to, each becomes right about different things, and the one you
# read is the one that is wrong.
#
# The 2026-07-31 incident this repo already carries is the same failure on the
# rule book (project_rules.md beside PROJECT_RULES.md, each invisible to the
# other writer). The board is likelier to attract a rival than the rule book
# was, because everyone has a favourite name for their to-do list.
#
# Two exemptions, both narrow and both named in the output:
#   * evals/cases/** — fixture inputs contain boards on purpose (zofia-003's
#     TODO.md is the trap that case exists to set). They are unreachable from
#     this repo's tooling.
#   * docs/SESSION_LOG_*.md — a campaign log is append-only history, like a
#     release note. It records what happened, never what is next.
BOARD_SHAPED='^(TODO|TODOS|STATUS|ROADMAP|BACKLOG|TASKS|TASKLIST|KANBAN|PLAN|NEXT_STEPS|BOARD|PATHWAY_FORWARD)\.(md|txt|org|rst)$'
board_files=""
while IFS= read -r f; do
    case "$f" in
        evals/cases/*) continue ;;
        docs/SESSION_LOG_*) continue ;;
    esac
    base=$(basename "$f")
    if printf '%s' "$base" | grep -qiE "$BOARD_SHAPED"; then
        board_files="${board_files}${f}"$'\n'
    fi
done < <(git ls-files 2>/dev/null || true)

board_files=$(printf '%s' "$board_files" | grep -v '^$' || true)
if [ -z "$board_files" ]; then
    fail "no board found — rule 21 requires PATHWAY_FORWARD.md at the root"
elif [ "$board_files" = "PATHWAY_FORWARD.md" ]; then
    ok
else
    while IFS= read -r f; do
        [ -z "$f" ] && continue
        [ "$f" = "PATHWAY_FORWARD.md" ] && continue
        fail "$f is a second board — PATHWAY_FORWARD.md is the one that carries the project forward (rule 21); fold it in or rename it to something that is not a to-do list"
    done <<< "$board_files"
    printf '%s\n' "$board_files" | grep -qx 'PATHWAY_FORWARD.md' \
        || fail "PATHWAY_FORWARD.md is not at the repo root — that name, that location (rule 21)"
fi

echo
echo "Check 35: every tagged release has a release note AND a GitHub Release (rule 15)"
# Check 27 proves every release NOTE has a matching TAG; this proves every
# TAG has both a note and a GitHub Release object. A pushed tag with no
# Release is not a published release.
#
# This is the only check that shells out to `gh`. Rule 21b's network ban is
# scoped to PATHWAY_FORWARD.md evidence commands, not to tests/check.sh.
#
# DEGRADE-HONESTLY GUARD, same discipline as Checks 27/28's SHALLOW/TAGLESS
# guards: `gh` missing, `gh` unauthenticated, or no tags are environments
# where the check cannot run — named, `ok`, never a silent pass and never a
# false fail for an environment problem.
if ! command -v gh >/dev/null 2>&1; then
    echo "  no gh CLI installed — cannot check for GitHub Releases, rule 15's Release half not checkable here"
    ok
elif ! gh auth status >/dev/null 2>&1; then
    echo "  gh CLI installed but not authenticated against this repo — rule 15's Release half not checkable here"
    ok
elif [ -z "$(git tag --list 'v*' 2>/dev/null || true)" ]; then
    echo "  no tags in this clone — rule 15 not checkable here"
    ok
else
    # The NOTE leg binds on EVERY tag, local or pushed. The RELEASE leg binds
    # only on tags that exist on the remote: a local-only tag has no GitHub
    # Release by definition and cannot be given one, so asserting otherwise
    # asserts something unsatisfiable. That is not pedantry — haruto's
    # workflow tags locally (step 9), pushes (12), then creates the Release
    # (12a), so between 9 and 12 the tag exists only here and GitHub has no
    # ref to attach a Release to. Failing then demands an action nobody can
    # take until the push: a terminal refusal (rule 28).
    # A PUSHED tag with no Release is the real defect and stays a hard fail.
    #
    # Enumeration is `git ls-remote --tags origin`, not a remote-tracking
    # ref: git fetches tags into refs/tags/ alongside locally-created ones,
    # so there is no local ref namespace that distinguishes the two. Asking
    # the remote is the only sound answer to "is this tag pushed".
    remote_tags=""
    remote_reachable=1
    # A clone whose origin is not the GitHub repo (a local-path clone, a
    # mirror, a fork behind a different URL) cannot be asked about Releases:
    # `gh release view` resolves the repo from origin and reports the failure
    # the same way it reports a genuinely missing Release. Left unguarded
    # this fails every pushed tag at once for an environment reason — it did,
    # 28 false FAILs in a plain `git clone /path/to/consilium` on 2026-09-18.
    gh_scope=1
    origin_url=$(git remote get-url origin 2>/dev/null || true)
    # Match github.com as the actual host, not as a substring anywhere in the
    # URL: a local mirror path like /data/mirrors/github.com-consilium/ or a
    # clone under ~/github.com-backups/ contains the string without being the
    # GitHub remote, and a substring match misreads it as in-scope — which
    # reproduces the exact false-FAIL failure mode this guard exists to
    # prevent, just on a different clone shape.
    #
    # Recognised host positions, one case arm per URL scheme this repo's
    # remotes actually use:
    #   https://github.com/... or http://github.com/...
    #   ssh://git@github.com/...  (or ssh://github.com/...)
    #   git@github.com:...        (scp-like syntax, no scheme)
    #   git://github.com/...
    if [ -z "$origin_url" ]; then
        gh_scope=0
        echo "  no origin remote configured — rule 15's Release half not checkable here; the note half still binds"
    else
        case "$origin_url" in
            https://github.com/*|https://github.com|\
            http://github.com/*|http://github.com|\
            ssh://*@github.com/*|ssh://*@github.com|\
            ssh://github.com/*|ssh://github.com|\
            git@github.com:*|\
            git://github.com/*|git://github.com) ;;
            *)  gh_scope=0
                echo "  origin is not a GitHub remote ($origin_url) — rule 15's Release half not checkable here; the note half still binds" ;;
        esac
    fi
    if remote_raw=$(git ls-remote --tags origin 2>/dev/null); then
        remote_tags=$(printf '%s\n' "$remote_raw" | sed 's#.*refs/tags/##; s/\^{}$//')
    else
        remote_reachable=0
        echo "  cannot reach origin to list remote tags — rule 15's Release half not checkable here; the note half still binds"
    fi
    while IFS= read -r tag; do
        [ -z "$tag" ] && continue
        if [ -f "release_notes_${tag}.md" ] || [ -f "docs/release_notes_${tag}.md" ]; then
            ok
        else
            fail "$tag has a git tag but no release_notes_${tag}.md in the root or docs/ (rule 15)"
        fi
        if [ "$remote_reachable" -eq 0 ] || [ "$gh_scope" -eq 0 ]; then
            ok
        elif ! printf '%s\n' "$remote_tags" | grep -qxF "$tag"; then
            echo "  $tag is local-only (not on origin) — a Release cannot exist for an unpushed tag; the Release half binds once it is pushed"
            ok
        elif gh release view "$tag" >/dev/null 2>&1; then
            ok
        else
            fail "$tag has a git tag but no GitHub Release — a pushed tag with no Release object is not a published release (rule 15)"
        fi
    done < <(git tag --list 'v*' | sort -V)
fi

echo
echo "Check 36: no tracked file contains a merge-conflict marker"
#
# Structural, deterministic, and there is no runtime to catch it. A conflict
# marker is valid text in every file this repo ships, so nothing downstream
# objects: the board, the rule book and an agent prompt all parse and read as
# normal until a human hits the marker weeks later.
#
# Scope is markers and nothing else. This does not read prose, does not judge
# content, and must not grow: a check that starts policing file health is the
# shape this suite just retired two checks for.
conflicted=0
while IFS= read -r f; do
    if LC_ALL=C grep -qE '^(<<<<<<< |=======$|>>>>>>> )' "$f" 2>/dev/null; then
        fail "$f contains a merge-conflict marker — a conflicted file parses as valid text and ships silently"
        conflicted=$((conflicted + 1))
    fi
done < <(git ls-files -- '*.md' '*.sh' '*.yaml' '*.yml' '*.awk' '*.tsv')
[ "$conflicted" -eq 0 ] && ok


echo
echo "Summary: $pass_count passed, $fail_count failed"
[ "$fail_count" -eq 0 ] || exit 1
