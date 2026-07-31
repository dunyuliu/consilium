# Release notes — v1.5.0

**Date:** 2026-07-31
**Previous:** v1.4.0 (archived to `docs/`)
**Bump:** minor — the eval suite went from 1 fixture ever run to 5

## 1. Summary of scope

Every fixture in the repository has now been executed at least once. That is
the whole release: no new agents, no new checks, no new rules — just the
suite finally being run, and the damage report from running it.

**Five fixtures, five runs, four defects found in the fixtures themselves.**
Three of the five agents passed cleanly. One fixture was broken in a way that
would have failed a correct answer. One run was void because the agent read
the answer key. The suite that existed to measure agents turned out to need
measuring first.

## 2. Results

| Fixture | Agent | Verdict | What the run revealed |
|---|---|---|---|
| `mira-001` | `mira-volkov` | **PASS** | `must_not_find` punished correct negations (fixed in v1.4.0) |
| `lars-001` | `lars-eriksson` | **PASS** | clean; 3 further real findings beyond the planted pair |
| `iris-001` | `iris-vermeulen` | **PASS** | clean; wrote and mutation-verified 4 shell scripts in-session |
| `sophia-001` | `sophia-okafor` | **fixture defective** | stale line range + a guard that never fires |
| `haruto-001` | `haruto-nakamura` | **VOID → PASS** | read the answer key; re-run scoped to `input/` passed |

## 3. Fixture defects found and fixed

**`sophia-001` — stale line range.** `expected` asserted `ingest.py:[27,30]`;
the planted `return cleaned * 1000.0` is at **:32**. The run cited `:32`
correctly and would have failed the location criterion **on a right answer**.
Corrected to `[30,33]`. Fixture line numbers drift the moment the input file
is edited — cite them from the file, never from memory.

**`sophia-001` — guard that never fires.** `must_not_find` held
`"spike_threshold_m default is wrong"`. The run committed exactly the error
the guard exists for — ranking configured values as `"default value
mismatch"` at High severity — and sailed through, because the guard matched
a phrasing nobody would write. Reworded to what runs actually produce.

**`haruto-001` — negation-unsafe guard.** Third instance of the v1.4.0 flaw.
The guard was `"back-fill v0.2.0"`, but recommending that a *human* back-fill
from `git log` is the **correct** disposition, and the run said so. Rewritten
as first-person completions and speculative content (`"I have created
release_notes_v0.2.0.md"`, `"v0.2.0 likely contained"`) that only a
fabricating run produces.

**Answer-key leakage — the serious one.** `case.yaml` (holding `expected` and
`must_not_find`) and the case `README.md` (describing every planted defect)
sit one directory above `input/`. The first `haruto-001` run read both; they
look like ordinary project context. Nothing about the output appeared wrong,
which is exactly the hazard — leakage is invisible in the result.

Now documented in `evals/README.md` and rule 5: scope every invocation to
`input/`, inspect the agent's own file-reference list before scoring, and
**void** any run that touched the key rather than calling it probably fine.
The root cause is structural — the format stores the answer key adjacent to
the input — so a real runner must hand the agent an isolated copy instead of
relying on instructions.

Suggestive data point: the leaked and scoped `haruto-001` runs reached
**opposite** conclusions on archival (leaked: archive `v0.1.0`; scoped:
archive nothing). Not proof of causation, but a leaked run is not merely
unscoreable — its substance may differ.

## 4. Behavioural finding — not fixed, deliberately

`sophia-okafor` treats a config that sets non-default values as spec drift.
Documenting defaults while configuring other values is configuration working
as intended, not divergence. The run hedged correctly in its closing note but
still ranked all three at High severity.

Recorded in the fixture's notes and routed to `nadia-hadid` as a prompt
issue. **The fixture was not weakened to make it pass** — that is the
temptation this rule set exists to resist.

## 5. Content updates

- `evals/README.md` — leakage warning with the incident, the negation-safe
  wording rule, "record the outcome in the case's notes" as step 6 of a
  manual run, and the read-only requirement stated explicitly.
- `PROJECT_RULES.md` — rule 5 gains the leakage clause: a run that read the
  answer key has no verdict at all.
- All five `case.yaml` files — first-run outcomes recorded in `notes:`, with
  what each run revealed about the fixture.

## 6. Verification

- `bash tests/check.sh` — **239 passed, 0 failed**.
- `git status` inside `evals/` clean after all six runs (five plus the
  re-run) — no agent modified fixture data.
- Every scored run's file-reference list inspected for answer-key access;
  the one that failed that check was discarded and re-run, not salvaged.

## 7. Totals

| | v1.4.0 | v1.5.0 |
|---|---|---|
| Agents | 20 | 20 |
| Eval fixtures | 5 | 5 |
| **Fixtures ever executed** | **1** | **5** |
| Fixtures passing | 1 | 4 of 5 valid runs |
| Structural checks | 239 | 239 |

## 8. Open issues

1. **Eval coverage** — 15 of 20 agents still have no fixture.
2. **Rule 5 partly unenforceable** — grading remains by eye. A runner must
   invoke agents, which costs tokens and cannot run in free CI. It would also
   fix leakage structurally, which now looks like the stronger argument for
   building it.
3. **`sophia-okafor` false positive** — open, routed to `nadia-hadid`.
4. **Rule 18 judgment-tier** — nothing mechanically prevents two mutating
   workflows at once.
5. **Fixture line numbers are unguarded** — `sophia-001`'s stale range was
   found by luck. A check could assert that each `expected.location`'s
   `line_range` still brackets a line matching its keywords.

## 9. Assumptions

- Minor, not patch: first execution of the suite changes what is known about
  the repo, and four fixture defects were corrected.
- Release note describes the post-audit filesystem, not the raw git diff.
- No `--no-verify` bypass was used.
