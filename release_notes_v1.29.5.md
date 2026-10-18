# Release notes — v1.29.5 — 2026-10-18

## 1. Version and date

v1.29.5, cut 2026-10-18, patch bump over v1.29.4 (`19dd3a7`, 2026-10-17).
Patch because the range adds no new agent and no new command — six commits
refining three existing prompts' lessons/rules, two new fixtures, one board
re-verification pass, and the stale `CITATION.cff`/`README.md`/
`docs/user/citing.md` version strings, plus this release's own audit pass.

## 2. Summary of scope

Six commits since v1.29.4, all already merged to `main` (`19dd3a7..ba8f093`):

- `d98fa1b` (#158): `release_notes_v1.29.4.md` — transcribe v1.29.4's own
  final CI run and release-gate rows (docs-only, post-tag follow-up).
- `87dce8e` (#159): the invoking session's own board commit is a relayed
  directive's citation, never circular (`wei-lin`); parallel briefs reserve
  numbered-file numbers (`wei-lin`); a completion notice older than the run
  is checked against the default branch, never re-queued (`wei-lin`);
  `zofia-kaminska`'s description says moving, deleting or pruning files and
  writing scripts go to another agent.
- `bce9b5a` (#160): `wei-lin`'s handoffs and status reports open with the
  phase table; worktrees link only named read-only inputs, outputs and
  databases are copied; the owner's board cap replaces the two-specialist
  default, throttled below only on an observed 429; a failing test to clear
  is a diagnosis and a red or unlanded general-purpose mission goes to the
  specialist. New fixture `wei-021-own-board-commit-cites`.
- `44ddc01` (#161): `iris-vermeulen` treats a brief's heavy-run count as a
  cap and locates an offender with targeted subsets, keeps the ~120-call
  stop mid-diagnosis, waits on the launch PID never `pgrep -f` (recurrence,
  fixture-eligible), and reproduces an environment-state failure in that
  state before any probe, reporting "not reproduced" rather than landing a
  fix from code reading.
- `de076cb` (#162): rule 10 fixture `iris-003-wait-on-launch-pid` carries
  the second fix for the launch-PID recurrence; a builder's misread stop
  line on resume dismissed as covered; waiting on host load before a
  sub-minute job deferred. Board rows 6, 21, 23, 24 re-run green (dates
  only — no row content, state, or command changed).
- `ba8f093` (#163): inbox handles probes on network mounts run under a
  timeout, never backgrounded (`zofia-kaminska` reads a live cwd via
  `readlink`; hung `lsof`/`fuser` were left across projects); parallel
  briefs give each agent its own scratch subfolder and queue heavy runs
  behind one shared `flock`; a failure blamed on a build flag is first
  rebuilt from a fresh clone at the same flags, each test build recorded
  clean or incremental (`wei-lin`). Usage flag deferred, one run.

This release's own contribution: the audit pass (`victor-reyes` plus a
scoped `kai-fischer` conciseness pass), bumping
`CITATION.cff`/`README.md`/`docs/user/citing.md` from 1.29.4 → 1.29.5, this
note, and the archive move.

## 3. Files added / removed / renamed / cleaned up

**Added**: `release_notes_v1.29.5.md` (this file);
`evals/cases/wei-021-own-board-commit-cites/` and
`evals/cases/iris-003-wait-on-launch-pid/` (each `README.md`, `case.yaml`,
`input/RUN_LOG.md`, `samples/fail.md`, `samples/pass.md`) — landed by
#160/#162, structurally sound (no symlink, no leaked answer key in
`input/`, both samples grade as labelled) per this release's audit, but
each carries a guard flaw — see §5.

**Removed**: nothing.

**Renamed**: `release_notes_v1.29.4.md` (repo root) →
`docs/release_notes_v1.29.4.md` (rule 8 — archived verbatim, content
unchanged).

**Modified** (by the six already-merged commits, #158-#163):
`release_notes_v1.29.4.md` (pre-archive, by #158, its own post-tag
transcription); `agents/iris-vermeulen.md` (8-line diff),
`agents/wei-lin.md` (18-line diff), `agents/zofia-kaminska.md` (4-line
diff, frontmatter `description` only); `docs/lessons_ledger.md` (append,
+22 lines); `PATHWAY_FORWARD.md` (rows 6, 21, 23, 24 re-dated, no content
change).

**Modified by this release**: `CITATION.cff`, `README.md`,
`docs/user/citing.md` — version `1.29.4` → `1.29.5`, date `2026-10-17` →
`2026-10-18` (all three, per rule 19 — `anya-petrov`'s surface, actioned
here per the release trigger's explicit instruction, same as v1.29.4).

## 4. Content updates to master documents

`PATHWAY_FORWARD.md`: rows 6, 21, 23, 24 re-run and re-dated to
`2026-10-18` by #162; no row content, state, priority, or command changed
— confirmed by `git diff 19dd3a7..HEAD -- PATHWAY_FORWARD.md` (4 one-line
date substitutions only) and the board-row tally in §10 (13 VERIFIED, 22
RETIRED, 0 BROKEN, 0 blank `last-checked`, identical before and after).
`PROJECT_RULES.md` and `CLAUDE.md` unchanged this range.

## 5. Audit findings and fixes

`victor-reyes` was dispatched on `19dd3a7..HEAD` (Agent-tool access
available, no sub-specialist dispatch needed — the range is small, prose
and fixture YAML only, no code logic). **Verdict: safe to release as a
patch.** 0 Critical. Direct inspection confirmed: `bash tests/check.sh`
green (1405 passed, 0 failed at HEAD, pre-release-commit), the
`agents/`+`commands/` net-0 claim true by direct count (5752 → 5752,
unchanged) across #159-#163, and no leaked personal name, host, or
absolute path in anything that ships (the `dunyu-liu` code-name and the
`Liu, Dunyu` CITATION/citing author line remain the established
carve-outs).

`kai-fischer` ran separately, scoped to the touched lines of
`agents/iris-vermeulen.md`, `agents/wei-lin.md`, `agents/zofia-kaminska.md`
(read-only, no edits). Net line-delta confirmed 0 (every touched hunk a
1:1 line replacement). One cut-able redundancy found — see finding 8
below.

**Findings (0 Critical, 3 Medium, 4 Minor, 1 Low)**:

| # | Severity | Location | Issue | Disposition |
|---|---|---|---|---|
| 1 | Medium | `evals/cases/wei-021-own-board-commit-cites/case.yaml` (`must_not_find: "i send the draft"`) | Fails a correct report: a report answering "Do I send the drafted reply? No." is a first-person claim about the subject, not the rule-25 "verdict line" form, and trips the guard. | Deferred — `evals/cases/*` is `iris-vermeulen`'s surface (rule 19). |
| 2 | Medium | `evals/cases/iris-003-wait-on-launch-pid/case.yaml` (`must_not_find`) | Same flaw: a correct report ("Do I run the drafted loop as written? No.") trips the guard `"the drafted loop is fine"`. | Deferred, same owner. |
| 3 | Medium | `agents/wei-lin.md:52` vs `agents/wei-lin.md:266` | The new owner-board dispatch-cap override at line 266 ("the cap the owner's board sets") is not reflected in rule 1's cap statement at line 52 ("background only a parallel pair"), so a conductor can quote line 52 to stay at two after the owner raised the cap — the exact #160 ledger failure shape. | Deferred — `agents/*.md` is `lian-zhao`'s surface. |
| 4 | Minor | `agents/wei-lin.md` cost paragraph (~line 81) | The new stale-completion-notice check names `git branch -r --contains <SHA>` first; a squash-merged commit (this project's own merge policy, rule 20) will not be found by that command, so the check can false-negative "not landed" on exactly the merge shape this repo uses. "or its PR" partially saves it. | Deferred, same owner. |
| 5 | Minor | `agents/zofia-kaminska.md:3` | Frontmatter `description` now says she "writes the rule book, the board **and the gate check it seeds**," in the same sentence that says "writing scripts go to another agent" — a gate check is a script. | Deferred, same owner. |
| 6 | Minor | process, not content | Rule 10 ("fixture first or in the same commit") was not followed for either new fixture: `wei-021`'s fix landed in `87dce8e` with its fixture one commit later in `bce9b5a`; `iris-003`'s fix landed in `44ddc01` with its fixture one commit later in `de076cb`. No shipped-content impact — both fixtures exist and are structurally sound (findings 1-2 aside). | No action this release; the rule-book owner (`zofia-kaminska`) may want to record this as a recurring soft-miss. |
| 7 | Low | `docs/release_notes_v1.29.4.md` ("Pre-tag fresh-clone check" paragraph, landed pre-archive by `d98fa1b`) | States README's literal `git clone` "produces a shallow, tag-less clone" — a plain `git clone <url>` is a full clone including tags, so the stated reason for 1285-vs-1366 passes in that note is likely wrong; the real cause is unverified. | **Cannot be fixed**: `v1.29.4` is already tagged and released; rule 8 forbids rewriting a prior release note once superseded, and this note is being archived to `docs/` in this same release (§3). Carried forward as an open, uncorrectable-in-place defect — see §6. |
| 8 | Minor | `agents/iris-vermeulen.md:51` | "and the ~120-call stop holds mid-diagnosis" restates line 43's existing "Past ~120 tool calls, checkpoint (commit, notes) and stop" three lines above — the mid-diagnosis exception reads better as a clause on the existing sentence than a second statement of the same number appended to an unrelated bullet. | Deferred — `agents/*.md` is `lian-zhao`'s surface. |

No finding fell on a surface this release owns (release notes, version
files, tags) except finding 7, which rule 8 forecloses fixing in place.

## 6. Remaining open issues or pending items

- `iris-vermeulen`: `wei-021` and `iris-003`'s `must_not_find` guards each
  fail a correct report (§5, findings 1-2) — both are first-person
  negation forms rule 25's third guard layer (the "verdict line" form)
  would have caught before shipping.
- `lian-zhao`: `wei-lin.md`'s two-specialist cap is stated two ways that
  disagree (§5, finding 3); its stale-notice check's primary command
  misses a squash-merged commit (§5, finding 4); `zofia-kaminska.md`'s
  frontmatter description self-contradicts on who writes a gate check
  (§5, finding 5); `iris-vermeulen.md:51` restates `:43` (§5, finding 8).
- `zofia-kaminska`: rule 15a's body text and its own "How to apply" line
  still disagree on whether a tag is ever pushed separately from its
  Release — **confirmed untouched by this range** (`PROJECT_RULES.md` is
  not in the `19dd3a7..HEAD` diff); carried forward, still open, owner
  decision pending.
- `iris-vermeulen`: `wei-019`'s rewritten guard still does not match its
  own `fail.md` sample; `wei-020`'s third guard is still untested by
  either sample — **confirmed untouched by this range**; carried forward,
  still open.
- `docs/release_notes_v1.29.4.md`'s shallow-clone explanation is likely
  wrong and now uncorrectable in place (§5, finding 7) — recorded here
  rather than silently left for a future reader to trust.
- Carried from v1.29.3/v1.29.4, unresolved and untouched by this range:
  `docs/lessons_ledger.md` call-count disagreements for rows 10-13/10-14;
  `wei-017`'s criteria not yet forcing lars-eriksson-first ordering;
  `agents/zofia-kaminska.md:17`'s main-checkout test also trips a
  genuinely isolated fresh clone; `commands/autopilot.md:6`'s
  unreadable-budget default has no home in `agents/wei-lin.md` itself; the
  `v1.29.1` GitHub Release body still shows the pre-correction SHA.
- Rule 1b line ceiling (5754) has 2 lines of headroom, unchanged this
  release (`agents/`+`commands/` at 5752).

## 7. Totals or cost changes

`bash tests/check.sh`: 1368 passed, 0 failed (v1.29.4, re-run fresh at tag
`19dd3a7` in an isolated worktree) → 1405 passed, 0 failed (this release,
pre-release-commit HEAD). `agents/`+`commands/` line count: unchanged at
5752 (ceiling 5754, 2 lines headroom).

## 8. Assumptions used

- `victor-reyes`'s report was taken at face value for its direct-inspection
  findings (net-0 line count, no leaked path/name); this release
  independently re-ran `tests/check.sh` and the fixture-count comparison
  rather than trusting the report's numbers alone.
- `kai-fischer`'s single cut-able-redundancy finding was spot-checked
  against the diff itself (`agents/iris-vermeulen.md:43` and `:51`), not
  re-derived beyond that.
- The six already-merged commits (#158-#163) were taken as correctly
  reviewed at merge time (each green on CI individually — confirmed in
  §10); this release re-audits their cumulative effect since v1.29.4, not
  each PR's own review.
- Finding 7 (v1.29.4 note's shallow-clone claim) was not independently
  re-derived from scratch — this release confirmed the claim is
  *inconsistent with README.md's actual clone command* (no `--depth`/
  `--single-branch` flag), not what the true cause of the pass-count
  difference was.
- Per this project's leak-free instruction, CI and release references
  below are recorded by run id / tag / SHA, not by full host URL, and this
  note was grepped for absolute paths and personal names before every
  push.

## 9. CI run this release was gated on

**Process note.** `main` lands every release commit through a PR, same as
v1.29.1-v1.29.4; direct `git push origin main` was not attempted.

PENDING AT TIME OF WRITING — completed and transcribed into this same file
in a follow-up commit before the tag is created, per the v1.29.3/v1.29.4
precedent (`b1dcc86`, `d98fa1b`): the release branch's PR number, its
pre-merge CI run, the squash-merge SHA, the CI run on that merged SHA
(read and confirmed green before the tag, per rule 15a), and the pre-tag
fresh-clone check (`clone: PASS <sha>`) against README's documented
install + first command.

## 10. Trend since v1.29.4 (19dd3a7)

- **Gate assertions** (`bash tests/check.sh`): 1368 passed, 0 failed (at
  `19dd3a7`, re-run fresh in an isolated worktree today) → 1405 passed, 0
  failed (at HEAD). Both 0 red; the count differs from the 1365 figure
  v1.29.4's own note recorded for itself, which was measured at release
  time rather than re-run today — some checks' assertion counts move with
  the calendar date (staleness-style checks), so a same-commit re-run on a
  later date is not guaranteed to reproduce an earlier count exactly. No
  regression either way.
- **Fixture verdicts** (`bash evals/run.sh list` / `score`): 34 cases → 36
  cases (+2: `wei-021`, `iris-003`). Verdict currency unchanged at 0% both
  times (0/34 → 0/36); never-run rose 25 → 27 (the two new fixtures, not
  yet hand-graded); stale unchanged at 9. Neither better nor worse by this
  measure alone — new coverage added, none of it graded yet, and two of
  the new guards are now known-defective (§5).
- **Tracked text lines** (`git diff --shortstat 19dd3a7..HEAD -- '*.md'
  '*.yaml' '*.sh' '*.awk' '*.tsv' '*.cff'`, counted repo-wide): 16 files
  changed, 277 insertions(+), 26 deletions(-).
- **Board currency** (`PATHWAY_FORWARD.md`, `## Board` section): 13
  VERIFIED, 22 RETIRED, 0 BROKEN, 0 blank `last-checked` rows — identical
  at both commits (35 rows total); only 4 rows' dates changed, confirmed
  by `git diff 19dd3a7..HEAD -- PATHWAY_FORWARD.md` showing no row
  content, state, or priority changes.
- **CI green-on-first-try rate**: 6/6 pushes to `main` since v1.29.4's tag
  (`19dd3a7`) through this release's pre-merge-base (`ba8f093`) concluded
  `success`, one run each, no re-run observed (`gh run list --branch main
  --json conclusion,headSha,createdAt`, no SHA appearing twice in the
  range) — 100%, unchanged from v1.29.4's 100%.

This section reports; it does not gate. Tracked lines grew (mostly new
lesson prose and two new fixtures) while the gate assertion count grew and
the fixture population grew without being graded — the same shape the
last several releases flagged — and two of the new guards shipped with a
real defect this release's own audit caught (§5, findings 1-2), which is
new: the last several releases flagged untested guards, not guards proven
wrong.

## 11. Work record

- audit: `victor-reyes` on `19dd3a7..HEAD` (6 commits), Agent-tool access
  this run, no sub-specialist dispatch (small prose/fixture-only range).
  Reported 0 Critical, 2 Medium (fixture guard flaws, `wei-021`/
  `iris-003`), 1 Medium (`wei-lin.md` dispatch-cap self-contradiction), 2
  Minor, 1 Low. Verdict: safe to release as a patch.
- correctness: 0 Critical, 0 Major introduced by this diff; three Medium
  findings, none blocking a patch release (two are unshipped fixture
  guards never dispatched in production, one is a prompt-text
  self-contradiction that does not reverse existing behaviour, only
  leaves an escape hatch).
- conciseness: `kai-fischer` reviewed the touched
  `agents/iris-vermeulen.md`/`agents/wei-lin.md`/`agents/zofia-kaminska.md`
  lines, scoped and read-only — found one cut-able redundancy (§5, finding
  8), net line-delta confirmed 0.
- fixes: the explicitly-requested version bump (`CITATION.cff`,
  `README.md`, `docs/user/citing.md`, 1.29.4 → 1.29.5) applied. All eight
  audit findings deferred to their named owners (`iris-vermeulen`,
  `lian-zhao`) or recorded as uncorrectable-in-place (finding 7, rule 8);
  none invented.
- docs: `PATHWAY_FORWARD.md` board re-dating reconciled against the live
  `## Board` table (§4, §10 — row content/state/priority tallies
  unchanged); `CITATION.cff`/`README.md`/`docs/user/citing.md` reconciled
  against the filesystem (all three now read 1.29.5 at this SHA).
- refactor: `kai-fischer` ran, scoped to the release diff's three touched
  agent files (§5) — verdict: one cut-able redundancy found
  (`agents/iris-vermeulen.md:51`), net-0 line delta otherwise confirmed.
- rules: checked directly against `PROJECT_RULES.md` myself (Check 7's
  index/body agreement and Check 31's root whitelist both green via
  `tests/check.sh`; rule 19's ownership table unchanged, Check 10 green;
  no new rule added, no naming-convention violation, no duplicate fixture
  id). Two pre-existing rule-book items (rule 15a's self-contradiction;
  the rule-10-ordering soft-miss, §5 finding 6) surfaced and routed to
  `zofia-kaminska`, not resolved here.

## 12. Release gate

PENDING AT TIME OF WRITING — `bash tests/release_gate.sh
release_notes_v1.29.5.md` to be run in a fresh clone of the pushed tag and
transcribed here in the same follow-up commit as §9, before the tag is
created (rule 15b; the gate decides all five rows, this release engineer
transcribes what it printed).

- tree: pending
- ci: pending
- publish: pending
- release: pending
- clone: pending
