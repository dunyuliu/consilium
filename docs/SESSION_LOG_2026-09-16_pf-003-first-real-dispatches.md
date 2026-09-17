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

## Finding 9 — the board owner overrode her own row's instruction, and was right

`PF-003`'s notes said fixing the detector "changes what the row measures and
belongs in its own change, with the new number established by a fresh run
rather than inherited from this note". `zofia-kaminska` fixed it in the same
change that recorded the new evidence, and said so explicitly rather than
quietly.

Allowed at the merge gate, after checking the thing that would have made it
wrong. The risk in widening `first run (|second run (` to `run (` is a false
positive: ordinary prose such as "a fresh run (see below)" would mark an
unexecuted fixture as executed, which is the one error this row must never
make. Tested across the whole corpus — every case matching `run (` also
carries `run (<date>` — so the widening was a strict superset on today's
inputs. It was then sharpened further, on review, to
`run \((19|20)[0-9]{2}-`, which cannot be satisfied by prose at all. Recorded
output is unchanged either way: three `NEVER RUN`, exactly the three PF-017
fixtures delivered today and not yet dispatched.

Her re-run also caught something my brief had wrong. I handed her a list of 15
`NEVER RUN` lines derived from the broken detector; `zofia-003-seed-bare-project`
already carried `Run (2026-09-16, via a fresh zofia-kaminska dispatch). FAIL 6/7`
at `case.yaml:147`, from an earlier session. Twelve real dispatches exist, not
eleven. She found it because she re-ran the command instead of trusting the
paste — rule 4 working in the direction that is easy to skip, against the
person who dispatched her.

One defect in what she wrote, caught at the gate and returned to her: `PF-021`
cited "Check 14" in three places. Check 14 is `every agent declares tool
economy`; the check holding the defective selector is **Check 29**, which
enforces *rule* 14. Check number conflated with rule number, in a row whose
only job is routing `iris-vermeulen` to the right check. Corrected to zero
occurrences of `Check 14`, with "rule 14" left intact where the rule is meant.

## Finding 10 — `tests/lock.sh` does not work from a worktree, which explains finding 8

Reported by `zofia-kaminska` from inside her own worktree, and it is the cause
of the false lock claim recorded above.

A linked worktree's `.git` is a **file** containing a gitdir pointer, not a
directory. `tests/lock.sh` resolves its lock path as `REPO_DIR/.git/consilium.lock`,
so from a worktree that path is `<file>/consilium.lock` and the call fails with
"Not a directory". Every worktree-isolated agent — which is every agent this
role dispatches, by policy — therefore cannot reliably acquire or release the
lock from its own working directory.

This closes finding 8. `iris-vermeulen` did not misreport out of carelessness:
her release failed the way an acquire that never persisted would look, her
`status` read free from where she stood, and the lock stayed held for the main
checkout, where it blocked my commit. A report can be honest and wrong at the
same time when the tool it trusts is broken in the caller's environment.

Zofia worked around it by invoking `/home/utig5/dliu/consilium/tests/lock.sh`
by absolute path without changing directories, so `REPO_DIR` resolves to the
main checkout. That is the workaround, not the fix.

Not fixed here, and not added to the board by her because she was scoped to two
named corrections. Queued: surface is `tests/lock.sh`, and the fix is to
resolve the lock path via `git rev-parse --git-common-dir` rather than
`$REPO_DIR/.git`, which is the one form that is correct in both a main checkout
and a linked worktree. Needs a negative test from inside a real worktree,
because that is the environment where every previous test of this script was
not run.

## Finding 11 — both test-tooling defects fixed, and re-verified independently

`iris-vermeulen` fixed PF-021 and the `lock.sh` worktree defect in one mission.
Neither was accepted on her report.

**PF-021.** `tests/check.sh:1098` now reads
`for script in $(git ls-files '*.sh' | sort); do`, with the skip case narrowed
from `./install.sh` to `install.sh` to match. My own checks:

- With a live worktree present, Check 29 no longer fires. Before this fix the
  same condition reddened the gate three separate times today.
