# Release notes — v1.6.0

**Date:** 2026-07-31
**Previous:** v1.5.0 (archived to `docs/`)
**Bump:** minor — three rules, three checks, four fixtures

## 1. Summary of scope

v1.5.0 ran the eval suite for the first time and found the fixtures were
broken. v1.6.0 turns that lesson into structure: the repo now states what it
believes about itself (rule 0), who may write where (rule 19), and how a
writer must behave (rule 20) — and each of those is a check, not a paragraph.

**Every new check found a real defect on its first run.** That is the release
in one line.

| Check | Found immediately |
|---|---|
| 9 — fixture anchors | my own `priya-001` anchor pointing at the wrong lines |
| 10 — write-surface ownership | three agents whose declared job their tools could not perform |
| 11 — isolation-first | five writers with no containment statement anywhere |

## 2. Rules added

**Rule 0 — Always eat what you cook.** Placed above the index because it is
not one rule among the others; it is the reason the others get checked. Every
discipline consilium sells, it applies here first. Carries four incidents,
all found only by aiming consilium at consilium: two agents enforcing a rule
book that did not exist, `wei-lin` and `haruto-nakamura` writing different
filenames for it, five fixtures never executed, and Check 9 shipping a design
this repo's own `evals/README.md` already forbade.

**Rule 19 — One owner per write surface.** A table mapping each file class to
exactly one agent, parsed by Check 10, so it is machine-readable truth rather
than documentation of it. Nine surfaces, nine owners.

**Rule 20 — Every writer declares isolation first, and is evaluated at the
merge.** The lifecycle: isolate → stay in your surface → finish → be judged
by someone else against a fresh gate run, never the author's report of one.
Placement is part of the rule: containment stated at line 80, after the agent
has read its mission, is advice; stated first it is a precondition.

## 3. Checks added

- **Check 9** — every fixture's `line_range` still brackets a declared
  `anchor:` (a literal string from the input file). New `anchor:` field on
  `kind: location` entries, documented in `evals/README.md`. Deliberately
  separate from `keywords:` — keywords describe the *report*, the anchor
  describes the *code*, and conflating them tests string-match, not detection.
- **Check 10** — the rule-19 table is complete and exclusive: every owner is a
  real agent that holds `Edit`/`Write`, every writer owns a surface, no
  surface has two owners.
- **Check 11** — every write-surface owner's first `##` section is
  `## Isolation`.

Suite: **239 → 284 checks.** All three negative-tested before landing.

## 4. Contract bugs fixed (found by Check 10)

| Agent | Owned | Held | Fix |
|---|---|---|---|
| `haruto-nakamura` | release notes, versions, tags | no `Edit`/`Write` | **the release engineer could not write a release note** — tools corrected |
| `anya-petrov` | CITATION.cff, Zenodo metadata | no `Edit`/`Write` | corrected; the README had claimed she "applies edits" |
| `nadia-hadid` | — | `Edit` | given her real surface: project-local `.consilium-review/` |

`wei-lin` no longer authors the rule book — he specifies what it must cover
and delegates writing to `zofia-kaminska`. Two owners was the disease behind
this morning's `project_rules.md` / `PROJECT_RULES.md` split; the filename was
only the symptom.

## 5. Isolation sections

All nine write-surface owners now open with `## Isolation`, tailored to the
surface rather than boilerplate:

- `haruto-nakamura`'s isolation is **temporal** — a release mutates the shared
  repo by design, so he holds it alone, never force-pushes, never `--no-verify`.
- `anya-petrov` stages into a **copy**, because scrubbing credentials and
  history is irreversible in a live tree.
- `nadia-hadid` may never edit a prompt she is grading — an evaluator that
  edits its subject is measuring itself.
- `iris-vermeulen` may never edit a fixture's planted defect to make a suite
  go green.
- `kai-fischer` stops being the owner the moment a refactor needs a test
  changed — that is a behaviour change.

Before this release, seven of the nine had no such statement; `zofia-kaminska`
also had a redundant "Scope boundary" section, now folded in.

## 6. Fixtures — coverage 5 → 9 of 20 agents

Three were authored by consilium's own agents, in parallel, each scoped to its
own directory. No agent authored its own fixture — a test written by the thing
under test is not a test.

| Fixture | Author | Planted defect |
|---|---|---|
| `priya-001` | this session | arithmetic-vs-geometric CAGR (9.68% claimed, 9.5937% true) with an **offsetting** period error, so a partial audit lands near the wrong answer and feels confirmed. Includes a correct control claim that must not be flagged |
| `rafael-001` | `dunyu-liu` | frictional power W/m² divided by ρc alone → **K·m not K**; predicts 7 K of coseismic heating where the physics gives 741 K. Secondary clip defect stays latent until the primary is fixed |
| `ingrid-001` | `dunyu-liu` | FTCS at `cfl = 0.9` against a von Neumann limit of 0.5; amplification 2.6/step, verified — and invisible on the coarsest grid a reviewer would try first |
| `jordan-001` | `iris-vermeulen` | silent inner-join drop: 50 rows in, 40 out, prints "Processed 40 trades successfully" |

Each author verified its own defect numerically and left the run-record slot
in `notes:` explicitly empty — the fixtures have not yet been run against
their target agents, and say so.

## 7. Verification

- `bash tests/check.sh` — **284 passed, 0 failed**.
- Checks 9, 10, 11 each negative-tested: a stale anchor, a missing ownership
  row, and a stripped isolation section all fail with the intended message,
  then restore clean.
- `install.sh` re-run — 20 agents, 18 commands.
- `jordan-001`'s row counts and `ingrid-001`'s amplification factor were
  re-derived independently rather than taken from the authoring agents'
  reports (rule 4).

## 8. Totals

| | v1.5.0 | v1.6.0 |
|---|---|---|
| Agents | 20 | 20 |
| Eval fixtures | 5 | **9** |
| Structural checks | 239 | **284** |
| Rules | 18 | **21** (0–20, 6 dropped) |
| Writers declaring isolation | 2 of 9 | **9 of 9** |

## 9. Open issues

1. **Eval coverage** — 11 of 20 agents still uncovered.
2. **Four new fixtures unrun** — `priya-001`, `rafael-001`, `ingrid-001`,
   `jordan-001`. On v1.5.0's evidence, expect first runs to find fixture
   defects, not just agent results.
3. **Rule 5 partly unenforceable** — grading is by eye; a runner needs API
   access and would also fix answer-key leakage structurally.
4. **`sophia-okafor` false positive** — treats configured non-default values
   as drift. Open, routed to `nadia-hadid`.
5. **Rule 18 judgment-tier** — nothing mechanically prevents two mutating
   workflows at once.

## 10. Assumptions

- Minor, not patch: three rules and three checks change what the repo
  enforces.
- Release note describes the post-audit filesystem, not the raw git diff.
- No `--no-verify` bypass was used.
