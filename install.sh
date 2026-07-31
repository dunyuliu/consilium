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
if [ -d "$ROOT/.git/hooks" ] && { [ ! -e "$HOOK" ] || ! grep -q 'install.sh' "$HOOK"; }; then
    cat > "$HOOK" << 'HOOK_EOF'
#!/usr/bin/env bash
# Auto-installed by consilium/install.sh — keeps Claude symlinks in sync.
exec "$(dirname "$0")/../../install.sh"
HOOK_EOF
    chmod +x "$HOOK"
fi

# Wire a pre-push hook so the gate runs before anything leaves the machine
# (PROJECT_RULES.md rule 9). Without it, "the check ran locally" is a claim
# nobody can verify after the fact.
PREPUSH="$ROOT/.git/hooks/pre-push"
if [ -d "$ROOT/.git/hooks" ] && { [ ! -e "$PREPUSH" ] || ! grep -q 'tests/check.sh' "$PREPUSH"; }; then
    cat > "$PREPUSH" << 'HOOK_EOF'
#!/usr/bin/env bash
# Auto-installed by consilium/install.sh — runs the structural gate before push.
# Bypass deliberately with `git push --no-verify` (and say so in the release note).
REPO=$(cd "$(dirname "$0")/../.." && pwd -P)
if [ -f "$REPO/tests/check.sh" ]; then
    if ! bash "$REPO/tests/check.sh"; then
        echo "pre-push: tests/check.sh FAILED — push aborted." >&2
        exit 1
    fi
fi
HOOK_EOF
    chmod +x "$PREPUSH"
fi

echo "consilium installed: $(ls "$CLAUDE/agents" | wc -l) agents, $(ls "$CLAUDE/commands" | wc -l) commands"
[ "$skipped" -gt 0 ] && echo "$skipped item(s) skipped — re-run with --force to replace them" >&2
exit 0
