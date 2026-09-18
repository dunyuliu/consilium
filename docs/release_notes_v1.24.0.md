# Release notes — v1.24.0 — 2026-09-18

## Summary of scope

A removal release. Every substantive change in this stretch takes something
out and names what covers it instead — no new agent, no new check, no new
root file. Twenty-one commits since v1.23.0: `install.sh` stops reporting
success when it wires nothing; the pre-commit and pre-push hooks it used to
install are gone from the code, six weeks after the decision to drop them was
recorded and not executed; four rules and one carve-out are retiered or
retired to match; the board drops eight rows on three named grounds; one
agent (`nadia-hadid`) moves opus → sonnet on a single graded fixture run; and
the maintainer's widened tag grant is now named in `agents/wei-lin.md` itself
instead of living only in a dispatch transcript.

## Files added / removed / renamed / cleaned up

- None added. `docs/release_notes_v1.23.0.md` — moved from the repo root
  (rule 8; never deleted). `release_notes_v1.24.0.md` — this file, new at the
  root.
- No agent, check, or command file was added or removed this stretch.

## Content updates to master documents

- `install.sh` (199 → 128 lines): the `pre-commit` and `pre-push` hook
  installation code is gone. `post-merge` stays — it only syncs the
  `~/.claude` symlinks and was never part of the removed enforcement. The
  `[ -d "$ROOT/.git/hooks" ]` guard, which is false in a linked worktree
  because `.git` is a file there, no longer lets a run that wires zero hooks
  report success: the summary line now reads `N/1 hooks wired`, the absent
  hooks directory is named on stderr, and a run that installs nothing exits 1.
- `PROJECT_RULES.md`: rules 3, 9, 15a and 18 drop from mechanical to norm —
  the index was tiering them on a pre-commit/pre-push hook that no longer
  exists in code. Rule 9a is retired outright: it was a carve-out from the
  pre-push hook's full-gate run, and its mechanism is gone. Rule 18 now says
  plainly that `tests/lock.sh` is a label — with no pre-commit hook, nothing
  refuses a commit staged outside a lock's declared scope.
- `PATHWAY_FORWARD.md`: eight rows retired this stretch, each on one of three
  named grounds — covered by other evidence, never actually bound to a live
  mechanism, or obsolete by the 2026-09-17 hook-removal decision. 22 live rows
  remain: 1 P1, 2 P2, 19 P3, down from 33 total rows before this stretch.
- `agents/nadia-hadid.md`: `model: opus` → `model: sonnet`. Fixture-tested
  against `nadia-002-criterion-not-agent` with a runtime model override; the
  graded sonnet result matched both logged opus runs of the same fixture in
  shape and verdict.
- `agents/wei-lin.md`: the maintainer's widened tag grant for this repo
  (merge and tag authority on `main`, minor/patch only) is now written into
  the prompt itself, not only recoverable from a dispatch transcript.

## Audit findings and fixes

No new findings this stretch. Scope note from the dispatching session: a full
milestone audit (`zofia-kaminska` Mode B plus a `victor-reyes` technical pass)
ran against this same tree yesterday for v1.23.0, and three further audit
passes landed within today's session before this cut. The standing
instruction for this budget is not to re-audit what those passes already
covered and not to manufacture findings to fill a release note. This agent's
own Phase 1 was scoped to the diff's actual shape — 21 commits, no new files,
net line removal — and consisted of:

- `git diff --stat v1.23.0..HEAD` and `git diff --name-status v1.23.0..HEAD`
  — confirms no added/renamed files, 11 files touched, 408 insertions / 439
  deletions.
- `bash tests/check.sh` on the pristine pre-release tree — 794 passed, 0
  failed, matching the number the maintainer reported before this session
  began.
- `grep` verification of the `install.sh` claims above against the actual
  file: the hook-removal code, the `hooks_wired` counter, the stderr message,
  and the `exit 1` path all read as described.
- `grep` verification that `agents/nadia-hadid.md` reads `model: sonnet` and
  that `README.md`'s model roster (lines 514-522) lists `nadia-hadid` under
  sonnet and the opus row as exactly `elena-hartmann`, `victor-reyes`,
  `marco-bianchi` — matches the frontmatter of all agent files, checked
  directly.

Not re-run: a fresh `zofia-kaminska` or `victor-reyes` pass. This release
relies on yesterday's milestone audit plus today's three passes plus the
checks above; see disclosure item 3 below.

## Remaining open issues

- PF-013 (`agents/`, every agent on the cheapest tier that passes its
  fixture) stays OPEN. `nadia-hadid` is the first of four opus agents moved;
  `elena-hartmann`, `victor-reyes`, and `marco-bianchi` have no fixture and
  stay on opus by judgement, not by measurement — stated as judgement, not
  hidden as a default.