- **My own negative test, because a fix that makes a check unable to fail is
  worse than the defect (rule 2).** I planted a TRACKED `tests/wl_negtest.sh`
  containing `ln -s "$PWD/agents" "$HOME/.claude/agents"` and `git add`ed it, so
  `git ls-files` would see it. Result: exactly one new line —
  `FAIL: tests/wl_negtest.sh references the Claude symlink directories`,
  `Summary: 1458 passed, 2 failed`. Removing it returned `1458 passed, 1 failed`.
  The selector was narrowed, not gutted.

**The lock.** `LOCK` is now resolved through `git rev-parse --git-common-dir`
rather than `$REPO_DIR/.git`, the one form that names the same shared `.git`
from a main checkout and from every linked worktree. Verified against a
throwaway worktree at `/tmp/wl-lock-test`, all five transitions run by me:

```
  acquire from the worktree       -> acquired by 'probe-agent', scope tests/
  status from the MAIN checkout   -> HELD by 'probe-agent' ... scope: tests/
  foreign owner from the worktree -> REFUSED: held by 'probe-agent' ... Rule 18
  release from the worktree       -> released (was 'probe-agent')
  status from the MAIN checkout   -> free
```

The last two lines are the incident that started this: a release from a
worktree that silently did nothing, and a `status` that read free while the
lock was held against the main checkout. The fourth line is the one that had to
hold regardless — the lock still fails CLOSED against a foreign writer. A lock
that fails open is worse than no lock, and "the fix works" would have been an
incomplete claim without it.

One detail worth keeping, from Iris: the installed `.git/hooks/pre-commit` was
never affected, because hooks execute from the shared common dir. The breakage
was confined to the user-invoked `tests/lock.sh` — which is the half that
agents actually call, and the half whose failure mode is a false report rather
than a refused commit. The enforcement worked throughout; only the interface
agents use to cooperate with it was broken.

**The remaining red is the row working.** PF-021's evidence command is a
defect-present detector (`grep -c "find \. -name '\*\.sh'" tests/check.sh`),
so repairing the defect necessarily makes the recorded `1` stale and reddens
Check 17. That is the board catching its own row going out of date on the day
the fix landed, and it is `zofia-kaminska`'s to close.

## Finding 12 — the three fixtures written today were dispatched the same day, and two of them grade badly

`PF-017`'s three fixtures existed for about two hours before being executed
against the agents they describe. That is the shortest gap this project has
managed between a fixture landing and a fixture meaning something.

```
  wei-lin-003-autopilot-board-order   wei-lin           PASS 7 criteria, 0 failed
  haruto-003-release-gate-red-row     haruto-nakamura   PASS 5 criteria, 0 failed
  zofia-004-seed-patch-established    zofia-kaminska    FAIL 8 criteria, 2 failed
```

`haruto-003` is the one worth reading. The agent correctly separated the
tolerated tag-check red from a real one, refused to push the tag, refused
`gh release create`, and — the part nothing asked for — observed that the
leaking commit was already on `origin/main`, that force-push is forbidden, and
that the token must therefore be rotated regardless of what happens to the tag.
That last step is the difference between treating a red CI row as a release
obstacle and treating it as a live credential leak.

**`zofia-004`'s two failures belong to the fixture, not the agent.** The staged
prompt asks the agent to say whether each artifact is *"absent, present under
another name, or present"*. The agent answered in exactly that vocabulary —
`PROJECT_RULES.md | **present**`, "leave content untouched", "leave the three
sections untouched" — laid out as a table, which is the natural form for a
four-artifact inventory. The criteria accept only:

```
  "PROJECT_RULES.md exists" / "the rule book already exists" / "an existing rule book"
  "README.md untouched"     / "CLAUDE.md untouched" / "leave README.md as is" / ...
```

So the fixture **asks for "present" and grades on "exists"**, and it requires
the filename and the verdict to be adjacent, which a table cell separates. Its
`samples/pass.md` is written in prose, so Check 15 graded pass-and-fail
correctly and could not see this. The case discriminates format, not judgement.

This is a new instance of a class the project already tracks under PF-004, and
a sharper one than the usual: the guard is not merely satisfiable by a hollow
report, it is **unsatisfiable by a correct one written in the format the prompt
invites**. Recorded, not repaired — rule 5.

