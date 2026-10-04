# Release notes — v1.28.2 — 2026-10-04

## 1. Version and date

**v1.28.2**, cut 2026-10-04 from `main`, on top of `v1.28.1`
(`522532c1e2603fb2aeb8f86f33664f8bd750cf3d`, 2026-10-03). Patch bump: five
merged PRs (#80–#84) since the last tag, all prompt/doc lessons folded in from
the inbox-triage process — no new agent, no new command, one rule-book line
changed (the shipped-prompt ceiling).

## 2. Summary of scope

5 commits, 28 files changed, **+109 / −67** (tracked `.md`/`.sh`/`.py` text).

| Theme | PR | What |
|---|---|---|
| v1.28.1 note completion | #80 | Transcribed the actual CI-run IDs and release-gate rows into `release_notes_v1.28.1.md` §9/§12, which shipped at tag time with pending placeholders |
| Per-PR process lessons | #81 | `kai-fischer` commits only when the brief says to; a wait names the agent or PID that wakes it; one owner per PR; claim checks read the full text, not a substring |
| Tool-call cap | #82 | Every agent's Tool economy section now says: past ~120 tool calls, checkpoint (commit, notes) and stop — a fresh agent continues cheaper. Applied identically across all 23 `agents/*.md` and reflected in `commands/autopilot.md`'s conductor-recycle logic |
| `/autopilot` conductor dispatch | #83 | Dispatches `wei-lin` by task type rather than generically; recycles a conductor that made no commit; the cap is a hard stop, not a suggestion |
| Inbox routing lessons | #84 | Route the costliest specialist (`dunyu-liu`) by task class, with the owner's sign-off required per dispatch; pool long independent gates instead of running them serially; board-affecting commits take the PR path, same as code |

## 3. Files added / removed / renamed / cleaned up

- **Renamed**: `release_notes_v1.28.1.md` → `docs/release_notes_v1.28.1.md`
  (`git mv`, rule 8 — archived, never deleted).
- **Added**: this note, at the repo root, as the only root release note.
- No other file added to or removed from the repo root; root still holds
  exactly rule 1's whitelist (`git ls-files` at repo root cross-checked by
  hand against `PROJECT_RULES.md` §1 — Check 31 confirms the same
  mechanically).
- No new agent, command, rule, check, or eval case landed in this range.

## 4. Content updates to master documents

- **`PROJECT_RULES.md`** — 1,003 lines, unchanged in rule count (47 index
  rows). Only line changed: rule 1b's `Ceiling: 5755` → `Ceiling: 5754`,
  tracking the net shrink below.
- **`PATHWAY_FORWARD.md`** — PF-003 (every eval fixture dispatched and graded
  at least once) flipped **VERIFIED → BROKEN**, 2026-10-04:
  `evals/cases/shu-han-001-no-invention` has never been dispatched. PF-006,
  PF-021, PF-023, PF-024 had their `last-checked` date refreshed to
  2026-10-04 on a fresh re-run of each row's own command. Board total:
  13 VERIFIED, 21 RETIRED, 1 BROKEN, 0 blank (of 35 rows), against 14/21/0/0
  at v1.28.1 — see §10.
