# Release notes — v1.11.0

**Date:** 2026-08-04
**Previous:** v1.10.0 (archived to `docs/`)
**Bump:** minor — a new agent, a living inspection log, six fixtures, four rules

## 1. Summary of scope

Eight commits. The repo gained the thing it had been missing since v1.0: an
artifact that says what is true **now**, with the date it was last checked and
the command that checked it.

The finding that dominates this release is not any single defect. It is that
**the agent under test was right and the fixture author was wrong nine times**,
across five different authors including me. That inverts how a failing case
should be read: it is a hypothesis about who erred, not a verdict on the agent.

## 2. `PATHWAY_FORWARD.md` — the inspection log

One row per surface of the repo, with the date it was last audited and the
command whose output was read. Release notes are append-only history (rule 8)
and go stale by design; this is the present tense.

- **A blank `last-checked` means never audited** and stays blank. Three rows
  ship blank: checks 1–5 never negative-tested, agent prompts never audited as
  a set, clean-clone install never executed. Check 12 reports blanks without
  failing, so an unaudited surface stays visible instead of being absorbed.
- Commands live in the item blocks, not the table — a markdown cell truncates
  at the first `|`, and a truncated command still looks like evidence.
- Every `# →` line is now the command's **literal stdout**, which is the
  precondition for mechanically diffing it later.

**Rule 21** is the standing half of rule 4: fresh runs are evidence, but rule 4
is applied when you write and never again.

**Check 12** enforces the shape and states plainly what it cannot do — it
verifies a `VERIFIED` claim *cites* a command, not that the recorded output is
still true. Four rows drifted within one day of landing, all carrying that
day's date, proving they were bumped without being re-run. `zofia-kaminska`
proposed rule 21a to close it; it is Proposed, not built.

## 3. PF-001 — the four-day-old false claim, closed

The v1.7.0 release note stated rule 18 became mechanical via `tests/lock.sh`
and a versioned `pre-commit` hook installed by `install.sh`.

```
git log --oneline -S 'PRECOMMIT' -- install.sh   →  0 commits
```

The hook existed only in the authoring machine's untracked `.git/hooks/`.
Every clone got the lock script and **no gate**. The *effect* had been verified
once — a marker present, a second writer's commit observed being blocked — and
the *source being committed* never was.

Now committed. All three hooks carry `consilium-hook-v3`, appended after
writing rather than typed into a quoted heredoc, because the first attempt kept
a literal stamp and a version variable in sync by hand and they drifted.

First board row to go **BROKEN → VERIFIED by being fixed** rather than
re-described.

## 4. `lian-zhao` (赵莲) — agent-refinement engineer

Owns `agents/*.md`, the surface rule 19 had never assigned — which is why the
prompts accreted with nobody accountable. Check 10 rejected her as an unscoped
writer until the row existed.

Two co-equal goals, verified in **opposite directions**:

| | cost change | performance change |
|---|---|---|
| fixture must | still pass | **fail first**, then pass |
| evidence | same verdict, fewer tokens | a case that failed before and passes now |
| failure mode | a saving that quietly loses a finding | a fix that overcorrects into blindness |

Three cardinal rules carry the session's sharpest lessons: *a saving with a
failing fixture is a regression you got paid for*; *never grade your own work —
an optimizer that scores its own optimizations will find that they all worked*;
and the tier dividing line is not difficulty but **whether the job requires
refusing the source's framing**.

## 5. Cost work — measured, not guessed

- **Rule 23 + Check 14**: every agent declares tool economy. Cost grows with the
  **square** of tool calls, not prompt size. Measured: <7 calls ≈ 19k tokens,
  >10 ≈ 75k, against ~2k to read a file directly.
- **Two tier drops**, each verified by the agent's own fixture via `model`
  override so nothing committed on a guess: `ziyan-chen` sonnet→haiku (PASS 5/5,
  11.9k vs 14.4k, and *more* precise), `selin-aydin` opus→sonnet (PASS 9/9,
  derived Λ₀ = 318 m from parameters scattered across three sections).
- **`priya-nair` sonnet→haiku FAILED and was kept.** It marked the 9.7% CAGR
  correct by recomputing with the document's own formula — the planted trap.
  That sentence is worth more than the saving.
- **Prompt slimming** 4,564 → 4,279 lines. The first pass over-cut and deleted
  agent-specific tails; caught on the diff and redone preserving eight.
  `mira-volkov`'s 88-line recipe book became 11 lines of principle; `mira-001`
  PASS after, 27k vs 34.7k tokens.

