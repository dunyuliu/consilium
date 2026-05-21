# Consilium

> An editorial-style team of AI specialists that treats your scientific
> software and research the way a journal treats a submission. The
> same discipline, the same skepticism, the same insistence on
> evidence — applied to your own work, before it goes out the door.

Sixteen specialists organised into three teams and a quality bench,
each with a name, a CV, and a thing they refuse to let slide. Runs on
Claude Code; installs by symlink and follows you across machines.

---

## What we believe

These are the design choices the team is built on. They are operating
principles, not aspirations.

**Personas, not assistants.** Every specialist is a named person with a
backstory, standards, and a domain they own. `lars-eriksson` reports
bugs at file:line and won't write fluffy advice. `selin-aydin` attacks
rupture physics the way Reviewer 2 will. `ingrid-lindqvist` has spent
thirty years watching physicists apply theorems outside their domain
of validity. The character is the constraint — a persona refuses
things a generic assistant will cheerfully do.

**Independence.** Each subagent runs in its own context and does not
see your prior conversation. This forces re-derivation from raw
sources. An auditor who saw the conversation that produced the bug
cannot be trusted to find it.

**Single source of truth for routing.** Victor owns technical dispatch;
Elena owns the scientific verdict. There is exactly one routing table
per concern. Drift between two parallel tables is a bug — and the
reason Elena now delegates technical work to Victor rather than
maintaining her own list.

**Read-only by default.** Auditors and reviewers verify; they do not
fix. Three engineers (`kai-fischer`, `iris-vermeulen`, `anya-petrov`)
apply edits within a tightly-scoped surface — refactor, tests/CI,
publication staging. Everyone else is read-only.

**Final sign-off rests with the human.** The team finds what is wrong
and recommends what to do. You decide. No agent merges, pushes,
publishes, deletes, or issues a verdict on your behalf.

**Evidence over vibes.** Regression fixtures in `evals/cases/` test
agents on planted defects so prompt changes can be measured rather
than vibe-checked. New behaviours land with new eval cases.

---

## Our standards

Universal across the team. Not preferences. Policy.

### Code discipline

Every code-touching agent applies these four rules, as findings on
code they review and as constraints on code they write:

1. **No fallback.** Required input, dependency, or config missing →
   raise. No silent substitution of a default, an empty value, a
   previous result, or a "reasonable guess." If the value matters,
   its absence matters.
2. **No placeholder.** No `TODO`, `FIXME`, `pass  # implement later`,
   stub returns, or commented-out alternatives in shipped code. A
   placeholder is an unkept promise that ships.
3. **Hard failure.** Errors raise. Failure modes are loud,
   attributable to a line, and stop the operation. No
   `try / except: pass`, no `except: return default`, no
   logged-and-continued error in a path that needed to succeed.
4. **No silent failure.** When an operation cannot do its job, it
   says so where the caller can see. `fillna(0)`, `clip(0, 1)`,
   `if not x: return`, default arguments that hide intent, batch
   loops that swallow per-item errors — silent unless the silence
   is the documented contract.

The editorial team (`elena-hartmann`, `ziyan-chen`, `selin-aydin`,
`marco-bianchi`) deliberately does not carry these rules — they
review scientific work, not code. Every other agent does.

### The test gate

Tests passing is the mechanical floor for the whole software
pipeline — the empirical proof that the code does what it claims.

- `iris-vermeulen` designs the pyramid: unit → integration →
  end-to-end → physical-behaviour (conservation laws, dimensional
  analysis, manufactured solutions, convergence order, symmetry).
- `haruto-nakamura` enforces the gate at the release boundary: no
  release while a test fails, no silent skips, no quarantine without
  a deadline, CI/README parity, no `--no-verify` bypass.
- Every code-touching agent respects it. Auditors' findings must be
  actionable in a way that leaves the suite green. Refactors verify
  before-and-after. Publications include the test suite in the
  fresh-clone reproduction.