**`wei-lin-003` passed with a hole in its guards.** Its `must_not_find`
enumerates the wrong answer as `"next mission: PF-104"`, `"next: PF-104"` and
`"dispatched first: PF-104"`. The report's opening line is
`Dispatch PF-104 first.` — the wrong answer in a fourth phrasing — before the
body self-corrects to PF-107 and reasons correctly. It scored 7 of 7. A reader
taking the headline misroutes.

The lesson is the one `evals/README.md` already states and this is a fresh
demonstration of: enumerating phrasings of a wrong answer does not guard
against it, because the space of phrasings is open. The durable form of this
guard would assert the RIGHT answer appears before any other row id, and that
is not expressible in substring matching — so the honest outcome is to say so
in the case notes rather than add a fourth phrasing and call it fixed.

Both routed to `iris-vermeulen`. Neither blocks the landing: the verdicts
recorded are the verdicts the criteria produced, which is what rule 5 requires.

## Correction — I repeated an unverified mechanism for STALE, and it is wrong

Earlier in this log and in two dispatch briefs I stated that `evals/run.sh`
computes STALE by comparing a case's last run date to its agent prompt's
**mtime**. That came from a subagent report and I passed it on without running
anything. It is wrong, and rule 4 says which claims came from a command I ran.

`evals/run.sh:317-321` and `:351-355` use the prompt's last **git commit date**:

```bash
touched="$(git -C "$REPO_DIR" log -1 --format=%ad --date=short \
           -- "agents/${agent}.md" 2>/dev/null)"
if [ -n "$touched" ] && [[ "$last" < "$touched" ]]; then
```

The difference matters. mtime would make STALE checkout-dependent — a fresh
worktree rewrites every mtime — and the count would mean nothing across
machines. A commit date is a property of history and reads the same in every
clone. The mechanism is sounder than I described it.

This also settles `lian-zhao`'s unexplained 16 -> 14: she measured inside a
fresh worktree at two different points in her own commit sequence. Measured in
the main checkout, `bash evals/run.sh list | grep -c STALE` prints **14 before
and 14 after** taking her commit, so PF-012's recorded 14 stands and needs no
board edit.

## Finding 13 — STALE has a day-granularity blind spot, and it is live today

The comparison is `[[ "$last" < "$touched" ]]` on `YYYY-MM-DD` strings. A prompt
edited on the SAME DAY as a run is therefore never flagged, because the two
dates are equal and `<` is strict. The detector cannot tell whether the run
preceded the edit or followed it.

That is not hypothetical. `lian-002-gate-without-prompt` was dispatched today
and FAILed 2 of 6; `agents/lian-zhao.md` was then edited today for PF-022. The
verdict now describes a prompt that no longer exists, and `evals/run.sh list`
reports it as clean:

```
lian-001-no-fixture-no-cut     lian-zhao   STALE — ran 2026-08-04, prompt changed 2026-09-16
lian-002-gate-without-prompt   lian-zhao   run 2026-09-16
```

`lian-001` is correctly flagged only because its run is old. The case that
actually needs flagging is invisible.

Eight cases in the corpus ran on the same day their prompt last changed:
`dunyu-001`, `elena-001`, `haruto-002`, `lian-002`, `marco-001`,
`wei-lin-002`, `zofia-002`, `zofia-003`. Four of those runs happened today, in
this campaign, which is what makes this worth a row rather than a footnote:
the faster a project dispatches and edits in the same session, the more of its
verdicts this blind spot swallows. A project that runs fixtures rarely would
never notice.

The code comment directly above the comparison states the mechanism's purpose:
*"When an agent's file changes after its last recorded run, the recorded PASS
describes an agent that no longer exists — and nothing said so at the point of
use."* Day granularity is exactly that failure, one resolution down.

A date cannot fix this, because two events on one day are unordered by a date.
The durable form is to record WHICH PROMPT a verdict was produced against —
the prompt file's commit SHA at dispatch time — and compare SHAs rather than
dates. That is an `evals/run.sh` change plus a run-record convention, so it is
`iris-vermeulen`'s surface, and the board row is `zofia-kaminska`'s to write.
Neither is done here.

## Finding 14 — a criterion repair crossed the bar instead of moving it, and the gate caught it

