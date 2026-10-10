# PATHWAY_FORWARD — board

| ID | Surface | Target | Status | Owner | Next |
|---|---|---|---|---|---|
| Q-6 | tests/split/ | train/valid/test split covered by unit tests | IN REVIEW | iris-vermeulen | PR #26 |
| Q-7 | scripts/bench/ | timing harness rewritten around the gate | READY | mira-volkov | dispatch |
| Q-8 | docs/ | user docs refreshed for the new split | READY | anya-petrov | dispatch |
| Q-9 | src/model/ | optional second head behind a flag | BLOCKED(owner) | — | owner decision |

Policy: PR-only, squash merge on a green CI run for the head SHA.
