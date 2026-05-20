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
│   ├── review.md           #   /review           — full editorial decision
│   ├── stage-publish.md    #   /stage-publish    — GitHub + Zenodo staging
│   ├── eval-deployment.md  #   /eval-deployment  — grade a real agent run
│   └── test-design.md      #   /test-design      — design + write the test pyramid
├── agents/            # specialist subagents   (--> ~/.claude/agents/)
│   ├── elena-hartmann.md   #   Editor in Chief — final scientific authority
│   ├── ziyan-chen.md       #   senior editor — citations, DOIs, manuscripts
│   ├── selin-aydin.md      #   seismology / earthquake-rupture reviewer
│   ├── marco-bianchi.md    #   geodynamics / long-timescale reviewer
│   ├── victor-reyes.md     #   audit orchestrator — routes technical work
│   ├── priya-nair.md       #   quantitative claims vs raw anchor data
│   ├── lars-eriksson.md    #   code math bugs, edge cases, sign conventions
│   ├── jordan-kim.md       #   data integrity — extraction + pipeline
│   ├── sophia-okafor.md    #   spec drift — docs vs code
│   ├── rafael-santos.md    #   physical validity — units, conservation, BCs
│   ├── ingrid-lindqvist.md #   mathematical rigor — derivations, stability, proofs
│   ├── kai-fischer.md      #   refactoring — simplify, dedupe (applies edits)
│   ├── iris-vermeulen.md   #   test architect — designs + writes the pyramid
│   ├── haruto-nakamura.md  #   release & maintenance — CI/CD, versioning, builds
│   ├── anya-petrov.md      #   publication staging — GitHub + Zenodo
│   └── nadia-hadid.md      #   onsite eval PM — grades real deployments
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

## Three teams + a quality bench

Consilium organises around three editorial-style teams plus a small quality
bench of standalone engineers. Each team has a single front door so you
never have to remember the specialist roster.

### Editorial — under `elena-hartmann`

Scientific judgment on a manuscript, analysis, or claim. Elena gives the
verdict and dispatches the deep-domain critical reviewers directly. For any
technical work (code, data, physics, math, spec drift), she hands the whole
bundle to `victor-reyes` rather than re-implementing his routing table.

| Member | Role |
|---|---|
| `elena-hartmann` | Editor in Chief. Holistic verdict. The buck stops here. |
| `ziyan-chen` | Citations, DOIs, author lists, claim-vs-abstract. |
| `selin-aydin` | Critical reviewer — seismology, earthquake-rupture physics, ground motion. |
| `marco-bianchi` | Critical reviewer — geodynamics, geodesy, long-timescale Earth physics. |

### Audit — under `victor-reyes`

Technical depth on what's actually in the repo: bugs, drift, integrity,
correctness. Victor diagnoses scope and spawns the right specialist(s) in
parallel.

| Member | Role |
|---|---|
| `victor-reyes` | Audit orchestrator. Routes technical work, runs specialists in parallel, aggregates findings. |
| `lars-eriksson` | Code auditor — math errors, edge cases, sign conventions, silent failures. |
| `priya-nair` | Numeric-claim verifier — re-derives from raw anchor data. |
| `jordan-kim` | Data integrity — extraction quality and end-to-end pipeline tracing. |
| `sophia-okafor` | Spec drift — docs / methods / config vs actual code. |
| `rafael-santos` | Physical validity — units, conservation, boundary conditions. |
| `ingrid-lindqvist` | Mathematical rigor — derivations, stability, theorem applicability. |

### Release & publication

Two engineers for two different shipping problems: ongoing version releases
versus one-shot publication staging.

| Member | Role |
|---|---|
| `haruto-nakamura` | Release & maintenance engineer. Cuts versioned releases, keeps CI green, audits build reproducibility, manages dependency hygiene. |
| `anya-petrov` | Publication-staging engineer. Prepares a project for GitHub public release and a Zenodo data deposit — scrub, reproducibility floor, CITATION.cff, DOI. |

### Quality bench

Three standalone engineers who keep the work and the team itself honest.
Each applies edits within a tightly-scoped surface (refactors, tests,
fixtures); none touch production code outside that surface.

