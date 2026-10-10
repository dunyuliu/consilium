# Release notes — v1.28.6 — 2026-10-10

## 1. Version and date

v1.28.6, cut 2026-10-10, patch bump over v1.28.5 (9fd3c5d, 2026-10-08).

## 2. Summary of scope

A patch release folding in five already-merged inbox-triage PRs (#108-#112,
each "net 0" — a prompt sharpening paired with the fixture or wording fix it
earns) plus this release's own audit pass and the fixes it required on three
owner surfaces. No new agent, no new command, no version-file bump beyond the
release note itself (this project has none — rule 15: a release is a note
plus a matching tag).

## 3. Files added / removed / renamed / cleaned up

**Added** — six new eval fixtures, each pairing a recurring inbox finding
with the fix it tests:
`evals/cases/wei-001-cap-across-resumes/`,
`evals/cases/wei-002-privacy-grep-every-pr/`,
`evals/cases/wei-003-merge-method-from-rulebook/`,
`evals/cases/wei-004-greenfield-dispatch-ok/`,
`evals/cases/wei-005-branch-report-from-remote/`,
`evals/cases/zofia-004-tidy-in-use-by-path/`.

**Removed**: none.

**Renamed**: `release_notes_v1.28.5.md` (repo root) → `docs/release_notes_v1.28.5.md`
(rule 8 — archived verbatim, content unchanged).

**Modified** (by the five already-merged PRs): `agents/haruto-nakamura.md`,
`agents/lars-eriksson.md`, `agents/victor-reyes.md`, `agents/wei-lin.md`,
`agents/zofia-kaminska.md`, `commands/autopilot.md`, `docs/lessons_ledger.md`,
`tests/release_gate.sh`.