## 6. Fixtures — 14 → 20 cases, 18 of 21 agents

New: `lars-002` (clean control), `lian-001`, `selin-001`, `anya-001`,
`zofia-001`, `dunyu-001`, `nadia-001`. **Smoke tier** added:
`bash evals/run.sh smoke` lists four fast cases to run after any prompt edit.

The most interesting are the ones testing a **refusal** rather than a detection:

- **`lars-002`** — the suite's first precision measurement. Its bar had to be
  rewritten after two runs: "zero findings" measures an auditor's *appetite*,
  not its precision. Lars found real NaN propagation (mine), then found that my
  fix introduced an absolute `_STD_FLOOR` rejecting legitimate small-scale data
  (also mine). Both correct. The bar is now **no CRITICAL finding and no
  finding that is factually false** — precision is the absence of invented
  defects, not silence.
- **`nadia-001`** — PASS 5/5, the strongest run of the session. Diagnosed a miss
  to `:47-49` and named the mechanism: the agent generalised a *ranking* rule
  into a *reporting* ban. *"The agent honoured its contract item-for-item and
  still did not answer the question. That makes this a prompt defect, not an
  agent defect."* Her fix scoped the rule rather than raising the threshold,
  which would have deleted the entire true positive.
- **`dunyu-001`** — PASS, and it **demolished its own fixture's premise**. The
  planted "3.12% imbalance from a loose tolerance" is an artifact: `u += 0.5*du`
  on a linear problem gives `R_n = 0.5ⁿ·f_ext`, and `0.5⁵ = 3.125%` —
  the headline number to three digits, independent of mesh and physics. He then
  found three unplanted showstoppers, including a stiffness matrix with **zero
  rigid-body modes** where three are required.

## 7. Rules and checks added

| # | Rule | Enforced by |
|---|---|---|
| 21 | Standing claims are re-checked on a schedule and cite a command | Check 12 |
| 22 | Every agent declares communication discipline | Check 13 |
| 23 | Every agent declares tool economy | Check 14 |
| 24 | Never audit a moving target; brief with ranges, not whole files | judgment |

Rule 24 records the ~20% of the day's subagent tokens that produced nothing
durable — every instance an orchestration error, not an agent failing: an
auditor dispatched at a directory being written, a fixture shipped without its
adversarial pass, briefs naming whole files re-billed on every call.

Checks 11 → 14. Suite 292 → 369.

## 8. Verification

- `bash tests/check.sh` — **369 passed, 0 failed**.
- Check 12 negative-tested 11 ways plus a boundary test proving no off-by-one.
- Checks 13 and 14 negative-tested by stripping a section from one agent.
- The machinery caught its author four times this cycle: Check 12 blocked a
  table/block mismatch, Check 11 caught an isolation-ordering violation, the
  pre-push hook aborted a bad push, and the lock's scope guard refused a commit
  staging a file outside its declared scope.
- Every fixture claim re-derived independently before landing.

## 9. Totals

| | v1.10.0 | v1.11.0 |
|---|---|---|
| Agents | 20 | **21** |
| Eval fixtures | 14 | **20** |
| Agents covered | 14 | **18 of 21** |
| Fixtures executed | 13 | **18** |
| Structural checks | 292 | **369** |
| Rules | 20 | **25** |
| Agent prompt lines | 4,564 | 4,279 (+`lian-zhao`) |

## 10. Open issues

Tracked on the board, not here — that is the point of §2. Summarised:

1. **PF-005** — v1.10.0's tag still carries six files its note does not mention.
2. **PF-008/009/010 never audited** — checks 1–5 never negative-tested, agent
   prompts never audited as a set, clean-clone install never executed.
3. **PF-011** — nine fixtures predate the adversarial-self-pass rule.
4. **Three agents uncovered** — `wei-lin`, `elena-hartmann`, `marco-bianchi`.
5. **Rule 21a Proposed** — executing evidence commands and byte-diffing them.
   The board's `# →` lines are now literal stdout, which was its precondition.
6. **`lian-zhao` has a fixture but has never run against it** under her own
   name — `lian-001` was executed through a stand-in.

## 11. Assumptions

- Minor, not patch: a new agent, four rules, three checks, six fixtures.
- Release note describes the post-audit filesystem, not the raw git diff.
- No `--no-verify` bypass was used.
