# Release notes — v1.1.0

**Date:** 2026-07-31
**Previous:** v1.0.2 (archived to `docs/`)
**Bump:** minor — four agents and three commands added since v1.0.2

## 1. Summary of scope

Twenty-six commits and one working-tree batch since v1.0.2. The release adds
three agents (`mira-volkov`, `wei-lin`, `zofia-kaminska`), the structural-check
gate, the git-pull install path, and — for the first time — a rule book for
consilium itself.

The headline change is that consilium now has enforceable rules. Two agents
already audited against `PROJECT_RULES.md`; the file did not exist. It does
now, and the release workflow was restructured to use it.

## 2. Files added

| File | What |
|---|---|
| `PROJECT_RULES.md` | The rule book — 17 rules, seeded by `zofia-kaminska` and adapted to consilium's real artifacts. Rules 1–11 are the portable starter set; 12–17 are consilium-specific. Rule 6 (performance provenance) dropped as inapplicable, its number left unassigned so citations do not shift. |
| `agents/zofia-kaminska.md` | Project-rules enforcer. Seeds a rule book for a new project, audits a repo against the one it has, codifies incidents into rules. Edits the rule book only. |
| `commands/enforce-rules.md` | `/enforce-rules` — audit, `seed`, or `codify`. |
| `agents/mira-volkov.md` | C/Fortran→Python porting + numerical optimization (landed `ed85c34`). |
| `agents/wei-lin.md` | Campaign conductor, multi-mission orchestration (landed `fd9f46f`). |
| `install.sh` | Root installer with the post-merge hook, so `git pull` refreshes every machine (landed `9b3cea5`). |
| `tests/check.sh`, `.github/workflows/check.yml` | Structural-invariant gate, 75 checks (landed `808a9f6`). |
| `evals/cases/iris-001-defers-all/`, `evals/cases/haruto-001-missing-prior-notes/` | Regression fixtures. |

## 3. Content updates

- **`agents/haruto-nakamura.md`** — release workflow restructured to
  **audit → fix → verify → cut → push**. The audit now runs first, on the
  pristine tree, before any archiving mutates it; the version is chosen only
  after the tree passes its gate. Added a verify step that halts on a red gate,
  a tag step, and a push step. Gained the `Agent` tool and delegates the deep
  audit to `victor-reyes`, falling back to an inline audit outside consilium.
- **`agents/wei-lin.md`** — rule-book filename canonicalised to
  `PROJECT_RULES.md` (5 references). Wei previously seeded `project_rules.md`
  while Haruto audited `PROJECT_RULES.md`; on a case-sensitive filesystem each
  wrote a file the other could not find.
- **`commands/release.md`** — description updated to match the new step order.
- **`README.md`** — specialist count corrected 16 → 19; `zofia-kaminska` added
  to the model table; `haruto-001` added to eval coverage; Layout tree now
  lists root `install.sh` and `PROJECT_RULES.md`.

## 4. Audit findings and fixes

`zofia-kaminska` audited the repo against the rule book she had just seeded.
Eight violations found; five fixed in this release.

| # | Rule | Finding | Status |
|---|---|---|---|
| V8 | canonical naming | `wei-lin` used `project_rules.md`, `haruto` used `PROJECT_RULES.md` | **fixed** |
| V1 | 11 | README claimed "Sixteen specialists"; 19 exist | **fixed** |
| V2 | 12 | Model table listed 18 of 19 agents | **fixed** |
| V3 | 11 | Eval coverage named 3 cases; 4 exist | **fixed** |
| V7 | 11 | Layout tree omitted root `install.sh` | **fixed** |
| V4 | 14 | Two divergent installers — root (32 lines, wires post-merge hook) vs `scripts/` (81 lines, `--force`, no hook). README directs users to the one without the hook, making its "git pull updates every machine" claim false for newly added agents. | **open** |
| V5 | 15 | Zero git tags for three release notes | **fixed** — v1.0.0, v1.0.1, v1.0.2 retro-tagged at their `release:` commits (`fe260b9`, `94e9878`, `b0872ae`); v1.1.0 tagged here |
| V6 | 13 | 15 of 19 agents have no eval fixture | **open** |

Tier split of the rule book itself: 8 mechanical, 5 judgment, 3 unenforceable
as written (rules 5, 9, 12).

## 5. Open issues

1. **V4 — two installers.** Which is canonical is a judgment call; not
   invented here. Consolidating is a behaviour change to the install path.
2. **V6 — eval coverage.** 15 agents uncovered, including `mira-volkov`, the
   largest prompt and most-dispatched agent.
3. **Tag provenance.** v1.0.0–v1.0.2 were created during this release by a
   concurrently-running release agent, not by this workflow run. They point at
   the correct `release:` commits and were verified as such, but two writers
   touched the repo at once — the merge-discipline failure `wei-lin` exists to
   prevent. Worth a rule.
4. **Rule 5 unenforceable** until an eval runner exists — pass/fail on fixtures
   is currently adjudicated by eye (`evals/README.md`).
5. **Rule 9 unenforceable** — nothing records whether the gate ran before a
   push. A `pre-push` hook would make it mechanical.
6. **Rule 12 unenforceable** — `check.sh` verifies an agent is *mentioned* in
   the README, not that its model-table row exists or matches frontmatter. V2
   passed the gate while the table was wrong.

## 6. Totals

| | v1.0.2 | v1.1.0 |
|---|---|---|
| Agents | 16 | 19 |
| Commands | 14 | 17 |
| Eval fixtures | 2 | 4 |
| Structural checks | — | 75 |
| Rule book | none | 17 rules |

## 7. Verification

`bash tests/check.sh` — **75 passed, 0 failed**, run against the final tree
after every fix above.

## 8. Assumptions

- Minor bump, not patch: three agents and three commands are new functionality.
  The `release` trigger requested a patch; the diff's scope says minor, and
  per the workflow's step 5 the scope wins with the discrepancy stated.
- Release notes describe the post-audit filesystem, not the raw git diff.