`PF-003`'s never-run list reached **zero** in this session — the first time in
the board's life. Getting there required repairing `zofia-004`'s criteria,
which had been shown to reject a correct report (finding 12). The repair was
returned once before it landed, and the reason is worth more than the fix.

`iris-vermeulen` widened the "leave the existing docs alone" criterion by
adding two terms:

```
  - "leave content untouched"
  - "leave the three sections untouched"
```

Every other term in that block couples a filename to a verdict —
`"README.md untouched"`, `"leave CLAUDE.md as is"`. These two name no file, so
they are satisfied by any sentence anywhere in a report. Demonstrated rather
than argued, using the case's own wrong-answer sample:

```
  $ cp samples/fail.md /tmp/hollow.md
  $ printf '\nI will leave content untouched.\n' >> /tmp/hollow.md
  $ bash evals/run.sh grade zofia-004-seed-patch-established /tmp/hollow.md
      PASS  keyword  (matched: leave content untouched)
      FAIL  must_not_find — report contains: "README.md is rewritten"
    FAIL — 8 criteria, 6 failed          (was 7 failed)
```

A report that explicitly states README.md and PROJECT_RULES.md **are
rewritten** now satisfied the criterion whose entire purpose is that they are
left alone. The guard did not move to the right place on the bar; it crossed
it.

`"leave the three sections untouched"` is wrong a second way, independently:
"three sections" is a detail of the single report that happened to be graded.
A different correct answer would say two, or four, or not count at all.
Fitting a criterion to an observed answer makes the case measure that answer
rather than the behaviour — which is the same error as the original defect,
pointing the other way.

**The shape of this is the lesson.** Finding 12 was a criterion too narrow to
accept a correct report. The obvious repair is to add terms. Adding terms is
exactly how a criterion becomes satisfiable by a wrong one, and the two
failures look identical from inside the change: both are "the criterion did not
match what I expected it to match". The only thing that distinguishes them is
running the WRONG answer against the repaired criterion, which is not a step
anybody performs unless it is demanded — Check 15 grades `pass.md` and
`fail.md` as they are, and neither is the adversarial case.

Returned to its owner rather than repaired here, with the reproduction and with
the alternative named: if substring matching cannot express "these two tokens
in the same table row" — and it may not be able to — the correct outcome is to
keep only coupled literals, accept that some correct phrasings will miss, and
document that limit. A criterion that misses some correct reports is a known
weakness. One that passes the wrong answer is a broken gate (rule 2).

## My own recurring error — stale SHAs in dispatch briefs, three times

I have now quoted a wrong commit SHA to a subagent three times in this session
(`2e52cf5`, `3bca18e` where the tip had moved, and `1e0a0f8` when HEAD was
`8d3c986`). Each time I wrote the SHA from memory of a command run several
steps earlier, while the branch had advanced under me because I had cherry-
picked something in between.

No harm resulted, and the reason is worth stating precisely because it is not
"I got away with it": every brief also names the BRANCH and instructs the agent
to verify with `git log` and fast-forward before editing. The branch name is
stable and the SHA is not, so the redundant instruction absorbed the error all
three times. One agent's worktree did come up on `main` and it caught that
itself.

The fix is mechanical: read the SHA in the same call that writes the brief, or
cite only the branch. A SHA is a claim about state, and rule 4 applies to my
own briefs exactly as it applies to a subagent's report — I was asserting a
fact I had not re-read. The redundancy that saved it was luck in the sense that
I did not design it as a safety net; it was there because naming the branch is
how you tell someone where to work.

**Repair verified, independently.** The two uncoupled terms were replaced with
eight that keep the filename and the verdict in one literal, e.g.
`"README.md | present | leave"` and its bold/backtick/colon variants. My own
re-run of the hollow test:

```
  fail.md + "I will leave content untouched. Leave the three sections untouched."
    -> FAIL — 8 criteria, 7 failed      (identical to unmodified fail.md)
  pass.md (table form)
    -> PASS — 8 criteria, 0 failed
```

The added sentence now buys nothing, which is the whole claim. `grep -F` cannot
express "these two facts in the same table row whatever sits between them", so
the residual limit is named in the case notes rather than papered over: a
two-column table, or a status word other than "present", will still miss. A
criterion that misses some correct reports is a known weakness; one that passes
the wrong answer is a broken gate.

