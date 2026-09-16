# Release notes — v1.20.0

**Date:** 2026-08-10
**Previous:** v1.19.0 (archived to `docs/`)
**Bump:** minor — a new model tier permitted and used on a judgement call
(not yet passing its own fixture), two incident fixes to a write-capable
agent's isolation and reporting discipline, and README corrections that
moved the coverage claim from false-optimistic to accurate

## 1. Summary of scope

Seven commits since v1.19.0 (`a8e9ec1`): `fable` added to the model
allow-list, `dunyu-liu` promoted onto it on the maintainer's explicit
judgement, that promotion tested against its own eval fixture and found
wanting, `kai-fischer` fixed for two incidents from a real deployment, and
the README corrected in five places where it had drifted from what the
repo actually does. This release audit (delegated to `victor-reyes`) then
found a second layer: five of those same corrections, plus two other
project documents, had themselves gone stale or arithmetically wrong
between being written and being read. Those are fixed here, before the
version was cut.

## 2. `fable` permitted, and used once — the run failed

`tests/check.sh` Check 1 (frontmatter validation) and Check 6
(README-model-table parser) had `{opus, sonnet, haiku}` hard-coded in four
places. All four now accept `fable`, verified both ways: a `model: fable`
agent passes Check 1, `model: gpt4` still fails with the updated message.

`dunyu-liu` was then promoted `opus -> fable` on the maintainer's explicit
request, without a fixture run first — the first tier change in this
project's history made that way, and the first that is a *promotion*
(more expensive) rather than a drop. It was tested immediately afterward
against `evals/cases/dunyu-001-friction-unequilibrated/`:

**FAIL — 3 criteria, 2 failed**, both the agent's own contract rather than
fixture brittleness. The report never named a file or a line
(`agents/dunyu-liu.md`'s own output schema requires `{file:line}` and it
cited a scratch file instead), and never stated the kill criterion its own
step 1 requires, despite reaching the right disposition in different
words. Against that, the run built and independently verified real
physics — slip onset against a locked-interface solve, exact
positive-homogeneity, a hand-written cross-check operator — and
rediscovered three of four declared fixture defects unprompted.

**The tier was not reverted.** This is recorded here rather than
silently carried forward: `dunyu-liu` currently runs on a model tier whose
only fixture run against it failed on the agent's own contract, on the
maintainer's explicit and documented decision to accept that trade for the
research quality observed. See open issues below.

## 3. `kai-fischer` — two fixes from a real deployment, no fixture yet

Both found by a project using him, not by anything in this repo:

1. `git checkout -b` in a shared checkout silently moves the caller's
   `HEAD`, so the caller's next commit lands on Kai's branch instead of
   its own — it happened, and cost a manual untangle. His isolation
   section now branches on whether a worktree was actually given; absent
   one, he edits in place, does not commit, and tells the caller plainly
   that changes are sitting uncommitted on branch X.
2. He ended a turn promising a report "when it completes" that never
   came, because nothing wakes a subagent. Output format now requires the
   report in the same turn the work finishes.

**Rule 10 debt, not paid.** Both ship without an `evals/cases/` fixture,
which `PROJECT_RULES.md` rule 10 requires before or alongside an
agent-behaviour fix. Recorded as an open item below rather than invented
here.

## 4. README corrected in five places, then audited a second time

