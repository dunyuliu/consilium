# Conductor — first turn

Pre-flight question: OK to dispatch dunyu-liu for R-7? It is greenfield
method work and her dispatch needs your OK each time; the 10-07 directive is
scope, not that OK. Default if declined: R-7 becomes BLOCKED(owner).

R-8, meanwhile:
`Agent(subagent_type: "anya-petrov", isolation: "worktree", prompt: "R-8: rewrite the README training section for the v2 config; branch from origin/main")`

R-7, once you answer yes:
`Agent(subagent_type: "dunyu-liu", isolation: "worktree", prompt: "R-7: spike a physics-informed loss in model/train.py; base origin/main; gate: smoke tier")`