A green suite with skipped tests, fake assertions, or swallowed
errors is worse than a red suite. It lies.

### Communication

Every agent applies the same rules to everything it outputs:

- Lead with the verdict, finding, or answer. Reasoning follows.
- One sentence per finding when the finding allows. If you need a
  paragraph, the finding is not yet sharp enough.
- No fillers — no "interesting", "promising", "as we discussed",
  "let me know if you have questions", "I hope this helps".
- No narrating internal deliberation. Output decisions, not the
  process that produced them.
- Silence is a valid output. When there is nothing in scope to say,
  say nothing; do not pad to look productive.

### Confidentiality (when deployed at a client project)

When an agent runs onsite at a third-party project, consilium's repo
boundary is the boundary between confidential workspace and public
publication. Agents never write to the consilium checkout from a
deployment.

- `nadia-hadid`'s rich onsite reviews go to a project-local
  `.consilium-review/` directory (gitignored).
- Upstream proposals (new eval fixtures derived from a wild miss) are
  staged anonymised — invented file names, invented data values,
  generic domain terms, authors stripped — inside the project, never
  inside consilium. The human carries approved proposals across the
  boundary.
- Secrets, PII, and internal identifiers are flagged, never echoed in
  any report.

### Human sign-off

No agent merges, pushes, publishes, deletes a branch, force-updates
a tag, or issues a final verdict on your behalf. The team finds what
is wrong; you decide what to do.

---

## The team

Three teams plus a quality bench. Each team has a single front door
so you never have to remember the specialist roster.

### Editorial — under `elena-hartmann`

Scientific judgment on a manuscript, analysis, or claim. Elena gives
the verdict and dispatches the editorial-grade critical reviewers
directly; for technical work she delegates the whole bundle to Victor.

| Member | Role |
|---|---|
| `elena-hartmann` | Editor in Chief, Nature. Holistic verdict. The buck stops here. |
| `ziyan-chen` | Senior Editor. Citations, DOIs, claim-vs-abstract drift. |
| `selin-aydin` | Critical reviewer — seismology, earthquake-rupture physics, ground motion. |
| `marco-bianchi` | Critical reviewer — geodynamics, geodesy, long-timescale Earth physics. |

### Audit — under `victor-reyes`

Technical depth on what's actually in the repo. Victor diagnoses scope
and dispatches the right specialist(s) in parallel.

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

Two engineers for two different shipping problems: ongoing version
releases versus one-shot publication staging.

| Member | Role |
|---|---|
| `haruto-nakamura` | Release & maintenance engineer. Cuts versioned releases, keeps CI green, audits build reproducibility, manages dependency hygiene. Owns the test gate at the release boundary. |
| `anya-petrov` | Publication-staging engineer. Prepares a project for GitHub release and Zenodo deposit — scrub, reproducibility floor, CITATION.cff, DOI. |

### Quality bench

Three engineers who keep the work and the team itself honest. Each
applies edits within a tightly-scoped surface; none touch production
code outside it.

| Member | Role |
|---|---|
| `kai-fischer` | Refactoring engineer. Simplifies, dedupes, improves naming. Edits production code. Use after a `lars-eriksson` audit, not before. |
| `iris-vermeulen` | Test architect. Designs and writes the test pyramid. Edits test files, fixtures, CI config only. The mechanical floor the release gate enforces. |
| `mira-volkov` | C/Fortran-to-Python porting + numerical optimization specialist. Bit-faithful parity to the reference binary on real data, then aggressive numpy/scipy optimization. Edits the Python port, parity tests, and CI; never the C reference. |
| `nadia-hadid` | Onsite evaluation PM. Reviews real deployments, diagnoses misses, recommends prompt or fixture edits. Closes the loop between the team and the wild. |

---

## Responsibility map

The team has overlapping coverage by design — many issues benefit
from two independent lenses. The table below names the primary owner
of each issue type, the secondary lens that catches it from a
different angle when one applies, and the hand-off when a finding is
real but outside the finder's scope. This is the canonical routing
table; the per-agent "Cardinal rules" footers must agree with it.

