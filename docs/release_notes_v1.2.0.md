# Release notes — v1.2.0

**Date:** 2026-07-31
**Previous:** v1.1.0 (archived to `docs/`)
**Bump:** minor — one agent, one command, one gate check added

## 1. Summary of scope

Closes three of the open issues v1.1.0 shipped with. The team gains its first
implementation role, the duplicate installer is gone, and two rules that were
unenforceable when the rule book was written are now mechanical gates.

The through-line: v1.1.0 wrote down rules it could not check. v1.2.0 makes two
of them checkable and proves the checks fail when they should.

## 2. Files added

| File | What |
|---|---|
| `agents/dunyu-liu.md` | Senior computational researcher. Owns research-heavy work with **no reference implementation** — where there is no parity gate and measurement carries the burden of proof. Frames the question before coding, states a kill criterion, spikes cheaply, lands narrow, reports what failed. Carries numerical discipline (units, conservation, convergence), surrogate-validation standards (generalization axes declared before training; no test-set checkpoint selection), and HPC provenance rules. |
| `commands/implement.md` | `/implement <feature>` builds; `/implement spike <question>` is feasibility only. |
| `evals/cases/mira-001-library-substitution/` | Fixture: `scipy.gaussian_filter` substituted for a custom truncated circular kernel, and `CubicSpline` for a local Catmull-Rom convolution, behind a docstring claiming parity verified on a 64×64 synthetic grid. |

## 3. Files removed

| File | Why |
|---|---|
| `scripts/install.sh` | Duplicate installer (rule 14). Its safety checks were merged into root `install.sh`; the directory is now empty and gone. |

## 4. Content updates

- **`install.sh`** — now the single canonical installer. Merges the post-merge
  hook and broken-symlink pruning with the former `scripts/` version's safety
  behaviour: `--force`, refusal to clobber foreign symlinks or real files, and
  a skip count on stderr. Additionally wires a **pre-push hook** running
  `tests/check.sh`.
- **`tests/check.sh`** — new **Check 6**: every agent appears exactly once in
  the README model table, under the model its own frontmatter declares, and no
  table row names a non-existent agent. Suite grows 79 → 119 checks.
- **`agents/mira-volkov.md`** — scope broadened from C/Fortran→Python to **any
  source language to any target**, with bit-identical parity promoted from a
  quality bar to the defining gate ("the language pair is not what defines you
  — the parity gate is"). Adds a mandatory isolation section (own worktree,
  never the root or main checkout, no write-through into golden dirs,
  parallel-sibling rules) and a checkpointed parity method: pin the contract,
  instrument both sides, dump the full function space, binary-search to the
  first divergence, optimize only after. Greenfield requests now route to
  `dunyu-liu` rather than being quietly accepted.
- **`PROJECT_RULES.md`** — rules 9 and 12 updated from "unenforceable /
  proposed upgrade" to mechanical, each recording the incident that motivated
  it and what remains unchecked.
- **`README.md`** — specialist count 19 → 20; the stale "Three engineers" line
  corrected to seven and enumerated; roster, model table, commands table,
  Layout tree, eval coverage, and the Install section (both hooks) updated.

## 5. Audit findings and fixes

Carried forward from `zofia-kaminska`'s v1.1.0 audit.

| # | Rule | Finding | Status |
|---|---|---|---|
| V4 | 14 | Two divergent installers; README pointed at the one without the post-merge hook, making its "git pull updates every machine" claim false | **fixed** |
| V6 | 13 | 15 of 19 agents had no eval fixture | **partly fixed** — `mira-001` added for the most-dispatched agent; 15 of 20 still uncovered |
| — | 9 | "Run the check before pushing" was unverifiable after the fact | **fixed** — pre-push hook |
| — | 12 | Check 4 passed on a *mention*, so an agent could be missing from the model table with the gate green | **fixed** — Check 6 |

**New finding, not fixed:** Check 5 treats any backticked one-hyphen term as
an agent reference. It false-positived twice this session — on `enforce-rules`
and `pre-push` — each time blocking on prose that was correct. It catches real
stale references, so it stays, but the heuristic needs narrowing.

## 6. Verification

- `bash tests/check.sh` — **119 passed, 0 failed** on the final tree.
- Check 6 **negative-tested** before landing: removing an agent from the model
  table produces `missing from the README model table`; listing an agent under
  the wrong model produces both a duplicate error and a model-mismatch error.
  A check that has never failed is not known to be a gate.
- `install.sh` run twice — idempotent, 20 agents / 18 commands both times.
- pre-push hook executed directly; exits 0 on the green tree.
- Fixture validated: the Python port parses, the C reference compiles clean
  under `gcc -fsyntax-only`.

## 7. Totals

| | v1.1.0 | v1.2.0 |
|---|---|---|
| Agents | 19 | 20 |
| Commands | 17 | 18 |
| Eval fixtures | 4 | 5 |
| Structural checks | 75 | 119 |
| Installers | 2 | 1 |
| Rules mechanically enforced | 3 | 5 |

## 8. Open issues

1. **V6 — eval coverage.** 15 of 20 agents uncovered.
2. **Rule 5 still partly unenforceable.** Fixture grading is by eye; a runner
   needs to invoke agents, which costs tokens and cannot run in free CI.
3. **Rule 12 partly covered.** The roster-table row and Layout-tree line are
   still unchecked — an agent in the model table but missing from its team
   roster passes.
4. **Check 5 heuristic** — see §5.
5. **Concurrent writers.** v1.1.0 was cut while an earlier release agent was
   still running; both wrote tags. No lock exists to prevent a repeat.

## 9. Assumptions

- Minor, not patch: a new agent, a new command, and a new gate check are new
  functionality.
- Release note describes the post-audit filesystem, not the raw git diff.
- No `--no-verify` bypass was used for this release.
