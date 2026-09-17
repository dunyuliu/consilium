# v1.22.0 — the eval suite cut to what earned its place

Maintainer decision, on months of direct experience with these agents: we do
not need this many evals and fixtures; most are useless. This release acts on
that rather than weighing it.

## What changed

**Rule 13 retired** (and 13a with it), along with **Check 25** that enforced
it. Rule 13 required every agent to land with a fixture naming it. That is a
headcount mandate, not a coverage measure: 22 agents forced at least 22
fixtures whether or not any of them ever distinguished a good report from a
bad one. It is the same self-citing shape as the Check 17 / rule 21a pair
retired in v1.21.0 — a rule generates an artifact, a check enforces the rule,
and each cites the other while nothing asks whether the artifact was worth
anything.

The measurement that decided it: **20 of the 36 fixtures had never recorded a
single FAIL.** A fixture that has only ever passed has never distinguished
anything.

**The suite went 36 → 10 cases** (258 files / 13,559 lines → roughly a third
of that). A fixture survived only on positive evidence that it did work: it
caught a real regression, changed a prompt, or its failure taught something
that shipped. "It exists and it passes" was not evidence; where the call was
unsure, the default was to cut.

## What was deliberately NOT done

- `evals/run.sh`, the grading machinery and Check 30's keyword corpus are
  untouched. The method stays available and works identically at ten cases.
- **No deleted fixture was replaced by prose in a prompt describing what it
  tested.** That would be the same weight with worse feedback.

## Two check defects the cut exposed

Neither was damage; both were latent false positives that only fired once
something was deleted.

- **Check 8** scanned `*release_notes_v*.md` unscoped, so deleting
  `haruto-003/input/release_notes_v3.4.0.md` — a *synthetic* note that is
  fixture data — tripped "release notes are archived, never removed". Now
  scoped to the root and `docs/`.
- **Check 12** required a priority and a re-run interval on every board row,
  including the new `RETIRED` state, where both would be decoration. `RETIRED`
  is now exempt from those two, and accepted by the state enum.

## One subagent cut reversed

`lars-002-clean-control` was cut as "PASS-only, no failure ever recorded". Its
own notes record the opposite: Run 1 (2026-08-04) FAIL, Run 2 FAIL again, and
it caught a `must_not_find` guard firing on a *correct negation* — a criterion
rejecting a correct report, which is the defect class Check 15 exists for. It
is also the suite's only clean control, the one fixture measuring precision
rather than recall. Restored on that evidence, which is why the count is 10
and not 9.

## Honesty note

The eval score moved 11/36 (30%) to 5/10 (50%). **That is a selection
artifact, not progress** — the denominator shrank and the survivors were
chosen partly for having recorded verdicts. Nothing about any agent got
better. README question 3 now states the trade plainly: we measure less on
purpose, because measuring prose by dispatching agents cost more than it told
us, and most agent behaviour now rests on the judgement of whoever reviews the
prompt.
