# Release notes — v1.30.3 — 2026-11-05

## 1. Version and date
v1.30.3, cut 2026-11-05, patch bump over v1.30.2 (`d8ddbed`). Patch because
the range adds no agent and no command: three prompt-wording fixes, one
extended fixture, and ledger and board rows.

## 2. Summary of scope
Five commits since v1.30.2 (`d8ddbed..654b900`):

- `fa48f33` (#198): post-tag follow-up for v1.30.2 — transcribed its CI run
  and release-gate rows into its note (not a feature for this release).
- `f985699` (#199): `agents/haruto-nakamura.md` checks the call count before
  each release step and reports at the brief's stop line;
  `evals/cases/haruto-004-clone-before-tag/` extended (rule 10, a repeat).
- `e389902` (#200): `agents/jordan-kim.md` reports a split mismatch only
  once raw arrays differ apart from derived keys.
- `e0e2582` (#201): `agents/wei-lin.md` starts no rebase or merge past call
  80 and aborts a half-done one before the cap handoff.
- `654b900` (#202): `agents/wei-lin.md` stops her monitors before reporting,
  freezes a prose audit's list at round 1 (three rounds at most), and runs
  the page build in the fast lane.

This release's own contribution: the audit pass, two pre-tag fixes (§5),
this note, and the archive move.

## 3. Files added / removed / renamed / cleaned up
**Added**: `release_notes_v1.30.3.md` (this file). **Removed**: nothing.
**Renamed**: `release_notes_v1.30.2.md` (root) →
`docs/release_notes_v1.30.2.md` (rule 8 archive).
**Modified**: `agents/{haruto-nakamura,jordan-kim,wei-lin}.md`,
`docs/lessons_ledger.md`, `PATHWAY_FORWARD.md`,
`evals/cases/haruto-004-clone-before-tag/` (#198-#202); `agents/wei-lin.md`
line 88 and `PATHWAY_FORWARD.md` rows 6, 21, 23, 24 (this release, §5).

## 4. Content updates to master documents
`PATHWAY_FORWARD.md`: rows 6, 21, 23 and 24 gained dated re-run notes and
row 6's stale quoted summary was replaced by the current one (finding 7,
below). Counts, `grep -c` against the file: 14 VERIFIED, 0 BROKEN, 36 rows,
0 blank `last-checked` — identical at v1.30.2 and at the pre-note tree.

## 5. Audit findings and fixes
`victor-reyes` audited `v1.30.2..654b900` directly, dispatching no
specialist (one prose surface, 10 files, +61/-18 lines): "no blocker", 7
findings — 0 Critical, 3 Medium, 4 Low; 2 mechanical, 5 judgment.

Applied pre-tag by the owning surface:
- **Low, finding 4** — `agents/wei-lin.md:88` named only `git rebase --abort`
  for "any half-done one" (rebase or merge). Fixed by `lian-zhao`: now
  "`git rebase --abort` or `git merge --abort`". Line delta 0.
- **Low, finding 7** — board rows 6, 21, 23, 24 re-dated with no dated note.
  Fixed by `zofia-kaminska`, each from a command run on `654b900`; row 6 now
  quotes `Summary: 1633 passed, 0 failed`. Net +2 lines.

Deferred (judgment, not mine to invent; see §6): findings 1, 2, 3, 5, 6.

## 6. Remaining open issues or pending items
- **Medium (1)** — `agents/wei-lin.md:88`: "merge" past call 80 does not say
  whether it means `git merge` or landing a PR; read as a PR landing it goes
  beyond the filed fix. Owner: `lian-zhao`.
- **Medium (2)** — `agents/wei-lin.md:288`: "three rounds at most" does not
  say what happens when round 3 still has BLOCKER/MAJOR items open.
  Owner: `lian-zhao`.
- **Medium, suspected (3)** — `agents/jordan-kim.md:112`: "apart from derived
  or normalised keys" sits on the normalization-leak bullet and can be read
  as switching off the check on its own bullet. Owner: `lian-zhao`.
- **Low (5)** — `agents/wei-lin.md:284`: the page-build step inherits "in a
  bare clone", which has no working tree. Owner: `lian-zhao`.
- **Low (6)** — `evals/cases/haruto-004-clone-before-tag/samples/pass.md:17-18`
  lists steps 0-4 as remaining at call 55; the prompt allows starting step 0
  there. Grade unaffected. Owner: `iris-vermeulen`.
- Carried from v1.30.2 §6: the CI-action deprecation annotations in
  `.github/workflows/check.yml` (`iris-vermeulen`).
- `bash evals/run.sh list`: `haruto-004` verdict is stale (prompt changed);
  needs a hand-graded live run.

## 7. Totals or cost changes
`agents/` + `commands/`: 5786 lines (`wc -l`), unchanged from v1.30.2 —
ceiling 5754, limit 5869, Check 37 green, overrun +32 lines / 0.56%, which
predates this release.

## 8. Assumptions used
None beyond what the commands in this note produced.

## 9. CI run this release was gated on
`structural-invariants` run
https://github.com/dunyuliu/consilium/actions/runs/42138917334 — conclusion
`success`, SHA `79bccef67cf1a665f2fa1f77eaf89fe353bc597c` (the tagged commit,
release PR #203's squash merge). Pre-merge runs on the branch SHA, also
`success`: https://github.com/dunyuliu/consilium/actions/runs/42138713033 and
https://github.com/dunyuliu/consilium/actions/runs/42138835503.

## Trend since v1.30.2
- **Gate assertions.** `bash tests/check.sh`: v1.30.2 tag checked out today:
  1628 passed, 4 failed (the board-currency check, rows 6, 21, 23, 24 "overdue
  by 5d": the tag's dates aged out). Pre-note tree: 1630 passed, 1 failed
  (Check 31, the expected transient between archiving the old note and
  writing this one). Better.
- **Fixture verdicts.** `bash evals/run.sh list` at both commits: 46 cases,
  9 stale, 37 never-run, 0 graded current. Unchanged.
- **Tracked text lines.** `git diff --shortstat v1.30.2..654b900 -- '*.md'
  '*.sh' '*.py'`: 9 files, +54/-18; this release's fixes add +5/-3.
- **Board currency.** `PATHWAY_FORWARD.md` at both commits: 14 VERIFIED, 0
  BROKEN, 0 blank `last-checked`, 36 rows. Unchanged; four rows now carry a
  dated run note.
- **CI green-on-first-try rate.** `gh run list --created ">=2026-10-25"`: 31
  runs, 31 `success` — 31/31 (no re-run entries visible).

This section reports; it does not gate. Lines grew modestly while the gate
held; no deterioration.

## Work record
- audit: victor-reyes's report on `v1.30.2..654b900` — "no blocker", 7
  findings (0 Critical, 3 Medium, 4 Low); 2 fixed pre-tag, 5 deferred (§6).
- correctness: no specialist dispatched; findings 1-3 are prompt-semantics
  ambiguities, not logic errors, and stay open at Medium (no live dispatch
  could confirm them).
- conciseness: not run; `kai-fischer` not dispatched. No production code in
  range; every prompt edit was line-neutral.
- fixes: 2 applied by owners (`lian-zhao`, `zofia-kaminska`), 5 deferred (§6).
- docs: `PATHWAY_FORWARD.md` reconciled against commands run on `654b900`
  (§4); ledger rows landed by their own PRs.
- refactor: not run — no simplification target in the range.
- rules: no `zofia-kaminska` rule-book pass (no rule change in range); the
  mechanical gate is green except the expected Check 31 transient (§Trend).

## Release gate
`bash tests/release_gate.sh release_notes_v1.30.3.md`, in a fresh clone of
tag `v1.30.3` (SHA `79bccef67cf1a665f2fa1f77eaf89fe353bc597c`):
`release gate: 5 passed, 0 failed, 0 skipped`.
- tree: clean, one worktree, no lock, level with upstream
- ci: green on `79bccef6`
- publish: v1.30.3 pushed and pointing at `79bccef6`
- release: GitHub Release exists for v1.30.3
- clone: PASS `79bccef67cf1a665f2fa1f77eaf89fe353bc597c` — fresh clone, empty
  `HOME`, README's install block and `bash tests/check.sh` both exited 0
