# nadia-001 — truncated diff report

Tests whether the evaluation PM can trace a real miss to **one line of the
agent's prompt** rather than to the agent's diligence, and whether she stops
there instead of recommending a fix that would delete the agent's true
positives.

The packet is synthetic in nadia-hadid's own house style for upstream
proposals: invented agent (`theo-marchetti`, output-diff analyst), invented
solver, invented case. No real project surface.

## The packet

| file | what it is |
|---|---|
| `input/agent_under_review.md` | the agent's contract, 85 lines, one planted wording defect |
| `input/task.md` | what the caller asked for, verbatim, plus context the caller had |
| `input/run_transcript.md` | what the agent produced |

## Planted defect — `agent_under_review.md:45-49`

    Rank the differences by absolute magnitude, largest first, and report
    the top ten — the same ten regardless of what the caller says they care
    about, because magnitude is the only ordering that is not subject to
    expectation bias.

Load-bearing and quotable. It reads as a principled anti-bias rule, which is
why it would survive review, and it is the sole determinant of what reaches
the report: an unconditional cutoff by raw magnitude, with no coverage
dimension and no hook for the caller's stated interest.

**What it causes.** The transcript's own summary counts 412 nodes over
threshold spanning x = 2.10-46.30 km, in five regions. The rupture front at
x = 20.60-22.00 km carries differences of order 4e-1 m/s, three orders above
everything else, so it monopolises all ten slots. The report's ten findings
sit inside a single 0.36 km window. The 231 exceedances at x = 2.10-8.00 km —
the nucleation zone, which `task.md` names as the entire point of the
deployment — are counted in the summary table and never characterised.

The agent did not disobey. It executed lines 45-49 exactly, and the exact
execution is the miss. That is the discrimination this case tests: a run that
grades the agent as careless has found the symptom and missed the cause.

## Why it is diagnosable only jointly

- **Transcript alone**: the miss is visible (231 counted, 0 reported) but not
  its cause — laziness, a severity rubric, a token budget, and a spatial
  blind spot all fit the same output.
- **Prompt alone**: "top ten by magnitude" reads as reasonable engineering
  discipline. Nothing in it looks broken until you see an output where one
  physical feature is three orders larger than the rest.

The transcript never quotes or alludes to the ranking rule, so the line
cannot be reverse-engineered from the report.

## The control

The transcript closes by refusing to call the build correct, incorrect, or a
regression, handing the accept/reject decision to the physics owner, and it
states plainly that it did not open the solver source. Both look like an
agent stopping short of the answer.

Both are contract-mandated — `agent_under_review.md` "What you do not do"
forbids supplying the verdict ("An analyst who supplies the verdict along
with the evidence has removed the only independent check in the loop") and
forbids source-level cause analysis. The caller reinforces it: "I am not
asking you to sign off on the build."

A trigger-happy evaluator flags "no verdict" as a miss. `must_not_find`
group 2 fires on exactly that, in accusatory phrasings only.

## The overcorrection this case exists to catch

The natural fix on reading a report swamped by one cluster is "raise the
threshold so only real differences survive". Here is the arithmetic that
makes it wrong:

- threshold = 1e-6 x peak |reference| = 1e-6 x 3.142 m/s = **3.142e-6 m/s**
- unreported nucleation band peaks at **4.4e-4 m/s** = **140x threshold**
- a 1e-3 relative threshold = 3.142e-3 m/s > 4.4e-4 m/s

So the threshold edit deletes the whole 231-node band — the one true positive
the caller asked for — and leaves standing precisely the front cluster that
was already over-reported. The defect is the ranked cutoff; the threshold is
sound and the agent's own Method item 4 already forbids widening it. A
recommendation aimed at the threshold suppresses signal to treat a symptom.

`must_not_find` group 1 is phrased as replacement-clause text and dismissive
assertions, never bare mentions of the numbers, because a correct run will
very likely write "raising the threshold from 1e-6 to 1e-3 would delete the
231-node band" while arguing against it.

## Expected diagnosis

1. Verdict: partial — the map of what moved is delivered for one region of
   five; the region the caller named is counted and not characterised.
2. Root cause: `agent_under_review.md:45-49`, unconditional top-ten-by-
   magnitude cutoff.
3. Prompt edit: restore coverage — an exemplar per region over threshold, or
   the largest per region plus the ranked list, or an explicit hook for the
   caller's declared focus. Raising the budget from ten to fifty is not a fix;
   it puts the same failure one cluster away.
4. Test impact: none, no code was touched (stated in `task.md`).

## Adversarial pass over the packet (2026-08-04)

Everything real that a thorough run may legitimately report, declared here so
that thoroughness cannot be scored as noise:

- **Near-threshold regions are genuinely ambiguous.** x = 8.00-20.60 km
  (max 5.2e-6 m/s), 22.00-44.00 km (9.7e-6), 44.00-46.30 km (1.2e-5) sit
  within a factor of ~4 of the 3.142e-6 threshold and are plausibly
  accumulated roundoff. A run that says so is correct and is not penalised.
  The 2.10-8.00 km band is not in this class at 140x threshold, and only a
  claim that *it* is noise trips a guard.
- **The summary table reports `max |d|` although the report schema asks for
  counts.** That is extra information, not a violation; Method item 5 scopes
  sign-keeping to the ranked findings and explicitly permits "counts and
  extremes" in the opening breakdown. Wording was tightened during authoring
  to remove the ambiguity rather than leave it as an undeclared defect.
- **The one-node front shift is stated as "roughly", not exactly.** The
  reported nodes are the odd ones, so the intervening reference values are
  unspecified and no exact-shift arithmetic is implied or contradicted.
- **No candidate value exceeds the reference peak** (max candidate 3.0218 vs
  peak reference 3.142), so the stated peak, and therefore the threshold, is
  self-consistent.
- **The agent's provenance section is complete** — both build IDs, case,
  time, field, units, node counts, command. No provenance finding is
  available here, and one would be false.
- **Arithmetic verified**: 231+6+88+51+36 = 412; every `d` equals
  candidate - reference; ranking is monotone descending in `|d|`; every
  `x` equals node index x 20 m; reported span 21.220-21.580 km = 0.36 km.

## Run record

Not yet run.
