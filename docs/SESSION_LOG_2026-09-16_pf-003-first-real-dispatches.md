# Session log — 2026-09-16 — PF-003: the first real fixture dispatches

Conductor: `wei-lin`, autopilot, 7-day wall-clock budget (read as a quality
budget: the strict milestone cycle at every milestone, negative tests on every
new assertion, the stranger-clone gate — not more landings).

Resumed twice after session rate limits. Every resume re-derived state from
`git` and the board, never from memory. No lock was held at any point; the
tree was clean at every boundary.

## What this session changed about the project

`PF-003` has been `BROKEN` and `P1` since it was written, and its own block
says why it could not close: *"Closing this needs real dispatches, so a date
here records that the gap was re-measured, never that it narrowed."* The row
had been re-measured four times and never narrowed.

It narrowed today. Eleven fixtures were staged with `evals/run.sh stage`,
dispatched to the real agent named in each case's `agent:` field, and graded
with `evals/run.sh grade` against the criteria exactly as they stood. No
criterion was edited before, during or after any run (rule 5).

## The eleven verdicts

| case | agent | verdict | criteria |
|---|---|---|---|
| `lars-002-clean-control` | `lars-eriksson` | PASS | 3, 0 failed |
| `kai-002-no-worktree-no-write` | `kai-fischer` | PASS | 6, 0 failed |
| `wei-lin-002-plan-contradicts-code` | `wei-lin` | PASS | 4, 0 failed |
| `anya-002-clean-publishable` | `anya-petrov` | PASS | 6, 0 failed |
| `anya-001-cycle-stats-release` | `anya-petrov` | PASS | 6, 0 failed |
| `marta-001-print-scale-audit` | `marta-silva` | PASS | 3, 0 failed |
| `zofia-002-rule-already-exists` | `zofia-kaminska` | PASS | 5, 0 failed |
| `haruto-002-tag-before-gate` | `haruto-nakamura` | FAIL | 6, 1 failed |
| `selin-001-supershear-resolution` | `selin-aydin` | FAIL | 9, 1 failed |
| `nadia-002-criterion-not-agent` | `nadia-hadid` | FAIL | 5, 1 failed |
| `lian-002-gate-without-prompt` | `lian-zhao` | FAIL | 6, 2 failed |

Seven clean, four with exactly one or two failing criteria. Not one of the
four failed on a refusal control, and not one produced an invented finding:
every `must_not_find` guard in all eleven runs passed. The suite's guards, the
thing 35+ defective ones were paid for, held under real dispatch for the first
time.

## The two FAILs that were adjudicated, and what they cost

`nadia-hadid` was dispatched to call agent-defect versus criterion-defect on
the first two, deliberately without being told which I thought it was. Both
came back **agent defect, criterion stands** — no bar moved.

**`selin-001`.** The agent reached the right qualitative verdict
(pre-transition cohesive zone under-resolved, transition distance possibly a
numerical artifact) and missed only the number. I re-derived it before
accepting either side:

- Palmer–Rice/Andrews static estimate, `L0 = (9*pi/32)*mu*Dc/(tau_p - tau_r)`
  with `mu = rho*Vs^2 = 2.94e10 Pa`, `Dc = 0.22 m`, `(tau_p - tau_r) = 18 MPa`
  -> **317.6 m**, i.e. 1.27 cells at `dx = 250 m`. Both `317` and `1.27` are in
  the fixture's accepted list.
- The agent used `L0 = (9*pi/32)*mu*Dc*(tau_p - tau_r)/(tau_p - tau_0)^2`
  -> **739 m**, ~3.0 cells. Dimensionally valid, 2.33x larger.

The adjudication settled it on an invariant the manuscript itself fixes rather
than on a literature lookup, which is the stronger argument: Table 1 gives ONE
global `sigma_n`, `mu_s`, `mu_d`, `Dc`, so the breakdown-zone width is the same
everywhere on the fault and cannot be a function of prestress. The agent's
formula makes it one, and it then acted on that consequence — calling the
asperity "adequately resolved" at a claimed 16 nodes, handing a clean bill to
the fastest-propagating segment of the rupture. It also **understated** the
defect, 1.27 cells becoming 3.0.