- **`agents/*.md` (24 files), `commands/autopilot.md`** — the tool-economy
  checkpoint line (PR #82), plus `agents/kai-fischer.md`, `agents/wei-lin.md`,
  `agents/dunyu-liu.md`, `agents/shu-han.md`, `agents/ziyan-chen.md` carrying
  additional targeted edits from PRs #81, #83, #84. Net effect on the
  shipped-prompt line count: `agents/`+`commands/` 5,755 → 5,754 lines
  (ceiling lowered to match, rule 1b).
- **`docs/lessons_ledger.md`** — 290 → 305 lines (+15), 15 new dated rows
  (10-03, 10-04), aliased (`self`, `P16`, `P17`, `P18`) — no project name in
  any added row (checked by hand against every new line).

## 5. Audit findings and fixes

**Dispatched `victor-reyes`** for the deep pass; he judged the diff (~500
lines, all prompt/doc text, one surface) small enough to assess directly
rather than sub-dispatching, and ran the gate and eval tooling fresh himself
rather than trusting this agent's own run.

**8 consolidated findings — 0 Critical, 1 Major, 4 Medium, 2 Low, 1 Low
(suspected).** None is a `tests/check.sh` check-logic defect (the gate itself
stays green — `921 passed, 0 failed`, confirmed independently by this agent).
**Fixes applied this release: none.** Every finding sits on a surface owned
by someone other than `haruto-nakamura` under rule 19 (`agents/*.md` and
`commands/*.md` prompt text is `lian-zhao`'s; `PATHWAY_FORWARD.md` row state
is `zofia-kaminska`'s; eval-fixture coverage is `iris-vermeulen`'s), so each
is recorded below as an open issue, routed by owner, rather than an invented
fix.

**This pass's own verification, re-run fresh:**
- `bash tests/check.sh` on the pristine pre-release tree: `921 passed, 0
  failed`.
- `cat agents/*.md commands/*.md | wc -l` → `5754`, matching the new ceiling
  exactly.
- Read every new `docs/lessons_ledger.md` row by hand: no project name, path,
  host, or person — only `P1x`/`self` aliases and agent names.
- Confirmed the PF-003 BROKEN flip and the four date refreshes are the only
  `PATHWAY_FORWARD.md` changes in range (`git diff v1.28.1..HEAD --
  PATHWAY_FORWARD.md`).

## 6. Remaining open issues or pending items

All from `victor-reyes`'s pass unless noted; none fixed this release (§5).

1. **(Major — flagged for the human, not resolved unilaterally.)** Rule 10
   says an agent-behaviour prompt fix with no eval fixture "is a debt that
   lands before the next version tag" — **this tag.** 12 of the 15 new
   `docs/lessons_ledger.md` rows mark a real-deployment behaviour fix
   "landed" (`wei-lin` ×6, `kai-fischer` ×2, `ziyan-chen`, `shu-han`,
   `dunyu-liu`/`wei-lin` ×2) with no matching `evals/cases/` fixture added
   this range, and `wei-lin`, `kai-fischer`, `ziyan-chen` have no fixture
   under `evals/cases/` at all. This is carried forward from v1.28.1 (its
   own §6.4, same debt, unresolved) and the unfixtured count has grown, not
   shrunk, across two consecutive patch tags. This agent did not invent a
   fixture — authoring one is `iris-vermeulen`'s surface and a judgment call
   about what the fixture should assert. **Recommendation to the human:**
   decide whether this debt pauses further "landed" lessons-ledger claims
   until fixtures catch up, or whether rule 10's "judgment" tier is meant to
   tolerate this. Owner: `iris-vermeulen` (fixtures); `zofia-kaminska` or the
   human (whether rule 10 itself needs a grace clause).
2. **(Medium)** `agents/wei-lin.md`'s turn-end list (around the isolation
   section) does not include "the ~120-call cap is reached" as a condition
   that ends her turn, while the new tool-economy line and a same-day
   `lessons_ledger` row both say a checkpoint there is mandatory — the two
   passages read as contradicting each other. Owner: `lian-zhao`.
