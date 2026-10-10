# Commands

Every slash command is a thin wrapper that invokes one agent with a scoped
prompt. README's commands table is the canonical, gate-checked listing; this
page gives the full description shipped in each command's own frontmatter,
and goes deep on the two commands whose behaviour has a boundary worth
understanding before you run them: `/autopilot` and `/propose`.

| Slash | Agent | What |
|---|---|---|
| `/audit` | `victor-reyes` | Audit a scientific computing project — does it do what it claims, is the math sound, can it be reproduced. Writes results to `AUDIT.md`. |
| `/audit-citations` | `ziyan-chen` | Audit manuscript citations — DOI resolution, author lists, title accuracy, claim-vs-abstract mismatches, overclaimed results. |
| `/audit-claim` | `priya-nair` | Verify a specific numeric claim (return, p-value, effect size, balance) by re-deriving it independently from raw anchor data. |
| `/audit-code` | `lars-eriksson` | Audit source files for math errors, edge cases, sign-convention bugs, and silent-failure modes. Reports findings at file:line. Read-only — does not fix. |
| `/audit-data` | `jordan-kim` | Audit data integrity — raw-source extraction (PDF, OCR, instrument) and end-to-end pipeline (drops, duplications, time-alignment, leakage). |
| `/audit-math` | `ingrid-lindqvist` | Audit mathematical rigor — derivations, proof correctness, theorem applicability, numerical stability, linear algebra, statistical assumptions. |
| `/audit-physics` | `rafael-santos` | Audit physical validity — dimensional analysis, conservation laws, boundary conditions, approximation validity, numerical scheme physics. |
| `/audit-spec` | `sophia-okafor` | Audit spec drift — check that documentation, preregistrations, and configs match what the code actually does. |
| `/refactor` | `kai-fischer` | Refactor code for simplicity, clarity, and reduced duplication. Applies changes directly. Does not hunt bugs — use `/audit-code` for that. |
| `/test-design` | `iris-vermeulen` | Design the test pyramid for a project — unit, integration, end-to-end, and physical-behaviour verification. Writes test files, fixtures, and CI config. |
| `/port` | `mira-volkov` | Port a C/Fortran numerical binary to vectorized Python with bit-faithful parity to the reference on real data, then optimize. Applies edits to the Python port, tests, and CI; never modifies the C reference. |
| `/campaign` | `wei-lin` | Run a long-running multi-mission engineering campaign. Dispatches specialists in isolated worktrees, gates merges, bumps tags, reverts + logs on regression, writes the session log. |
| `/autopilot` | `wei-lin` | Work the status board unattended for a stated budget (`autopilot 12h`). See the deep dive below. |
| `/release` | `haruto-nakamura` | Versioned-release workflow. `release` / `release minor` / `release major`. Audits first, fixes findings, verifies the tree over a green gate, cuts the version, writes release notes, pushes, gates on green CI, then tags. |
| `/propose` | `shu-han` | Funding proposal end to end. See the deep dive below. |
| `/review` | `elena-hartmann` | Holistic scientific review of a manuscript or analysis — verdict, core weakness, methodology, internal consistency, what a hostile reviewer would say. Dispatches specialists when depth is needed. |
| `/stage-publish` | `anya-petrov` | Stage a project for public release — GitHub publish-ready repo and Zenodo-ready data bundle. Scrubs for credentials, fixes the reproducibility floor, generates CITATION.cff and Zenodo metadata, mints a DOI. |
| `/eval-deployment` | `nadia-hadid` | Review a real-world deployment of any consilium agent or team — scores the run against the agent's contract and the task, diagnoses the root cause of any miss, recommends prompt or fixture edits. |
| `/implement` | `dunyu-liu` | Research-heavy new implementation with no reference. `implement <feature>` builds; `implement spike <question>` is feasibility only. |
| `/enforce-rules` | `zofia-kaminska` | Enforce the project rule book. No argument audits; `seed` aligns the project to the book — creating what is absent, patching what exists; `codify <incident>` turns an incident into a rule. |
| `/brief` | — | The owner's one-screen report on the calling session's work, run in that session: answer, what changed with proof, a comparison table, numbered decisions with a recommendation, what runs next. Silent past one line when nothing changed; loop it with `/loop 2h /brief`. |

## `/autopilot` — what it may do unattended

`autopilot <budget>` invokes `wei-lin` to work a project's status board
unattended for the budget you give it — `12h`, `3 milestones`, or `until the
board is green`. She reads the queue in `prio` order (tie-break: state),
lands each change through a gated merge, and at each milestone runs the
strict cycle: a rules audit (`zofia-kaminska`) and a technical audit
(`victor-reyes`), fixes by each finding's surface owner, a `kai-fischer`
refactor scoped to the findings, and a `haruto-nakamura` release gated on
green CI for that exact commit — then proves the result by cloning that
commit fresh and following the README as a stranger.

**No agent merges, pushes, publishes, deletes a branch, force-updates a tag,
or issues a final verdict on your behalf — except this one narrow,
named exception.** An autopilot run is pre-authorized to commit, push, and
tag **patch and minor releases on a non-default branch**, each behind its
own gates: the merge gate, the milestone audit cycle, a green CI run on the
exact SHA, and the fresh-clone check described above. Nothing else is
granted:

- No major version bump.
- No tag on the default branch.
- No publish to a package index.
- No force-update of an existing tag.
- Every other verdict stays yours — the run stops and asks rather than
  assuming, including on a second CI failure at the same check.

Starting a campaign is not the same as signing off on it: `wei-lin` signs
individual merges inside the run; you sign the run itself, by invoking
`/autopilot` in the first place. At most two specialists run at once (they
share one rate limit), and work-in-progress is committed before each
dispatch, so an interrupted run resumes from the last committed checkpoint
and the board rather than from memory.

## `/propose` — what it does

`propose <idea> [solicitation-url-or-path] [inputs…]` invokes `shu-han`,
fresh, on the idea and whatever inputs you pass. The idea comes first; with no
solicitation she lists the programs that fit and you pick one. Her workflow order is the
contract: nothing is drafted before `criteria_checklist.md` and
`literature_review.md` exist, and a requested output list adds files to the
run without ever dropping a step. The full sequence: criteria checklist,
literature review, a scope matrix, figures, one-source drafts of each
section, validated references, an elevation pass, and fresh review rounds.
Her report names any step she skipped. For unpublished work her DOI/ID-only
lookups hold; generic topic searches stay allowed.