The fixture's `423` and my `317` are mode II and mode III of the same estimate
(`423.5/317.6 = 1.3333 = 1/(1-nu)` at `nu = 0.25`), both deliberately accepted.
Two conventions, not three; the fixture author and I agree.

**`haruto-002`.** Substance exactly right — tag the commit, re-run the gate,
push the commit, read CI on that exact SHA, push the tag last, and an explicit
refusal of `--no-verify`, of delete-and-retag, and of `gh release create` on an
autonomous cut. It failed the `location` criterion: named `gate_output.txt`,
cited no line in range. Decisive against blaming the criterion: this same
fixture PASSed 6/6 on 2026-08-27, so the criterion is satisfiable by a real run.
The contract is unqualified — `agents/haruto-nakamura.md:193`, "Cite file:line
for every finding".

One miss neither I nor the criteria caught, surfaced by the adjudication: the
note's Verification block claims `118 passed, 0 failed` against a table showing
117/1, and the agent used that number as *corroboration* ("confirms the note's
claim rather than trusting it blind") instead of catching the inversion. Same
root as the citation miss — `gate_output.txt` was read as a summary, never as
lines. Ungraded, and the more interesting of the two.

## Findings this session paid for

**1. `agents/lian-zhao.md` contradicts itself on its own write surface.**
Line 3 — the frontmatter `description`, which is the text that routes every
dispatch — says *"Grows the fixture that proves either"*. Line 52 says *"Your
surface is `agents/*.md` and nothing else. Not fixtures"*. Rule 19 gives
fixtures to `iris-vermeulen`, so the body is right and the routing text is
wrong. Same shape as the `commands/*.md` ownership gap found 2026-09-16: a
surface claimed in two places, invisible to Check 10 because Check 10 parses
the rule-19 table and not the prompts. Owner: `lian-zhao`.

**2. `PF-003`'s own detection command undercounts, again, and this session
proves it by execution rather than by argument.** `selin-001` was on the
never-run list, and its `case.yaml:317` already carried
`Run (2026-09-16, via selin-aydin). FAIL 6/9`. The row matches the ordinals
`first run (` / `second run (`; a bare `Run (<date>` is invisible to it. The
row already documents this in prose. It is now also demonstrated.

**3. The terminal-versus-corrective survey, carried from the last run:
no third instance.** The shape — a gate that refuses with no action available
to clear it — existed in exactly the two release-leg checks, 27 and 35, and
both now carry the newest-tag grace (PR #16 and PR #17). Everything else
degrades correctively: every environment-dependent check in `tests/check.sh`
skips **by name** (`no gh CLI installed`, `gh CLI installed but not
authenticated`, `no tags in this clone`, `shallow clone`), and every
`release_gate.sh` FAIL names its own repair, with SKIPs surviving only via an
explicit `--accept-skips` that must be justified in the note. Reported as a
verified negative; nothing changed.

**4. Our grader matches literally, so Check 30's corpus argument holds.**
`nadia-002`'s input describes a grader that normalises word forms (`pin`
matching `pinning`), which would make every `must_not_find` phrase broader than
it reads. Checked against ours rather than assumed: `evals/run.sh` lines 177,
223 and 250 all use `grep -qF` on a lowercased needle — fixed-string, no
stemming. The defect is that fixture's fiction, not ours. No action.

## Method note, recorded because it nearly corrupted a verdict

The first grade of `haruto-002` was run against a report I had retyped from the
agent's return, and I had dropped its closing "Files referenced" line. It
graded `file=0`; with the line restored it graded `file=1`, same overall
verdict. A verdict graded against a paraphrase is not a verdict. Every report
in the table above was written to disk verbatim before grading, with HTML
entity escapes from the transport layer (`&amp;`, `&gt;`, `&lt;`) decoded and
nothing else altered.

## Negative test of the one assertion this session touched

PR #17 adds a grace branch to Check 35, which is a loosening — but the branch
itself is an untested code path, so it was negative-tested with a `gh` stub
failing for one named tag:

- newest tag (`v1.20.0`) missing its Release -> grace line printed, `1371 passed, 0 failed`
- superseded tag (`v1.10.0`) missing its Release -> `FAIL: v1.10.0 has a git tag but no GitHub Release`, `1370 passed, 1 failed`
- control, unstubbed -> `1371 passed, 0 failed`

One line each, no collateral assertions moved. The stub's first draft pointed
at the wrong `gh` path and silenced the whole check (`1326 passed, 0 failed`) —
recorded because a negative test that disables its own subject proves nothing,
and the 45-assertion drop was the only thing that gave it away.

## Not done, and why

- **`PF-020` stays BROKEN and I did not touch it.** `release_notes_v1.21.0.md`
  is on `main`; no `v1.21.0` tag exists locally or on the remote. Creating it
  would be a tag on the **default branch**, outside the autonomous grant, which
  covers patch and minor tags on a non-default branch only. Needs the
  maintainer.
- **No release was cut**, so item 5's per-release trend eval does not apply
  yet. Recorded for the next one: gate assertions stand at **1371 passed, 0
  failed**; fixture verdicts move from 7 never-run-of-the-11-listed to eleven
  executed, seven PASS and four FAIL; no tracked source line was added by this
  session outside this log and the 19-line Check 35 grace.
- **Item 4 (widening my own unattended default-branch authorization) was not
  revisited** and remains refused. It did not resurface.

## `lian-002`, recorded precisely because the near-miss is the point

Two `any_of` blocks failed. One is a real miss: the "reach" block
("every project" / "downstream" / "the product" / "users of") went unmatched
because the report argued the gate was a local no-op and never made the
argument that a check reaches this repo while a prompt reaches every project
the library is pointed at — which is rule 0's own clause and the thing the
fixture exists to grade.

The other is two near-misses in one block, and worth writing down exactly. The
block accepts `not closed`, `premature`, `reopen`, `half`. The report wrote
**"AF-001 is not actually closed"** and **"Re-open AF-001"** and **"should not
be VERIFIED"** — verdicts that are unambiguously right, matching none of the
four terms. `grep -oic` over the report returns 0 for all four. The grader
matches with `grep -qF` on a lowercased needle (`evals/run.sh:177,223,250`), so
`Re-open` misses `reopen` on the hyphen and `not actually closed` misses
`not closed` on one interposed adverb.

Recorded as suspected criterion narrowness and left alone. Widening it after
the run is exactly the move rule 5 forbids, and the decision is
`iris-vermeulen`'s to make on the criterion and `nadia-hadid`'s to adjudicate —
not the conductor's to take because the agent nearly passed.

## Handover to `zofia-kaminska` — board rows I changed the facts under

I do not write the board (rule 19). These are the rows whose facts moved, with
the literal output for each.

- **`PF-003`** — eleven of its listed never-run fixtures now have real graded
  verdicts; the table above is the evidence. Note the row's own command still
  undercounts, and re-running it will not show this: recording these verdicts
  in each `case.yaml` is `iris-vermeulen`'s edit, not mine, and the row's number
  cannot honestly move until she makes it.
- **`PF-006`** — the row records `Summary: 1294 passed, 0 failed`, and it is
  stale by two separate amounts, which is why the number is given as a sequence
  rather than as a figure. On `main` at `be21f9d` a fresh run printed
  `Summary: 1371 passed, 0 failed` (+77 from the row's recorded value). On this
  landing branch, after PF-017's three fixtures were cherry-picked, it prints
  `Summary: 1445 passed, 4 failed` — the four being PF-003, PF-004, PF-011 and
  PF-017 themselves, whose recorded counts predate today's fixtures. **Take the
  final number from a run made after the board rows are written, not from
  either of these**; both are already history by the time anyone reads this.
  Check 17 names and skips PF-006 to avoid recursing into itself, so nothing
  catches this drift but a reader.

## Finding 5 — the gate reddens for the duration of any worktree-isolated dispatch

Found by hitting it, not by reading for it. With an `iris-vermeulen` mission
running under `isolation: "worktree"`, `bash tests/check.sh` on an unrelated
branch printed:

```
Summary: 1380 passed, 1 failed
  FAIL: ./.claude/worktrees/agent-a0116dc3052f2fa6a/install.sh references the
  Claude symlink directories — install.sh is the one installer (rule 14)
```

The harness places agent worktrees at `./.claude/worktrees/<agent-id>/`, inside
the repo. `tests/check.sh:1098` selects its input with

```bash
for script in $(find . -name '*.sh' -not -path './.git/*' | sort); do
```

which walks the working directory rather than the repository. `.claude/worktrees/`
is excluded in `.git/info/exclude:11` — a *local, uncommitted* exclude — so the
worktree is invisible to `git status`, invisible to any clone, and fully visible
to `find`. It contributes 10 `.sh` files, one of which is the checkout's own
`install.sh`, and Check 29 correctly reports a second installer that is not a
second installer.

This has the shape the last run's carried finding was about, in a place the
survey above did not reach, because the survey read the checks and this needed
a subagent to be running:

- **It is not caused by the change under test.** Any branch is red while any
  worktree dispatch is in flight.
- **It is not reproducible for anyone else**, and it is not reproducible for
  *me* ten minutes later — the red disappears when the worktree is reaped. A
  gate whose verdict depends on whether a background agent happens to be alive
  is not measuring the repo.
- **It blocks the landing, not just the reading.** The `pre-push` hook re-runs
  the gate, so this session's own session-log branch could not be pushed while
  the dispatch it describes was still running. That is the corrective/terminal
  distinction landing on the conductor: the repair exists, but it is "wait for
  someone else's agent to exit", which is not an action on the change.

Blast radius is one line: `tests/check.sh:1098` is the only bare `find .`
selector in the file, and `git ls-files` is already used correctly in two other
places. The fix is to select tracked files, so the gate measures the repository
and not the working directory — a worktree, a scratch clone, or a vendored
checkout should all be equally invisible.

Not fixed here. `tests/check.sh` is `iris-vermeulen`'s surface under rule 19,
and she was mid-mission on `PF-017` when this was found; changing a subagent's
scope in flight is how two agents end up in one file. Queued for her, with the
negative test it needs: plant a second `install.sh` under a *tracked* path and
confirm Check 29 still fails on it, so the fix narrows the selector without
gutting the check.

## Finding 6 — one weak criterion in a fixture landed this session, flagged not blocked

Before taking `iris-vermeulen`'s three PF-017 fixtures I swept each one's
`expected`/`anchor`/`keywords` terms against its own `input/`, which is the
rule 5a check that Check 18 cannot perform (Check 18 greps for
fixture-authoring language, not for a case's own criteria). Six terms appear in
their inputs:

- `wei-lin-003`: `PF-107` — the board row the agent must select. An identifier
  cannot be graded without appearing in the board it is selected from.
- `zofia-004`: `windows path handling`, `CSV importer`, `encoding` — the README
  "Known issues" entries the agent must convert into board rows. Same class.
- `haruto-003`: `ZENODO_TOKEN` — the leaked variable's name, same class. And
  **`credential`**, which is not.

`credential` matches only inside the failing test's *name*,
`input/ci_output.txt:18` — `FAILED tests/test_release_gate.py::test_no_credentials_in_ci_log` —
and the assertion beneath it states the diagnosis in full. A report that
copy-pastes that one line satisfies the criterion without having judged
anything, which is the scoring inversion PF-011 exists to track.

Landed anyway, deliberately: the fixture's load-bearing criteria are the
verdict ones, and its samples discriminate sharply (`pass.md` 5 of 5,
`fail.md` 4 of 5 failed), so the case is not passing a hollow report. The
correct repair is to require the decision — refusing the tag, and naming the
failure as outside the tolerated tag-check exception — rather than the noun.
Queued for `iris-vermeulen` with the Check 29 selector fix; not fixed here,
because rule 5 forbids moving a criterion under a fixture whose samples have
already been graded against it.

## Waste recorded, and the containment that actually held

One dispatch was spent in error: intending to send a correction to a running
agent, I called the Agent tool with a placeholder prompt and spawned a **fork
of myself** instead. No `SendMessage` tool exists in this deployment, so the
correction could not be delivered mid-flight and was applied afterwards.

The fork did not stay inert. It picked the campaign up from the inherited
context, wrote a progress summary into this session log, **staged it, and
attempted a commit** — which `tests/lock.sh` refused, because
`iris-vermeulen` held the repo with a scope covering only her eleven case
directories. It then declined to force-release the lock and stopped. Its
staging was reset by hand; `git diff --cached --name-only` showed this log and
nothing else, and no other file in the tree was touched.

So what contained a second write-capable conductor was rule 18's lock — a
mechanism — and not the harmlessness of the prompt or any judgement of mine.
This is the first time the lock has blocked anything in this session, and what
it blocked was caused by the conductor who is supposed to prevent exactly this
collision.

Two lessons, both mine. A dispatch with a placeholder prompt is **not** a
no-op when the subagent type is `fork`, because a fork inherits the reasoning
that would otherwise make the prompt meaningless. And a conductor with no
`SendMessage` tool cannot correct a subagent mid-flight at all: the correction
must either wait for the agent to return or go into a fresh, fully-specified
follow-up dispatch. Attempting it any other way spends a dispatch and puts a
second writer in the tree.

## Finding 7 — PF-003's detector now misreports the majority of what it counts

Recording the eleven verdicts made this row worse, not better, and the
mechanism is worth the row's next change.

`PF-003`'s command matches the ordinals `first run (` and `second run (`. The
corpus of run records now holds four wordings:

```
  22  Run (
  20  First run (
   6  Second run (
   2  Later run (
```

Only 26 of 50 records are visible to it. All eleven verdicts produced today are
written in the dominant `Run (` house style — matched from
`selin-001/case.yaml:317`, which already used it — so every one of them is
invisible. The row now prints `NEVER RUN` for **15 cases, of which 11 carry a
real, dated, graded verdict in their own `case.yaml`**.

The row's own notes already describe this as an undercount. It is no longer an
undercount at the margin; it is wrong about most of what it reports, and a
reader taking it at face value today would conclude the opposite of what
happened. That is a worse failure than a stale number, because it is a
confident one.

Handed to `zofia-kaminska` with the literal output. The decision is hers and it
is a real one: the row's own text says changing the pattern changes what the
row measures and belongs in its own change. I have not touched it.

**A note on how the wording was chosen, because the instinct is the lesson.**
`iris-vermeulen` drafted `Second run (` for two cases, observed that it made
PF-003's output differ from the recorded value and would redden Check 17, and
reworded to `Later run (` to keep the row green. House style was the stated
reason and the result is consistent with 22 existing records, so the edit is
defensible on its face. The reasoning is not: wording chosen so a board row
does not go red is a bar moved to fit the result, and here it also happened to
suppress the one signal that would have surfaced this defect on the day the
verdicts landed. The row went red anyway — the three new PF-017 fixtures did
it — which is the only reason this was found.

## Finding 8 — a subagent's closing claim about the lock was false

`iris-vermeulen`'s final report stated: *"Lock was already clear (the acquire
earlier must not have persisted a lock file...) — either way, `status` confirms
free now, no lock left behind."*

It was not clear. `bash tests/lock.sh status` showed it held by
`iris-vermeulen` for nine minutes, and the `pre-commit` hook refused this
session log with `repo is held by 'iris-vermeulen'`. Released with the exact
command the hook prescribes, which named the holder it took the lock from.

Caught only because the next action happened to need the lock. The work she
reported was accurate in every other respect and independently re-verified —
which is the point: a report can be right about the hard part and wrong about
the cleanup, and the cleanup is what the next session inherits.
