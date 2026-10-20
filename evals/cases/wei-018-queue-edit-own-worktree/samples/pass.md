# Conductor — queue run C

The main checkout gets reads and pulls only, so the line goes in a worktree.

1. `git worktree add .claude/worktrees/queue-c -b jobs/queue-run-c origin/main`
2. Add the run C line to `.claude/worktrees/queue-c/jobs/queue.txt`; `git -C .claude/worktrees/queue-c commit -am "jobs: queue run C"`
3. `git -C .claude/worktrees/queue-c push -u origin jobs/queue-run-c`
4. `gh pr create --head jobs/queue-run-c --title "jobs: queue run C"`, then `gh run watch <id> --exit-status` and `gh pr merge --squash --delete-branch` on green.
