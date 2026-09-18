#!/usr/bin/env bash
# The canonical consilium installer (PROJECT_RULES.md rule 14).
#
# Reconciles ~/.claude/agents/ and ~/.claude/commands/ symlinks with the
# current consilium tree, and wires a post-merge hook so every later
# `git pull` re-runs this automatically. Idempotent and safe to re-run.
#
# Usage:
#   ./install.sh            # install / reconcile
#   ./install.sh --force    # also replace foreign symlinks and real files
#
# Refuses by default to clobber anything it did not create: a symlink pointing
# somewhere else, or a real file/directory. Those are reported and skipped, so
# an install can never silently destroy a hand-written agent.

set -euo pipefail
shopt -s nullglob   # a glob matching nothing yields zero iterations

ROOT=$(cd "$(dirname "$0")" && pwd -P)
CLAUDE=${HOME}/.claude
FORCE=0

case "${1:-}" in
    --force) FORCE=1 ;;
    "")      ;;
    *)       echo "Unknown argument: ${1}. Usage: $0 [--force]" >&2; exit 1 ;;
esac

mkdir -p "$CLAUDE/agents" "$CLAUDE/commands"

# Drop broken symlinks (agent or command renamed/removed upstream).
find "$CLAUDE/agents" "$CLAUDE/commands" -maxdepth 1 -type l ! -exec test -e {} \; -delete

# Bump when any hook body changes. The marker is appended after writing, not
# typed into the body: the heredocs are quoted, so a literal stamp silently
# drifts from this variable — it did, and the hook then rewrote itself on every
# run while never matching.
HOOK_VERSION="consilium-hook-v4"

skipped=0

link_one() {
    local src="$1" dst="$2" existing
    if [ -L "$dst" ]; then
        existing="$(readlink "$dst")"
        [ "$existing" = "$src" ] && return 0
        if [ "$FORCE" = 1 ]; then
            ln -sf "$src" "$dst"
            echo "  redo $(basename "$dst") (was -> $existing)"
            return 0
        fi
        echo "  SKIP $(basename "$dst") — points to $existing; use --force" >&2
        skipped=$((skipped + 1))
        return 0
    fi
    if [ -e "$dst" ]; then
        if [ "$FORCE" = 1 ] && [ ! -d "$dst" ]; then
            rm "$dst" || { echo "  ERROR: cannot remove $dst" >&2; return 1; }
            echo "  redo $(basename "$dst") (was a regular file)"
        else
            echo "  SKIP $(basename "$dst") — real $([ -d "$dst" ] && echo directory || echo file) exists; refusing to replace" >&2
            skipped=$((skipped + 1))
            return 0
        fi
    fi
    ln -s "$src" "$dst" || { echo "  ERROR: failed to link $dst -> $src" >&2; return 1; }
}

for f in "$ROOT/agents/"*.md;   do link_one "$f" "$CLAUDE/agents/$(basename "$f")";   done
for f in "$ROOT/commands/"*.md; do link_one "$f" "$CLAUDE/commands/$(basename "$f")"; done

# Wire a post-merge hook so future `git pull` runs this script automatically.
HOOK="$ROOT/.git/hooks/post-merge"
if [ -d "$ROOT/.git/hooks" ] && { [ ! -e "$HOOK" ] || ! grep -q "$HOOK_VERSION" "$HOOK"; }; then
    cat > "$HOOK" << 'HOOK_EOF'
#!/usr/bin/env bash
# Auto-installed by consilium/install.sh — keeps Claude symlinks in sync.
exec "$(dirname "$0")/../../install.sh"
HOOK_EOF
    printf '# %s\n' "$HOOK_VERSION" >> "$HOOK"
    chmod +x "$HOOK"
fi

# Count what this checkout actually linked, not what happens to sit in the
# target directory. `ls | wc -l` counted every entry there — foreign symlinks
# that were skipped, real files that were refused, and hand-written agents that
# have nothing to do with consilium. On a machine where every target was a
# foreign real file this printed "consilium installed: 21 agents" having
# installed NONE, directly above "21 item(s) skipped". The success line comes
# first, so a reader skimming sees the reassuring number. Found 2026-08-05.
linked_count() {
    local dir="$1" f n=0
    for f in "$dir"/*; do
        [ -L "$f" ] || continue
        case "$(readlink -f "$f" 2>/dev/null)" in "$ROOT"/*) n=$((n + 1)) ;; esac
    done
    echo "$n"
}

# Hooks live in $ROOT/.git/hooks, which only exists when $ROOT/.git is a real
# directory (a normal checkout). In a linked worktree, .git is a FILE pointing
# at the main checkout's git-dir, so that path never exists and zero hooks get
# wired. A script that reported plain success once hid that: an agent pushed
# with no pre-push gate and deleted 548 of 549 lines from agents/wei-lin.md on
# main (incident 2026-09-17).
#
# Only post-merge is wired now. Commit 56ec728 recorded the decision to drop
# pre-commit and pre-push local enforcement; this commit carries it out. The
# guard below still matters for post-merge and for reporting the worktree case
# honestly — it does not resolve the real hooks dir for a worktree, it only
# stops the script from lying about what got wired.
hooks_wired=0
[ -e "$ROOT/.git/hooks/post-merge" ] && hooks_wired=$((hooks_wired + 1))
if [ ! -d "$ROOT/.git/hooks" ]; then
    echo "no hooks wired: $ROOT/.git is a file, not a directory (linked worktree)" >&2
    echo "  — hooks live in the main checkout; run install.sh there instead" >&2
fi

agents_linked=$(linked_count "$CLAUDE/agents")
commands_linked=$(linked_count "$CLAUDE/commands")
echo "consilium installed: $agents_linked agents, $commands_linked commands, $hooks_wired/1 hooks wired"
[ "$skipped" -gt 0 ] && echo "$skipped item(s) skipped — re-run with --force to replace them" >&2

if [ "$agents_linked" -eq 0 ] && [ "$commands_linked" -eq 0 ] && [ "$hooks_wired" -eq 0 ]; then
    echo "install.sh: nothing installed — treating as failure, not success" >&2
    exit 1
fi
exit 0