3. **(Medium)** "the owner's OK" (new in PR #84's inbox-routing lesson) is
   ambiguous between "the user's OK" and "the named rule-19 surface owner's
   OK" — `agents/wei-lin.md` and `agents/dunyu-liu.md` use the phrase in a
   way that could be read either way, and a self-approval reading would
   defeat the control the lesson intends. Owner: `lian-zhao`, to confirm the
   intended meaning with the maintainer and disambiguate the wording.
4. **(Medium)** `PATHWAY_FORWARD.md`'s PF-003 is now BROKEN with no deferral
   line and no named next step; the obvious remedy is a fresh dispatch of
   `shu-han` against `evals/cases/shu-han-001-no-invention` with a recorded
   `Run (...)` line, but rule 24.2 also requires the fixture's own author
   adversarial pass to be recorded first, which this fixture (landed in PR
   #59, pre-dates this release) has not had confirmed. Owner:
   `zofia-kaminska` (board row), `iris-vermeulen` (run record and adversarial
   pass).
5. **(Medium — disclosure, not a defect.)** `evals/run.sh score` shows **0 of
   10** fixture verdicts current against HEAD's prompts (9 stale, 1 never
   run) — down from 20% at v1.28.1 — because PR #82 touched all 24 prompts
   in one pass. No fixture in the suite currently certifies any agent's
   behaviour at this tag; this is expected after a fleet-wide prompt edit
   (rule 25d) and is not itself a defect, but a reader of this note should
   not infer fixture coverage from the green `tests/check.sh` run.
6. **(Low, carried)** The pattern of amending a tagged release note after its
   tag exists (v1.28.1 itself, via PR #80, filling in §9/§12 placeholders)
   repeats a gap already flagged in v1.28.1 §6.5: `haruto-nakamura`'s prompt
   has no step naming this two-commit pattern as expected. Owner: `lian-zhao`.
7. **(Low, advisory)** PF-003's VERIFIED→BROKEN state change landed inside
   commit #83 (an unrelated cost/autopilot change), not its own commit; rule
   19's board carve-out gives the conductor only mechanical updates (command
   output + date), with state changes reserved for `zofia-kaminska`. All five
   commits in range are attributed to the human maintainer, so no agent
   rule-19 violation is provable from git alone. Owner: `zofia-kaminska`
   (to confirm who made the edit and whether the carve-out needs tightening).
8. **(Low, suspected — not confirmed)** `agents/wei-lin.md` may have dropped
   a "never dispatch onto a file another active subagent is editing" line in
   this range; three of four removed "Never" lines are still covered
   elsewhere in her prompt (major bumps, revert-on-regression, diff-before-copy),
   but this fourth was not confirmed present under a paraphrase. Owner:
   `lian-zhao`, to confirm by direct read whether the guarantee survives
   elsewhere in the file.

**Carried from v1.28.1, still open, not re-audited this pass:** §6.6 (no
rule-19 ownership row for `docs/maintainer.md`, `docs/user/*.md`,
`docs/lessons_ledger.md` itself); §6.2/§6.3/§6.7/§6.9/§6.10/§6.11/§6.12 of
v1.28.1 (the `/autopilot` commit-authority ambiguity, the MEASURED/VERIFIED
conflict with rule 21, the three-standards mid-run-message gap, and four
smaller prompt-wording items) — no new evidence either way this range.

## 7. Totals or cost changes

Both columns measured fresh this session — v1.28.1 in a throwaway detached
worktree at that tag, v1.28.2 on the release branch before the tag was cut —
using one consistent command per row, not copied from either note.

| Measure | v1.28.1 | v1.28.2 |
|---|---|---|
| Tracked lines (`git ls-files \| xargs wc -l`) | 21,096 | 21,138 |
| `evals/` lines | 4,585 | 4,585 |
| `tests/check.sh` lines | 1,409 | 1,409 |
| `PROJECT_RULES.md` lines | 1,003 | 1,003 |
| `agents/`+`commands/` lines (rule 1b) | 5,755 (ceiling 5,755) | 5,754 (ceiling 5,754) |
| Live checks | 32 | 32 |
| Eval cases | 10 | 10 |
| Agents / commands | 23 / 20 | 23 / 20 |
| Rule-book index rows (incl. sub-rules, retired) | 47 | 47 |
| Board rows VERIFIED / RETIRED / BROKEN (of 35 total) | 14 / 21 / 0 | 13 / 21 / 1 |

## 8. Assumptions used

- **The brief's state was re-verified, not taken.** `main`'s tip (`ae508c6`),
  the five-PR/five-commit range, the free lock, branch protection (required
  check: `"check"`), and the local `921/0` gate were each re-read by command
  before use, not copied from the dispatch brief.
- **No refactor pass ran** (`kai-fischer` not dispatched) — this range is
  five already-PR-gated prompt/doc commits with no production code touched;
  nothing on his surface to simplify.
- **No dedicated rules audit ran** (`zofia-kaminska` not dispatched) — this
  agent cross-checked `PROJECT_RULES.md` and `PATHWAY_FORWARD.md` directly
  for internal consistency against the diff and found nothing broken by it
  beyond the PF-003 flip already on the board, which is not a substitute for
  her tier-split/violation verdict.
- **§7's v1.28.1 baseline was re-measured in a throwaway detached worktree at
  that tag**, not copied from `docs/release_notes_v1.28.1.md`'s own §7 table
  — same resolution v1.28.1 applied to its own v1.28.0 comparison.

## 9. CI run this release was gated on

_Filled in after the release PR's CI run and the post-merge run on `main`;
see the Release gate section (§12) for the final, transcribed values._

## 10. Trend since v1.28.1

Every row is the output of a command run this session, at both commits.

| Measure | v1.28.1 | v1.28.2 | Direction |
|---|---|---|---|
| Gate assertions — `bash tests/check.sh` | `915 passed, 5 failed` (today; 5 fails are PF-003/006/021/023/024 reading "overdue by 1d" purely from today's date against that commit's 2026-09-19 `last-checked` — not a defect in v1.28.1 itself) | `921 passed, 0 failed` | **Better** — the board rows this release touched are current as of today; the comparison is date-sensitive by the check's own design, not a regression at the earlier tag. |
| Fixture verdicts — `bash evals/run.sh score` | 10 cases, 2 current (20%), 7 stale, 1 never-run | 10 cases, 0 current (0%), 9 stale, 1 never-run | **Worse.** PR #82's fleet-wide prompt edit invalidated the two previously-current verdicts; expected after a prompt edit (rule 25d) but real currency loss — see §6.5. |
| Tracked text lines — `git diff --stat v1.28.1..HEAD -- '*.md' '*.sh' '*.py'` | — | 28 files, **109 added / 67 removed, net +42** | **Modest growth**, almost entirely `docs/lessons_ledger.md` rows documenting already-landed fixes plus the one-line tool-economy edit repeated 24 times, not duplication. |
| Board currency — `PATHWAY_FORWARD.md` | 14 VERIFIED, 21 RETIRED, 0 BROKEN, 0 blank | 13 VERIFIED, 21 RETIRED, **1 BROKEN**, 0 blank | **Worse** — PF-003 flipped to BROKEN this range (§4, §6.4); a real gap found and tracked, not swept under. |
| CI green-on-first-try — `gh run list` since v1.28.1's tag push | — | 5 runs, 5 green on attempt 1, 0 reruns | **Unchanged in substance** (100%, same as v1.28.1's own 43/43 excluding its documented boundary artifact), on a much smaller run count for this shorter, doc-only range. |