**Modified further** (this release's own audit-fix pass, below):
`agents/wei-lin.md`, `agents/zofia-kaminska.md`, `agents/haruto-nakamura.md`,
`commands/autopilot.md`, `tests/release_gate.sh`,
`evals/cases/wei-001-cap-across-resumes/case.yaml`,
`evals/cases/wei-003-merge-method-from-rulebook/case.yaml`,
`evals/cases/wei-004-greenfield-dispatch-ok/case.yaml`,
`evals/cases/zofia-004-tidy-in-use-by-path/case.yaml`.

## 4. Content updates to master documents

`docs/lessons_ledger.md` gained 36 entries (the inbox triage rows for
#108-#112), each verified against the commit it cites. `PATHWAY_FORWARD.md`
was not touched by the diff and needed no change — the audit's one finding
against it (see below) turned out to be a false positive.

## 5. Audit findings and fixes

`victor-reyes` audited `9fd3c5d..ae7eca6` (no sub-specialist dispatch — the
Agent tool was unavailable in that session, logged separately, see inbox
note) and returned 16 findings, 0 Critical/Major, 6 Medium, 7 Low, 3 Advisory.
Per the owner's instruction, every finding on an owner-write-surface (rule 19)
was routed to that owner and fixed before this cut, not deferred:

- **`lian-zhao`** (agents/*.md, commands/*.md — rule 19) fixed: the
  ambiguous ~100-vs-120 call-cap threshold in `agents/wei-lin.md`; the
  self-contradicting "sole copy beside its originals" sentence in
  `agents/zofia-kaminska.md`; a missing non-main-branch guard on autopilot's
  `git pull --ff-only` step; `wei-lin`'s resource-safety list missing `stop`;
  and the stale "one worktree" pass-text in `agents/haruto-nakamura.md`'s note
  template. Verified: `bash tests/check.sh` 1023→unchanged pass count at that
  point, 0 failed; line-count ceiling held (5745/5754).
- **`iris-vermeulen`** (test files, fixtures, CI config — rule 19) fixed:
  four fixture criteria that could reject a correct report or pass a wrong
  one on substring luck (`zofia-004`'s tautological "in use" check,
  `wei-001`'s and `wei-003`'s over-broad `must_not_find` guards, `wei-004`'s
  exact-phrasing-only positive check); and three items on
  `tests/release_gate.sh` (stale "one worktree" pass-text, a stale "Phase 1"
  comment citation, and a one-line note recording why the tree-row relaxation
  in #108 was justified, per rule 26). Verified: all four touched fixtures'
  `samples/pass.md` and `samples/fail.md` still grade correctly; `bash
  tests/check.sh` 1027 passed, 0 failed.
- **`zofia-kaminska`** (`PATHWAY_FORWARD.md` — rule 19) checked the PF-025
  fixture-id-collision finding and found it a false positive: PF-025 already
  cites the retired fixture by its full name
  (`zofia-004-seed-patch-established`), distinct from the new
  `zofia-004-tidy-in-use-by-path`, so no edit was needed. Recorded as a real
  "nothing needed" verdict, not a skipped check.

## 6. Remaining open issues or pending items

Deferred to the human owner, not fixed here (rule: never invent a fix for a
judgment call):

- **Whether `/autopilot`'s invoking session may ever write to the owner's
  main checkout.** The `git pull --ff-only` step says yes; `wei-lin`'s
  reading of rule 20 item 1 ("no agent writes to the main/master checkout")
  says no. One of the two readings is wrong; `lian-zhao` was told explicitly
  not to resolve it and left both sides as found.
- **`docs/release_notes_v1.28.5.md` §5 vs §12 self-contradiction** (whether
  the post-tag gate ran in a scratch clone of the pushed tag, or cloned
  branch `main`). Pre-existing in an already-published, now-archived release
  note; rule 8 forbids rewriting a prior release note, so this is recorded
  here rather than silently fixed in place.
- **Rule 26** (measure before relaxing a signal): commit `03fe2aa`'s
  tree-row relaxation in `tests/release_gate.sh` has no recorded before/after
  false-positive count — unmeasurable retroactively now; `iris-vermeulen`
  added a one-line justification comment instead.
- **The fixture `wei-004-greenfield-dispatch-ok` names the agent `dunyu-liu`**
  in its criteria and sample reports. `dunyu-liu` is an existing, long-shipped
  agent persona name (also used throughout `README.md` and `agents/wei-lin.md`
  before this release) and not a leak introduced by this diff, but it is
  flagged for the human to judge against the no-personal-names convention.

## 7. Totals or cost changes

`bash tests/check.sh`: 933 passed (v1.28.5) → 1027 passed, 0 failed (this
release) — 94 more structural assertions, driven by the new fixtures.
`agents/` + `commands/` line count: 5742 → 5745 (ceiling 5754, +3 net from the
autopilot branch-guard addition, offset elsewhere).

## 8. Assumptions used

- The five already-merged PRs (#108-#112) were taken as correctly reviewed
  and merged at the time; this release re-audits their cumulative effect, not
  each PR's own review.
- `dunyu-liu` in fixture/README text is treated as an established product
  persona name, not a new leak, per existing repo-wide precedent — flagged
  above rather than silently accepted or silently fixed.

## 9. CI run this release was gated on

PR #113's head (`c7f7dee`): run
https://github.com/dunyuliu/consilium/actions/runs/38019948653 — `success`.
Squash-merge commit `2325e9f74c266904c059f2c1817cac9cd41a7571` (the tagged
SHA): run https://github.com/dunyuliu/consilium/actions/runs/38019979229 —
`success`, `run_attempt: 1`.

## 10. Trend since v1.28.5 (9fd3c5d)

- **Gate assertions** (`bash tests/check.sh`): 933 passed, 0 failed → 1027
  passed, 0 failed. Better (94 more assertions, still 0 red).
- **Fixture verdicts** (`bash evals/run.sh list` / `score`): 10 cases → 16
  cases (6 new). Verdict currency unchanged at 0% in both (0/10 → 0/16) —
  expected, since `run.sh` never dispatches an agent and nothing here was
  live-graded; stale count held at 9, never-run rose 1 → 7 (the six new
  fixtures, not yet hand-graded). Neither better nor worse — new coverage
  added, none of it graded yet.
- **Tracked text lines** (`git diff --stat 9fd3c5d..HEAD -- '*.md' '*.sh'
  '*.py'`, extensions chosen to match this repo's tracked prose/code): to be
  finalized against the release commit (see follow-up); at the pre-fix
  cumulative diff it stood at 442 insertions, 67 deletions across 38 files —
  almost entirely new fixture content, not prompt growth (rule 1b's ceiling
  held: 5742 → 5745 lines in `agents/`+`commands/`).
- **Board currency** (`PATHWAY_FORWARD.md`): 35 rows, 13 VERIFIED, 0 BROKEN,
  0 blank-`last-checked` — unchanged at both commits; the board was not
  touched by this diff.
- **CI green-on-first-try rate**: 5/5 pushes since v1.28.5 (`03fe2aa`,
  `7da737b`, `3eea001`, `9d63e31`, `ae7eca6`) concluded `success` on
  `run_attempt: 1` — 100%, via `gh api repos/:owner/:repo/actions/runs/<id>`
  per SHA.

This section reports; it does not gate. Tracked lines grew (442 insertions)
while the gate and fixture-currency numbers did not improve proportionally —
most of that growth is new, ungraded fixture content, which is a coverage
bet, not yet a proven improvement. Said plainly: this is acceptable for a
patch release but is not itself evidence of a stronger suite until those six
fixtures are hand-graded.

## 11. Work record

- audit: `victor-reyes`, solo pass (no sub-specialist dispatch — Agent tool
  unavailable in that session), 16 findings (0 Critical/Major, 6 Medium, 7
  Low, 3 Advisory).
- correctness: no Critical/Major findings; the one code-logic claim audited
  (`tests/release_gate.sh`'s worktree/lock-path change, #108) verified
  correct by `iris-vermeulen` against git 2.34.1 behavior.
- conciseness: net 0 line delta across the four files `lian-zhao` touched for
  correctness ($0, 0, 0, +3$); ceiling held at 5745/5754. No separate
  simplification pass requested — the audit found no duplication or
  complexity needing one, and this project routes prompt conciseness through
  `lian-zhao` (rule 19: `agents/*.md`/`commands/*.md` have no separate
  refactor owner here).
- fixes: 3 owner-surface batches applied in full (`lian-zhao` ×5,
  `iris-vermeulen` ×7, `zofia-kaminska` ×1-verified-unneeded); 4 items
  deferred to the human owner (§6 above), none invented.
- docs: `docs/lessons_ledger.md` spot-checked against the commits it cites by
  `victor-reyes` (match); `PATHWAY_FORWARD.md` checked against the diff by
  `zofia-kaminska` (no change needed, false-positive finding); release note
  archived unchanged (rule 8).
- refactor: `lian-zhao` — no dedicated simplification pass; the correctness
  fixes above were the only edits to `agents/*.md`/`commands/*.md`, and she
  tightened wording in the two lines she was already touching (rule 1,
  smallest change) rather than hunting further.
- rules: `zofia-kaminska` — no `PROJECT_RULES.md` violations found this
  cycle; no tier changes; the one rule-adjacent finding routed to her
  (PF-025 citation) was a false positive, recorded as a real verdict.

## 12. Release gate

- tree: PENDING — known once the release commit is pushed; filled in the
  follow-up transcription commit.
- ci: PENDING — known once CI concludes on the pushed SHA (rule 15a); filled
  in the follow-up transcription commit.
- publish: PENDING — `tests/release_gate.sh`'s `publish`/`release`/`clone`
  rows structurally cannot resolve before the tag exists (rule 15b); filled
  in the follow-up transcription commit, run after the tag.
- release: PENDING
- clone: PENDING
