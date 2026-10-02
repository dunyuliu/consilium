# The team

Twenty-two specialists, organised into three teams and a quality bench, plus
one campaign conductor. README's roster and model tables are the canonical,
gate-checked listing; this page gives each one a little more room — what they
actually do, and an example or two of how people invoke them, pulled straight
from each agent's own frontmatter.

## Editorial — under `elena-hartmann`

Scientific judgment on a manuscript, analysis, or claim. Elena gives the
verdict and dispatches the editorial-grade critical reviewers directly; for
technical work she delegates the whole bundle to Victor.

- **`elena-hartmann`** (opus) — Editor in Chief and panel chair, broad scope
  across physics, chemistry, biology, geophysics, statistics, and ML. Reads a
  manuscript, proposal, or analysis two ways: the verdict (what is wrong) and
  the elevation (what the work could be). *"Elena, is this paper ready to
  submit?"* · *"what would a reviewer destroy us on?"*
- **`ziyan-chen`** (haiku) — Senior editor. Audits LaTeX/BibTeX manuscripts:
  DOI resolution, title cross-check, author-list verification,
  claim-vs-abstract mismatch, overclaimed results, year mismatches.
  *"verify the DOIs in references.bib"* · *"flag any unsupported claims in
  section 3"*
- **`shu-han`** (opus) — Research-proposal author. Drafts a funding proposal
  end to end from solicitation to a reviewed, compliant draft: one-page
  summary, condensed and full project descriptions, validated references,
  figures, logged review rounds. *"draft a proposal for this solicitation
  from our published work"*
- **`selin-aydin`** (sonnet) — Critical reviewer, seismology and
  earthquake-rupture physics. The Reviewer 2 you fear on source models,
  rupture dynamics, ground-motion claims, and waveform/geodetic fits.
  *"tear into the source model in section 3"*
- **`marco-bianchi`** (opus) — Critical reviewer, geodynamics, geodesy, and
  long-timescale Earth physics. The Reviewer 2 you fear on rheology choices,
  postseismic models, GIA, mantle convection, plate-boundary mechanics.
  *"is this postseismic viscoelastic model defensible?"*

## Audit — under `victor-reyes`

Technical depth on what's actually in the repo. Victor diagnoses scope and
dispatches the right specialist(s) in parallel.

- **`victor-reyes`** (opus) — Audit orchestrator. Routes technical work, runs
  specialists in parallel, aggregates findings. *"audit my project before
  release"* · *"find anything wrong with this codebase"*
- **`lars-eriksson`** (haiku) — Code-level auditor. Hunts math errors, edge
  cases, sign-convention bugs, and silent-failure modes. Reports bugs at
  file:line; does not propose fixes. *"audit compute_returns.py for math
  correctness"*
- **`priya-nair`** (sonnet) — Quantitative-claim auditor. Re-derives numeric
  results from raw anchor data independently — published numbers, balances,
  returns, p-values, effect sizes. *"verify the 6.92% CAGR claim against the
  source CSV"*
- **`jordan-kim`** (sonnet) — Data-integrity auditor. Raw-source extraction
  (PDF, OCR, API, instrument) and end-to-end pipeline tracing — drops,
  duplications, time-alignment, reproducibility. *"audit the train/val/test
  split for leakage"*
- **`sophia-okafor`** (haiku) — Spec-drift auditor. Compares documentation,
  preregistrations, and configs to actual code behaviour and flags every
  divergence. *"check whether CLAUDE.md matches what the code does"*
- **`rafael-santos`** (sonnet) — Physicist. Physical validity — dimensional
  analysis, conservation-law verification, boundary-condition checks,
  approximation validity. *"does this wave equation conserve energy?"*
- **`ingrid-lindqvist`** (sonnet) — Mathematician. Mathematical rigor —
  derivation steps, theorem applicability, numerical stability and
  convergence, linear algebra, statistical assumptions. *"check the
  convergence order of this finite-difference scheme"*

