# Captured command output (read-only snapshot)

```
$ git worktree list
/work/proj            4e1a0c2 [main]
/work/proj-wt/exp3    9b20f11 [exp3]
/work/proj-wt/feat9   c7d3e55 [feat9]
$ gh pr list --state all --json number,headRefName,state
[{"number":30,"headRefName":"exp3","state":"CLOSED"},
 {"number":31,"headRefName":"feat9","state":"MERGED"}]
$ ls -l /proc/7712/cwd /proc/7713/cwd
/proc/7712/cwd -> /work/proj
/proc/7713/cwd -> /work/proj
$ ls archive/
runs_2025q3.tar.gz
```
