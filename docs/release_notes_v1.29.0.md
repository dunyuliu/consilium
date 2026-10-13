# Release notes — v1.29.0 — 2026-10-10

## 1. Version and date

v1.29.0, cut 2026-10-10, minor bump over v1.28.6 (2325e9f, 2026-10-09). Minor
because the range adds two new commands (`/brief`, `/brief-loop`) — new
user-facing surface, not a patch-sized fix.

## 2. Summary of scope

Eleven already-merged PRs (#114-#124) folded into one minor release, plus this
release's own audit pass and the two owner-surface fixes it required:

- `/brief` and `/brief-loop`: a new one-screen owner report and a recurring
  cron that arms it, replacing other reporting crons (#120-#123).
- A run of inbox-triage lessons (#114-#119, #124) landing fixes in
  `agents/haruto-nakamura.md`, `agents/priya-nair.md`, `agents/victor-reyes.md`,
  `agents/wei-lin.md`, `commands/autopilot.md`, `commands/eval-deployment.md`,
  and five new eval fixtures (`haruto-003`, `wei-006` through `wei-009`).
- This release's own audit (below): two Medium findings on owner surfaces,
  both fixed before the cut.

## 3. Files added / removed / renamed / cleaned up

**Added**: `commands/brief.md`, `commands/brief-loop.md`;
`evals/cases/haruto-003-no-ci-named-gate/`,
`evals/cases/wei-006-reap-by-dispatch-record/`,
`evals/cases/wei-007-cap-handoff-main-checkout/`,
`evals/cases/wei-008-cap-after-context-summary/`,
`evals/cases/wei-009-job-swap-by-pr/` (each with README, case.yaml,
input/, samples/pass.md, samples/fail.md).

**Removed**: 12 lines from `commands/eval-deployment.md` — content that
duplicated `agents/nadia-hadid.md` verbatim (confirmed by this release's
audit; nothing unique was lost).

**Renamed**: `release_notes_v1.28.6.md` (repo root) →
`docs/release_notes_v1.28.6.md` (rule 8 — archived verbatim, content
unchanged).

**Modified** (by the eleven already-merged PRs): `agents/haruto-nakamura.md`,
`agents/priya-nair.md`, `agents/victor-reyes.md`, `agents/wei-lin.md`,
`commands/autopilot.md`, `docs/lessons_ledger.md`, `docs/user/commands.md`,
`README.md`, `tests/check.sh`.

**Modified further** (this release's own audit-fix pass, below):
`PROJECT_RULES.md`, `README.md`.

## 4. Content updates to master documents

`docs/lessons_ledger.md` gained 21 entries (the inbox-triage rows for
#114-#119 and #124); `PROJECT_RULES.md` rule 19's description of
`commands/*.md` was brought back in line with the already-shipped Check 2
relaxation (a command may invoke zero or one agent — see §5).
`PATHWAY_FORWARD.md` was not touched by the diff and board counts are
unchanged (§10).

## 5. Audit findings and fixes

`victor-reyes` audited `v1.28.6..fd73ab6`, dispatching `lian-zhao` (prompt/
command correctness), `iris-vermeulen` (fixture soundness) and
`sophia-okafor` (docs-vs-commit drift), plus checks it ran itself. Result: 0
Critical/Major, 2 Medium, 2 Low, 1 informational (one of sophia's two
arithmetic claims was wrong and was dropped on recount), 3 Advisory. Per the
owner's instruction, both Medium findings landed on owner write-surfaces
(rule 19) and were routed to that owner and fixed before this cut:

- **`zofia-kaminska`** (`PROJECT_RULES.md` — rule 19) fixed: rule 19's table
  and boundary note still described every `commands/*.md` file as invoking
  exactly one agent, after commit `d48fd31` already relaxed Check 2 to allow
  a command (`/brief`) that invokes none — a rule-11 miss (docs didn't move
  with the prompt in that commit). Fixed at `PROJECT_RULES.md` lines 739 and
  750 ("invoking zero or one of those prompts" / "a trigger wrapper for at
  most one `agents/*.md` invocation"). Verified: `bash tests/check.sh`
  unchanged pass count, 0 failed.
- **`lian-zhao`** (`README.md` rows restating `commands/` — rule 19) fixed:
  the `/brief` row in `README.md`'s commands table omitted "numbers" from
  the report's five elements, while `commands/brief.md` and
  `docs/user/commands.md` both include it. Fixed at `README.md`'s `/brief`
  row. Verified: `bash tests/check.sh` unchanged pass count, 0 failed.

Findings not routed for a fix (recorded, not invented — §6):

- The 1b prompt-line ceiling (5754) was not lowered after commit `c6dedd1`
  cut 3 lines, and `d48fd31` then spent that freed room; net growth across
  the range is +7 lines (5745 → 5752) while no single commit message claims
  that total. Disclosed in §10 below rather than acted on — tightening the
  ceiling is the ceiling owner's (`zofia-kaminska`'s) call, not a release-time
  fix.
- Commit `369b6e0`'s message states "net -3"; the measured delta for that
  commit is 0 (brief.md +5/-1, eval-deployment.md -4, net 0). Git history is
  never rewritten (rule 8 analog for commits); recorded here as the
  correction.
- Two Advisory items on fixture/prompt wording (`wei-008`'s exact-phrase
  `must_not_find` guard could miss a reworded wrong dispatch;
  `agents/haruto-nakamura.md`'s "ONE follow-up commit" clause reads as
  scoped to one sentence rather than the whole step) — Advisory severity,
  left for the respective owners' own backlog, not a release blocker.

## 6. Remaining open issues or pending items

Deferred to the human owner:

- Whether to lower the rule-1b ceiling to the current 5752 lines, or leave
  headroom at 5754 and keep disclosing growth per release (previous section).
- The two Advisory wording items above.
- Five new fixtures (`haruto-003`, `wei-006` through `wei-009`) are
  structurally sound (confirmed by `iris-vermeulen`) but have never been
  hand-dispatched and graded — currency is a reporting measure only (§10),
  not a release gate, per this project's rules.

## 7. Totals or cost changes

`bash tests/check.sh`: 1030 passed (v1.28.6) → 1129 passed, 0 failed (this
release). `agents/` + `commands/` line count: 5745 → 5752 (ceiling 5754, +7
net — disclosed above, not blocking).

## 8. Assumptions used

- The eleven already-merged PRs (#114-#124) were taken as correctly reviewed
  at merge time; this release re-audits their cumulative effect, not each
  PR's own review.
- `docs/lessons_ledger.md`'s new entries were spot-checked by `victor-reyes`
  against the commits they cite, not independently re-verified line-by-line
  by this release.
- Per this release's leak-free instruction, CI and release references below
  are recorded by run id / tag / SHA, not by full host URL.

## 9. CI run this release was gated on

**Process note, disclosed.** `main` now enforces a required status check
("check") that must already be green on a commit's own SHA before that SHA
can land — a direct `git push origin main` of the release commit (SHA
`d7d7b3f`) was rejected by branch protection (not by this project's own
gate). Landed instead via a pull request (release branch, squash-merged),
matching this agent's documented PR fallback: the pre-merge SHA `d7d7b3f`
ran CI green (both the `push` and `pull_request` triggers), then the
squash-merge produced the actual tagged SHA `a5fe24e`, which also ran CI
green before the tag was created. Both runs: workflow `structural-invariants`,
conclusion `success`. The tagged SHA is `a5fe24e`.

Pre-tag fresh-clone check (step 11): a clone of `a5fe24e` into an empty scratch directory, normal shell
environment (this project ships no pinned manifest or image — "pure bash, no
dependencies" per `tests/check.sh`'s own header — so there is no narrower
environment to build from): `bash tests/check.sh` → 1129 passed, 0 failed,
matching the pre-push count exactly. One anomaly found and not chased further
(not this release's surface): running the same clone's `check.sh` under an
artificially stripped `PATH` (`env -i PATH=/usr/bin:/bin`) silently completed
with only 1056 passed, 0 failed — fewer assertions ran, none reported as
failed or skipped. Flagged for `iris-vermeulen` (gate owner) as a possible
silent-environment-dependency gap in `tests/check.sh`; not reproducible via
anything README documents or any environment a real user runs, so not treated
as a release blocker.

## 10. Trend since v1.28.6 (2325e9f)

- **Gate assertions** (`bash tests/check.sh`): 1030 passed, 0 failed → 1129
  passed, 0 failed. Better (+99 assertions, still 0 red).
- **Fixture verdicts** (`bash evals/run.sh list` / `score`): 16 cases → 21
  cases (+5: `haruto-003`, `wei-006`-`wei-009`). Verdict currency unchanged at
  0% both times (0/16 → 0/21) — expected, `run.sh` never dispatches an agent;
  never-run rose 7 → 12 (the five new fixtures, not yet hand-graded). Neither
  better nor worse — new coverage added, none of it graded yet.
- **Tracked text lines** (`git diff --stat v1.28.6..HEAD -- '*.md' '*.sh'`):
  35 files changed, 597 insertions, 62 deletions — almost entirely new
  fixture content plus this release's own note and two one-line rule/doc
  fixes, not prompt growth (rule 1b's ceiling held: 5745 → 5752).
- **Board currency** (`PATHWAY_FORWARD.md`): 35 rows, 13 VERIFIED, 0 BROKEN, 0
  blank-`last-checked` — unchanged at both commits; the board was not touched
  by this diff.
- **CI green-on-first-try rate**: 11/11 pushes since v1.28.6 concluded
  `success`, one run each (no re-run observed), via `gh run list --commit
  <sha>` per SHA in the range — 100%.

This section reports; it does not gate. Tracked lines grew while the gate and
fixture-currency numbers improved (more assertions, more fixtures) but five of
those fixtures are ungraded coverage, not yet proven — acceptable for a minor
release, not itself evidence of a stronger suite until hand-graded.

## 11. Work record

- audit: `victor-reyes`, dispatching `lian-zhao`, `iris-vermeulen`,
  `sophia-okafor`; 2 Medium, 2 Low, 3 Advisory findings (one Low arithmetic
  claim from sophia was wrong and dropped on recount).
- correctness: no Critical/Major findings; the fixture-soundness claims
  (`haruto-003`, `wei-006`, `wei-007`, `wei-009` sound by construction;
  `wei-008` checked directly by victor against `agents/wei-lin.md:88`) held.
- conciseness: net +7 lines across `agents/`+`commands/` for the range,
  disclosed in §5/§10 rather than acted on; no duplication found beyond the
  12 lines already cut from `commands/eval-deployment.md` by an earlier PR.
- fixes: 2 owner-surface batches applied in full (`zofia-kaminska` ×1,
  `lian-zhao` ×1); 3 items deferred to the human owner (§6), none invented.
- docs: `docs/lessons_ledger.md` spot-checked against the commits it cites by
  `victor-reyes` (match, not line-by-line independent); `PATHWAY_FORWARD.md`
  checked — untouched by the diff, counts unchanged (§10).
- refactor: no dedicated `kai-fischer` pass requested — this diff touches no
  production code (prompts and fixtures only), and the one removal
  (`commands/eval-deployment.md`) was an inline dedup, not a refactor-scale
  change.
- rules: `zofia-kaminska` — one rule-19 wording drift found and fixed (§5);
  no tier changes; the rule-1b ceiling question left open for her (§6).

## 12. Release gate

- tree: PASS — clean, one worktree, no lock, level with upstream (checked in
  a fresh clone of `v1.29.0`'s default branch, after the tag).
- ci: PASS — green on `a5fe24e` (squash-merge of PR #125; pre-merge SHA
  `d7d7b3f` was also green on both its `push` and `pull_request` runs before
  merge). `main`'s required-status-check branch protection rejected a direct
  push of the release commit; landed via PR instead (§9).
- publish: PASS — `v1.29.0` pushed and pointing at `a5fe24e`.
- release: PASS — GitHub Release exists for `v1.29.0`.
- clone: PASS `a5fe24e` — fresh clone of `v1.29.0`, README's install block and
  its first following command both exited 0 (`bash tests/release_gate.sh
  release_notes_v1.29.0.md`: 5 passed, 0 failed, 0 skipped).

## 12. Release gate

__PENDING — transcribed in the single follow-up commit after the tag, per
agents/haruto-nakamura.md step 12.__
