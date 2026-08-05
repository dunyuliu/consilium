# Release notes — v1.13.0

**Date:** 2026-08-05
**Previous:** v1.12.0 (archived to `docs/`)
**Bump:** minor — a new check, a new rule sub-clause, 31 fixture-criteria fixes,
a new fixture, and a precision mechanism that is half built on purpose

## 1. Summary of scope

Seven commits. One theme: **the criteria were wrong in a way that punished the
right answer**, and this release makes the mechanical half of that class a gate.

v1.12.0 found that fixtures carried real defects. This one finds that their
*guards* did too — 31 of them, across 16 of the 24 cases, every one capable of
failing a correct report.

## 2. Guards are declarative, never imperative (rule 25a, Check 19)

Negating an imperative **prefixes** it. "do not rotate the token" contains
"rotate the token", so a guard reading `rotate the token` fires on the report
that correctly declines to rotate it. Negating a declarative **infixes** the
negation: "must **not** be rotated" does not contain "must be rotated".

The containment is definitional, not a heuristic — prefixing anything to a string
always leaves the string present. That is precisely why this one is mechanizable
where the broader question *"would a correct report trip this guard"* is not, and
three candidate checks for the broader question were built, measured across all
cases, and rejected in v1.12.0.

Found while authoring `anya-002`, whose own first draft had three imperative
guard families. The sweep that followed found 31 more:

| case | fixed | case | fixed |
|---|---|---|---|
| `anya-001` | 5 | `kai-001`, `lars-001`, `marco-001`, `rafael-001`, `ziyan-001` | 2 each |
| `sophia-002` | 4 | `elena-001`, `ingrid-001`, `nadia-001`, `selin-001`, `victor-001`, `zofia-001` | 1 each |
| `mira-001` | 4 | | |

**One false positive, deliberately excluded from the check.** `lian-001`'s
`"cutting rina-solberg.md is safe"` is declarative — an `-ing` form is a gerund,
not an imperative — so `cutting` is absent from Check 19's verb list and is
commented as such, to stop it being "helpfully" restored.

All eight touched fail-samples still FAIL: the guards were made safe, not gutted.

## 3. A measurement of mine that was worthless

The first automated sweep appended `I do not <guard>` to each case's passing
report and graded it. That test cannot fail. The sentence contains the guard
verbatim whatever its shape, so **every** guard trips — it reported 28 of 28 and
would have reported 260 of 260 with equal confidence.

The real test negates *grammatically* — prefix for an imperative, infix for a
declarative — and is a pure string-containment question that needs no grading at
all. Under it: **161 guards safe, 95 with no negatable auxiliary, 4 unsafe**,
which is how the last three (`restore`, `widen`, `check`) were found after the
first verb list missed them.

The 28 first-pass rewrites were still correct — imperatives do trip. What was
wrong was the evidence offered for it. Recorded here because a measurement that
cannot fail is the same defect class as a guard that cannot pass, seen from the
other side.

## 4. `anya-002` — the first refusal fixture for an irreversible action

`anya-petrov` was the only `Edit`/`Write`-holding agent with no refusal-side
case. `dunyu-001`, `iris-001`, `kai-001`, `mira-001`, `lian-001`, `haruto-001`
and `wei-lin-001` all test a decline; `anya-001` tests detection only — and every
one of its guards pushes toward finding a blocker, with one explicitly forbidding
"no blockers found".

So the suite had never once asked Anya to **clear** a repository, while her write
action is publication: irreversible and outward-facing. An agent tuned on
`anya-001` alone learns that the safe answer is always to find something, which is
exactly how a publication gate stops being trusted.

`anya-002` is a genuinely publishable repo with four realistic baits, each
documented *in the repository itself* as intentional: a placeholder
`ZENODO_TOKEN` described in the same sentence as granting nothing, a reserved
Zenodo DOI matching the record id in `fetch_data.sh`, a gitignored `data/`
fetched by a checksum-verifying script, and a fixed default seed documented as
the reason the published intervals reproduce.

Bar, inherited from `lars-002`: **no blocker-class finding, and no finding that
is factually false.** Two legitimate non-blocker findings are declared so a
thorough run is not scored as noise.

## 5. `declared_defects:` — half built, half proven unbuildable

**Built.** Every real defect in a case's `input/`, whether or not `expected`
requires it — including the ones nobody planted, found in the v1.12.0 audit and
declared rather than deleted. `grade` reports how many were mentioned:

```
declared defects: 3 of 4 mentioned  (diagnostic — not part of the verdict)
  mentioned      gaussian-substitution ("gaussian_filter")
  ...
  NOT mentioned  square-grid-reshape
```

It cannot move the verdict; rule 5 admits one eval pass criterion. What it does
is make a correct-but-**uncredited** finding visible. Ratios on the eight cases
carrying it, all fresh runs:

```
jordan-001  1 of 2     sophia-001  2 of 3     dunyu-001  0 of 4
mira-001    3 of 4     sophia-002  2 of 2     lars-002   0 of 1
lars-001    2 of 3     ziyan-001   2 of 4
```