**Reading, plainly.** The gate itself holds green and the tracked-line growth
stays modest and attributable to ledger rows, not duplication. But two
measures moved the wrong way for real reasons: fixture-verdict currency
dropped to zero (a fleet-wide prompt edit with no re-dispatch to re-certify
any of it), and the board gained its first BROKEN row in this project's
history (a fixture that has sat never-run since PR #59). Neither is swept
into the gate's green — both are open issues (§6.1, §6.4, §6.5) and the
unfixtured-lesson count is now compounding across two consecutive patch
releases, which is the clearest piece of deterioration in this note.

## 11. Work record

- **audit**: `victor-reyes`, self-handled without sub-dispatch (diff judged
  too small to need a specialist). 8 consolidated findings — 0 Critical, 1
  Major, 4 Medium, 2 Low, 1 Low-suspected, all §6.
- **correctness**: `bash tests/check.sh` → `921 passed, 0 failed` on the
  pristine pre-release tree; see §12 for the merged-SHA and tagged-SHA
  re-runs.
- **conciseness**: assessed inline, not independently verified by
  `kai-fischer` (see `refactor:` below). Net +42 tracked lines, almost
  entirely new ledger rows and a one-line prompt edit repeated across 24
  files; no duplication found.
- **fixes**: **none applied.** All 8 findings sit on `lian-zhao`'s
  (`agents/*.md`, `commands/*.md`), `zofia-kaminska`'s (`PATHWAY_FORWARD.md`
  row state), or `iris-vermeulen`'s (eval-fixture coverage) surfaces under
  rule 19, recorded as open issues (§6), routed by owner, not invented fixes.
- **docs**: reconciled against the filesystem, not the diff. Root walked
  against rule 1's whitelist; every count in §7 re-read off disk this
  session at both commits.
- **refactor**: **`kai-fischer` did not run this release.** Five
  already-PR-gated prompt/doc commits with no production code in the diff —
  nothing on his surface.
- **rules**: **`zofia-kaminska` did not run a fresh Mode B pass for this
  cut.** This agent verified mechanically: 47 index rows unchanged, no
  renumbering, one value changed (rule 1b's ceiling, tracking the measured
  shrink). No tier-split, violation list, or unenforceable-rule verdict was
  produced, because no dedicated rules audit ran.

## 12. Release gate

_Filled in once `tests/release_gate.sh release_notes_v1.28.2.md` runs clean
after the tag and Release are created — see the final report for the
transcribed rows._
