# Release notes — v1.14.0

**Date:** 2026-08-05
**Previous:** v1.13.0 (archived to `docs/`)
**Bump:** minor — a new check, a new rule sub-clause, a refusal fixture, and
staleness made visible where it is used

## 1. Summary of scope

Four commits. The theme is **rows and records that described something other
than what they claimed to** — a check that verified presence and was read as
verifying content, an evidence command that counted lines to support a claim
about behaviour, and a re-run that the board relied on and no case file records.

## 2. Check 20 — the dispatch warning tracks the `Agent` tool

v1.13.0's PF-009 audit recorded a limit: Checks 13 and 14 verify that the
discipline sections **exist**, and `## Communication discipline` is
byte-identical across all 21 agents, so Check 13 proves 21 copies of a paragraph
exist rather than 21 considered declarations.

Auditing the content settled it the other way. **Uniformity is correct here.**
Reading files and reporting costs the same whoever does it, and there is exactly
one axis on which the economics genuinely differ — whether the agent spawns
subagents, at ~10× the cost of doing the work itself. The prompts already
differentiate on precisely that axis and nothing else: the four `Agent`-holders
carry a dispatch-cost paragraph the other sixteen do not, and `lian-zhao` carries
a variant because dispatching is her *main* cost rather than an occasional one.

So the useful invariant was never "these sections differ per agent" — it is that
the one real difference stays **aligned with the capability that causes it**.
Check 20 enforces exactly that, negative-tested both directions. Rule 23a.

The PF-009 paragraph calling it a gap is left standing with the correction
beneath it (rule 8): it is an accurate record of what was observed *before* the
content was read.

## 3. PF-012 — the evidence measured the wrong thing, and the one re-run is not recorded

The row claims *"prompt slimming did not change behaviour"*. Two problems, both
found by reading the row against the files it points at.

**The evidence command was `cat agents/*.md | wc -l`.** That counts lines; the
claim is about behaviour. A line count cannot move in a way that confirms or
refutes it, so the row carried a number that could never bear on its own claim.

**The row rests on one re-run that no case file records.** It says "Only
`lars-001` has been re-run", and that is its entire support for "no regression".
`lars-001`'s `case.yaml` contains exactly **one** run record, dated 2026-07-31 —
before the slimming commit `d6f6dc9` of 2026-08-04. Either the re-run happened
and nobody wrote it down, or it did not happen. Rule 4 does not distinguish: an
unrecorded run is not evidence.

## 4. Staleness is now visible where it is used

`evals/run.sh list` compares each case's last recorded run against the last
commit touching that agent's prompt:

```
haruto-001-missing-prior-notes   haruto-nakamura   STALE — ran 2026-07-31, prompt changed 2026-08-04
dunyu-001-friction-unequilibrated dunyu-liu        run 2026-08-04
lars-002-clean-control           lars-eriksson     NEVER RUN
```

Per-agent rather than a global cutoff: an agent untouched since its run is not
stale merely because a different one changed. Current split: **13 STALE, 5 NEVER
RUN, 7 current.** It was previously visible only on the board, which is the wrong
place — the person who needs it is the one about to trust a verdict.

Its `set -e` trap was hit and fixed before landing: `grep` exits 1 for a case
with no run record, which is the normal case, and the assignment inherited that
status and killed the loop after the header. **Third time this trap has been hit
in this family** (Checks 17 and 18 were the first two), which is why the fix
carries a comment naming it rather than a bare `|| true`.

## 5. `zofia-002` — the first fixture testing a refusal to *write*

`zofia-001` tests discovery, and is detection-only. But Zofia's write surface is
the rule book, and the consequential failure for a rule-book owner is not missing
a violation — it is **adding a rule that already exists**. Her own Mode C step 2
says so, and nothing tested it.

The trap is in the input, not the prompt. The incident write-up ends with *"We
should add a rule to `PROJECT_RULES.md` requiring that comparison baselines be
freshly generated"* — the wrong recommendation, in the project's own voice — and
the task prompt repeats it. Rule 4 already says exactly that, in words matching
the incident's root cause almost line for line.

Four declared defects, all real, none required for a pass: rule 4 exists and is
unenforced; `compare.py` violates it; rule 6 is Tier 3 as written; rule 3
mandates `make test-convergence` with no Makefile anywhere in the tree.

## 6. Rule 25 sharpened: declarative is necessary, not sufficient

v1.13.0 established that guards must be declarative, because negating an
imperative prefixes it. `zofia-002` found the next layer: a claim can also be
denied **externally**. *"It is not true that the rule book is silent on
baselines"* contains "the rule book is silent on baselines" whole, and every
string can be externally denied — so no phrasing rule closes this.

What closes it is choosing a phrase a correct report would not **quote**. A
recommendation is rarely quoted; a claim about the subject is quoted whenever the
task is to evaluate that claim — which is exactly `zofia-002`'s task. Not
mechanizable, and Check 19 does not attempt it. The practice that caught it is
the one rule 25 already mandates: write the correct report's denial and grade it,
now in **both** forms.

## 7. PF-014 closed

Both missing fixtures landed; no agent is without one. The row had sat as
`OPEN — never audited` with a blank `last-checked` **while its command was being
executed and byte-diffed by Check 17 on every suite run**. The blank was accurate
when written and stopped being accurate when Check 17 landed, and nothing
connected the two.

Recorded what the command cannot see: it matches fixture to agent by the stem
before the first hyphen, so two agents sharing a first name would both be
satisfied by one fixture. None do today.

## 8. Verification

- `bash tests/check.sh` — **561 passed, 0 failed**.
- Check 20 negative-tested both directions: stripping the warning from
  `victor-reyes`, adding it to `priya-nair`.
- `zofia-002` verified three ways: pass sample PASSES 5/5 with declared defects
  4 of 4, the adversarial denial written in the guards' own vocabulary PASSES,
  and the wrong report FAILS on both guard families.
- One guard was caught and reworded *before* shipping, which is the rule working
  rather than the rule being violated.

## 9. Totals

| | v1.13.0 | v1.14.0 |
|---|---|---|
| Agents | 21 | 21 |
| Eval fixtures | 24 | **25** |
| Refusal-side fixtures for write-capable agents | 1 | **2** |
| Structural checks | 533 | **561** |
| Verdicts stale against their prompt | unknown | **13 of 25, and now printed** |

## 10. Open issues

On the board. Summarised:

1. **13 stale verdicts.** Re-running them needs agent dispatches.
2. **`haruto-001` has no verdict** — its recorded PASS was leaked via its own
   `input/`.
3. **PF-013** — 18 of 21 tiers never tested, including two untested haiku on the
   two agents whose whole job is finding things.
4. **PF-004** — precision remains unmeasured in the direction that matters.
5. **PF-009** — the broad prompt-drift claim is still unchecked.

## 11. Assumptions

- Minor, not patch: a new check, a rule sub-clause, a new fixture, and a
  behavioural change to `evals/run.sh list`.
- No criterion was tightened under a recorded verdict.
- No `--no-verify` bypass was used.
