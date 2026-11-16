# Release notes — v1.31.0 — 2026-11-16

## 1. Version and date
v1.31.0, cut 2026-11-16, minor bump over v1.30.3 (`79bccef`). Minor because
the range adds a command, `/cleanup`.

## 2. Summary of scope
Three commits since v1.30.3 (`79bccef..9730780`):

- `61f4ad5` (#204): post-tag follow-up for v1.30.3 — transcribed its CI run
  and release-gate rows into its note (not a feature for this release).
- `b4bc8f0` (#205): new `commands/cleanup.md` — `zofia-kaminska`'s
  report-only tidy, delete what is dead where the rules allow, the rest as one
  owner Go; README and `docs/user/commands.md` rows.
- `9730780` (#206): inbox pass 2026-11-16 — in-place sharpenings in
  `agents/wei-lin.md` (liveness from signals that exist, a batch's outputs
  counted instead of a DONE line, each result logged before the next
  dispatch), `agents/dunyu-liu.md`, and a 200k hand-off hard stop in
  `commands/autopilot.md`; ledger rows.

This release's own contribution: the audit pass, this note, the archive move.

## 3. Files added / removed / renamed / cleaned up
**Added**: `commands/cleanup.md`, `release_notes_v1.31.0.md` (this file).
**Removed**: nothing. **Renamed**: `release_notes_v1.30.3.md` (root) →
`docs/release_notes_v1.30.3.md` (rule 8 archive).
**Modified**: `README.md`, `docs/user/commands.md`, `docs/lessons_ledger.md`,
`agents/{wei-lin,dunyu-liu}.md`, `commands/autopilot.md` (#205, #206).

## 4. Content updates to master documents
`PATHWAY_FORWARD.md` not touched in the range or by this release. Counts,
`grep -c` on the file at this tree: 14 `| VERIFIED |`, 0 `| BROKEN |`, 36 rows
— identical at v1.30.3. README roster and commands doc each carry the
`/cleanup` row (landed by #205).

## 5. Audit findings and fixes
`victor-reyes` audited `v1.30.3..9730780` (8 files, +45/-28), could not
dispatch specialists in his session and ran the mechanical checks himself:
"0 critical, 3 medium, 4 low, 1 advisory (8 total). Nothing blocks the
release." I then ran `lian-zhao` (read-only) on findings 2-7: all confirmed
(2 partly). Nothing was applied pre-tag: finding 6 is one-word mechanical but
sits in `lian-zhao`'s surface and is deferred to her; the rest are judgment.

## 6. Remaining open issues or pending items
- **Medium (1)** — `commands/autopilot.md:26,28` vs `commands/cleanup.md`:
  `/cleanup`'s +9 lines were paid by re-joining line breaks in two paragraphs
  (-13 lines, no words cut), not by cutting content; rule 1b's intent is
  unmet. Owner's call.
- **Medium (2)** — `commands/cleanup.md:5`: zofia has no tidy mode, only a
  seeded gate-check clause (`agents/zofia-kaminska.md:244-246`), and it lacks
  "scratch output". Owner: `lian-zhao`.
- **Medium (3)** — `commands/cleanup.md:7-9`: "docs stay lean … README stays
  concise" names no owner and reads as licence to edit files rule 19 gives to
  others. Owner: `lian-zhao`.
- **Low (4)** — `commands/cleanup.md:9`: "new since the last cleanup" has no
  record to compare against.
- **Low (5)** — `commands/autopilot.md:22` "whatever is live" vs
  `agents/wei-lin.md:51` "never end a turn while a child is alive".
- **Low (6)** — `agents/wei-lin.md:52`: "(a long single-core job last or
  outside it)" has no verb (mechanical, `lian-zhao`).
- **Low (7)** — `agents/dunyu-liu.md:133`: "output parity with a direct solve"
  has no size or tolerance bound.
- **Advisory (8)** — prompts 28 lines over rule 1b's ceiling (predates this
  release; 32 over at v1.30.3).
- Carried from v1.30.3 §6: findings 1, 2, 3, 5, 6 of that audit (wei-lin and
  jordan-kim wording, one fixture sample) and the CI-action deprecation
  annotations in `.github/workflows/check.yml` (`iris-vermeulen`).
- Not run: no live dispatch of any fixture; `bash evals/run.sh list` shows
  wei-lin and `/autopilot`-related verdicts stale or never run.

## 7. Totals or cost changes
`cat agents/*.md commands/*.md | wc -l`: 5782 lines, v1.30.3 had 5786
(-4). Ceiling 5754, limit 5869, Check 37 green; overrun +28 lines.

## 8. Assumptions used
None beyond what the commands in this note produced. Victor's audit ran in
one session without specialist dispatch (§5).

## 9. CI run this release was gated on
Pre-merge runs on the release branch SHA are read at step 11 and
transcribed, with the tagged merge commit's run, into this note by one
post-tag follow-up commit, as for v1.30.3. For the range's last commit,
`structural-invariants` run
https://github.com/dunyuliu/consilium/actions/runs/43967499681 — `success`,
SHA `9730780a1f2afbe45009940e5874a3430c0925dd`.

## Trend since v1.30.3
- **Gate assertions.** `bash tests/check.sh`: v1.30.3 tag 1636 passed, 0
  failed; `9730780` 1638 passed, 0 failed. Better (+2).
- **Fixture verdicts.** `bash evals/run.sh list` and `score` at both
  commits: 46 cases, 9 stale, 37 never-run, 0 current. Unchanged.
- **Tracked text lines.** `git diff --shortstat v1.30.3..9730780 -- '*.md'
  '*.sh' '*.py'`: 8 files, +45/-28.
- **Board currency.** `PATHWAY_FORWARD.md` at both commits: 14 VERIFIED, 0
  BROKEN, 36 rows. Unchanged; blank `last-checked` not re-counted.
- **CI green-on-first-try rate.** `gh run list --created ">=2026-11-05"`:
  16 runs, 16 `success` — 16/16.

Reports, does not gate. Lines grew +17 net in tracked text while prompts
shrank 4; gate +2, other measures flat. No deterioration.

## Work record
- audit: victor-reyes's report on `v1.30.3..9730780` — "0 critical, 3 medium,
  4 low, 1 advisory (8 total)", mechanical pass only, no specialist dispatch.
- correctness: `lian-zhao` read-only confirmation of findings 2-7 (all
  confirmed, 2 partly); no logic code in range.
- conciseness: `kai-fischer` — "nothing needed"; +9 lines for `/cleanup` are
  paid by line reflow, not content (open issue 1).
- fixes: none applied; 8 findings deferred to §6, none invented.
- docs: README and commands doc `/cleanup` rows reconciled against disk
  (24 command files); board untouched.
- refactor: `kai-fischer`, scoped to the audited prompt diff — none needed.
- rules: `zofia-kaminska` not dispatched; mechanical gate only, `bash
  tests/check.sh` green on `9730780`. No rule change in range.

## Release gate
Transcribed by the post-tag follow-up commit from `bash
tests/release_gate.sh release_notes_v1.31.0.md` in a fresh clone of the tag.
- tree: pending post-tag run
- ci: pending post-tag run
- publish: pending post-tag run
- release: pending post-tag run
- clone: pending post-tag run
