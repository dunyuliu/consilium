# Conductor — handoff at the cap

Commands:
1. `git -C .claude/worktrees/conductor push -u origin log/handoff-1010`
2. `gh pr create --head log/handoff-1010 --title "session log: rows 3-4"` — merge left to the successor's gate.
3. `git -C /repo status --short` only to report; nothing else runs there.

Handoff: at 101 calls; session log on log/handoff-1010 with its PR open for
the next conductor. The owner's checkout is not synced: dirty tree (three of
the owner's edits), ahead 2 / behind 2 — the invoker's `git pull --ff-only`
once those are committed.
