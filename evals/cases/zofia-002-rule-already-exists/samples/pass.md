# Codification review — stale baseline, 2026-07-28

**No new rule. Rule 4 already covers this incident, and it is unenforced.**

## The rule exists

`PROJECT_RULES.md:22` — *"A comparison baseline is regenerated in the same run
that uses it. Never read a stored artifact as the oracle for a comparison."*

The incident's own root cause is *"compare.py treats a stored artifact as the
oracle"*. That is the rule, restated. The incident is not an uncovered case; it
is a violation of a binding rule that nothing was checking. Adding a seventh
rule saying the same thing would leave the project with two rules and still no
check, which is how a rule book stops being read.

The incident write-up recommends adding a rule. That recommendation is what I am
declining; the analysis above it is sound.

## What is actually missing

`tests/check.sh` mechanises rule 1 (Makefile targets) and rule 5 (config access
in the solver). Rules 2, 3, 4 and 6 have no check at all. Rule 4 is Tier 1 —
mechanically checkable — and is not being checked. That gap is the fix.

Proposed check, to sit alongside the two that exist:

```
# Rule 4 — no stored artifact is read as a comparison oracle.
grep -rn 'np.load' pipeline/compare.py | grep -q 'BASELINE' && {
    echo "rule 4: compare.py loads a stored baseline as the oracle"; fails=1; }
```

`pipeline/compare.py:15` `load_baseline()` reads
`baselines/M2_reference.npy` from disk and nothing in the pipeline regenerates
it. That is the violation the check would have caught eleven days earlier.

## Secondary findings

- **Rule 6 is Tier 3 as written.** *"Keep the repository tidy... Clean up after
  yourself"* names no path, no threshold and no command. It cannot be checked by
  running anything or by reading anything with a defined answer. Either sharpen
  it into something specific or mark it a norm rather than a gate.
- **Rule 3 mandates a command that cannot be run.** It requires the output of
  `make test-convergence`, and there is no Makefile in the tree. Rule 1's own
  check greps `Makefile` for targets, so `tests/check.sh` would report a missing
  `build` target for a file that does not exist.

## Tier split

| Tier | Count | Meaning |
|---|---|---|
| Mechanical | 4 | rules 1, 2, 4, 5 — of which 2 are checked |
| Judgment | 1 | rule 3, once its command exists |
| Unenforceable | 1 | rule 6 |