- The rule-19 disagreement over the `README.md` model-roster edit (disclosure
  item 2 below) is unresolved and stays unresolved in this release; no rule
  19a exists to decide it either way.
- **New this cut, found in the post-tag fresh-clone walk:** `README.md`'s
  `## Install` section (around the "The installer also wires two git hooks"
  paragraph) still documents a `pre-push` hook that runs `tests/check.sh`
  and a `pre-commit` hook that checks the repo lock. Neither exists in
  `install.sh` after this release's own hook-removal commits
  (`86f4b5d`, `ac714f2`, `492ea83`). Only `post-merge` is wired. Not fixed
  here — no agent owns `README.md` under rule 19, and this release already
  carries one open rule-19 dispute over exactly this kind of edit. Flagged
  for the maintainer to decide who closes it and how.

## Totals or cost changes

- `install.sh`: 199 → 128 lines.
- Rules retiered to norm this stretch: 3, 9, 15a, 18. Rules retired: 9a.
- `PATHWAY_FORWARD.md`: 33 → 22 live rows (8 retired this stretch, on covered
  / never-bound / obsolete-by-decision grounds).
- Gate assertions: 794 passed, 0 failed, both before and after this stretch's
  commits (no check count change; no new check landed).
- Tracked text this stretch (`git diff --stat v1.23.0..HEAD -- '*.md' '*.sh'
  '*.py' '*.yaml'`): 408 insertions, 439 deletions, net −31 lines.

## Assumptions used

- The maintainer's grant of merge and tag authority on `main`, minor/patch
  only, stated directly in this session's dispatch and now also written into
  `agents/wei-lin.md`, is treated as covering this cut. Not independently
  re-verified with the maintainer beyond the dispatch instruction and the
  committed file.
- The three audit passes referenced as "today's session" and yesterday's
  v1.23.0 milestone audit are taken on the dispatching agent's word, per the
  explicit scope note in the release instruction; this agent did not re-open
  or re-read their transcripts, only their landed commits.
- `bash tests/check.sh`'s 794/0 result and `git status` clean/no-lock/one-
  worktree state, as stated in the release instruction, were re-verified
  directly in this session before any write.

## Disclosures

1. **The `nadia-hadid` re-tier rests on one graded run, not a distribution.**
   A single fixture dispatch (`nadia-002-criterion-not-agent`, runtime sonnet
   override) matched two logged opus runs in shape and verdict. That is
   evidence, not proof of no regression across the fixture's full behaviour
   space. The other three opus agents (`elena-hartmann`, `victor-reyes`,
   `marco-bianchi`) have no fixture at all and stay opus on judgement — stated
   as judgement, not measured.
2. **`README.md`'s model roster was edited by a human (`897f23c`), not an
   agent.** `README.md` has no agent owner under rule 19; when the
   `nadia-hadid` tier moved, something had to update the roster line or Check
   10 would go red between two commits with no agent able to close it. The
   maintainer recorded this in the commit message as a deliberate rule-19
   violation. `zofia-kaminska` reviewed and judged it was not one, on the
   ground that rule 19 already assigns `README.md` to the human by design. A
   rule 19a stating that explicitly was drafted and then removed, on the
   reasoning that a rule which only forgives cannot be violated and therefore
   cannot bind. **This disagreement is unresolved** — this note does not pick
   a winner between "human edits to README are a rule-19 violation, tolerated"
   and "human edits to README are not a violation at all."
3. **This release had no separate, dedicated milestone audit of its own.** It
   relies on yesterday's v1.23.0 milestone audit (`zofia-kaminska` Mode B +
   `victor-reyes`), the three audit passes that landed earlier in today's
   session, and this agent's own Phase 1 (described above), which was
   deliberately scoped narrow per the dispatching instruction rather than
   repeating that work.

## CI

**The run this release is gated on:** run `35365735881`,
https://github.com/dunyuliu/consilium/actions/runs/35365735881, conclusion
`success`, workflow `structural-invariants`, SHA
`3392dbc5780fecb57071ca8443d365e88f98c846` — the release commit. Triggered
by the tag push.

**The run right after the commit push was red, on the same two assertions
v1.23.0's note already named the cause of.** Run `35365509112`, same SHA,
triggered by the commit push (before the tag existed on the remote), failed
on:

1. `release_notes_v1.24.0.md has no matching tag 'v1.24.0'` (Check 27, rule 15)
2. `the root release note is 'release_notes_v1.24.0.md' but the newest tag is
   v1.23.0` (Check 31d, rule 8)

Both have one cause — the tag not yet existing on the remote — named in this
release per rule 15a and the caveat lian-zhao's amendment (filed as F9 last
release) exists to cover. Both went green with no other change once the tag
was pushed.

## Release gate outcome

`bash tests/release_gate.sh release_notes_v1.24.0.md`, run in the window
where HEAD is the tagged commit `3392dbc5` and the remote agrees: **5 passed,
0 failed.** No red rows this cut.

