# Release notes — v1.10.0

**Date:** 2026-07-31
**Previous:** v1.9.0 (archived to `docs/`)
**Bump:** minor — the eval runner lands, and rule 5 becomes partly mechanical

## 1. Summary of scope

`evals/run.sh` — stage and grade. The suite has had fixtures since v1.0 and a
grading criterion written in prose since then; this is the first time that
criterion is applied by a machine instead of by whoever happens to be reading.

The runner exists because of **isolation**, not grading. That reordering came
out of v1.9.0 and is the whole justification.

## 2. What it does, and what it deliberately does not

```bash
bash evals/run.sh list                         # every case, and whether it has ever run
bash evals/run.sh stage <case>                 # isolate input/, print the prompt + agent
bash evals/run.sh grade <case> <report.md>     # apply the criterion, mechanically
```

**`stage` is the load-bearing half.** It copies `input/` to
`$TMPDIR/consilium-evals/<case>/` — outside the repo, with no `case.yaml` and
no case `README.md` reachable from it — then prints the case's own prompt with
the isolation clause appended, and the agent to send it to.

Two failure modes had occurred that no wording in a brief could prevent:

- **Answer-key leakage** (`haruto-001`, v1.5.0) — the answer key sits one
  directory above `input/`; an agent read it, and nothing in the output looked
  wrong.
- **Read-only violation** (`victor-001`, v1.9.0) — a specialist imported a
  fixture module and wrote `__pycache__/` into `input/`.

Both are closed structurally by handing over a copy. Read-only-by-instruction
is an honour system, and an honour system is not a gate.

**`grade` applies `evals/README.md`'s criterion exactly**: every `expected`
entry matched, no `must_not_find` matched, no partial credit — because
inventing a second criterion inside the grader would be a rule-5 violation by
the grader itself. It also **voids** any report referencing `case.yaml`,
`must_not_find`, or "planted defect": a leaked run has no verdict.

**What it does not do: invoke the agent.** That needs API access and tokens,
so it cannot run in free CI. A gate that cannot run is worse than no gate, and
automating the half that works is more honest than faking the half that
doesn't.

## 3. Negative-tested, three ways

Per rule 0 — a grader that has only ever passed is not known to be a gate:

| Report | Expected | Got |
|---|---|---|
| finds `compute_returns.py:19` + `fillna(0)` | PASS | PASS — 3 criteria, 0 failed, exit 0 |
| "looks broadly fine, add type hints" | FAIL | FAIL — 2 of 3 failed, exit 1 |
| "per case.yaml the planted defect is at line 19" | VOID | VOID, exit 1 |

Staging verified across four cases: each staged tree contains only the input
files, and the parent directory holds no answer key.

## 4. Precision — the criterion we still do not have

`must_not_find` guards phrasings. It cannot see that a report found the
planted defect **and four things that are not there**. A run at 25% signal
scores identically to a clean one — and one did: `sophia-001` reported one
true finding beside three unactionable ones at equal severity, and the fixture
reported green.

Building the runner made the mechanism visible, and it falls out of something
this project was already forced into. Four fixtures shipped with undeclared
real defects, and the fix each time was to **declare the complete defect set**
rather than delete what the agent found. Once a case declares everything real
in its input, precision becomes measurable:

- report findings that map to a declared defect → true positives
- findings that map to nothing → either a **new real defect** (declare it; the
  fixture was incomplete) or a **false positive** (the run was noisy)

That disjunction is the difficulty, and it is not automatable — choosing the
branch is exactly the judgement a human or an evaluator agent must make. What
*is* automatable is surfacing the ratio and refusing to pass while it is
unexamined.

Proposed in `evals/README.md`, **not implemented**: a `declared_defects:` key,
a `N findings / M declared` line in `grade`, and **INCONCLUSIVE** rather than
PASS for any run with unmapped findings. The grader would not judge precision;
it would decline to certify a run whose precision is unknown. Today's `grade`
output already says so in plain text rather than implying a clean bill.

## 5. Rule 5 status

Upgraded from "partly unenforceable" to **partly mechanical**. The structural
half (`check.sh` exit 0) was always mechanical; the eval half is now applied
by `run.sh grade` rather than by eye. What remains manual is agent invocation
and the precision judgement — both stated plainly in the rule rather than
implied to be covered.

## 6. Verification

- `bash tests/check.sh` — **292 passed, 0 failed**.
- `run.sh grade` negative-tested on pass / fail / leaked reports (§3).
- `run.sh stage` verified to exclude `case.yaml` and `__pycache__`, on
  `lars-001`, `mira-001`, `jordan-001`, `victor-001`.
- `run.sh list` reports all 13 cases with their run records.
- Cut holding the lock.

## 7. Totals

| | v1.9.0 | v1.10.0 |
|---|---|---|
| Eval fixtures | 13 | 13 |
| Agents covered | 14 of 20 | 14 of 20 |
| Structural checks | 292 | 292 |
| Rules mechanically enforced | 6 | **7** |

## 8. Open issues

1. **6 agents uncovered** — `selin-001` and `anya-001` are authoring now.
2. **Precision unmeasured** — mechanism proposed, not built (§4).
3. **Agent invocation still manual** — and will stay so until someone accepts
   the token cost of an API-driven suite.
4. **A fixture author cannot certify their own input clean.** Four cases
   proved it; `victor-001`'s adversarial self-pass helped but is not a
   substitute for a run.

## 9. Assumptions

- Minor, not patch: a new tool and a rule-tier upgrade.
- Release note describes the post-audit filesystem, not the raw git diff.
- No `--no-verify` bypass was used.
