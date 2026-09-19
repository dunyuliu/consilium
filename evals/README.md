# Evals

Small, hand-crafted fixtures. **What this suite is, measured against what it
has actually caught:** a lint for criteria and a smoke test for the harness.
Every defect it has ever found was a defect in the eval system itself — an
answer-key leak that reshaped `run.sh`'s isolation, a criterion that rejected a
correct report, a `cmd_grade` false positive, three rounds of grader repair.
Not one was a defect in an agent, and it cannot become one: grading is
substring matching on prose, a verdict costs a human pasting a staged prompt
into a live session, and two dispatches of one prompt to one agent have
produced different judgements, so every verdict is n=1. Agent quality is
judged by the humans and agents who read the work, not here.

That is worth keeping. A criterion that cannot be satisfied by a correct report
is a real bug, and nothing else in this repo can find one.

## What lives here

```
evals/
├── README.md       # this file — fixture format and runner contract
└── cases/          # one directory per case
    └── <case-id>/
        ├── case.yaml    # metadata: agent, prompt, expected findings
        ├── input/       # files the agent reads (committed to the repo)
        └── README.md    # human-readable description of the planted defect
```

A case is one (agent, input, expected-finding) triple. Keep each case small —
ideally one planted defect per fixture so failure modes don't tangle.

## Fixture format

`case.yaml` shape:

```yaml
id: lars-001
agent: lars-eriksson           # which agent to invoke
prompt: |                      # what the user would type
  Audit input/compute_returns.py for math correctness.
input_dir: input               # path relative to the case directory
expected:
  - kind: location             # finding must mention a specific file:line
    file: compute_returns.py
    line_range: [42, 48]       # finding cites a line in this range
    keywords:                  # finding mentions at least one of these
      - "look-ahead"
      - "future"
      - "leakage"
    severity: critical         # optional — match agent's severity grade
  - kind: keyword              # finding mentions these terms anywhere
    any_of:
      - "off-by-one"
      - "window"
must_not_find:                 # false-positive guards
  - keywords:
      - "rewrite the whole file"
      - "switch to pandas"     # advisory creep we don't want
notes: |
  Planted defect: the rolling-mean window uses df['close'][i:i+5] instead of
  df['close'][i-5:i], leaking future prices into the "past" window.
```

### Match semantics

- `kind: location` — the agent's report contains the file name and at least
  one line number in `line_range`. Keywords are case-insensitive substrings.
  Add an **`anchor:`** — a literal string from the input file that must sit
  inside `line_range`. `tests/check.sh` Check 9 verifies it on every run, so
  an edit to the input that shifts the defect fails the gate instead of
  silently failing a correct answer later. The anchor is a separate field
  from `keywords` on purpose: keywords describe the *report*, the anchor
  describes the *code*, and conflating them means testing string-match
  rather than detection.
- `kind: keyword` — at least one keyword from `any_of` appears anywhere in
  the agent's report.
- `must_not_find` — if any keyword from a `must_not_find` entry appears, the
  case fails. Use this to guard against scope creep, hallucinated bugs, or
  unwanted fix-recommendations.

> **Matching is literal, so it cannot tell an assertion from its negation.**
> A `must_not_find` entry of `"loosen the tolerance"` also fires on *"I did
> not loosen the tolerance"* — a sentence only a correct run produces. Agents
> routinely state what they refrained from doing, so a naive guard punishes
> exactly the behaviour it is meant to reward.
>
> Phrase every entry so it can only appear in a genuinely wrong answer:
> prefer verdict assertions (`"parity is confirmed"`, `"safe to ship"`) and
> recommendation imperatives (`"recommend loosening"`, `"edit resamp.c to"`)
> over bare descriptions of the bad act. `mira-001` shipped with the naive
> wording and passed its first run only by luck of phrasing.

> ### The most common criterion defect: enumerated paraphrases
>
> An `any_of` list of full sentences can never be exhaustive. Four cases failed
> correct runs this way in one session — `"do not merge"` missing *"does not
> merge"*, `"send it back"` missing *"send back"*, seven variants of *"rina has
> no fixture"* missing *"zero fixtures"*, and a `kind: location` on a one-line
> stub that no report cites as `:1`.
>
> **Anchor on the shortest distinctive token the answer must contain**, not on
> a phrasing you imagine. `"refuse"` beats `"refuse to merge"`. `"1.27"` beats
> `"1.27 cells across the cohesive zone"`. If no short token is distinctive
> enough, the criterion is probably asking for a judgement rather than a fact,
> and belongs in the notes for a human to score.

### Pass criteria

A case passes when every `expected` entry matches AND no `must_not_find`
entry matches. Partial-credit scoring (k of n findings) is out of scope for
v1 — start strict, relax later if needed.

## Writing a good case

- **One defect per case.** Tangled fixtures produce tangled diagnoses.
- **Realistic.** Use code shapes the specialist will actually encounter, not
  contrived puzzles.
- **Avoid the agent's own keywords in the input.** If the file already
  contains the word "look-ahead" in a comment, you're testing string-match,
  not detection.
- **Document the planted defect.** Put it in `README.md` inside the case
  directory. Future-you will not remember.
- **Include a clean control occasionally.** A case with no defect should
  yield no findings — confirms the agent isn't hallucinating.
