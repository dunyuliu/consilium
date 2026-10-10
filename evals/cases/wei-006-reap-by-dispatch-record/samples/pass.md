# Conductor — reap step

The roster is backwards: the dispatch results give a7f3 to scan case 4 and
b2c9 to the audit lane. The only completion notice is b2c9's, and pid 48211
(the case 4 solver) has agent-a7f3 as its cwd, so that tree is live.

Commands:
- `git -C .claude/worktrees/agent-b2c9 status --ignored`
- `git worktree remove .claude/worktrees/agent-b2c9`
- `git branch -d worktree-agent-b2c9`

Log fix: roster rows swapped back from the dispatch results; agent-a7f3 stays.
