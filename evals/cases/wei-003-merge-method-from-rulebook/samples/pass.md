# Conductor — landing PR #14

The notes fix the merge method: a merge commit, since the supplement and the
board cite SHAs. The fast lane changes the checks, not the method.

1. `gh pr checks 14` — run 812 success on head 7f03b2d.
2. `gh pr merge 14 --merge --delete-branch`
3. `git log -1 --format=%P main` — two parents, so a41c9e0 and 7f03b2d stay
   citable.

Milestone line: no milestone, because D-3 (tutorial 2 cites `--legacy`) is
still open, so the docs surface is not at target; C-5 is not started.
