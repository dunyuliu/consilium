# Release notes — v1.29.4 — 2026-10-17

## 1. Version and date

v1.29.4, cut 2026-10-17, patch bump over v1.29.3 (`832e62e`, 2026-10-16).
Patch because the range adds no new agent and no new command — seven commits
refining existing rules, board mechanics, one agent/command text set (net 0
lines), one new fixture, and the stale CITATION/README/citing version
strings, plus this release's own audit pass.

## 2. Summary of scope

Seven commits since v1.29.3, all already merged to `main`. The trigger
message ("#151–#156 plus one more") undercounted by naming six; the seventh,
`b1dcc86` (#150), is v1.29.3's own post-tag fixup and is included here
because it lands inside the `v1.29.3..HEAD` range this release ships:

- `b1dcc86` (#150): v1.29.3's own follow-up, transcribing its final CI run
  and release-gate rows into `release_notes_v1.29.3.md` (docs-only).
- `d954f23` (#151): an owner verb naming no target means survey the project
  for that verb's work and do it, never narrowing to an earlier-scoped item
  (fixture `wei-020`); a citation check reads full text when a local PDF is
  given, a verdict short of verified quotes the page or says ABSTRACT ONLY;
  a drift auditor's "code does X" cites the code path that built the
  artifact; the general-purpose stop line sits above any project header.
- `f44d021` (#152): the porting specialist ports against a reference
  implementation — a loader or wiring build framed as "parity" is no port.
- `1512063` (#153): `/audit` returns findings inline and writes no file
  unless the rule book names where audits go or the user asks.
- `1438d35` (#154): run folders are `runs/expNNN<v>_<slug>/`; board row IDs
  are `1, 2, 3` with `1a, 1b` sub-rows, never reused or renumbered.
- `9a702be` (#155): consilium's own board rows renamed `PF-NNN` → bare
  numbers (`PF-006` → row `6`, no number changes); live references in
  `PROJECT_RULES.md` follow, history untouched; Check 12 now reddens on a
  malformed or reused id instead of skipping it.
- `04230af` (#156): a variant carries only the asked change; one a-priori
  rule picks every compared arm's checkpoint or window; a rule/board change
  that falsifies another row updates it in the same PR; v1.29.3's own
  deferred findings fixed — `wei-019`'s `must_not_find` guard made
  declarative with a denial sample, `haruto-nakamura.md` merges with the
  rule book's method flag and uses step 7's note path, a `wei-lin.md`
  sentence break, a ledger row wording fix, `CITATION.cff`/`README.md`/
  `docs/user/citing.md` bumped to 1.29.3.

This release's own contribution: the audit pass (`victor-reyes` plus a
scoped `kai-fischer` conciseness pass), bumping `CITATION.cff`/`README.md`/
`docs/user/citing.md` from 1.29.3 → 1.29.4, this note, and the archive move.

## 3. Files added / removed / renamed / cleaned up

**Added**: `release_notes_v1.29.4.md` (this file);
`evals/cases/wei-020-owner-verb-no-target/` (`README.md`, `case.yaml`,
`input/RUN_LOG.md`, `samples/fail.md`, `samples/pass.md`) — landed by #151,
confirmed structurally sound (no symlink, no leaked answer key, no `expected`
term in `input/`) by this release's audit; one `must_not_find` guard
(`"the refactor round is complete"`) is unexercised by either sample — a
Minor authoring gap, not a gate failure (§5/§6).

**Removed**: nothing.

**Renamed**: `release_notes_v1.29.3.md` (repo root) →
`docs/release_notes_v1.29.3.md` (rule 8 — archived verbatim, content
unchanged).

**Modified** (by the seven already-merged commits, #150-#156):
`release_notes_v1.29.3.md` (pre-archive, by #150); `PROJECT_RULES.md`
(`PF-NNN` → bare board-row-number references, 6 lines); `PATHWAY_FORWARD.md`
(board rows renamed `PF-NNN` → bare numbers, 196-line diff, no row content or
ordering changed); `README.md` (`/audit` roster description updated for
#153; `CITATION.cff`/`README.md`/`docs/user/citing.md` version bump to
1.29.3 by #156); `docs/maintainer.md`, `docs/lessons_ledger.md` (append);
`agents/dunyu-liu.md`, `agents/haruto-nakamura.md`, `agents/sophia-okafor.md`,
`agents/victor-reyes.md`, `agents/wei-lin.md`, `agents/ziyan-chen.md`,
`agents/zofia-kaminska.md`, `commands/audit.md`, `commands/brief.md` (net 0
lines across all nine — see §5); `tests/check.sh`, `tests/parse_board.awk`,
`evals/run.sh`, `evals/results.tsv` and several `case.yaml` files (board-id
and rule-text references updated to match).

**Modified by this release**: `CITATION.cff`, `README.md`,
`docs/user/citing.md` — version `1.29.3` → `1.29.4`, date `2026-10-16` →
`2026-10-17` (all three, per rule 19 — `anya-petrov`'s surface, actioned
here per the release trigger's explicit instruction). No other finding from
the audit (§5) fell on a surface this release owns.

## 4. Content updates to master documents

`PROJECT_RULES.md` and `PATHWAY_FORWARD.md`: every `PF-NNN` board-row
reference renamed to the bare row number (#155), content and ordering
otherwise unchanged — confirmed by `git diff v1.29.3..HEAD -- PROJECT_RULES.md`
(12 lines, all `PF-0NN` → `board row NN` substitutions) and the board-row
count/state tally in §10 (unchanged: 13 VERIFIED, 22 RETIRED, 0 blank
`last-checked`, both before and after). `CLAUDE.md` unchanged this range.

## 5. Audit findings and fixes

`victor-reyes` was dispatched on `v1.29.3..HEAD`, Agent-tool access
available. It flagged the commit-count undercount in its own brief (6 named
vs. 7 actual, `b1dcc86` missing) — corrected in §2 above. It found the
`agents/+commands/` net-0 claim across #154/#155/#156 true by direct count
(5752 → 5752, unchanged), the `haruto-nakamura.md` step 11/12 edit faithful
to its commit message, and no leaked personal name, host, or absolute path
in anything that ships (the `dunyu-liu` code-name and the `Liu, Dunyu`
CITATION/citing author line are both carve-outs under the project's own
leak-free rule — code-name and citation authorship). Verdict: **safe to
release as a patch**.

`kai-fischer` ran separately, scoped to the `agents/*.md`/`commands/*.md`
lines actually touched by this diff (read-only, no edits). Verdict:
**nothing to cut** — every touched hunk is a same-line-count edit (31
insertions / 31 deletions across the nine files), no duplicated block, no
addition that could have replaced existing prose instead of appending beside
it. Net line-delta confirmed 0.

**Findings (0 Critical)**:

| # | Severity | Location | Issue | Disposition |
|---|---|---|---|---|
| 1 | Major | `PROJECT_RULES.md:401-404` vs `:421` | Rule 15a's body ("never push a tag separately… create the tag and the Release in one step") contradicts its own "How to apply" line ("tag locally, push commit, push tag, then require green"). Confirmed pre-existing — this diff does not touch either line (the only rule-15a-adjacent edits in range are the `PF-033`→`board row 33` cosmetic renames, elsewhere in the file). | Deferred — `PROJECT_RULES.md` rule-text correctness is `zofia-kaminska`'s surface (rule 19), not this release's to resolve by invention; this release followed the body text (create tag + Release together, never push a tag alone), consistent with `agents/haruto-nakamura.md`'s own step 12. |
| 2 | Minor | `evals/cases/wei-019-no-op-wake-per-tick/case.yaml:33-35` | The `must_not_find` keyword was rewritten (declarative, per rule 25) from `"next tick at 10:28"` to `"I look at the next tick"`, but `samples/fail.md`'s text (`"...and look at the next tick at 10:28"`) no longer contains the new phrase verbatim — the sample still grades FAIL correctly via the other guard, so Check 15 is green, but this guard is now untested in both directions. | Deferred — `evals/cases/*` is `iris-vermeulen`'s surface. |
| 3 | Minor | `evals/cases/wei-020-owner-verb-no-target/case.yaml` | One of three `must_not_find` guards (`"the refactor round is complete"`) is unexercised by either `samples/pass.md` or `samples/fail.md` — same untested-guard pattern as #2. | Deferred, same owner. |
| 4 | Info | commit-count framing | The release trigger named "#151–#156 plus one more, making 7" but the six-commit list in the trigger's own phrasing (and this release engineer's initial audit-dispatch brief) undercounted by one, omitting `b1dcc86` (#150). No content impact — `b1dcc86` is v1.29.3's own docs-only fixup, already reconciled with the live `release_notes_v1.29.3.md`. | Corrected in §2; no further action. |
| 5 | Info | `bash evals/run.sh list` | `wei-019`, `wei-020`, and 23 others show NEVER RUN or STALE against the current prompt SHA — reporting measure only (rule 25d), not a release gate. | No action — recorded in §10. |

## 6. Remaining open issues or pending items

- `zofia-kaminska`: rule 15a's body text and its own "How to apply" line
  disagree on whether a tag is ever pushed separately from its Release
  (§5, finding 1) — pre-existing, carried from before v1.29.3, still open.
- `iris-vermeulen`: `wei-019`'s rewritten guard no longer matches its own
  `fail.md` sample (§5, finding 2); `wei-020`'s third guard is untested by
  either sample (§5, finding 3).
- Carried from v1.29.3, unresolved and untouched by this range:
  `docs/lessons_ledger.md` call-count disagreements for rows 10-13/10-14
  (needs the original inbox digests, outside this repo); `wei-017`'s
  criteria not yet forcing lars-eriksson-first ordering;
  `agents/zofia-kaminska.md:17`'s main-checkout test also trips a genuinely
  isolated fresh clone; `commands/autopilot.md:6`'s unreadable-budget
  default has no home in `agents/wei-lin.md` itself; the `v1.29.1` GitHub
  Release body still shows the pre-correction SHA.
- Rule 1b line ceiling (5754) has 2 lines of headroom, unchanged this
  release (`agents/`+`commands/` at 5752).

## 7. Totals or cost changes

`bash tests/check.sh`: 1350 passed, 0 failed (v1.29.3) → 1365 passed, 0
failed (this release, pre-release-commit HEAD). `agents/`+`commands/` line
count: unchanged at 5752 (ceiling 5754, 2 lines headroom).

## 8. Assumptions used

- `victor-reyes`'s report was taken at face value for its direct-inspection
  findings (net-0 line count, no sub-dispatch needed); this release
  independently re-ran `tests/check.sh` and the fixture-count comparison
  rather than trusting the report's numbers alone.
- `kai-fischer`'s "nothing to cut" verdict was spot-checked against
  `git diff --stat -- agents/ commands/` (31/31, net 0), not re-derived
  hunk by hunk beyond that.
- The seven already-merged commits (#150-#156) were taken as correctly
  reviewed at merge time (each green on CI individually — confirmed in
  §10); this release re-audits their cumulative effect since v1.29.3, not
  each PR's own review.
- Rule 15a's self-contradiction (finding 1) was left unresolved by design —
  judgment calls on rule-book text are not this release's to invent a fix
  for; this release followed the stricter, more recently amended body text.
- Per this project's leak-free instruction, CI and release references below
  are recorded by run id / tag / SHA, not by full host URL, and this note
  was grepped for absolute paths and personal names before every push.

## 9. CI run this release was gated on

**Process note.** `main` lands every release commit through a PR, same as
v1.29.1-v1.29.3. Filled after the release PR is merged and the exact tagged
SHA is known (this project squash-merges, so the merge produces a new SHA
distinct from this branch's tip) — see the follow-up fixup commit, same
two-commit pattern used for v1.29.3 (#149 + #150).

## 10. Trend since v1.29.3 (832e62e)

- **Gate assertions** (`bash tests/check.sh`): 1350 passed, 0 failed → 1365
  passed, 0 failed. Better (+15 assertions, still 0 red) — growth from
  Check 12's reused/malformed-id validation (#155) and fixture `wei-020`
  (#151).
- **Fixture verdicts** (`bash evals/run.sh list` / `score`): 33 cases → 34
  cases (+1: `wei-020`). Verdict currency unchanged at 0% both times (0/33
  → 0/34); never-run rose 24 → 25 (the one new fixture, not yet
  hand-graded); stale unchanged at 9. Neither better nor worse by this
  measure alone — new coverage added, none of it graded yet.
- **Tracked text lines** (`git diff --shortstat v1.29.3..HEAD -- '*.md'
  '*.yaml' '*.sh' '*.awk' '*.tsv' '*.cff'`, counted repo-wide): 32 files
  changed, 340 insertions(+), 186 deletions(-).
- **Board currency** (`PATHWAY_FORWARD.md`, `## Board` section): 13
  VERIFIED, 22 RETIRED, 0 BROKEN, 0 blank `last-checked` rows — identical at
  both commits (35 rows total); only the row-id spelling changed (`PF-NNN` →
  bare number), confirmed by `git diff v1.29.3..HEAD -- PATHWAY_FORWARD.md`
  showing no row content, state, or date changes.
- **CI green-on-first-try rate**: 7/7 pushes to `main` since v1.29.3's tag
  (`832e62e`) through this release's merge-base (`04230af`) concluded
  `success`, one run each, no re-run observed (`gh run list --branch main
  --json conclusion,headSha,attempt` filtered to the SHA range) — 100%,
  unchanged from v1.29.3's 100%.

This section reports; it does not gate. Tracked lines grew (mostly the
`PF-NNN` rename's mechanical diff plus one new fixture) while the gate
assertion count improved and the fixture population grew without being
graded — the same shape the last several releases flagged, with no new
mechanical-fixture defect introduced by this release's own hand (none were
made — §5).

## 11. Work record

- audit: `victor-reyes` on `v1.29.3..HEAD` (7 commits, corrected from the
  trigger's undercount of 6), with Agent-tool access this run, reported 1
  Major (pre-existing rule 15a self-contradiction, out of this diff's
  scope), 2 Minor (`wei-019`/`wei-020` fixture guards untested by their own
  samples), 2 Info, 0 Critical. Verdict: safe to release as a patch.
- correctness: 0 Critical, 0 Major introduced by this diff; the one Major
  finding is pre-existing rule-book text this release does not own.
- conciseness: `kai-fischer` reviewed the touched `agents/*.md`/
  `commands/*.md` lines, scoped and read-only — verdict "nothing to cut,"
  net line-delta confirmed 0; line ceiling unchanged at 5752/5754.
- fixes: the explicitly-requested version bump (`CITATION.cff`, `README.md`,
  `docs/user/citing.md`, 1.29.3 → 1.29.4) applied. All audit findings
  deferred to their named owners (`zofia-kaminska`, `iris-vermeulen`); none
  invented.
- docs: `PROJECT_RULES.md`/`PATHWAY_FORWARD.md` board-id rename reconciled
  against the live `## Board` table (§4, §10 — row content/state/date
  tallies unchanged); `CITATION.cff`/`README.md`/`docs/user/citing.md`
  reconciled against the filesystem (all three now read 1.29.4 at this SHA).
- refactor: `kai-fischer` ran, scoped to the release diff's `agents/`+
  `commands/` lines (§5) — verdict "nothing needed," net-0 line delta,
  every hunk a same-line-count edit.
- rules: checked directly against `PROJECT_RULES.md` myself (rule 10's
  fixture-justification convention followed by `wei-020`'s notes; rule 1's
  root whitelist unchanged, Check 31 green once this note exists; no
  naming-convention violation; no duplicate fixture id). One pre-existing
  rule-book self-contradiction (rule 15a, §5 finding 1) surfaced and routed
  to `zofia-kaminska`, not resolved here.

## 12. Release gate

Filled after the tag is cut — `bash tests/release_gate.sh
release_notes_v1.29.4.md` to be run in a fresh clone of the pushed tag, same
two-commit pattern as v1.29.3 (§9).
