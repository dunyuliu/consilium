# Evals

Small, hand-crafted fixtures for regression-testing the agents.

The point: when you tighten a prompt in `agents/lars-eriksson.md`, you should
be able to tell whether the change helped or hurt. Without fixtures, every
prompt edit is a vibes-based diff.

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

## Running a case (manual, for now)

There is no automated harness yet. To run a case by hand:

1. `cd` into the case directory.
2. Open Claude Code in this repo (so the symlinked agents are loaded).
3. Run `/agents` and invoke the agent named in `case.yaml`.
4. Paste the `prompt` field as your message, scoping it to `input/`.
5. **Save the agent's verbatim output to a file** and run
   `bash evals/run.sh grade <case> <that file>`. Do not grade a summary you
   wrote — a condensed transcription drops the exact sentences the criteria
   match on, and every failure it produces is your paraphrase failing, not
   the agent. This happened repeatedly on 2026-08-04.
6. Record the outcome in the case's `notes:` — date, verdict, and anything
   the run revealed about the fixture itself. A run nobody wrote down is a
   run that will be repeated.

Invoke the agent read-only (rule 7): fixture inputs are the planted defects,
and an agent that "helpfully" fixes one converts a failing regression test
into a passing one. `git status` inside `evals/` must be clean after a run.

> ### Scope the agent to `input/` — the answer key is one directory up
>
> `case.yaml` holds `expected` and `must_not_find`; the case `README.md`
> describes every planted defect. Both sit in the parent of `input/`, so an
> agent pointed anywhere near the case directory can read the answers, and a
> capable one will — it looks like project context.
>
> **This has already happened.** The first `haruto-001` run listed the case's
> `case.yaml` and `README.md` among its referenced files. The report was
> discarded and the case re-run; nothing about the output looked wrong, which
> is exactly the problem — leakage is invisible in the result.
>
> Every invocation must say, explicitly: *treat `input/` as the entire
> project; do not read, list, or grep anything above it — specifically not
> `case.yaml` or the parent `README.md`.* Then check the agent's own
> file-reference list before scoring. A run that touched the answer key is
> void, not "probably fine".
>
> The layout is the root cause: the fixture format stores the answer key
> adjacent to the input. A runner should hand the agent an isolated copy of
> `input/` instead of relying on instructions.

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

Membership is **fixed**, not selected by staleness — a tier whose membership
moves with history cannot be compared across edits. The nine members are the
five original fast cases plus the three refusal controls and the clean control,
which are the cases most likely to break when a prompt is edited: an edit that
makes an agent keener breaks a refusal case before it breaks a detection one.

`smoke` prints each member's baseline state, and that is not decoration. As of
2026-08-05 **seven of the nine have no verdict against the current prompt** —
four never run, three stale. A green smoke run means "these cases pass today",
not "nothing regressed", because for seven of them there is nothing to have
regressed from.

## Staging refuses a symlinked input

`stage` copies `input/` with `cp -R`, which copies a symlink **as a symlink**. An
absolute link therefore resolves from the staged copy back to whatever it names —
including the `case.yaml` one directory above `input/`. Demonstrated 2026-08-05:
a staged `leak.md` printed the full `expected:` block, and a link to
`/etc/hostname` read the host's name. Staging exists to make the answer key
unreachable; one symlink makes it reachable again.

Refusing beats dereferencing. `cp -RL` would inline the target's *content* into
the staged copy, leaking the same bytes while looking clean. No fixture needs a
symlink, so `stage` stops and Check 23 fails the suite at commit time.

Filenames with spaces and filenames beginning with a dash were probed at the same
time and stage handles both correctly.

## The leakage check is input-aware

`grade` voids a report containing `case.yaml`, `must_not_find` or "planted
defect" — but only when that term is **not** in the case's own `input/`. A case
whose input is a criteria file (`nadia-002`) legitimately uses that vocabulary,
and a correct report naming the section by its real name was being voided for
speaking about the thing it was asked to review. A term the agent was handed
proves nothing about leakage. A term it was not handed still voids, which is the
`haruto-001` and `victor-001` case and is unchanged.

## Roadmap for the harness

- ~~Programmatic runner that reads `case.yaml` and grades the output.~~
  **Landed** as `evals/run.sh` (stage + grade). Agent *invocation* is
  deliberately not automated: it needs API access and tokens, so it cannot run
  in free CI, and a gate that cannot run is worse than no gate.
- CI hook so every PR to this repo re-runs the suite — blocked on the above.
- Per-case latency and token-cost tracking.
- A "leaderboard" page so prompt changes can be A/B'd.

The fixtures matter more than the harness. Land cases first; automation
follows.
