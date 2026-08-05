# Release notes — v1.15.0

**Date:** 2026-08-05
**Previous:** v1.14.0 (archived to `docs/`)
**Bump:** minor — a red CI fixed, a grader defect fixed, a third refusal
fixture, and rule 25 sharpened twice more

## 1. Summary of scope

Five commits. The finding that matters most was not found by anything in this
repository: **CI had been red for eleven commits and no row, check or command
here knew.** The maintainer noticed it on the remote.

The rest of the release is the same theme the last two have been — machinery
that punished a correct answer — found this time in the grader itself and in two
more guard families.

## 2. CI was red since Check 17, and this repository could not see it

`actions/checkout@v4` defaults to a depth-1 checkout with no tags. Check 17
executes the board's evidence commands and byte-diffs their output, and two of
them read git history:

```
PF-005  git show --stat v1.10.0 --name-only | grep -c anya-001
        → "unknown revision" — the tag was never fetched
PF-012  bash evals/run.sh list | grep -c STALE
        → 20 instead of 13
```

The second is the subtler one: on a single-commit clone `git log -1 --
agents/X.md` returns the tip commit for **every** file, so every agent appears
to have changed today and every case reads stale.

**Check 17 made the gate environment-dependent and nothing in its design
acknowledged that.** Checks 1–16 inspect files and answer the same anywhere; the
moment the suite began *executing* commands, where it ran started to matter.
That defect landed in `015485b` and survived eleven commits, every one of them
reporting a green local suite.

Fixed at both ends. The workflow checks out full history and tags, so CI runs
what a developer runs. And Check 17 detects a shallow repository and skips
history-dependent evidence **by name** — `shallow clone, history-dependent
evidence not re-run: PF-005` — rather than diffing garbage or passing silently.
An exemption that leaves no trace is indistinguishable from a check that passed,
which is why the self-referential rows are named too.

Verified in both environments: a full clone runs everything; a
`--depth 1 --no-tags` clone also reports 570 passed, naming the two it skipped.

**PF-016** now tracks the CI surface, with its limit stated: it verifies that
the workflow *asks for* full history. It cannot tell you whether the last run
was green — that lives on GitHub and this repository has no credentials to ask.

## 3. The leakage detector voided correct reports

`grade` voids any report containing `case.yaml`, `must_not_find` or "planted
defect", because a run that saw the answer key has no verdict (rule 5).

`nadia-002` reviews an agent run *against its criteria file*, so its input
legitimately contains `must_not_find`. A correct report naming the section by its
real name was being VOIDed — for speaking about the thing it was asked to review.
Same shape as the imperative guards, this time in the tool that judges them.

The detector now drops a term that appears in the case's own `input/`, which
proves nothing, and keeps the rest. **Rule 5 is unweakened and was re-verified**:
appending "The planted defect is on line 19" to `lars-001`'s pass sample still
VOIDs, because that term is not in `lars-001`'s input.

## 4. `nadia-002` — the refusal set is complete

Three write-capable agents, three ways of being irreversibly wrong, one refusal
control each:

| fixture | the refusal |
|---|---|
| `anya-002` | refuses to block a clean repository |
| `zofia-002` | refuses to write a rule that already exists |
| `nadia-002` | refuses to recommend a change when the agent was right |

Nadia's output *is* a list of prompt edits, so recommending one when the agent
was right is her whole failure mode, and `nadia-001` tested only detection.

The situation is this repository's own history rather than an invention: the
agent under review correctly declines an unverifiable pin, exactly as its
contract mandates, and the criterion it was graded against guards on the
imperative `"pin the transitive dependency"` — so the correct refusal contains
the guard and fires it. Thirty-one guards of that shape were fixed here on the
same day; this case points the lesson back at the agent whose job is to tell an
agent defect from a criterion defect.

## 5. Rule 25, sharpened twice more — three layers now

| layer | fails because | paid for by |
|---|---|---|
| imperative | `do not X` contains `X` | `anya-002`, then 31 guards |
| declarative claim | *"it is not true that X"* contains `X` | `zofia-002` |
| first-person claim | same external denial | `nadia-002` |
| **verdict line** | a report states its own verdict, never quotes the opposite | — |

`"verdict: agent defect"` survives because a correct report has no reason to
write it at all. Only the first layer is mechanizable (Check 19); the rest is
the practice rule 25 mandates — write the correct report's denial, in **both**
infixed and external forms, and grade it before shipping.

## 6. Runs recorded in prose are not runs

Asked whether any of the 13 stale verdicts could be cleared without a re-run.
None can: all twelve agent files changed in the same two commits, and the
tool-economy section instructs the agent how much evidence to gather — an agent
that gathers less can find less. Not cosmetic.

The sharper finding: **three post-change runs are claimed with specific numbers
and none is in the case's own run log.**

```
ziyan-001  "sonnet→haiku, PASS 5/5, 11.9k vs 14.4k"   release note v1.11.0
mira-001   "PASS 5/5 at 27k vs 34.7k, 4 calls vs 12"  PF-013
lars-001   "has been re-run (PASS)"                    PF-012
```

`evals/run.sh list` reads the case's run log, because that is where rule 4 points
and the only place a verdict sits beside the criteria it was graded against.
**Deliberately not transcribed** — copying a claim you did not verify into the
place the tooling trusts is manufacturing evidence, whatever its source. They
stay STALE. Rule 25 gained the upstream fix: a run's record lives in the case, at
the time of the run.

## 7. Smoke keeps a fixed membership and prints its baselines

Considered selecting smoke by staleness so the cheapest re-run targets the
verdicts that no longer describe the current prompts. Decided against, and the
reasoning now sits beside the code: a tier whose membership moves with history
cannot be compared across edits, and staleness grows — thirteen cases is not a
fast tier.

What smoke does owe its user is the state of its own baselines, and printing them
paid off at once: **five of the seven smoke members have no verdict against the
current prompt** — three STALE, two NEVER RUN. The tier the project trusts most
is the tier whose baselines are least current.

## 8. Verification

- `bash tests/check.sh` — **570 passed, 0 failed**, on both a full clone and a
  `--depth 1 --no-tags` clone.
- `nadia-002` verified three ways: pass sample PASSES 5/5, the adversarial denial
  in both infixed and external forms PASSES, the wrong report FAILS on both
  guard families.
- Rule 5's leakage void re-verified against a term absent from the case's input.
- Two guards in `nadia-002` were caught and reworded *before* shipping, which is
  the rule working rather than being violated.

## 9. Totals

| | v1.14.0 | v1.15.0 |
|---|---|---|
| Agents | 21 | 21 |
| Eval fixtures | 25 | **26** |
| Refusal fixtures for write-capable agents | 2 | **3** |
| Structural checks | 561 | **570** |
| Board rows | 15 | **16** |

## 10. Open issues

1. **CI status is unobservable from here.** PF-016 checks the workflow's input,
   not its result. Watching actual run status needs `gh` installed and
   authenticated.
2. **13 stale verdicts**, refreshable only by agent dispatches.
3. **`haruto-001` has no verdict** — its recorded PASS was leaked via its own
   `input/`.
4. **PF-013** — 18 of 21 tiers never tested, two of them the cheapest tier on
   the two agents whose whole job is finding things.
5. **PF-004** — precision unmeasured in the direction that matters.

## 11. Assumptions

- Minor, not patch: behavioural changes to `tests/check.sh`, `evals/run.sh` and
  the CI workflow, plus a new fixture and a new board row.
- No criterion was tightened under a recorded verdict.
- No `--no-verify` bypass was used.
