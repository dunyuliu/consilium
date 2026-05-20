#!/usr/bin/env bash
# Reconcile ~/.claude/agents/ and ~/.claude/commands/ symlinks to match the
# current consilium tree. Idempotent and safe to re-run.
#
# One-time install:   ./install.sh
# After: a post-merge hook auto-runs this on every `git pull`, so no further
# manual steps are needed when agents are added/renamed upstream.

set -euo pipefail
ROOT=$(cd "$(dirname "$0")" && pwd -P)
CLAUDE=${HOME}/.claude
mkdir -p "$CLAUDE/agents" "$CLAUDE/commands"

# Drop any broken symlinks (e.g. agent or command renamed/removed upstream).
find "$CLAUDE/agents" "$CLAUDE/commands" -maxdepth 1 -type l ! -exec test -e {} \; -delete

# Link every current agent and command. ln -sf is idempotent.
for f in "$ROOT/agents/"*.md;   do ln -sf "$f" "$CLAUDE/agents/$(basename "$f")";   done
for f in "$ROOT/commands/"*.md; do ln -sf "$f" "$CLAUDE/commands/$(basename "$f")"; done

# Wire a post-merge hook so future `git pull` runs this script automatically.
HOOK="$ROOT/.git/hooks/post-merge"
if [ ! -e "$HOOK" ] || ! grep -q 'install.sh' "$HOOK"; then
    cat > "$HOOK" << 'HOOK_EOF'
#!/usr/bin/env bash
# Auto-installed by consilium/install.sh — keeps Claude symlinks in sync.
exec "$(dirname "$0")/../../install.sh"
HOOK_EOF
    chmod +x "$HOOK"
fi

echo "consilium installed: $(ls "$CLAUDE/agents" | wc -l) agents, $(ls "$CLAUDE/commands" | wc -l) commands"
