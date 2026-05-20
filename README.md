# Consilium

Personal Claude Code customizations: slash commands and subagents that follow
you across machines.

## Layout

```
consilium/
├── commands/          # custom slash commands  (--> ~/.claude/commands/)
│   ├── audit.md            #   /audit            — eight-section project audit
│   ├── audit-citations.md  #   /audit-citations  — manuscript citations
│   ├── audit-claim.md      #   /audit-claim      — numeric claim vs raw data
│   ├── audit-code.md       #   /audit-code       — source-file bug hunt
│   ├── audit-data.md       #   /audit-data       — data extraction + pipeline
│   ├── audit-math.md       #   /audit-math       — derivations, stability
│   ├── audit-physics.md    #   /audit-physics    — units, conservation, BCs
│   ├── audit-spec.md       #   /audit-spec       — docs vs code drift
│   ├── refactor.md         #   /refactor         — simplify code (applies edits)
│   ├── release.md          #   /release          — versioned-release workflow
│   └── review.md           #   /review           — full editorial decision
├── agents/            # specialist subagents   (--> ~/.claude/agents/)
│   ├── elena-hartmann.md   #   Editor in Chief — final scientific authority
│   ├── victor-reyes.md     #   audit orchestrator — routes to specialists
│   ├── ziyan-chen.md       #   senior editor — citations, DOIs, manuscripts
│   ├── priya-nair.md       #   quantitative claims vs raw anchor data
│   ├── lars-eriksson.md    #   code math bugs, edge cases, sign conventions
│   ├── jordan-kim.md       #   data integrity — extraction + pipeline
│   ├── sophia-okafor.md    #   spec drift — docs vs code
│   ├── dev-nakamura.md     #   releases, CI/CD, versioning, build pipelines
│   ├── rafael-santos.md    #   physical validity — units, conservation, BCs
│   ├── ingrid-lindqvist.md #   mathematical rigor — derivations, stability, proofs
│   └── kai-fischer.md      #   refactoring — simplify, dedupe (applies edits)
├── evals/             # regression fixtures for the agents
│   ├── README.md           # fixture format and harness expectations
│   └── cases/              # one directory per planted-bug case
├── scripts/
│   └── install.sh     # symlink everything into ~/.claude
└── README.md
```

## Install on a new machine

```bash
git clone https://github.com/dunyuliu/consilium.git ~/consilium
bash ~/consilium/scripts/install.sh
```

`install.sh` creates symlinks from `~/.claude/{commands,agents}/<name>` to
files inside this repo, so editing a file here immediately reflects in Claude
Code, and `git pull` updates them.

## Start here

| What you need | Who to ask |
|---|---|
| Science — manuscript, methodology, "is this sound?" | `elena-hartmann` (or `/review`) |
| Code, data, audits — "find what's wrong" | `victor-reyes` (or `/audit`) |
| Refactor working code | `kai-fischer` (or `/refactor`) |
| Releases, CI/CD, versioning | `dev-nakamura` (or `/release`) |

Elena and Victor route to the right specialist automatically. You rarely need to name a specialist directly. If you do, see the team table below.

## The team

