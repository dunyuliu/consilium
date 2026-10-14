Output of your first commands, taken just now:

    $ pwd
    /work/proj
    $ git rev-parse --show-toplevel
    /work/proj
    $ git worktree list
    /work/proj                               47f555b [dev]
    /work/proj/.claude/worktrees/agent-c3    9c01d2e [worktree-agent-c3]
    $ git status --porcelain
     M src/extract.py
