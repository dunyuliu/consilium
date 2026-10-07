# Consilium

> An AI specialist team to accelerate scientific innovation. Named
> specialists take research from idea to result: proposals, new methods,
> ports, audits, peer review, releases and publication, with gates and
> checks that measure whether they actually did.

Specialists organised into three teams and a quality bench, each with a
name, a CV, and a thing they refuse to let slide. Runs on Claude Code;
installs by symlink and follows you across machines.

## Install

```bash
git clone https://github.com/dunyuliu/consilium.git ~/consilium
bash ~/consilium/install.sh
```

Idempotent symlinks; safe to re-run after `git pull`. Each subagent loads
its prompt from `~/.claude/agents/<name>.md` and each slash command from
`~/.claude/commands/<name>.md`, both symlinked from this repo. Use
`--force` to re-link when targets have moved — without it, a symlink
pointing elsewhere or a real file is reported and skipped, never clobbered.

## Quick start

```bash
bash ~/consilium/tests/check.sh
```

This is the install check: it is pure bash with no dependencies, and a
green run confirms your clone is wired correctly. Then, inside a Claude
Code session anywhere on your machine:

```
/audit                 # audit a project — Victor routes to the right specialist(s)
/review                # full editorial verdict on a manuscript or analysis
/autopilot 12h          # work the status board unattended for a stated budget
```

You rarely need to name a specialist directly — the front-door agent
routes. See `docs/user/getting-started.md` for how to pick one.

## The team

Three teams plus a quality bench and a campaign conductor.

| Member | Team | Role |
|---|---|---|
| `elena-hartmann` | Editorial | Editor in Chief, Nature. Holistic verdict. The buck stops here. |
| `ziyan-chen` | Editorial | Senior Editor. Citations, DOIs, claim-vs-abstract drift. |
| `shu-han` | Editorial | Proposal author — drafts a funding proposal end to end; Elena gives the verdict, Ziyan checks references. |
| `selin-aydin` | Editorial | Critical reviewer — seismology, earthquake-rupture physics, ground motion. |
| `marco-bianchi` | Editorial | Critical reviewer — geodynamics, geodesy, long-timescale Earth physics. |
| `victor-reyes` | Audit | Audit orchestrator. Routes technical work, runs specialists in parallel, aggregates findings. |
| `lars-eriksson` | Audit | Code auditor — math errors, edge cases, sign conventions, silent failures. |
| `priya-nair` | Audit | Numeric-claim verifier — re-derives from raw anchor data. |
| `jordan-kim` | Audit | Data integrity — extraction quality and end-to-end pipeline tracing. |
| `sophia-okafor` | Audit | Spec drift — docs / methods / config vs actual code. |
| `rafael-santos` | Audit | Physical validity — units, conservation, boundary conditions. |
| `ingrid-lindqvist` | Audit | Mathematical rigor — derivations, stability, theorem applicability. |
| `haruto-nakamura` | Release & pub | Release & maintenance engineer. Cuts versioned releases, keeps CI green. |
| `anya-petrov` | Release & pub | User-docs owner and publication-staging engineer. README, Diátaxis docs, GitHub release + Zenodo deposit, CITATION.cff, DOI. |
| `marta-silva` | Release & pub | Publication-figure engineer. Makes and audits matplotlib figures for print. |
| `kai-fischer` | Quality bench | Refactoring engineer. Simplifies, dedupes, improves naming. Edits production code. |
| `iris-vermeulen` | Quality bench | Test architect. Designs and writes the test pyramid. Edits tests/CI only. |
| `mira-volkov` | Quality bench | Bit-identical porting specialist, any source language to any target. |
| `dunyu-liu` | Quality bench | Senior computational researcher. New implementations where no reference exists. |
| `nadia-hadid` | Quality bench | Onsite evaluation PM. Reviews real deployments, diagnoses misses. |
| `lian-zhao` | Quality bench | Agent-refinement engineer. Owns the prompts themselves — cheaper without worse. |
| `zofia-kaminska` | Quality bench | Project-rules enforcer. Aligns an existing project to a proven rule book. |
| `wei-lin` | Campaign | Workflow conductor. Runs a multi-mission campaign over hours-to-days in isolated worktrees, gating merges on green tests. |

### Models

Open-ended research runs on fable; heaviest reasoning (orchestration, final
verdicts, adversarial reviewing) on opus; deep-but-specific work on sonnet;
pattern-match-heavy auditing on haiku.

| Model | Agents |
|---|---|
| fable | `dunyu-liu` |
| opus | `elena-hartmann`, `victor-reyes`, `marco-bianchi`, `shu-han` |
| sonnet | `nadia-hadid`, `priya-nair`, `jordan-kim`, `rafael-santos`, `ingrid-lindqvist`, `kai-fischer`, `iris-vermeulen`, `mira-volkov`, `haruto-nakamura`, `anya-petrov`, `wei-lin`, `zofia-kaminska`, `selin-aydin`, `lian-zhao`, `marta-silva` |
| haiku | `lars-eriksson`, `sophia-okafor`, `ziyan-chen` |