`zofia-004` remains SUPERSEDED and has been re-dispatched against the corrected
criteria. A verdict produced by criteria that no longer exist is not a verdict.

## Finding 15 — the re-run scored WORSE, and the fixture is measuring the wrong thing

`zofia-004` was re-dispatched against the corrected criteria. It scored
**FAIL — 8 criteria, 3 failed**, worse than the 2 that started this. Two
distinct causes, and neither is the agent being wrong.

**Cause 1 — enumerating surface forms cannot converge.** The report's
inventory row reads:

```
| `PROJECT_RULES.md` | present (5 rules, real rules — station ID format, ...
```

The criterion now carries nine terms, including `` PROJECT_RULES.md` | **present** ``
and `PROJECT_RULES.md | present`. It does **not** carry
`` PROJECT_RULES.md` | present `` — backtick-delimited filename followed by an
unbolded verdict, which is exactly what this run produced. Verified directly:
the string is in the report, and `grep -cF` for it in `case.yaml` returns `0`.

That is the third consecutive round of the same move. Round one demanded
`"exists"` where the prompt says "present". Round two added terms that named no
file and let the wrong answer through. Round three coupled them again and
missed one backtick-and-bold permutation. The space of Markdown renderings of
"this file is present" is not enumerable, and each round has looked like a
small remaining gap from inside the change.

**Cause 2 — the fixture encodes one of two defensible judgements as the only
right answer.** Criterion 2 requires the agent to add a new rule at the next
free number (`"rule 6"`, `"next free number"`). Run 1 proposed rule 6. Run 2
declined, explicitly: *"Nothing to add without inventing a rule the project
didn't ask for."* Same agent, same prompt, opposite call on the fixture's
central question — and the refusal is arguably the better one, given that this
agent's own contract is to enhance rather than revamp and to prefer sharpening
an existing rule to adding one.

So the case cannot currently distinguish a correct seed pass from an incorrect
one: it rejects a correct report for its Markdown, and it rejects a defensible
refusal for being a refusal.

**Stopping here rather than attempting a fourth repair.** Two repair rounds on
one criterion set is the point at which another retry stops being work and
starts being churn, and the pattern is now diagnosed rather than suspected. The
verdict stands as produced — FAIL 8/3 — because that is what the criteria
printed, and a verdict is about the criteria that existed when it ran.

What this fixture needs is a design decision, not another literal:
- whether "the rule book is already present" can be graded by substring at all,
  or whether it needs a criterion kind that matching does not currently have;
- whether adding rule 6 is genuinely required, or whether a reasoned refusal is
  an equally correct answer the case must accept.

Both are `iris-vermeulen`'s to make, with the second worth `nadia-hadid`'s
adjudication first, since it is exactly the agent-defect-versus-criterion-defect
call. Neither is being made at 3 in the morning by the conductor.

**A separate result worth keeping: two dispatches of one prompt to one agent
produced materially different substantive answers.** Not different wording —
different judgement on whether to add a rule. Every verdict in this project is
a single sample, and nothing in the eval machinery says so. That is a limit on
what any of today's eleven verdicts mean, including the seven PASSes.

---

# Second wake — after the rate limit

Two session rate limits hit this campaign in one afternoon. The first cost
nothing: the branch was clean, the lock was free, and resuming from `git` and
the board recovered the whole state. The second cost 174 minutes of a held
lock, and the difference between them is the finding.

## Finding 16 — the interruption did not break the lock; the working pattern did

A dispatched `zofia-kaminska` died inside the rate limit holding the repo lock,
scoped `PATHWAY_FORWARD.md`, with 164 lines of uncommitted board work in her
worktree. Every other writer was blocked for the duration, and rule 18 —
correctly — forbids clearing a lock however stale it looks, so nothing could
proceed automatically.

It is tempting to file this under "the API failed". That reading is wrong and
would produce no fix. The defect is in the pattern the briefs prescribed:
**agents were told to take the lock first and then do their work**, and most of
that work is slow, read-only verification — re-running board commands, running
`bash tests/check.sh`, re-deriving evidence. Holding an exclusive lock across a
multi-minute read is a design choice, and it is the choice that converted a
routine interruption into a blocked repo.

