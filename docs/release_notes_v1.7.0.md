# Release notes — v1.7.0

**Date:** 2026-07-31
**Previous:** v1.6.0 (archived to `docs/`)
**Bump:** minor — rule 18 made mechanical, every fixture executed, a real agent defect fixed

## 1. Summary of scope

Every one of the nine fixtures has now been run at least once, and the last
judgment-tier rule became a gate. The headline is not the count — it is that
running the suite keeps finding defects in the suite, and this time also found
a genuine defect in an agent.

**Nine fixtures, nine executed, nine passing.** Four ran for the first time in
this release; all four passed on substance, and one exposed a mis-specified
criterion in its own `case.yaml`.

## 2. Rule 18 is now mechanical

`tests/lock.sh` takes a named lock; the versioned `pre-commit` hook installed
by `install.sh` refuses a commit from any other writer while it is held.

```bash
export CONSILIUM_LOCK_OWNER=<who-you-are>
bash tests/lock.sh acquire "release v1.7.0"
bash tests/lock.sh release
```

**The first design was wrong and running it proved so within a minute.** It
stored `$$` and checked process liveness — and the lock read as *stale the
instant it was taken*, because `$$` is the pid of the short-lived `lock.sh`
shell itself. Agents issue each command in a fresh shell, so no pid outlives
the work it is meant to protect. Ownership is now a label. A lock is never
auto-cleared however old, because "probably stale" is exactly the reasoning
that caused the original incident.

**Second bug, also found by running it:** `install.sh` only wrote a hook when
one was absent, so the corrected `pre-commit` never replaced the broken one
already on disk. **A hook fix could never reach anyone who had already
installed.** Hook bodies now carry a version marker and are rewritten when it
changes. This silently affected `post-merge` and `pre-push` too.

Verified end-to-end: writer B's commit refused with the holder named, writer
A's commit allowed, release clears it.

## 3. Fixture runs — four firsts, all passing

| Fixture | Verdict | Beyond the plant |
|---|---|---|
| `jordan-001` | PASS | Reconciled 50 in / 40 out and quantified the unlogged exposure at **$42,565** by recomputing from source — the outputs cannot show it. Flagged two unplanted real issues |
| `ingrid-001` | PASS | Derived the von Neumann bound independently, then showed the docstring's convexity argument is **self-invalidating** at `cfl=0.9` because `1-2r` goes negative. Caught the secondary L2-norm defect |
| `rafael-001` | PASS | Reproduced the factor-of-`1/w` = 100 error (7.4 K vs ~740 K) without seeing the author's numbers. Raised a **third, unplanted** issue: `T_MELT = 1450 K` is ambiguous between dry (~1488–1533 K) and fluid-present (~923 K) granite solidus — which matters because the corrected peak lands within ~200 K of it |
| `priya-001` | PASS | Found all three planted defects, correctly **passed the control**, identified which month the wrong −1.5% actually came from, and ran an unplanted self-consistency check: `(1.097)^5 − 1 = 58.9%` contradicts the document's own 56.9% total return |

Each was scoped to `input/` and its file-reference list checked for
answer-key access before scoring.

## 4. Fixture defect found and fixed

**`priya-001` demanded a citation style its agent does not use.** `expected[0]`
was `kind: location`, requiring a `doc:line` citation — but `priya-nair`'s
documented output schema is a per-claim table with an Anchor column, and she
never cites `doc:line`. The criterion would have failed a correct audit **for
using its own contract's format**. Converted to `kind: keyword`; the anchor is
retained as a comment so the defect stays locatable.

The general lesson, now in the case notes: *a fixture must assert what the
agent's contract says it produces.* This is the fourth distinct way a fixture
has been wrong, after stale line ranges, negation-unsafe guards, and guards
too specific to fire.

## 5. A real agent defect, diagnosed and fixed

`nadia-hadid` reviewed the `sophia-okafor` false positive from v1.5.0 and
traced it to exact wording rather than guessing: `agents/sophia-okafor.md:94`
("Default value documented as A; code defaults to B") fires on *any* observed
value that isn't A, including a config file doing its job, and neither
existing false-positive suppressor covers value provenance. The frontmatter
example `"audit config defaults vs runtime defaults"` was the vocabulary
contamination underneath it.

Applied:

- **Config-drift section** now states plainly that a config setting a
  non-default value is not drift, and names the three cases that *are*.
- **New operating principle** — "distinguish the default from the deployment"
  — requiring a cited code-side fallback at `file:line` before any
  default-mismatch finding, with an explicit anti-overcorrection clamp naming
  the two true-positive classes it must not suppress.
- **Severity rubric added.** The output schema demanded a Severity column and
  nothing defined the scale, which is how three unactionable findings landed
  at High beside a genuinely critical one. Now: *if you cannot name the fix,
  you cannot rank it High.*
- **Frontmatter example** rewritten.

Nadia also found an **undeclared silent failure** in `sophia-001`'s own
fixture input (`ingest.py:29-30` returns an empty series that downstream
cannot distinguish from no-data). Rather than remove it, it is now a declared
second expected finding — it is realistic, and the run missed it.

Her closing observation is the one worth keeping: the fixture *reported green*
on a run with a 25% signal rate. `must_not_find` guards phrasing; it cannot
measure precision.

## 6. Verification

- `bash tests/check.sh` — **283 passed, 0 failed** (one fewer than v1.6.0's
  284: `priya-001` no longer has a `kind: location` entry for Check 9 to
  verify, which is the correct outcome, not a regression).
- Lock tested end-to-end: refused the other writer, admitted the holder.
- Hook versioning verified: all three hooks carry the current marker after a
  re-run.
- `jordan-001`'s row counts and `ingrid-001`'s amplification factor were
  re-derived independently of the authoring agents' reports (rule 4).
- This release was cut while holding the lock it introduced.

## 7. Totals

| | v1.6.0 | v1.7.0 |
|---|---|---|
| Agents | 20 | 20 |
| Eval fixtures | 9 | 9 |
| **Fixtures ever executed** | **5** | **9** |
| Structural checks | 284 | 283 |
| Rules | 21 | 21 |
| Judgment-tier rules remaining | 6 | **5** |

## 8. Open issues

1. **Eval coverage** — 11 of 20 agents still have no fixture.
2. **Rule 5 partly unenforceable** — grading is by eye. A runner would also
   fix answer-key leakage structurally.
3. **`must_not_find` cannot measure precision** — it catches forbidden
   phrasings, not a report that is 25% signal. No mechanism proposed yet.
4. **Nadia's proposed `sophia-00N` fixture** — a two-sided case locking both
   directions of the default-vs-deployment fix. Sketched, not built.
5. **Sophia's fix is unverified** — the prompt changed after her only run.
   Re-running `sophia-001` is the next obvious step.

## 9. Assumptions

- Minor, not patch: a rule became mechanical and an agent's behaviour changed.
- Release note describes the post-audit filesystem, not the raw git diff.
- No `--no-verify` bypass was used.