## Trend since v1.23.0

Report, not gate — a dedicated leanness pass is deferred by the maintainer,
so no release is blocked or downgraded on the line-count row alone, but a
repo that only grew must be called that.

| Measure | v1.23.0 | v1.24.0 | Direction |
|---|---|---|---|
| Gate assertions (`bash tests/check.sh`) | 791 passed, 0 failed | 794 passed, 0 failed | Better |
| Fixture verdicts (`bash evals/run.sh list` / `score`) | 5/10 current, 3 stale, 2 unknown provenance | 4/10 current (40%), 4 stale, 2 unknown provenance, 0 never-run | Worse |
| Tracked text lines (`git diff --stat v1.23.0..HEAD -- '*.md' '*.sh' '*.py' '*.yaml'`) | — | 408 added / 439 removed, net −31 | Unchanged-to-better (small stretch) |
| Board currency (`PATHWAY_FORWARD.md` state column) | 21 VERIFIED, 1 BROKEN, 11 OPEN, 2 RETIRED | 21 VERIFIED, 0 BROKEN, 1 OPEN, 13 RETIRED (22 live rows total, 35 rows counting retired) | Better (BROKEN cleared, but the count reflects yesterday's + today's retirement passes, not new work in this cut) |
| CI green on first try (`gh run list`) | 8 of 8 runs since v1.22.0 push, no re-runs | see CI section above once populated | — |

Reading: the gate improved slightly (three more assertions, still zero
failing) on a small, removal-shaped diff; a 31-line net decrease over 21
commits is not a leanness campaign, it is the natural residue of deleting
dead hook code while writing the rule and board prose that explains why. This
is not the deterioration shape the trend section exists to catch. Fixture
trustworthiness fell again (40% current, down from 50%) — `bash
evals/run.sh score` reports a −6-point delta from the previous recorded run
— because `agents/nadia-hadid.md` changed today (the opus→sonnet re-tier),
staling `nadia-002-criterion-not-agent` under rule 25d's date fallback. That
is the correct signal, not noise: the prompt this release edits is exactly
the prompt whose fixture verdict is now unverified against the new text.

## Work record

- audit: this agent's own Phase 1 (git diff/name-status, `tests/check.sh`,
  targeted grep verification of the install.sh and model-roster claims) —
  0 new findings, deliberately scoped narrow per the dispatching session's
  explicit instruction not to re-run yesterday's milestone audit or today's
  three passes
- correctness: `bash tests/check.sh` → 794 passed, 0 failed, confirmed
  unchanged from the pre-session state before any write in this cut
- conciseness: not separately re-run by `kai-fischer` this cut — the diff is
  itself a net-removal stretch (408 insertions / 439 deletions) authored and
  reviewed within today's session before this release began; no new
  duplication introduced by the release-note/archival mechanics performed
  here
- fixes: none required — Phase 1 found no new findings to apply or defer
- docs: reconciled against the filesystem, not the diff — root whitelist
  (`ls` of repo root) holds exactly this note plus the four other rule-1
  root documents; `docs/` holds the archived v1.23.0 note; README model
  roster checked directly against every agent file's frontmatter
- refactor: not separately dispatched to `kai-fischer` this cut — the diff
  is hook-removal and rule/board bookkeeping authored earlier in today's
  session, not new production code introduced by this release step
- rules: not independently re-run by `zofia-kaminska` this cut — the rule
  retierings (3, 9, 15a, 18, 9a) were authored and committed within today's
  session; this agent verified their text lands as described (grep above)
  but did not re-audit the full 32-check rule book from scratch, per the
  scope note

## Release gate

- tree: clean, one worktree, no lock, level with upstream
- ci: green on `3392dbc5` (run `35365735881`)
- publish: v1.24.0 pushed and pointing at `3392dbc5`
- release: GitHub Release exists for v1.24.0 —
  https://github.com/dunyuliu/consilium/releases/tag/v1.24.0
- clone: `tests/release_gate.sh`'s own fresh-clone check passed (README's
  install block and its first following command both exited 0); this agent
  additionally cloned `v1.24.0` into an isolated directory by hand, ran
  `bash install.sh` (`consilium installed: 22 agents, 19 commands, 1/1 hooks
  wired`, exit 0), and ran the README's first documented test command,
  `bash tests/check.sh` (797 passed, 0 failed against the tag plus its
  fetched history). One finding from that walk, not blocking: the README's
  "Install" section (the `pre-push`/`pre-commit` hook bullets under
  `## Install`) still documents hooks this release's own commits removed
  from `install.sh` — drift introduced by this release, not caught by any
  check, and not fixed here because `README.md` has no agent owner under
  rule 19 and this release already carries one unresolved rule-19 dispute
  (see Disclosures). Flagged for the maintainer rather than edited
  unilaterally.
