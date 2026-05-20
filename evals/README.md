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
- `kind: keyword` — at least one keyword from `any_of` appears anywhere in
  the agent's report.
- `must_not_find` — if any keyword from a `must_not_find` entry appears, the
  case fails. Use this to guard against scope creep, hallucinated bugs, or
  unwanted fix-recommendations.

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

## Running a case (manual, for now)

There is no automated harness yet. To run a case by hand:

1. `cd` into the case directory.
2. Open Claude Code in this repo (so the symlinked agents are loaded).
3. Run `/agents` and invoke the agent named in `case.yaml`.
4. Paste the `prompt` field as your message, scoping it to `input/`.
5. Compare the agent's report against `expected` and `must_not_find` by eye.

## Roadmap for the harness

- Programmatic runner that reads `case.yaml`, invokes the agent via the
  Claude Agent SDK, and grades the output.
- CI hook so every PR to this repo re-runs the suite.
- Per-case latency and token-cost tracking.
- A "leaderboard" page so prompt changes can be A/B'd.

The fixtures matter more than the harness. Land cases first; automation
follows.