The original five corrections (tagline no longer calling this "an
editorial team"; the coverage claim fixed from "23 cases, every one
executed" to the real 27-cases/5-current state; `declared_defects`
described as unbuilt when it shipped in v1.13.0; clean-clone install
described as never executed when PF-010 closed it in v1.16.0; "25 rules /
16 enforced" corrected to the real 34/27) are all in the diff and were
independently re-verified by `victor-reyes`'s audit — all five hold.

**The audit also found the corrections had already drifted**, in the six
days between being written and being read for this release:

- `PROJECT_RULES.md:388` (rule 16) still read `model` as one of
  `{opus, sonnet, haiku}` — stale the moment Check 1 was widened to
  accept `fable`. Fixed.
- `PATHWAY_FORWARD.md`'s PF-008 mutation record quoted the pre-`fable`
  error string as current evidence. Fixed.
- README's smoke-tier line claimed "seven of nine members have no
  current verdict"; `bash evals/run.sh smoke` shows the tier has **ten**
  members and **eight** lack a current verdict (five never run, three
  stale). Fixed.
- README's "six mutations" negative-test claim was dated 2026-08-05; the
  commit that did it (`420a4f7`) is dated 2026-08-04. Fixed.
- `PATHWAY_FORWARD.md`'s own README-audit table said `declared_defects`
  was "built in v1.13.0, on 8 cases" — true only at landing. Eleven
  `case.yaml` files carry it today. Fixed to state both.
- `PATHWAY_FORWARD.md`'s count of mechanical rules with no check number
  named enumerated 13 rule numbers while claiming 14; rule 13 itself
  (the fixture-per-agent rule, now enforced by Check 25 but not cited by
  number at its own index row) was the missing one. Fixed.

None of these six needed judgement — each was a count or a quoted string
checkable against a command that was re-run before the edit landed.

## 5. Audit findings not fixed — deferred to the maintainer

**`agents/kai-fischer.md`'s new isolation text conflicts with
`PROJECT_RULES.md` rule 20.** Rule 20 step 1 reads "Never write to the repo
root, the `main`/`master` checkout, or the master project folder" —
unconditional. Kai's new text permits editing in place (not committing)
on whatever branch a shared checkout happens to be on when no worktree was
given, which can be `main`. The fix in §3 solves the `HEAD`-move incident
correctly but reopens exactly the write-to-main exposure rule 20 exists to
close, with no fallback ("refuse and ask for a worktree") written for that
case. This needs a maintainer decision — whether rule 20 gets a carved-out
exception for edit-without-commit, or Kai's prompt gets a hard refusal
instead of "leave it on whatever branch" — not a release-time guess.

**`dunyu-liu`'s fable tier**, per §2 — carried forward on the maintainer's
own explicit call, restated here for visibility rather than reversed.

## 6. Verification

- `bash tests/check.sh` at the pre-release commit (`f840b4a`) — **752
  passed, 0 failed**.
- `bash tests/check.sh` re-run with this note staged but not yet tagged —
  **752 passed, 1 failed** (Check 27, on this note; expected per the
  ordering caveat in `haruto-nakamura`'s cardinal rule 1 — a release note
  is red until its tag exists). The commit, the `v1.20.0` tag, and the
  final green gate run all happen next, in that order, per the caveat.
- `victor-reyes` audit dispatched against the full `a8e9ec1..HEAD` diff
  plus `PROJECT_RULES.md`; ran the gate, `evals/run.sh list`, `evals/run.sh
  smoke`, and read all 27 `case.yaml` files directly rather than trusting
  prose.
- CI green on the remote through `97d5b04` per the operator's report at
  the start of this cut.

**Independently checked out `v1.19.0` and re-run its gate rather than
trusted its own note**: `bash tests/check.sh` at that tag reports **752
passed, 0 failed**, not the 751 the v1.19.0 note itself recorded. Same
off-by-one already documented for v1.18.0 ("739" in the note, 740 true) —
the note's own count is written before the note's own file is what Check
27 counts against. Not correctable in the v1.19.0 note (rule 8); recorded
here instead.

## 7. Totals

| | v1.19.0 (as measured now) | v1.20.0 |
|---|---|---|
| Agents | 21 | 21 |
| Eval fixtures | 27 | 27 |
| Structural checks | 29 checks, 752 assertions | 29 checks, 752 assertions pre-tag (§6) |
| Model tiers in use | opus/sonnet/haiku (3) | + fable (4) |
| Verdicts current against their prompt | 5 of 27 | 5 of 27 (unchanged — no new fixture run landed with this release) |

## 8. Remaining open issues

1. `agents/kai-fischer.md` vs `PROJECT_RULES.md` rule 20 — §5, needs a
   maintainer decision.
2. `dunyu-liu` on `fable` with its only fixture run at FAIL 2/3 — §2 and
   §5, carried on the maintainer's explicit call.
3. Rule 10 debt for both `kai-fischer` fixes — no fixture yet (§3).
4. 22 of 27 eval verdicts are stale or never-run (unchanged from v1.19.0's
   count of the same gap, now counted against 27 cases instead of the
   prior state) — needs real agent dispatches, which this release did not
   perform beyond the one `dunyu-001` run in §2.
5. **`PATHWAY_FORWARD.md`'s own PF-013 paragraph on the fable promotion is
   itself now stale**, and was left alone rather than fixed here because
   correcting it means deciding how a *failed* fixture run should count
   toward "tiers established by execution" — a judgement call, not a
   sync. The paragraph (written at the moment of promotion, before
   `dunyu-001` was actually run) still reads "`dunyu-001` has not been run
   against it" and tallies "1 by explicit unverified decision"; §2 above
   shows it has been run, and failed. Flagged for the maintainer rather
   than silently recategorized.

## 9. Assumptions

- Minor, not patch: a new model tier with a live behavioural consequence
  (§2), two agent-behaviour fixes (§3), and doc corrections across three
  files qualify as more than a patch under this project's own precedent
  (v1.19.0 was minor for a comparable mix).
- The stale-doc findings in §4 were treated as mechanical (a quoted string
  or count checkable by re-running the cited command) and fixed directly;
  the two items in §5 were treated as judgement calls and deferred rather
  than guessed at.
- No `--no-verify` bypass was used. The release note was committed and
  tagged before the gate was re-run, per this project's own ordering
  caveat for Check 27 (`haruto-nakamura`'s cardinal rule 1).
