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
#
# Checks 6 and 7 exist because check 4 passes on a bare mention: an agent
# could be absent from the model table, the roster, or the tree with the
# gate green. Both were negative-tested when added.
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

echo
echo "Summary: $pass_count passed, $fail_count failed"
[ "$fail_count" -eq 0 ] || exit 1
