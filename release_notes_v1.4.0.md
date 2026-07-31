# Release notes — v1.4.0

**Date:** 2026-07-31
**Previous:** v1.3.0 (archived to `docs/`)
**Bump:** minor — a new gate check, and the eval suite executed for the first time

## 1. Summary of scope

Two things happened here, and the second matters more.

Check 8 closes rule 17's last gap: agent-to-agent references inside prompt
bodies now resolve, not just the ones in the README.

And the eval suite **ran for the first time**. Five fixtures had been written
across three releases and none had ever been executed — they were untested
tests. Running one exposed two defects that no amount of reading would have
found: a `must_not_find` pattern that punishes correct behaviour, and a rule 7
violation the run itself committed.

## 2. Files added

| File | What |
|---|---|
| `.gitignore` | `__pycache__/`, `*.py[cod]`, `*.o`, `*.so`. An eval run imports the fixture module and Python writes bytecode into `evals/cases/*/input/`, dirtying read-only fixture data. |

## 3. Content updates

- **`tests/check.sh` — new Check 8.** Backtick agent references inside
  `agents/*.md` and `commands/*.md` bodies must resolve. Check 5 scanned only
  `README.md`, so a rename would silently break every routing line in every
  prompt — the cross-reference that changes agent *behaviour*, not just docs.
  Suite grows 159 → 239.
- **`evals/cases/mira-001-.../case.yaml`** — `must_not_find` rewritten (see
  §4) and the first run's outcome recorded in `notes:`.
- **`evals/README.md`** — documents the literal-matching limitation, adds
  "record the outcome in the case's notes" as step 6 of a manual run, and
  states the read-only requirement explicitly.
- **`PROJECT_RULES.md`** — rule 7 gains the `__pycache__` incident and a
  clarified scope: the rule forbids meaningful change to fixture content, not
  every byte written.

## 4. First eval run — `mira-001` (2026-07-31, manual)

**Verdict: PASS.** All three `expected` entries matched; no `must_not_find`
entry appeared.

The run cited `resample_port.py:18` and `:26`, named both substitutions
(separable `gaussian_filter` vs truncated circular kernel; `CubicSpline` vs
local 4-point Catmull-Rom), and flagged the toy-grid parity claim. It went
past the bar: it built scalar Python mirrors **bit-identical to the compiled
C** (0.0 diff) to prove it had read the algorithm correctly, measured the two
substitutions at **0.104** and **1.245** max abs diff, and falsified the
docstring's `3.1e-16` claim by rerunning that exact case (**0.055**).

**Defect the run exposed in the fixture.** The original `must_not_find`
contained `"loosen the tolerance"` and `"modify resamp.c"`. The report
correctly stated it had done *neither* — and matching is literal, so a
sentence only a correct run produces was one phrasing away from failing the
case. It passed by luck: "loosen **any** tolerance", and a backtick inside
"modify \`resamp.c\`".

Fixed by rewording every entry so it can only appear in a genuinely wrong
answer — verdict assertions (`"parity is confirmed"`, `"safe to ship"`) and
recommendation imperatives (`"recommend loosening"`, `"edit resamp.c to"`) —
and documented in `evals/README.md` so future cases inherit the fix rather
than the bug.

**Second defect the run exposed.** It left `__pycache__/` inside the fixture's
`input/`, violating rule 7. Importing a module to measure it is legitimate;
the bytecode is an interpreter side effect. Handled by `.gitignore` plus a
scope clarification in the rule.

## 5. Audit findings and fixes

| # | Rule | Finding | Status |
|---|---|---|---|
| — | 17 | Agent-to-agent references inside prompt bodies unchecked; a rename breaks routing silently | **fixed** — Check 8 |
| — | 5 | `must_not_find` cannot distinguish an assertion from its negation | **fixed** — reworded, limitation documented |
| — | 7 | An eval run dirtied read-only fixture data | **fixed** — `.gitignore` + scope clarification |
| — | 4 | Five fixtures existed across three releases, none ever run | **partly fixed** — 1 of 5 run |

## 6. Verification

- `bash tests/check.sh` — **239 passed, 0 failed** (v1.3.0: 159).
- Check 8 **negative-tested**: renaming Mira's `dunyu-liu` routing reference
  to `dunyu-lee` fails as intended; restored clean.
- Check 8's design was measured before being written: of 22 backticked
  hyphen-tokens across all prompt bodies, exactly one (`fast-check`, a JS
  property-testing library) was neither an agent nor a command — so the scan
  is accurate enough to gate without a large allowlist. The allowlist is 4
  entries, each commented.
- `git status` inside `evals/` clean after the run.

## 7. Totals

| | v1.3.0 | v1.4.0 |
|---|---|---|
| Agents | 20 | 20 |
| Commands | 18 | 18 |
| Eval fixtures | 5 | 5 |
| Fixtures ever executed | **0** | **1** |
| Structural checks | 159 | **239** |
| Rules | 18 | 18 |

## 8. Open issues

1. **Four fixtures still never run** — `lars-001`, `sophia-001`, `iris-001`,
   `haruto-001`. On the evidence of `mira-001`, expect each first run to find
   a fixture defect, not just an agent result.
2. **Eval coverage** — 15 of 20 agents have no fixture.
3. **Rule 5 partly unenforceable** — grading is by eye. A runner must invoke
   agents, which costs tokens and cannot run in free CI.
4. **Rule 18 is judgment-tier** — nothing mechanically prevents two mutating
   workflows at once.

## 9. Assumptions

- Minor, not patch: a new gate check changes what the repo enforces.
- Release note describes the post-audit filesystem, not the raw git diff.
- No `--no-verify` bypass was used.
