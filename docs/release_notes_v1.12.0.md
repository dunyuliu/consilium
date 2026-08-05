# Release notes — v1.12.0

**Date:** 2026-08-05
**Previous:** v1.11.0 (archived to `docs/`)
**Bump:** minor — two checks, two rule sub-clauses, a staging bug fixed, and the
first complete audit of the fixture corpus

## 1. Summary of scope

Nine commits, and one finding that reframes the rest: **every fixture input in
the suite has now been read end to end, and nine of them were wrong.** Not the
agents — the fixtures. This release is mostly the machinery that found them and
the rules that stop them recurring.

The single sharpest item: `haruto-001` — the fixture whose 2026-07-31 answer-key
leak is the entire reason `evals/run.sh stage` exists — had been shipping the
answer key **inside its own `input/`** the whole time.

## 2. `haruto-001` — the anti-leak mechanism could not see this leak

`input/README.md` read, in full sight of every run:

> `release_notes_v0.2.0.md` is **deliberately absent** — v0.2.0 was tagged in
> git history but never got a notes file. This is the planted defect the agent
> is supposed to surface.

`evals/run.sh stage` isolates `input/` **from** the answer key. It copies
`input/` verbatim, by definition. It cannot help when the key is *in* it.

The case's second run is recorded as *"scoped to `input/`, PASS"*. **Scoping to
`input/` was the fix; the answer key was in `input/`.** Rule 5 voids that run —
its central finding is the one sentence its own input handed it. Its reasoning
beyond the key (the Rule #2 archival analysis, concluding no archival was due)
was not available from that README, so the run was not merely parroting. That is
a mitigation, not a verdict. A third run is required.

Sharper still: `evals/run.sh grade` voids any report containing "planted
defect". **An agent that faithfully quoted this fixture's own input would have
been voided for reading what it was given.**

The correction is appended to the case, not written over it (rule 8).

## 3. Two checks

**Check 17 — the board's evidence is executed, not merely cited.** Every fenced
command in `PATHWAY_FORWARD.md` runs on every suite pass and its output is
byte-diffed against the recorded `# →` lines. Check 12 verifies a `VERIFIED`
claim *cites* a command; nothing verified the command still said so.

This is rule 21a, attempted in v1.11.0 and reverted for blocking the suite. The
first diagnosis was wrong in its most important part. The awk parser was a real
obstacle but not the fatal one: `check.sh` runs under `set -euo pipefail`, and
the first evidence command to exit non-zero — a `grep -c` that finds nothing is
routine — killed the run before the `Summary` line. Evidence commands now run
with errexit suspended, because **the contract is what a command prints, not
whether it succeeded.**

It reddened on landing, which is the point. Five of thirteen rows had drifted,
including two whose recorded "literal stdout" was only the first line of a
multi-line output — so the precondition claimed in the v1.11.0 note had already
lapsed when that note was written. `PF-007` then drifted *again during the same
change*, 16 → 17, because adding Check 17 changed the number of checks.

**Check 18 — no fixture input contains fixture-authoring language.** Its own
`set -e` trap was hit and fixed before landing: `grep -rIl` exits 1 when it finds
nothing, which is the normal case, and the assignment inherited that status. The
same failure that blocked Check 17's first attempt, caught in one run this time.

Two phrases were tried and **removed**: `must_not_find` and `case.yaml`.
`lian-001` is a fixture *about* fixtures and legitimately ships a mock one. A
check that fails on correct content is an obstacle, not a gate.

## 4. That false positive found a real bug

Staging ran `find "$dest" -name 'case.yaml' -exec rm -rf`, unbounded by depth —
so it **deleted `lian-001`'s mock `evals/cases/tam-001/case.yaml`**, silently
handing the agent a different scenario than the author wrote, and one that
happens to be exactly the *"no fixture exists"* condition the case turns on.

The real answer key lives in the *parent* of `input/` and is never copied there,
so the deletion was belt-and-braces at depth 1 and destructive below it. Now
`-maxdepth 1`.

## 5. PF-011 — nine real fixture defects, none in an agent

| case | defect |
|---|---|
| `haruto-001` | answer key inside `input/`, surviving the anti-leak mechanism |
| `ziyan-001` | `must_not_find` forbade the case's own declared defect |
| `lars-002` | `"fillna"` guard fails a correct negation — in the precision fixture |
| `dunyu-001` | `"friction law"` / `"slipping"` guards fail a correct deferral |
| `sophia-002` | notes described code that is not there, load-bearingly |
| `jordan-001` | undeclared unsigned-notional rollup — "exposure" summed gross |
| `mira-001` | undeclared silent square-grid reshape |
| `lars-001` | undeclared formula/docstring inconsistency |
| `kai-001` | stale prose line number (+ `lars-001` ×3, `rafael-001` ×1) |

Three deserve their detail:

- **`ziyan-001` forbade its own right answer.** Its declared defect 4 is
  *"`manuscript.tex:34` uses et al. for a two-author paper"* — and its guard was
  the bare token `"Williams"`. No correct report could pass. `samples/pass.md`
  contains zero mentions of Williams and could not have reported it. This is the
  exact error described in the comment on the *very next* guard entry, fixed
  there and missed one line above.
- **`sophia-002` described code that is not there.** Its notes and its guard
  comment both said `worker.py:20-21` reads two keys "via bare `cfg[...]`
  subscripts with no fallback of any kind anywhere in the file", and gave that
  absence as the reason those keys are out of scope. The code reads
  `cfg.get("queue_name", "default")`. The verdict survives — the fallback agrees
  with the documented default — but an agent applying the very rule this fixture
  exists to lock would have found the fallback the fixture called absent.
- **`jordan-001`** loads `side` on line 18 to fix its dtype and never uses it
  again. Every sector's "exposure" is reported with the wrong sign and 3.5×–7×
  the net magnitude: 1,607,795 against a net of −230,785.

Cleared clean: `kai-001`, `ingrid-001`, `rafael-001`, `priya-001`, `iris-001`,
`sophia-001`, `dunyu-001`. `dunyu-001`'s declared corrections were re-verified
rather than trusted — the residual history is exactly `0.5ⁿ`, and the
*unconstrained* stiffness matrix has 0 zero eigenvalues where 3 rigid-body modes
are required. (The first attempt at that test applied boundary conditions first
and proved nothing.)

## 6. Rules, grown by sub-clause

**Rule 5a — the answer key is never inside `input/`** (mechanical, Check 18).
Rule 5 had asserted that `case.yaml` and the case README "sit one directory
above `input/`" — the exact assumption `haruto-001` falsified. Now qualified,
carrying the incident. The rule states plainly what Check 18 cannot do: a leak
written in the project's own voice reads as ordinary code and passes.

**Rule 25 — before shipping a guard, write the correct report's negation and
grade it.** A `must_not_find` entry must be a phrase only a *wrong* answer
produces; a bare noun never is, because the right answer's denial contains it.
Four instances, every one demonstrated by execution rather than argued.

The rule also records that this is **not mechanizable**, and why, so the work is
not repeated. Three candidate checks were built and measured across all 23 cases:

| candidate | why it was rejected |
|---|---|
| term also appears in the case's own notes | flags 8, misses three known-bad, most hits legitimate |
| term must be ≥ 3 words | false-positives every good short verdict (`"parity holds"`) |
| term must contain a verb | correct in principle, not detectable in bash |

Shipping any of them would have caught part of the class while reading as a
gate, which is worse than none (rule 2).

## 7. PF-010 — the clean-clone install, executed at last

Every install to date had been a re-run on the authoring machine, where the
symlinks and hooks already existed. The path a new user takes had never run.

`git clone` to a scratch directory, then `install.sh` under a sandboxed `HOME` —
the installer hardcodes `CLAUDE=${HOME}/.claude` with no override, so that is the
only way to exercise the real code path without touching the real one.

| | |
|---|---|
| gate on the fresh clone | 502 passed, 0 failed |
| first install | 21 agents, 18 commands |
| second install | identical — idempotent |
| broken symlinks | 0 |
| hooks written | `post-merge`, `pre-commit`, `pre-push` |
| hooks carrying the `v3` marker | 3 of 3 |

Both `pre-commit` guards were fired deliberately rather than assumed: a commit by
a foreign `CONSILIUM_LOCK_OWNER` was refused, and a commit by the holder staging
outside the declared scope was refused.

Checked and **not** a defect: with no lock present the hook exits 0 and the
commit proceeds. That is `[ -f "$LOCK" ] || exit 0` working as written — rule 18
governs concurrent writers, not every commit.

## 8. Verification

- `bash tests/check.sh` — **503 passed, 0 failed**.
- Check 17 negative-tested three ways: a non-zero-exit command still reaches
  `Summary` (the exact attempt-1 regression), a two-line command fails, an empty
  parse fails.
- Check 18 negative-tested by reintroducing a leak phrase into
  `iris-001/input/index.md`.
- Every fixture correction demonstrated in both directions — the corrected report
  passes *and* the wrong-direction report still fails — so no guard was gutted
  while being loosened.
- The machinery caught its author four times this cycle: Check 17 flagged
  `PF-007` twice, Check 18's own `set -e` trap blocked the suite once before
  landing, and Check 18's first phrase list produced a false positive that had to
  be retracted.

## 9. Totals

| | v1.11.0 | v1.12.0 |
|---|---|---|
| Agents | 21 | 21 |
| Eval fixtures | 20 | **23** |
| Fixture inputs fully audited | 0 | **23 of 23** |
| Structural checks | 369 | **503** |
| Rules | 25 | 25 (+2 sub-clauses) |

## 10. Open issues

Tracked on the board (`PATHWAY_FORWARD.md`), not here — that is the point of
keeping the two separate. Summarised:

1. **`haruto-001` has no verdict** until a third run against the de-leaked input.
2. **PF-005** — v1.10.0's tag still carries six files its note does not mention.
3. **PF-004** — `declared_defects:` precision measurement still unbuilt; grading
   remains necessary and not sufficient.
4. **PF-009** — agent prompts have never been audited as a set.
5. **Refusal coverage** — several agents have one fixture that tests detection
   only, with nothing testing that they decline correctly.

## 11. Assumptions

- Minor, not patch: two new checks, two rule sub-clauses, and a behavioural fix
  to `evals/run.sh` staging.
- Loosening a `must_not_find` guard preserves earlier verdicts; every fixture
  correction in this release was a loosening or a note change, never a tightening.
- No `--no-verify` bypass was used.
