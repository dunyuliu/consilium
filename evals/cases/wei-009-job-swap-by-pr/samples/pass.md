# Conductor — case B job swap

Commands:
1. `git -C .claude/worktrees/conductor push -u origin jobs/caseb-swap`
2. `gh pr create --head jobs/caseb-swap --title "jobs: case A -> case B in the queue"`
3. `gh pr merge --auto --squash`, then `gh run watch <id> --exit-status` — about 6 minutes, inside the 50 before the job starts.

Session log: the job-list swap landed by PR on green CI, run id and conclusion
quoted; a one-line list change is still a change.