See `docs/user/agents.md` for what each specialist actually does, with
examples, and `docs/maintainer.md` for the full issue-to-owner routing
table.

## Commands

| Slash | Agent | What |
|---|---|---|
| `/audit` | `victor-reyes` | Eight-section project audit. Writes `AUDIT.md`. |
| `/audit-citations` | `ziyan-chen` | Manuscript citations — DOIs, authors, claim-vs-abstract. |
| `/audit-claim` | `priya-nair` | Verify a specific numeric claim against raw anchor data. |
| `/audit-code` | `lars-eriksson` | Source-file bug hunt — math, edge cases, sign conventions. |
| `/audit-data` | `jordan-kim` | Data integrity — extraction and pipeline. |
| `/audit-math` | `ingrid-lindqvist` | Mathematical rigor — derivations, stability, theorems. |
| `/audit-physics` | `rafael-santos` | Physical validity — units, conservation, BCs. |
| `/audit-spec` | `sophia-okafor` | Spec drift — docs / config vs code. |
| `/refactor` | `kai-fischer` | Simplify, dedupe, improve naming. Applies edits. |
| `/test-design` | `iris-vermeulen` | Design and write the test pyramid. Applies edits to test files only. |
| `/port` | `mira-volkov` | Port a C/Fortran numerical binary to vectorized Python with bit-faithful parity, then optimize. |
| `/campaign` | `wei-lin` | Conduct a long-running multi-mission engineering campaign. |
| `/autopilot` | `wei-lin` | Work the status board unattended for a budget (`autopilot 12h`). |
| `/release` | `haruto-nakamura` | Versioned-release workflow. `release` / `release minor` / `release major`. |
| `/propose` | `shu-han` | Funding proposal end to end. |
| `/review` | `elena-hartmann` | Full editorial decision — verdict, core weakness, Reviewer-2 attack. |
| `/stage-publish` | `anya-petrov` | Stage for GitHub + Zenodo publication. |
| `/eval-deployment` | `nadia-hadid` | Grade a real agent run against its contract, diagnose misses. |
| `/implement` | `dunyu-liu` | Research-heavy new implementation with no reference. |
| `/enforce-rules` | `zofia-kaminska` | Enforce the project rule book — audit, `seed`, or `codify`. |

Full descriptions, and a deep dive on `/autopilot` and `/propose`, in
`docs/user/commands.md`.

## The questions

Three questions are the project's own — the ones this repo is built to keep
answering. Full detail, including what is and is not yet enforced, is in
`docs/maintainer.md`.

1. **Seeding** — does a new project come out with four documents doing four
   jobs (`CLAUDE.md` for agents, `README.md` for users, `PATHWAY_FORWARD.md`
   as a living board, `PROJECT_RULES.md` to anchor the work)? Enforced for
   existence; not yet for whether a seeded README is *credible*.
2. **Release** — does it cover what a release owes (audit, correctness,
   conciseness, docs, a clean tree, green CI, the published tag, the rule
   book followed)? Five of twelve obligations are gate-enforced; the rest
   are on the release engineer, not a row a script checks.
3. **Autopilot** — how is any of that enforced strictly, rather than hoped
   for? By three tiers that bind: a gate that refuses, a recorded verdict a
   check asserts exists, and an owner who is not the author. Prompt prose
   alone is not a tier.

Two more the project keeps asking:

- Is this number from a run, or from a memory?
- What would this tool find if aimed at us?

## Where to go next

- `docs/user/getting-started.md` — how to pick a front door, and what
  Quick start actually does
- `docs/user/agents.md` — the full specialist roster, in depth
- `docs/user/commands.md` — every slash command, including what
  `/autopilot` may do unattended
- `docs/user/citing.md` — how to cite consilium
- `docs/maintainer.md` — beliefs, standards, the responsibility map,
  mechanics, hiring, regression evals, tests, the inspection log, the
  roadmap, and the Layout tree
- `PROJECT_RULES.md` — the binding rule book
- `PATHWAY_FORWARD.md` — the inspection log, present tense
- `CLAUDE.md` — how to work on this repo

## Contact

Questions, bugs, or feature ideas: open a
[GitHub issue](https://github.com/dunyuliu/consilium/issues). Or reach
Dunyu Liu directly at dliu@ig.utexas.edu.

## Cite

Consilium is released under the MIT License (`LICENSE`). If you use it,
please cite it — `CITATION.cff` at the repo root is the machine-readable
source; GitHub's "Cite this repository" button reads it directly. See
`docs/user/citing.md` for the full field list.

```bibtex
@software{liu2026consilium,
  author  = {Liu, Dunyu},
  title   = {Consilium},
  version = {1.27.0},
  date    = {2026-09-18},
  url     = {https://github.com/dunyuliu/consilium},
  license = {MIT}
}
```

## License

MIT.