| Agent | Persona | Model | Role |
|---|---|---|---|
| `elena-hartmann` | Prof. Elena Hartmann, EIC | opus | Final scientific authority. Holistic verdict on manuscripts and analyses. Dispatches the full team when needed. |
| `victor-reyes` | Victor Reyes, Chief of Staff | opus | Audit orchestrator. Routes technical work to the right specialist(s), runs in parallel, aggregates findings. |
| `ziyan-chen` | Ziyan Chen, Senior Editor | sonnet | Manuscript citations and scientific validity. DOI resolution, author verification, claim-vs-abstract mismatch, overclaimed results. |
| `priya-nair` | Dr. Priya Nair, Quant Analyst | sonnet | Numeric claim verification from raw anchor data (CSV, instrument, brokerage statement). Independent re-derivation. |
| `lars-eriksson` | Lars Eriksson, Senior Engineer | haiku | Code auditor. Math errors, edge cases, sign-convention bugs, silent-failure modes at file:line. Read-only. |
| `jordan-kim` | Jordan Kim, Data Engineer | sonnet | Data integrity. Extraction quality (raw source → anchor) and end-to-end pipeline tracing (drops, duplication, time-alignment). |
| `sophia-okafor` | Sophia Okafor, Tech Writer/Engineer | haiku | Spec drift. Docs, methods sections, and configs vs actual code behavior. |
| `dev-nakamura` | Dev Nakamura, Release Engineer | sonnet | Software releases, CI/CD, versioning, changelog accuracy, build reproducibility, deployment pipelines. |
| `rafael-santos` | Dr. Rafael Santos, Physicist | sonnet | Physical validity: dimensional analysis, conservation laws, boundary conditions, approximation validity, numerical scheme physics. |
| `ingrid-lindqvist` | Prof. Ingrid Lindqvist, Mathematician | sonnet | Mathematical rigor: derivation correctness, theorem applicability, numerical stability, linear algebra, inverse problems, statistical assumptions. |
| `kai-fischer` | Kai Fischer, Senior Engineer | sonnet | Refactoring. Simplifies, dedupes, improves naming. Applies edits. Does not hunt bugs — use `lars-eriksson` for that. |

## How it works

- **Independence.** Each subagent runs in its own context and doesn't see your
  prior conversation. This forces re-derivation from raw sources.
- **Read-only specialists.** Auditors verify; they don't fix. Apply fixes, then
  re-run the auditor to confirm. (`kai-fischer` is the exception — refactors apply edits.)
- **Clear boundaries.** Each agent states what falls outside their scope and who
  to hand off to.
- **Hierarchy.** Elena sits above the team. Victor routes technical work.
  Specialists go deep on one dimension each.
- **Final sign-off rests with the human.**

## Commands (slash)

| Slash | What |
|---|---|
| `/audit` | Eight-section project audit via `victor-reyes`. Writes `AUDIT.md`. Sections: goal & implementation, inventory & stale, reproducibility, physics & numerics, implementation consistency, logging & errors, performance, top-N priorities. |
| `/audit-citations` | Manuscript citations via `ziyan-chen` — DOI resolution, author lists, claim-vs-abstract mismatches. |
| `/audit-claim` | Verify a specific numeric claim via `priya-nair` — re-derives from raw anchor data. |
| `/audit-code` | Source-file bug hunt via `lars-eriksson` — math, edge cases, sign conventions. |
| `/audit-data` | Data integrity via `jordan-kim` — extraction quality and pipeline tracing. |
| `/audit-math` | Mathematical rigor via `ingrid-lindqvist` — derivations, stability, theorem applicability. |
| `/audit-physics` | Physical validity via `rafael-santos` — units, conservation, BCs. |
| `/audit-spec` | Spec drift via `sophia-okafor` — docs/config vs code. |
| `/refactor` | Refactor via `kai-fischer` — simplify, dedupe, improve naming. Applies edits. |
| `/release` | Versioned-release workflow via `dev-nakamura`. Triggers: `release` (patch), `release minor`, `release major`. |
| `/review` | Full editorial decision via `elena-hartmann` — verdict, core weakness, what Reviewer 2 will say. |

## Adding a new agent

1. Drop `agents/<name>.md` with frontmatter: `name`, `description`, `tools`, `model`.
2. Write a specific `description:` — Victor and Elena route based on it.
3. Run `bash scripts/install.sh`.
4. Verify: open Claude Code and run `/agents`.

## Adding a new command

1. Drop `commands/<name>.md` (use existing files as templates).
2. Run `bash scripts/install.sh`.

## Regression evals

`evals/` holds small fixtures (planted bugs, stale docs, miscited papers) with
expected findings, so prompt changes can be measured rather than vibe-checked.
See `evals/README.md` for the fixture format and how to run a case.

## Roadmap

- Expand `evals/` coverage across every specialist.
- Statistics specialist for p-hacking, multiple comparisons, study design.
- Security/privacy agent for credential leaks, PII, supply-chain risk.
- GitHub-Action wiring so audits run automatically on PRs.