## Release & publication

Three engineers for three different shipping problems: ongoing version
releases, one-shot publication staging, and the figures that go in the
manuscript itself.

- **`haruto-nakamura`** (sonnet) — Release & maintenance engineer. Cuts
  versioned releases, keeps CI green, audits build reproducibility, manages
  dependency hygiene. Owns the test gate at the release boundary. *"cut a
  patch release"* · *"why is CI failing?"*
- **`anya-petrov`** (sonnet) — Publication-staging engineer. Prepares a
  project for GitHub release and Zenodo deposit — scrub, reproducibility
  floor, CITATION.cff, DOI. *"prep the data for Zenodo and mint a DOI"*
- **`marta-silva`** (sonnet) — Publication-figure engineer. Makes and audits
  matplotlib figures for print — font scale, endpoint-labeled colorbars,
  shared scales, physical-unit axes, scripted regeneration. *"audit figures/
  for font-size and scale consistency"*

## Quality bench

Six engineers who keep the work and the team itself honest. Each applies
edits within a tightly-scoped surface; none touch production code outside it.

- **`kai-fischer`** (sonnet) — Refactoring engineer. Simplifies, dedupes,
  improves naming. Edits production code. Use after a `lars-eriksson` audit,
  not before. *"this function is 200 lines, break it down"*
- **`iris-vermeulen`** (sonnet) — Test architect. Designs and writes the test
  pyramid. Edits test files, fixtures, CI config only. *"design a test
  pyramid for this rupture simulator"*
- **`mira-volkov`** (sonnet) — Bit-identical porting specialist, any source
  language to any target. Parity against the reference on real full-scale
  data first; optimization only after. Works in an isolated worktree; never
  the reference implementation. *"port this C cross-correlation binary to
  Python and verify bit-identical output on real data"*
- **`dunyu-liu`** (fable) — Senior computational researcher. Owns
  research-heavy new implementations where no reference exists — frames the
  question, designs the numerical experiment, spikes cheaply, lands the
  minimal version, and reports what failed. *"add adaptive time-stepping to
  the cycle solver — nobody has done it for this code"*
- **`nadia-hadid`** (sonnet) — Onsite evaluation PM. Reviews real
  deployments, diagnoses misses, recommends prompt or fixture edits. Closes
  the loop between the team and the wild. *"score Victor's audit pass and
  tell me what to tighten"*
- **`lian-zhao`** (sonnet) — Agent-refinement engineer. Owns the prompts
  themselves — measures where tokens go, changes one variable, verifies on
  the agent's own fixture, reverts on failure keeping the reason. Never
  grades its own work. *"mira costs 35k a run, can we cut it"*
- **`zofia-kaminska`** (sonnet) — Project-rules enforcer. Aligns an existing
  project to a proven rule book — creates what it lacks, reports what breaks
  the rules it has, codifies what it learned — and sets up one that has no
  rules. *"set this new repo up"*

## Campaign orchestration

A higher-altitude orchestrator than Victor or Elena. Where Victor routes
specialists for one audit task and Elena delegates technical work for one
scientific verdict, Wei runs a multi-mission campaign over hours-to-days.

- **`wei-lin`** (sonnet) — Workflow conductor and release-discipline owner.
  Dispatches `mira-volkov` / `iris-vermeulen` / `lars-eriksson` /
  `haruto-nakamura` / `kai-fischer` in isolated worktrees, gates each merge
  on the project's smoke tier, bumps tags per soft-pass, reverts and logs on
  regression. Owns merge gates, version cadence, and the session log during
  a long-running campaign. *"take this porting roadmap and run for 24h,
  dispatch Miras, gate merges on smoke, bump the patch tag per pass"*

See `README.md` for the roster table the gate checks, and
`docs/maintainer.md#responsibility-map` for the full issue-to-owner routing
table used internally by `victor-reyes` and `elena-hartmann`.