| Member | Role |
|---|---|
| `kai-fischer` | Refactoring engineer. Simplifies, dedupes, improves naming. Applies edits to production code. Use after a `lars-eriksson` audit, not before. |
| `iris-vermeulen` | Test architect. Designs and writes the test pyramid — unit, integration, end-to-end, and physical-behaviour tests. Applies edits to test files, fixtures, and CI config only. The mechanical floor that the release gate enforces. |
| `nadia-hadid` | Onsite evaluation PM. Reviews a real deployment of any agent or team against its own contract and the user's task, diagnoses root causes, and recommends prompt edits or new eval fixtures. Closes the loop between the agents and the wild. |

## Start here

| What you need | Front door |
|---|---|
| Science — manuscript, methodology, "is this sound?" | `elena-hartmann` (or `/review`) |
| Code, data, audits — "find what's wrong" | `victor-reyes` (or `/audit`) |
| Refactor working code | `kai-fischer` (or `/refactor`) |
| Design / write tests for a project | `iris-vermeulen` (or `/test-design`) |
| Cut a release / fix CI / keep the project shippable | `haruto-nakamura` (or `/release`) |
| Stage for public release — GitHub + Zenodo | `anya-petrov` (or `/stage-publish`) |
| Grade what an agent just produced — improve next time | `nadia-hadid` (or `/eval-deployment`) |

You rarely need to name a specialist directly. The front-door agent routes.

## Models

The team uses a mix of model sizes by role. Heaviest reasoning (orchestration,
final verdicts, adversarial reviewing) runs on opus; deep-but-specific work
runs on sonnet; pattern-match-heavy auditing runs on haiku.

| Model | Agents |
|---|---|
| opus | `elena-hartmann`, `victor-reyes`, `selin-aydin`, `marco-bianchi`, `nadia-hadid` |
| sonnet | `ziyan-chen`, `priya-nair`, `jordan-kim`, `rafael-santos`, `ingrid-lindqvist`, `kai-fischer`, `iris-vermeulen`, `haruto-nakamura`, `anya-petrov` |
| haiku | `lars-eriksson`, `sophia-okafor` |

## How it works

- **Independence.** Each subagent runs in its own context and doesn't see
  your prior conversation. This forces re-derivation from raw sources.
- **Read-only specialists.** Auditors and reviewers verify; they don't fix.
  Apply fixes, then re-run to confirm. `kai-fischer`, `iris-vermeulen`,
  and `anya-petrov` are the exceptions — each applies edits within a
  tightly-scoped surface (refactor, tests/CI, publication staging).
- **Clear boundaries.** Each agent states what falls outside their scope
  and who to hand off to.
- **One routing table.** Victor owns the technical routing; Elena delegates
  technical work to him rather than maintaining a parallel table.
- **Code discipline rules are universal.** No fallback, no placeholder,
  hard failure, no silent failure — every code-touching agent applies
  these as findings on code they review and as constraints on code they
  write.
- **Tests-pass is the mechanical floor.** The empirical proof that the
  code does what it claims. `iris-vermeulen` designs the pyramid;
  `haruto-nakamura` enforces the gate at the release boundary;
  everyone else respects it.
- **Final sign-off rests with the human.**

## Commands (slash)

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
| `/test-design` | `iris-vermeulen` | Design and write the test pyramid — unit, integration, end-to-end, and physical-behaviour tests. Applies edits to test files only. |
| `/release` | `haruto-nakamura` | Versioned-release workflow. `release` / `release minor` / `release major`. |
| `/review` | `elena-hartmann` | Full editorial decision — verdict, core weakness, Reviewer-2 attack. |
| `/stage-publish` | `anya-petrov` | Stage for GitHub + Zenodo publication. |
| `/eval-deployment` | `nadia-hadid` | Grade a real agent run against its contract, diagnose misses, recommend prompt or fixture edits. |

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

- Expand `evals/` coverage across every specialist (currently `lars-001`, `sophia-001`).
- Statistics specialist for p-hacking, multiple comparisons, study design.
- Security/privacy agent for credential leaks, PII, supply-chain risk.
- GitHub-Action wiring so audits run automatically on PRs.