- **Verify the control is actually clean, as rigorously as you verify the
  planted defect is present.** This is the single most common way a fixture
  has been wrong here. On 2026-07-31 three consecutive cases shipped with
  contaminated "clean" regions: `sophia-001` had an undeclared silent-failure
  return, `sophia-002`'s negative keys documented defaults the code had no
  fallback for, and `ziyan-001`'s control references were never `\cite`d and
  one overclaimed its own abstract. In every case a thorough run was scored
  as noisy for reporting something real.
  An undeclared true defect in a control does not merely produce a false
  failure — it makes a complete audit score *worse* than an incomplete one,
  which is the exact opposite of what the suite is for. Either declare it in
  `expected` or remove it; never leave it unlisted.

## Running a case

1. `bash evals/run.sh stage <case-id>` — it copies `input/` outside the repo and
   prints the prompt, the agent, and the record line to paste back.
2. **Save the agent's verbatim output to a file** and run
   `bash evals/run.sh grade <case> <that file>`. Do not grade a summary you
   wrote — a condensed transcription drops the exact sentences the criteria
   match on, and every failure it produces is your paraphrase failing, not
   the agent. This happened repeatedly on 2026-08-04.
3. Record the outcome in the case's `notes:` — date, verdict, and anything
   the run revealed about the fixture itself. A run nobody wrote down is a
   run that will be repeated.

Invoke the agent read-only (rule 7): fixture inputs are the planted defects,
and an agent that "helpfully" fixes one converts a failing regression test
into a passing one. `git status` inside `evals/` must be clean after a run.

## Precision — the criterion we do not have

`must_not_find` guards *phrasings*. It cannot see that a report found the
planted defect and four things that are not there. A run at 25% signal scores
identically to a clean one, and one did: `sophia-001` reported one true
finding beside three unactionable ones at the same severity, and the fixture
reported green.

**The mechanism falls out of something we were forced into anyway.** Four
fixtures shipped with undeclared real defects, and the fix was to declare the
*complete* defect set rather than delete what the agent found. Once a case
declares everything real in its input, precision becomes measurable:

    findings in the report that map to a declared defect   -> true positives
    findings that map to nothing declared                  -> either a NEW
      real defect (declare it, and the fixture was incomplete) or a false
      positive (and the run was noisy)

That disjunction is the whole difficulty, and it is not automatable — deciding
which branch a finding falls into is exactly the judgement a human or an
evaluator agent has to make. What *is* automatable is surfacing the ratio and
refusing to let it pass unexamined.

**Half of this is now built, and the other half is not buildable. Both halves
matter, so read which is which.**

**Built (2026-08-05).** `declared_defects:` in `case.yaml` lists every real
defect in `input/`, whether or not it is required for a pass — including the
ones nobody planted, found while auditing the corpus (PF-011) and declared
rather than deleted. `run.sh grade` reports how many were mentioned:

```
declared defects: 3 of 4 mentioned  (diagnostic — not part of the verdict)
  mentioned      gaussian-substitution ("gaussian_filter")
  mentioned      cubicspline-substitution ("CubicSpline")
  mentioned      toy-grid-parity-claim ("64x64")
  NOT mentioned  square-grid-reshape
```

**A low ratio is not automatically bad.** For a case whose right answer is a
*refusal* the correct report may legitimately mention none: `dunyu-001`'s pass
sample reads 0 of 4 because a deferral does not enumerate the physics it is
deferring, and `lars-002`'s reads 0 of 1 because its bar is "no CRITICAL finding
and nothing factually false", not "report everything". The number says how much
of the input the report engaged with, and what that ought to be depends on the
case.

**Terms are matched literally, with no unescaping.** What is typed in the YAML
is what `grep -F` sees. `ziyan-001` shipped `"2 \\times 10"` — the author wrote
YAML-style escaping the parser never undoes, so the term reached the matcher as a
literal double backslash and could never fire. Found 2026-08-05 by sweeping all
three criteria sections for backslashes; it was the only one. No check was added:
the only complete test is "flag any `\\`", and a `ziyan` report quoting a LaTeX
line break would trip it, so the false positive is real.

It cannot move the verdict — rule 5 admits exactly one eval pass criterion.
What it does is make a **correct but uncredited** finding visible. An
undeclared true defect makes a thorough audit score no better than a shallow
one; before this, the extra defects lived in prose that nothing read.

**Not buildable: the other direction.** The original sketch also wanted
`grade` to list report findings it could not map to a declared defect, and to
return INCONCLUSIVE when any were unmapped. That requires enumerating findings
from the report, and a report is prose — findings are not delimited. Counting
rows counts non-findings, and **that exact error has already been made twice in
this suite** (`lars-002` and `sophia-002` both had a pass bar written in report
rows and had to be rewritten in distinct defects).

So `grade` says plainly that precision is NOT MEASURED rather than returning an
INCONCLUSIVE derived from a finding count that would itself be wrong. A verdict
built on a bad measurement is worse than an honest absence of one (rule 2).
**Precision is read, not computed.**

## Tiers

There is exactly one tier and `evals/run.sh smoke` is the only thing that reads
it. `tier: smoke` means **fast, offline, single-file, and worth running after any
prompt edit**; a case with no `tier:` is full-suite only. Check 22 rejects any
other value, because metadata that reads as meaningful and is inert is worse than
none — it invites the next author to write `tier: slow` and believe something
will honour it. `dunyu-001` carried `tier: dev` from its authoring and nothing
ever acted on it.

## Verdict currency

`bash evals/run.sh score` emits one number:

```
verdict currency: 3/9 verdicts recorded against the current prompt (33%)
  (currency only — this says nothing about agent quality; it falls whenever a prompt improves)
```

**What it measures, exactly**: the fraction of cases whose recorded verdict
still describes the prompt that case currently grades. That is all. It is not a
quality score for the agents and never was one — see the top of this file for
what this suite has actually caught.
