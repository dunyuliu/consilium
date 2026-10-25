# Release notes — v1.30.1 — 2026-10-24

## 1. Version and date
v1.30.1, cut 2026-10-24, patch bump over v1.30.0 (`59449173`). Patch because
the range adds no agent and no command — three one-line prompt wording fixes,
one new eval fixture, one extended fixture, ledger rows, and a post-tag note
transcription.

## 2. Summary of scope
Five commits since v1.30.0 (`59449173..cb5d345`):

- `4427572` (#186): post-tag follow-up for v1.30.0 — transcribed its own
  final CI run and release-gate rows into its note (rule 8/step 12
  allowance; not a feature for this release).
- `be7fd0d` (#187): 2026-10-22 inbox pass — `agents/haruto-nakamura.md` step
  4 now runs the gate on a tree whose `git status --porcelain` is empty and
  probes in a scratch copy, closing a recurrence (P24) where the release
  agent's own probing left its worktree dirty between gate runs.
- `aeaf3fa` (#188): 2026-10-23 inbox pass — `agents/iris-vermeulen.md`'s
  reproduce-first line now covers an incident the brief names, requires
  naming the triggering test, and claims a fix only once that reproduction
  passes; new rule-10 fixture `evals/cases/iris-004-reproduce-named-incident/`.
- `cd7a01e` (#189): 2026-10-23 inbox pass — `docs/lessons_ledger.md` gains
  nine rows; no prompt or fixture change.
- `cb5d345` (#190): 2026-10-24 inbox pass — `agents/wei-lin.md`'s branch
  report now marks every listed branch (board and log branches included) as
  merged, open-PR, or abandoned before any "no open branches" claim;
  `evals/cases/wei-005-branch-report-from-remote/` extended for the
  recurrence.

This release's own contribution: the audit pass (`victor-reyes`), two
pre-tag fixes it required (below, applied by the owning surfaces), this
note, and the archive move.

## 3. Files added / removed / renamed / cleaned up
**Added**: `evals/cases/iris-004-reproduce-named-incident/{README.md,
case.yaml, input/RUN_LOG.md, samples/pass.md, samples/fail.md}` (landed by
#188); `release_notes_v1.30.1.md` (this file).

**Removed**: nothing.

**Renamed**: `release_notes_v1.30.0.md` (repo root) →
`docs/release_notes_v1.30.0.md` (rule 8 archive). Untouched otherwise.

**Modified**: `agents/haruto-nakamura.md` (step 4, #187 and this release's
pre-tag fix, see §5); `agents/iris-vermeulen.md` (#188); `agents/wei-lin.md`
(#190); `evals/cases/wei-005-branch-report-from-remote/{case.yaml,
README.md}` (#190 extension and this release's pre-tag fix, see §5);
`docs/lessons_ledger.md` (#189, #187, #188, #190 rows).

## 4. Content updates to master documents
`docs/lessons_ledger.md` gained the rows documented in #187-#190 (gate
recurrence, reproduce-first recurrence, branch-report recurrence, and usage
notes) — landed by those commits, not by this release. `PATHWAY_FORWARD.md`
is unchanged and current: 14 VERIFIED, 0 BROKEN, 0 blank `last-checked`, 36
rows, identical at v1.30.0 and at this release's final commit (`grep -c "|
VERIFIED |"`, `grep -c "| BROKEN |"`, `grep -c "^| [0-9]"` against
`PATHWAY_FORWARD.md`) — no board row is owed by this diff.

## 5. Audit findings and fixes
`victor-reyes` audited `v1.30.0 (59449173)..cb5d345` (the diff before any
pre-tag fix) directly, dispatching no specialist (14 files, +152/-18 lines,
one surface class, under his own-pass threshold). Verdict: **do not tag
until two Medium findings are fixed.** `tests/check.sh` at `cb5d345`: 1607
passed, 0 failed.

Applied before the cut, by the owning surface (rule 19 — not mine to write):
- **Medium** — `evals/cases/wei-005-branch-report-from-remote/case.yaml`
  carried a `must_not_find` guard, `"no open branches"`, that rejects a
  correct report: victor graded a hand-written correct denial ("I will not
  write that there are no open branches until #43 is checked") and got a
  false FAIL on that guard (rule 25a — guards must be declarative, never
  substring-naive). Fixed by `iris-vermeulen` (fixture owner): the guard
  entry removed, the sibling guard `"open branches: none"` kept.
  Re-verified: `samples/pass.md` PASS (4/4), `samples/fail.md` FAIL (4/4
  failed, still catches "all branches deleted"), `tests/check.sh` 1607
  passed / 0 failed.
- **Medium** — `agents/haruto-nakamura.md` step 4 (added in #187) required
  running the gate "on a tree whose `git status --porcelain` is empty,"
  immediately after step 3 applies fixes to that same tree and before step
  9's commit — unsatisfiable on any release that applies a fix, which this
  one does. Fixed by `lian-zhao` (prompt owner): the empty-porcelain
  requirement now scopes to the scratch probing copy, not the main working
  tree, which may legitimately carry step 3's uncommitted fixes. Line delta
  0 (reworded in place); no `haruto-*` fixture exercises this wording
  (confirmed by grep), so the reword changes no fixture verdict;
  `tests/check.sh` 1607 passed / 0 failed, Check 37 unaffected.

Deferred as open issues (judgment calls, not mechanical, not mine to invent
a fix for — see §6):
- **Low** — `agents/wei-lin.md`'s "`git cherry` empty" branch-merge test
  never passes for a squash-merged branch (victor reproduced this in a
  scratch repo: `git cherry main feat` printed one line after a squash
  merge, not nothing). The sibling test, "its PR merged," covers the gap
  today, so no live failure has resulted. Routed to `lian-zhao`.
- **Low** — rule 25's "run it once yourself" was not done before shipping
  either `iris-004` or the extended `wei-005` case; both notes say "verified
  by the author" / "never dispatched." Rule 10's existing relaxation covers
  this gap; no fixture or prompt change forced.
- **Advisory** — the three #187/#188/#190 prompt edits each lengthened one
  line (haruto +132 bytes, iris +107, wei-lin +160) while the file line
  counts stayed flat; `agents/`+`commands/` remains 5786 lines against a
  5754 ceiling (5869 limit) — the same +32-line/0.56% overrun that predates
  this diff. Check 37 is green; flagged under the size-budget discipline,
  no cut forced.
- **Advisory** — v1.30.0's note carries 1493 as its stranger-clone assertion
  count; this release re-derives its own clone count fresh rather than
  reusing that figure (§12).

## 6. Remaining open issues or pending items
- The two Low findings above, routed to `lian-zhao`.
- The Advisory findings above: recorded, no action required while Check 37
  stays green.

## 7. Totals or cost changes
`agents/` + `commands/`: 5786 lines, unchanged from v1.30.0 (the haruto fix
is a same-line reword, net 0). Ceiling 5754, limit 5869 — Check 37 green,
overrun unchanged at +32 lines / 0.56%, which predates this release.

## 8. Assumptions used
None beyond what the commands in this note produced, run directly against
the commits and SHAs named.

## 9. CI run this release was gated on
`structural-invariants` run
https://github.com/dunyuliu/consilium/actions/runs/40132233827 — conclusion
`success`, SHA `f5d49f805d98212e1ab9dc292ac8d8d06c934f87` (the tagged commit,
pushed via the release PR's merge to `main`). An earlier run on the same SHA
triggered by the merge itself,
https://github.com/dunyuliu/consilium/actions/runs/40132163969, also
concluded `success`.

## Trend since v1.30.0
- **Gate assertions.** `bash tests/check.sh`: v1.30.0 (`59449173`): 1584
  passed, 0 failed. This release's pre-tag tree: 1607 passed, 0 failed.
  Better (more checks running from the new fixture, none failing).
- **Fixture verdicts.** `bash evals/run.sh list` at both commits: v1.30.0 —
  44 cases, 9 stale, 35 never-run. This release — 45 cases (1 new,
  `iris-004`), 9 stale (unchanged), 36 never-run. Currency unchanged
  (`run.sh` never dispatches an agent, so a new or extended case cannot
  raise it by itself).
- **Tracked text lines.** `git diff --stat v1.30.0..HEAD -- '*.md' '*.sh'
  '*.py'` (repo's tracked text extensions): 12 files changed, +91/-17.
- **Board currency.** `PATHWAY_FORWARD.md` at both commits: 14 VERIFIED, 0
  BROKEN, 0 blank `last-checked`, 36 rows — identical at v1.30.0 and here.
  Unchanged (no board row was owed by this diff, per §4).
- **CI green-on-first-try rate.** `gh run list` since v1.30.0's tag push:
  15 runs listed, all `success`, no re-run entry visible in that window —
  15/15.

This section reports; it does not gate. Tracked lines grew modestly
(+91/-17, net +74, mostly the new fixture directory and the ledger rows)
while the gate and board numbers held or improved — no deterioration to
call out.

## Work record
- audit: victor-reyes's report on `v1.30.0 (59449173)..cb5d345` — "do not
  tag until two Medium findings are fixed"; 2 Medium (both fixed pre-tag,
  §5), 2 Low and 2 Advisory (deferred, §5/§6).
- correctness: victor found no logic errors needing a specialist dispatch;
  both Medium findings were prompt/fixture-wording defects, not math or
  code-correctness bugs.
- conciseness: not run — `kai-fischer` not dispatched. The diff is three
  one-line prompt rewords, one new fixture directory, one fixture
  extension, and ledger rows; no duplication or complexity was flagged
  needing simplification.
- fixes: 2 applied, both by the owning surface (`iris-vermeulen` on the
  fixture, `lian-zhao` on the prompt), neither by the release engineer. 2
  deferred (Low, §6). 2 advisory, no action forced (§6).
- docs: `PATHWAY_FORWARD.md` checked against the filesystem — already
  current, no drift found needing this release to update it (§4).
- refactor: not run — see conciseness above; the two pre-tag fixes were
  each a single reworded/removed line on their owning surface, not a
  simplification pass.
- rules: no `zofia-kaminska` pass run this release (no rule-book change in
  range); the mechanical rule gate (`tests/check.sh`) is green, 1607 passed
  / 0 failed, on the final pre-tag commit.

## Release gate
`bash tests/release_gate.sh release_notes_v1.30.1.md`, run in a fresh clone
against tag `v1.30.1` (SHA `f5d49f805d98212e1ab9dc292ac8d8d06c934f87`):
`release gate: 5 passed, 0 failed, 0 skipped`.
- tree: clean, one worktree, no lock, level with upstream
- ci: green on `f5d49f80`
- publish: v1.30.1 pushed and pointing at `f5d49f80`
- release: GitHub Release exists for v1.30.1
- clone: PASS `f5d49f805d98212e1ab9dc292ac8d8d06c934f87` — fresh clone of
  v1.30.1, README's install block and its first following command both
  exited 0