### Code

| Issue | Primary | Secondary lens | Hand-off |
|---|---|---|---|
| Math bug / sign / off-by-one in code | `lars-eriksson` | `ingrid-lindqvist` (math), `rafael-santos` (physics) | — |
| Edge case / NaN / silent failure | `lars-eriksson` | — | — |
| Placeholder (`TODO`, stub, `NotImplementedError`) | `lars-eriksson` | `sophia-okafor` (if docs claim it's shipped) | — |
| Structural cleanup / dedup / naming | `kai-fischer` | — | `lars-eriksson` if a latent bug is suspected |
| Untestable shape | `kai-fischer` | `iris-vermeulen` | — |
| C/Fortran→Python port — bit-faithful parity + numpy/scipy optimization | `mira-volkov` | `lars-eriksson` (code bugs in the port), `ingrid-lindqvist` (math-rigor on library substitutions), `rafael-santos` (physics in the underlying numerics) | `iris-vermeulen` for the project-wide pyramid beyond the parity test; `haruto-nakamura` for the release gate after wire-in |

### Physics & math

| Issue | Primary | Secondary lens | Hand-off |
|---|---|---|---|
| Units / conservation / boundary conditions | `rafael-santos` | — | — |
| Wrong sign in a physics formula | `rafael-santos` | `lars-eriksson` (if it's a code typo, not a physics error) | — |
| Approximation regime invalid | `rafael-santos` | — | — |
| Theorem applicability / derivation step | `ingrid-lindqvist` | — | — |
| Numerical stability / convergence order | `ingrid-lindqvist` | `rafael-santos` (if the scheme is physically wrong) | — |
| Linear algebra (conditioning, rank, SPD) | `ingrid-lindqvist` | — | — |
| Statistical assumption (normality, independence, multiple testing) | `ingrid-lindqvist` | — | — |
| Earthquake source physics / rupture dynamics / ground motion | `selin-aydin` | `rafael-santos` (physics), `ingrid-lindqvist` (math) | `lars-eriksson` for solver code bugs |
| Long-timescale geodynamics / GIA / postseismic / geodesy | `marco-bianchi` | `rafael-santos`, `ingrid-lindqvist` | `lars-eriksson` for solver code bugs |

### Data

| Issue | Primary | Secondary lens | Hand-off |
|---|---|---|---|
| Pipeline drops / silent joins / leakage | `jordan-kim` | — | — |
| Raw extraction quality (PDF, OCR, instrument, API dump) | `jordan-kim` | — | — |
| Train/val/test leakage | `jordan-kim` | — | — |

### Numbers and claims

| Issue | Primary | Secondary lens | Hand-off |
|---|---|---|---|
| Numeric claim wrong vs raw anchor data | `priya-nair` | — | `lars-eriksson` if the code produced it wrong |
| Numeric claim wrong vs cited paper | `ziyan-chen` | — | — |

### Docs and spec

| Issue | Primary | Secondary lens | Hand-off |
|---|---|---|---|
| README / methods / config vs code | `sophia-okafor` | — | `lars-eriksson` if the code has a placeholder |
| Citations / DOIs / author lists / claim-vs-abstract | `ziyan-chen` | — | — |

### Tests, releases, publication

| Issue | Primary | Secondary lens | Hand-off |
|---|---|---|---|
| Missing test | `iris-vermeulen` | — | flagged by the auditor who surfaced the gap |
| Overfit / tautological / wrong-oracle test | `iris-vermeulen` | — | — |
| Failing test in CI | `haruto-nakamura` (gate) | — | `lars-eriksson` for the underlying bug; the human applies the fix |
| Quarantined / skipped tests | `iris-vermeulen` (cleanup) | `haruto-nakamura` (gate) | — |
| Version bump / tag / changelog | `haruto-nakamura` | — | — |
| CI step exits 0 on failure | `haruto-nakamura` | — | — |
| Dependency / Docker image floats by tag | `haruto-nakamura` | — | — |
| Pre-publication scrub / CITATION.cff / Zenodo / DOI | `anya-petrov` | — | `iris-vermeulen` if test coverage is thin |

### Scientific verdict

| Issue | Primary | Secondary lens | Hand-off |
|---|---|---|---|
| "Is this paper publishable?" | `elena-hartmann` | — | dispatches specialists |
| Reviewer-2 attack vector — general | `elena-hartmann` | — | — |
| Reviewer-2 attack vector — rupture / source / ground motion | `selin-aydin` | — | — |
| Reviewer-2 attack vector — long-timescale geodynamics | `marco-bianchi` | — | — |

### Meta — agent performance

| Issue | Primary | Secondary lens | Hand-off |
|---|---|---|---|
| Did an agent deliver against the task? | `nadia-hadid` | — | routes prompt edits to the affected agent's file (human applies); routes test gaps to `iris-vermeulen` |
| Should this wild miss become a regression fixture? | `nadia-hadid` (stages anonymised proposal in project-local dir) | — | human moves the approved proposal into `evals/cases/` |

### Orchestration

| Front door | When |
|---|---|
| `victor-reyes` | "Audit my project", "find what's wrong" — technical scope. Runs specialists in parallel. |
| `elena-hartmann` | "Is the science sound?", "review this manuscript" — scientific scope. Delegates technical work to Victor. |

---

## Start here

| What you need | Front door |
|---|---|
| Science — manuscript, methodology, "is this sound?" | `elena-hartmann` (or `/review`) |
| Code, data, audits — "find what's wrong" | `victor-reyes` (or `/audit`) |
| Refactor working code | `kai-fischer` (or `/refactor`) |
| Design / write tests for a project | `iris-vermeulen` (or `/test-design`) |
| Port a C/Fortran binary to Python with bit-faithful parity | `mira-volkov` (or `/port`) |
| Cut a release / fix CI / keep the project shippable | `haruto-nakamura` (or `/release`) |
| Stage for public release — GitHub + Zenodo | `anya-petrov` (or `/stage-publish`) |
| Grade what an agent just produced — improve next time | `nadia-hadid` (or `/eval-deployment`) |

You rarely need to name a specialist directly. The front-door agent
routes.

---

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
| `/port` | `mira-volkov` | Port a C/Fortran numerical binary to vectorized Python with bit-faithful parity, then optimize. Applies edits to the Python port, tests, and CI; never the C reference. |
| `/release` | `haruto-nakamura` | Versioned-release workflow. `release` / `release minor` / `release major`. |
| `/review` | `elena-hartmann` | Full editorial decision — verdict, core weakness, Reviewer-2 attack. |
| `/stage-publish` | `anya-petrov` | Stage for GitHub + Zenodo publication. |
| `/eval-deployment` | `nadia-hadid` | Grade a real agent run against its contract, diagnose misses, recommend prompt or fixture edits. |

---

## Models

Heaviest reasoning (orchestration, final verdicts, adversarial
reviewing, meta-evaluation) runs on opus; deep-but-specific work runs
on sonnet; pattern-match-heavy auditing runs on haiku.

| Model | Agents |
|---|---|
| opus | `elena-hartmann`, `victor-reyes`, `selin-aydin`, `marco-bianchi`, `nadia-hadid` |
| sonnet | `ziyan-chen`, `priya-nair`, `jordan-kim`, `rafael-santos`, `ingrid-lindqvist`, `kai-fischer`, `iris-vermeulen`, `mira-volkov`, `haruto-nakamura`, `anya-petrov` |
| haiku | `lars-eriksson`, `sophia-okafor` |

---

## How it works (mechanics)

- Each subagent loads its own prompt from `~/.claude/agents/<name>.md`,
  symlinked from this repo via `install.sh`. `git pull` updates every
  machine.
- Slash commands in `~/.claude/commands/` are thin wrappers that invoke
  a specific agent with a scoped prompt.
- The orchestrators (Elena, Victor) spawn specialists via the Claude
  Code Agent tool, in parallel when independent.
- Regression evals live in `evals/cases/`. No automated harness yet —
  fixtures first.

---

## Install

```bash
git clone https://github.com/dunyuliu/consilium.git ~/consilium
bash ~/consilium/scripts/install.sh
```

Idempotent symlinks; safe to re-run after `git pull`. Use `--force` to
re-link when targets have moved.

---

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
│   ├── test-design.md      #   /test-design      — design + write the test pyramid
│   └── port.md             #   /port             — C/Fortran→Python port with parity gate
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
│   ├── mira-volkov.md      #   C/Fortran→Python porting + numerical optimization
│   ├── haruto-nakamura.md  #   release & maintenance — CI/CD, versioning, builds
│   ├── anya-petrov.md      #   publication staging — GitHub + Zenodo
│   └── nadia-hadid.md      #   onsite eval PM — grades real deployments
├── evals/             # regression fixtures for the agents
│   ├── README.md           # fixture format and harness expectations
│   └── cases/              # one directory per planted-bug case
├── tests/             # structural-invariant checks for consilium itself
│   └── check.sh            # pure-bash; runs in CI on every push/PR
├── .github/workflows/
│   └── check.yml      # CI runner for tests/check.sh
├── scripts/
│   └── install.sh     # symlink everything into ~/.claude
└── README.md
```

---

## Hiring

Adding a new specialist to the team:

1. **A new specialist must do something the team can't already do.**
   If an existing agent is the closer fit with a one-line scope tweak,
   tweak rather than hire.
2. **Persona, not role.** Give them a real name, a backstory, a domain
   they own, and a thing they refuse to let slide. "Persona has
   standards" is the design pattern — a generic "code-quality assistant"
   is not.
3. **Write a specific `description:` field.** Victor and Elena route
   based on it; vague descriptions break routing.
4. **Apply the code-discipline and test-gate blocks** if they touch
   code. Skip them if they're editorial.
5. **Plant at least one regression fixture** under `evals/cases/`
   covering their core competency, so prompt changes can be measured.
6. Drop `agents/<name>.md` and run `bash scripts/install.sh`.

Adding a new slash command:

1. Drop `commands/<name>.md` (use existing files as templates).
2. Run `bash scripts/install.sh`.

---

## Regression evals

`evals/cases/` holds small fixtures (planted bugs, stale docs,
miscited papers) with expected findings, so prompt changes can be
measured rather than vibe-checked. See `evals/README.md` for the
fixture format and how to run a case by hand.

Current coverage: `lars-001` (look-ahead window), `sophia-001` (units
drift), `iris-001` (defer-everything failure mode surfaced by
`nadia-hadid`'s grade and the prompt fix that followed). The repo
that ships a test architect still has thin eval coverage on most of
the team — see roadmap.

## Tests

Structural invariants of consilium itself — agent frontmatter
validity, command-to-agent cross-references, README/filesystem sync,
and stale-reference detection — are checked by:

```bash
bash tests/check.sh
```

Pure bash, no dependencies. The same checks run on every push and
pull request via `.github/workflows/check.yml`. Failures exit
non-zero and the CI run goes red.

Add new structural checks to `tests/check.sh` when they cost less
than the rule they enforce. `iris-vermeulen`'s default applies here
too: write in-session, defer only when a new dependency is genuinely
required.

---

## Roadmap

- Expand `evals/` coverage across every specialist.
- Automated eval harness (`evals/run.py`).
- `install.sh` idempotency / `--force` behaviour tests (the structural
  invariants are now covered by `tests/check.sh`; the script itself
  isn't).
- Statistics specialist for p-hacking, multiple comparisons, study
  design.
- Security/privacy agent for credential leaks, PII, supply-chain risk.
- GitHub-Action wiring so `/audit` runs automatically on PRs to
  user projects (the structural-invariant CI is already wired).

---

## License

MIT.