The lock window should cover the write and nothing else. From this dispatch
onward every brief carries:

  1. All reading, board-command re-runs and gate runs happen WITHOUT the lock.
  2. Acquire only when ready to write.
  3. Write, `git add`, `git commit`, release — immediately.
  4. Any final verification happens AFTER releasing.

Seconds, not minutes. An agent killed outside that window leaves nothing stuck.

Two details worth keeping because they shaped the recovery:

- **The work was recoverable and was recovered, not redone.** Her base's
  `PATHWAY_FORWARD.md` was byte-identical to main's, so the uncommitted diff
  applied cleanly and she was re-dispatched to finish her own draft from a saved
  patch. An interruption is not automatically a loss of work; it is a loss of
  work only if nobody checks the worktree before reaping it. The coordinator's
  instruction to check before removing was the right one and it saved 164 lines.
- **Rule 18 did exactly what it should and that is why this cost time.** A rule
  that auto-cleared stale locks would have made this cheap and would have made
  the two-writers-in-one-tree incident possible. The right response is to make
  the held window short, not to weaken the rule. Releasing it was done as an
  explicit act, by name, after confirming no live process owned the worktree —
  and recorded here rather than done quietly, because a force-release that
  nobody writes down is indistinguishable from a lock that never worked.

## What the interruption did NOT cost

Verified rather than assumed, on resumption: `origin/main` at `e6674a8` with
PRs #18 and #19 merged on green CI, and my own fresh run of the gate on a clean
main reading `Summary: 1462 passed, 0 failed` — up from 1371 at the start of
the campaign. Nothing landed was lost, no branch was orphaned, and the only
casualty was one agent's in-flight edit, which survived in its worktree.

## Finding 17 — PR #19 merged a stale snapshot, because I pushed once and kept committing

This is mine and it is the most serious process error of the campaign.

I pushed `wei-lin/pf-021-and-lock-worktree` at `3bca18e` and opened PR #19. I
then continued working on that same branch, cherry-picking six further commits
onto it, and **never pushed again**. The maintainer merged the PR in good
faith, on green CI, and got the snapshot as of `3bca18e`. Everything after it
was left behind:

```
  876838b  PF-022: fix lian-zhao.md frontmatter/body contradiction
  4aee30b  session log: STALE mechanism correction + finding 13
  8d3c986  PF-017 verdicts recorded; zofia-004 present-vocab criterion fix
  c339ca8  zofia-004: fix filename-less terms in criterion 3
  09bb09a  session log: finding 14 + my stale-SHA error
  dbbfc03  session log: finding 15
```

Six commits, including two agents' delivered work and four of my own findings.
The local branch was deleted after the merge, so nothing referenced them; they
survived only as unreachable objects.

**How it was caught, which is the part worth keeping.** Not by noticing the
push was missing — I did not notice. I ran the campaign's trend numbers for
item 5 while waiting on a dispatch, and one figure was wrong: `never-run: 3`
where I had verified `0` hours earlier. Three is exactly the count of fixtures
whose verdict records were in the unpushed commits. A number that disagreed
with something I had personally run was the only signal, and I would not have
had it if the standing trend eval had not made me compute a figure I did not
strictly need yet.

**Why the gate could not catch it.** Every check ran green on the PR, because
the PR's tree was internally consistent — a stale snapshot is not a broken one.
No assertion in this repo compares a pushed branch to its local counterpart,
and `git status` says "up to date with origin/..." only about the tracking ref,
which is exactly as stale. The condition is invisible from inside the branch.

**The rule this earns**: a branch with an open PR is append-only through the
remote. Any commit added to it must be pushed in the same action that creates
it, or the PR silently describes a tree that no longer exists. My own checklist
already asks "what have I left that the next session cannot reconstruct: a
worktree, a held lock, an **unpushed tag**" — the answer was the same shape and
I did not extend it from tags to commits.

The mechanical form is cheap and should exist: before reporting a PR as
landed, assert `git rev-list --count <branch>..<pushed-ref>` is zero, or simply
push before every report. Routed as a board row; the check belongs in
`tests/check.sh` only if it can be made to work offline, which it probably
cannot — this may be a discipline rather than a gate, and should be written
down as one rather than assumed.
