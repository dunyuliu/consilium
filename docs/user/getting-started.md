# Getting started

Consilium is a team of named AI specialists that accelerates scientific
innovation, from idea and proposal through methods, audits and peer review
to release and publication, backed by checks that keep the team itself
honest. It runs on Claude Code; `README.md` has the install steps and
the Quick start block.

You rarely need to name a specialist directly — a front-door agent routes to
the right one(s) for you. This page is about picking that front door, and
what happens after you do.

## Picking a front door

| What you need | Front door |
|---|---|
| Science — manuscript, methodology, "is this sound?" | `elena-hartmann` (or `/review`) |
| Code, data, audits — "find what's wrong" | `victor-reyes` (or `/audit`) |
| Refactor working code | `kai-fischer` (or `/refactor`) |
| Design / write tests for a project | `iris-vermeulen` (or `/test-design`) |
| Port a binary between languages with bit-identical parity | `mira-volkov` (or `/port`) |
| Conduct a long-running multi-mission engineering campaign | `wei-lin` (or `/campaign`) |
| New feature or method with no reference implementation | `dunyu-liu` (or `/implement`) |
| Cut a release / fix CI / keep the project shippable | `haruto-nakamura` (or `/release`) |
| Stage for public release — GitHub + Zenodo | `anya-petrov` (or `/stage-publish`) |
| Grade what an agent just produced — improve next time | `nadia-hadid` (or `/eval-deployment`) |
| Work the status board unattended for a stated budget | `wei-lin` (or `/autopilot <budget>`) |
| Draft a funding proposal end to end | `shu-han` (or `/propose`) |

Three of those front doors do their own internal routing, so naming them
covers more ground than the single row suggests:

| Front door | When | What it does with the work |
|---|---|---|
| `victor-reyes` | "Audit my project", "find what's wrong" — technical scope. Single audit task. | Diagnoses scope and runs the right specialist(s) in parallel, then aggregates findings. |
| `elena-hartmann` | "Is the science sound?", "review this manuscript" — scientific scope. Single verdict. | Gives the holistic verdict herself; delegates technical work to Victor. |
| `wei-lin` | "Run this porting / refactor / optimization roadmap for X hours" — campaign scope spanning hours-to-days. | Owns merge gates, version cadence, and the session log; dispatches `mira-volkov` / `iris-vermeulen` / `lars-eriksson` / `haruto-nakamura` / `kai-fischer` in isolated worktrees. |

## What Quick start actually does

`bash tests/check.sh` (shown in README's Quick start) is the structural gate
for this repo's own prompts and tests — run it right after install to confirm
your clone is wired correctly. It is pure bash with no dependencies, so if it
exits 0 your installation is sound.

`/audit`, `/review`, and `/autopilot <budget>` are invoked from inside a
Claude Code session, anywhere on your machine — not from the consilium
checkout. They work because `install.sh` symlinked `agents/*.md` and
`commands/*.md` into `~/.claude/`.

- `/audit` dispatches `victor-reyes`, who scopes and parallelizes the right
  technical specialists against whatever project you are sitting in.
- `/review` dispatches `elena-hartmann` for a full editorial verdict on a
  manuscript or analysis.
- `/autopilot <budget>` dispatches `wei-lin` to work a project's status board
  unattended for the stated budget (`12h`, `3 milestones`, `until the board is
  green`). See `docs/user/commands.md` for exactly what it is and is not
  allowed to do without asking you first.

## Next

- `docs/user/agents.md` — the full specialist roster, in depth
- `docs/user/commands.md` — every slash command, including the autopilot
  authorization boundary
- `docs/user/citing.md` — how to cite consilium
- `docs/maintainer.md` — if you are adding a specialist, editing a rule, or
  cutting a release
