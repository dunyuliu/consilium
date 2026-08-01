# Release notes — v1.8.0

**Date:** 2026-07-31
**Previous:** v1.7.0 (archived to `docs/`)
**Bump:** minor — three fixtures, a behavioural fix verified two-sided, and a pattern named

## 1. Summary of scope

Three new fixtures (12 cases, **12 of 20 agents** covered), and the
`sophia-okafor` fix from v1.7.0 verified in both directions by a purpose-built
two-sided case.

The finding that matters most is not any single defect. It is that **three
consecutive fixtures shipped with contaminated "clean" regions** — and each
time the agent under test was right and the fixture was wrong. That is now
named, documented, and the correction rule is written into
`evals/README.md`.

## 2. The `sophia-okafor` fix is verified — both directions

`sophia-002-default-vs-deployment` was built specifically to catch
overcorrection, because a one-sided fixture cannot. Three adjacent situations:
a code fallback that disagrees with the documented default (must find), a
config key the code never reads (must find), and keys the config legitimately
overrides where doc and code defaults agree (must stay silent).

**Result: PASS.** Both true positives found; the legitimately-overridden keys
correctly silent. The v1.5.0 false positive is suppressed and the genuine
code-fallback drift still fires — which is exactly what Nadia's
anti-overcorrection clamp was written for.

`sophia-001` was also re-run and passed, with **recall improved**: it found
two drifts the pre-fix run missed, including a symmetric spike filter
(`README.md:12` says "above the rolling median"; `ingest.py:18` uses `.abs()`).

## 3. New fixtures

| Fixture | Author | The trap |
|---|---|---|
| `sophia-002-default-vs-deployment` | `iris-vermeulen` | The deployed `max_retries` **matches** the documented default, so the bug never fires at runtime — forcing the finding to be about the two *written* defaults rather than an observable symptom |
| `kai-001-half-bin-offset` | `dunyu-liu` | Three counting loops identical but for constants; one carries a `+ 0.5 * MAG_BIN` centring term. Merging all three shifts **42.4% of 5000 synthetic events** into different bins and biases mean magnitude low by 0.042 — half a bin — into the b-value the module feeds |
| `ziyan-001-thermal-expansion` | `lars-eriksson` | A claim its correctly-cited paper does not support, plus a year mismatch, offline-checkable with no network |

`kai-001`'s author negative-tested Check 9 against their own fixture before
shipping it, and deliberately left no test suite in `input/` so the case tests
reading discipline rather than test discipline.

## 4. The pattern: contaminated controls

Three fixtures in a row declared regions "clean" that were not:

- **`sophia-001`** — an undeclared silent-failure return (found by
  `nadia-hadid`).
- **`sophia-002`** — the negative keys documented defaults the code had no
  fallback for, so reporting them was correct. The run reported four findings
  where the fixture expected two, and **all four were right**.
- **`ziyan-001`** — the control references were never `\cite`d (one `\cite`
  command in the entire manuscript, so three entries would vanish from the
  bibliography), one control overclaimed its own abstract, and a 30–50% figure
  had no citation at all.

Every one was fixed in the fixture, never by relaxing the agent.

`evals/README.md` now carries the rule: **verify the control is clean as
rigorously as you verify the planted defect is present.** An undeclared true
defect in a control does not merely produce a false failure — it makes a
complete audit score *worse* than an incomplete one, which is the exact
opposite of what the suite is for.

## 5. Two further fixture-criterion defects

- **`sophia-001`** — a criterion added earlier the same day listed `"silent"`
  and `"min_valid_fraction"` as keywords, generic enough to match incidental
  mentions, so it passed *without the defect being found*. A criterion that
  passes without the defect being found is worse than no criterion. Tightened.
- **`sophia-002`** — the pass interval counted **report rows** ("exactly two
  findings"). An agent may legitimately decompose one defect into two claims,
  as this one did (the knob is inert; the routing is absent). Corrected to
  count **distinct defects**. A criterion that counts rows punishes
  thoroughness.

Running tally of distinct ways a fixture has been wrong: stale line range,
negation-unsafe guard, guard too specific to fire, criterion demanding a
citation style the agent's contract does not produce, criterion loose enough
to pass on nothing, contaminated control, and counting rows instead of
defects. **Seven.**

## 6. Verification

- `bash tests/check.sh` — **290 passed, 0 failed**.
- Every run scoped to `input/` with the agent's file-reference list checked
  for answer-key access before scoring.
- `sophia-002`'s three planted situations verified independently against the
  source before the case was run — the `.get("max_retries", 5)` fallback, the
  unreferenced `enable_dead_letter`, the bare-subscript keys.
- `ziyan-001`'s control contamination verified directly (`grep -c "cite{"`
  returned 1) before accepting the run's claim.
- Cut while holding the lock introduced in v1.7.0.

## 7. Totals

| | v1.7.0 | v1.8.0 |
|---|---|---|
| Agents | 20 | 20 |
| Eval fixtures | 9 | **12** |
| Agents covered | 9 | **12 of 20** |
| Fixtures executed | 9 | 11 of 12 |
| Structural checks | 283 | **290** |

## 8. Open issues

1. **8 agents uncovered** — victor-reyes, wei-lin, zofia-kaminska, dunyu-liu,
   nadia-hadid, anya-petrov, elena-hartmann, selin-aydin, marco-bianchi.
2. **`kai-001` and the corrected `ziyan-001` unrun.** `kai-001` must run on a
   copy — Kai holds `Edit` and the case is about what he changes.
3. **`must_not_find` cannot measure precision.** Three of today's seven
   fixture-defect classes trace to it guarding phrasing rather than behaviour.
   A report that is 25% signal still passes. This is now the most load-bearing
   open problem in the suite.
4. **Rule 5 partly unenforceable** — grading remains by eye.

## 9. Assumptions

- Minor, not patch: three fixtures and a verified behavioural fix.
- Release note describes the post-audit filesystem, not the raw git diff.
- No `--no-verify` bypass was used.
