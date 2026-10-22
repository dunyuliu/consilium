# Release notes — v1.30.0 — 2026-10-22

## 1. Version and date
v1.30.0, cut 2026-10-22, minor bump over v1.29.7 (`c954c06`). Minor because
the range adds a new command, `commands/extract.md`.

## 2. Summary of scope
Four commits since v1.29.7 (`c954c06..e147f65`):

- `4aac688` (#182): post-tag follow-up for v1.29.7 — transcribed its own
  final CI run and release-gate rows into its note (rule 8/step 12
  allowance; not a feature for this release).
- `88693f6` (#183): 2026-10-21 inbox pass — `/autopilot` now seeds a fresh
  conductor only after `TaskStop` on the old one (ended is not stopped);
  wei-lin's orient step treats unexplained uncommitted edits as another
  live conductor and stops rather than sweeping them into its own commit.
  Four ledger rows; `agents/`+`commands/` net 0 (5752 lines).
- `22b613e` (#184): 2026-10-22 inbox pass — naming a future event is not
  arming a wake for it; Phase 4 now arms a wake before any turn ends on a
  named future event.
- `e147f65` (#178): 2026-10-21 inbox pass, seven conductor gaps closed in
  `agents/wei-lin.md` (+15/−7 lines) plus the new command
  `commands/extract.md` (+26 lines, extraction-first autopilot), each gap
  gated by a new fixture (`evals/cases/wei-023`..`wei-029`), and
  `docs/lessons_ledger.md` gains five rows.

This release's own contribution: the audit pass (`victor-reyes`), one
in-scope leak fix found and applied before the cut (below), this note, and
the archive move.

## 3. Files added / removed / renamed / cleaned up
**Added**: `commands/extract.md`; `release_notes_v1.30.0.md` (this file);
`evals/cases/wei-023-infra-only-stall/`, `wei-024-unbounded-poll/`,
`wei-025-unprovisioned-worktree-failures/`, `wei-026-tail-masks-exit-code/`,
`wei-027-repeated-relay-no-sha/`, `wei-028-board-already-authorizes/`,
`wei-029-tier3-reader-available/` (landed by #178; lars-eriksson confirmed
each `pass.md`/`fail.md` grades as labelled, no symlink or leaked keyword in
any `input/`).

**Removed**: nothing.

**Renamed**: `release_notes_v1.29.7.md` (repo root) → `docs/release_notes_v1.29.7.md`
(rule 8 archive). One in-scope content fix was applied to it before the
move (see §5) — the rest of the file is untouched.

**Cleaned up**: `evals/cases/wei-016-exhausted-and-milestone/` extended
(rule 10, recurrence of the 09-29/10-03 wake-arming gap).

## 4. Content updates to master documents
`PATHWAY_FORWARD.md` gained row 36 (`agents/wei-lin.md`, `commands/extract.md`,
VERIFIED, 2026-10-21) and three 2026-10-21/10-22 inbox rows, all landed by
#178/#183/#184, not by this release. `README.md` gained the `/extract`
roster row (also #178). No board row was opened or closed by this release's
own audit pass.

## 5. Audit findings and fixes
`victor-reyes` audited `v1.29.7 (c954c06)..e147f65`, routing to
`lars-eriksson` (fixture/prompt-logic correctness) and `sophia-okafor`
(board-vs-code drift). Verdict: **nothing blocks the tag — 2 Low, 1
Advisory, 1 informational.** `tests/check.sh` at `e147f65`: 1581 passed, 0
failed (both specialists ran it independently).

Applied before the cut (mechanical, on my own surface — release notes):
- **Informational, in scope** — victor flagged that the audited range is
  four commits, not the three named in this release's brief: `4aac688`
  (the v1.29.7 post-tag transcription follow-up) is in range and is the
  only commit touching `release_notes_v1.29.7.md`. That commit had added a
  GitHub Actions run URL containing the maintainer's account name to §9 of
  the v1.29.7 note. Per the leak-free rule covering this release's audited
  range, the URL is dropped from that line (run id, conclusion and SHA
  kept) before archiving to `docs/`. No other content in that note was
  touched.

Deferred as open issues (board/doc-surface findings, not mine to write —
see §6):
- **Low** (sophia-okafor, re-rated by victor) — `PATHWAY_FORWARD.md:555`
  says "seven lines added to `agents/wei-lin.md`" for #178; the actual
  change is +15/−7 (net +8) physical lines, one sentence per gap. Routed to
  `zofia-kaminska` (board owner, rule 19).
- **Low** (sophia-okafor) — `docs/maintainer.md`'s Layout tree lists
  `commands/autopilot.md` but not the new `commands/extract.md`. Rule 12
  only requires a Layout line for a new *agent*, so this is incomplete, not
  a rule violation; routed to whoever next edits that tree.
- **Advisory** — the board's claim that each of `wei-023`..`wei-029` "fails
  against `main`'s prompt text and passes against this branch's" is
  unverified by anything in the repo (fixtures are never dispatched
  mechanically, rule per `CLAUDE.md`); the samples do grade as labelled,
  which is as far as a repo-only check can go.

Separately flagged, out of this release's audited range and not fixed
here: `README.md`'s Contact/Cite section carries a personal name, an email
address and a GitHub account name directly in the shipped doc. This
predates the `v1.29.7` tag (the README diff in this release's range is one
roster-row line), so it is outside `v1.29.7..HEAD` and outside
`haruto-nakamura`'s surface (user docs are `anya-petrov`'s, rule 19) —
flagged for the owner, not touched.

One claim in the audit's own internal aggregation was self-corrected before
reaching this note: one specialist's draft severity (Critical/Major) for
the two Low findings above counted lines across all four commits rather
than #178 alone; victor re-checked with `git show --numstat` and re-rated
both Low.

## 6. Remaining open issues or pending items
- The two deferred Low findings in §5, routed to `zofia-kaminska` (board
  wording) and the Layout-tree owner.
- The pre-existing README Contact-section leak, routed to `anya-petrov` /
  the owner — out of this release's audited range.

## 7. Totals or cost changes
`agents/` + `commands/`: 5786 lines (ceiling 5754, limit 5869 — Check 37
green). Up from 5752 at v1.29.7: #178 adds `commands/extract.md` (+26) and
net +8 to `agents/wei-lin.md`; the owner approved this addition explicitly
ahead of the cut, and this release does not cut lines to chase the ceiling
(brief, this release).

## 8. Assumptions used
None beyond what the commands in this note produced, run directly against
the commits and SHAs named.

## 9. CI run this release was gated on
Pre-merge, PR #185's branch head `e147f659c424b7f5e3731df6edc95e9a3c265619`:
run `39803339887`, conclusion `success`. Post-squash-merge on `main`, SHA
`59449173f4dc4fe3b6fc6b533d62e13ebd9711ef` (the tagged commit): run
`39805836865`, conclusion `success` (tag-ref push of `v1.30.0` onto the same
SHA triggered a second run, `39806136239`, also `success`).

## Trend since v1.29.7
- **Gate assertions.** `bash tests/check.sh` — v1.29.7 (`c954c06`): 1446
  passed, 0 failed. v1.30.0 (`e147f65`, pre-cut): 1581 passed, 0 failed.
  Better (more checks running — new fixtures add check volume — none
  failing).
- **Fixture verdicts.** `bash evals/run.sh list` / `score` at both commits:
  v1.29.7 — 37 cases, 9 stale, 28 never-run, currency 0/37. v1.30.0 — 44
  cases (7 new from `wei-023`..`wei-029`), 9 stale (unchanged), 35
  never-run, currency 0/44. More fixtures, same staleness count, currency
  unchanged (expected: `run.sh` never dispatches an agent).
- **Tracked text lines.** `git diff --stat v1.29.7..HEAD -- '*.md' '*.sh'
  '*.py'` (repo's tracked text extensions): 39 files changed, +456/−25.
- **Board currency.** `PATHWAY_FORWARD.md` at both commits: v1.29.7 — 13
  VERIFIED, 0 BROKEN, 0 blank `last-checked`, 35 rows. v1.30.0 — 14
  VERIFIED, 0 BROKEN, 0 blank, 36 rows (row 36, this release's new
  command). Better (one more row closed, none regressed).
- **CI green-on-first-try rate.** `gh run list --limit 20` since v1.29.7's
  tag push (2026-10-21T21:14Z) through this release's branch push: 20/20
  listed runs `success`; no failed or re-run entry visible in that window.

This section reports; it does not gate. Tracked lines grew (+456/−25, net
+431, most of it seven new fixture directories plus `commands/extract.md`)
while the gate, fixture and board numbers all moved in step or stayed flat
— no deterioration to call out. The prompt-line ceiling grew by design
this release (owner-approved, §7), which the project's own rule 1b
earmarks as reportable here rather than gating.

## Work record
- audit: victor-reyes's report on `c954c06..e147f65` — nothing blocking,
  2 Low, 1 Advisory, 1 informational (the leak, fixed, §5).
- correctness: lars-eriksson found no logic errors or broken cross-
  references in the new fixtures or `agents/wei-lin.md`/`commands/
  extract.md`; sophia-okafor found no cross-reference breaks, two Low
  doc-currency gaps (§5).
- conciseness: not run — `kai-fischer` not dispatched. The diff is a new
  26-line command file, wording-level gap closures in `agents/wei-lin.md`,
  and seven new fixture directories; the audit identified no duplication
  or complexity needing simplification, and the owner already approved the
  line growth (§7), so there was no refactor scope to open (rule 1 — not
  an invitation to tidy unrelated code).
- fixes: 1 applied (the release-note leak scrub, §5, mine to make). 2
  deferred (board wording, Layout tree, §6), 1 flagged out of range
  (README Contact section, §6).
- docs: `PATHWAY_FORWARD.md` and `README.md` checked against the
  filesystem — both already current for `/extract` (landed by #178
  itself); no drift found needing this release to update them.
- refactor: not run — see conciseness above; no agent prompt beyond
  `agents/wei-lin.md`'s seven gap-sentences changed.
- rules: no `zofia-kaminska` pass run this release (no rule-book change in
  range); `tests/check.sh` (the mechanical rule gate) is green, 1581
  passed / 0 failed, at `e147f65` and re-confirmed at the final commit
  below.

## Release gate
Pre-tag stranger clone, under `env -i HOME=/tmp/consilium-clone-scratch/home`
(scratch, never the real `HOME`), `git clone` of `59449173f4dc4fe3b6fc6b533d62e13ebd9711ef`:
exit 0; `bash tests/check.sh` in that same env: 1493 passed, 0 failed
(`clone: PASS 59449173`).

`bash tests/release_gate.sh release_notes_v1.30.0.md` in a fresh clone,
checked out on `main` (tracking `origin/main`) at `59449173`: **release
gate: 5 passed, 0 failed, 0 skipped.**
- tree: clean, one worktree, level with upstream
- ci: green on `59449173`
- publish: v1.30.0 pushed and pointing at `59449173`
- release: GitHub Release exists for v1.30.0
- clone: fresh clone of v1.30.0 — README's install block and its first
  following command both exited 0