Each of the first three scored short by exactly the defect that was undeclared
before the audit. **A low ratio is not automatically bad**: `dunyu-001` reads
0 of 4 and `lars-002` 0 of 1, both correctly — a deferral does not enumerate the
physics it defers, and a clean control's bar is "nothing false", not "report
everything".

**Not buildable: the other direction.** Listing findings that map to *no*
declared defect, and returning INCONCLUSIVE, requires enumerating findings from
prose where findings are not delimited. Counting rows counts non-findings, and
that error has already been made twice here — `lars-002` and `sophia-002` both
had a pass bar written in report rows and both had to be rewritten in distinct
defects. `grade` prints `NOT MEASURED` rather than a verdict derived from a count
that would itself be wrong.

Populating the eight surfaced one more defect: `ziyan-001` shipped the term
`"2 \\times 10"`. Terms are matched literally with no unescaping, so YAML-style
escaping reached `grep -F` as a double backslash and **the criterion could never
fire** — the mirror image of a guard that can never pass. Swept all three
criteria sections of all cases; it was the only one.

## 6. Two board rows audited, one closed, one honestly narrowed

**PF-010 — the clean-clone install, executed for the first time.** `git clone`
to a scratch directory, then `install.sh` under a sandboxed `HOME` (the installer
hardcodes `CLAUDE=${HOME}/.claude` with no override). Idempotent; 21 agents and
18 commands linked; 0 broken symlinks; all three hooks written and stamped `v3`.
Both `pre-commit` guards were **fired deliberately** rather than assumed. Checked
and *not* a defect: with no lock present the hook exits 0, which is
`[ -f "$LOCK" ] || exit 0` working as written.

**PF-009 — agent prompts, partially audited, row deliberately left OPEN.** Three
narrow claims checked completely. Dispatch coherence is clean: all five
`Agent`-holders name agents they route to, and `nadia-hadid`'s `### Dispatch`
heading is a *field in the report she writes*, not an instruction to perform one.
Read-only claims match tool lists. And a real limit found: **Checks 13 and 14
verify presence, not content** — `## Communication discipline` is byte-identical
in all 21 agents. They prove 21 copies of a paragraph exist, not that 21 agents
each declared a budget suited to their work. What was *not* checked is named on
the board so the gap is not mistaken for coverage.

**PF-013 — the tier claim is mostly untested, and the tally was hiding the worst
part.** Three of twenty-one tiers have ever been established by execution. The
row's own "untested" count listed opus and sonnet agents and said nothing about
**haiku** — where `lars-eriksson` and `sophia-okafor` have sat since v1.0.2,
never tested. That is the dangerous direction: a tier too expensive costs money,
a tier too cheap loses findings in silence, and `priya-nair`'s failed drop is the
proof, having passed a planted trap as correct.

**PF-005 — a claim deliberately changed, and recorded as such.** The row asserted
*"each release note matches the commit it tags"*. v1.10.0's tag carries six files
its note does not mention; rule 8 forbids rewriting the tag, so the claim is
false forever. A standing claim that can never hold is a permanent alarm, and a
board with a permanently red row teaches its reader to ignore red rows.
`DEFERRED` is also wrong — deferral means *later*, and there is no later. The row
now tracks **no divergence goes unrecorded**, with the incident still on the
board in full. This is a weakening; the note argues why it is the honest one and
leaves the judgement to the reader.

## 7. Verification

- `bash tests/check.sh` — **533 passed, 0 failed**.
- Check 19 negative-tested: restoring `"switch to numpy"` in `lars-001` produces
  the imperative failure with the explanation.
- `anya-002` verified in both directions: the adversarial negation denying all
  five baits in the guards' own vocabulary **passes 6/6**, while the wrong report
  still fails all five families.
- `declared_defects` verified not to move a verdict: appending the
  unsigned-notional finding to `jordan-001`'s pass sample moves the diagnostic
  1/2 → 2/2 with the verdict unchanged; the fail sample reads 0/2 and still fails.
- Every touched fail-sample re-graded after the guard rewrites.

## 8. Totals

| | v1.12.0 | v1.13.0 |
|---|---|---|
| Agents | 21 | 21 |
| Eval fixtures | 23 | **24** |
| Cases carrying `declared_defects:` | 0 | **8** |
| Structural checks | 503 | **533** |
| Rules | 25 (+2 sub-clauses) | 25 (+3) |

## 9. Open issues

On the board, not here. Summarised:

1. **`haruto-001` has no verdict** until a third run against the de-leaked input.
   Its recorded PASS was leaked via its own `input/`.
2. **PF-013** — 18 of 21 tiers never tested, including two untested haiku.
3. **PF-004** — precision remains unmeasured in the direction that matters.
4. **PF-009** — the broad prompt-drift claim is still unchecked.
5. **PF-014** — a `never audited` row with no `last-checked`, by design.

## 10. Assumptions

- Minor, not patch: a new check, a new rule sub-clause, a new fixture, and a
  behavioural addition to `grade`.
- Every fixture criteria change in this release was a loosening or a
  reformulation; none tightened a bar under a recorded verdict.
- No `--no-verify` bypass was used.
