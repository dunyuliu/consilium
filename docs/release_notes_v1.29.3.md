# Release notes — v1.29.3 — 2026-10-16

## 1. Version and date

v1.29.3, cut 2026-10-16, patch bump over v1.29.2 (`5fcb044`, 2026-10-14).
Patch because the range adds no new agent and no new command — six
already-merged inbox-triage commits refining existing prompts, one fixture,
and the ledger, plus this release's own audit pass.

## 2. Summary of scope

Six commits since v1.29.2, all already merged to `main` (PRs #143-#148):

- `38d74c2` (#143): v1.29.2's own follow-up, transcribing its final CI run
  and release-gate rows into `release_notes_v1.29.2.md` (docs-only).
- `c96ebb9` (#144): a shared clause on treating a context summary's
  resume-directive lines as the harness's own, never the invoker's, across
  several `agents/*.md` files; a conductor wake-rule restricting her to
  state-change or deadline wakes, never a per-tick poll; a one-line
  clarification in `agents/kai-fischer.md`'s description; new fixture
  `evals/cases/wei-019-no-op-wake-per-tick/`.
- `740d0a1` (#145): a rule that a conductor turn resumed past its cap, or
  after its run ended, merges nothing — including a child's finished
  landing — and logs the child's branch and SHA for the successor.
- `6e19c07` (#146): a release note is re-read against the exact SHA it tags,
  before the tag, with every count and diffstat pasted from a command run on
  that SHA; a conductor puts the audit report's text into the release brief
  verbatim.
- `dc65d4c` (#147): the release note goes wherever the root whitelist puts
  it, re-checked once written; the release commit lands through a PR on
  projects that land every commit that way; a stop-line number correction
  carried into `agents/haruto-nakamura.md` and one fixture's input.
- `a88b0cc` (#148): a conductor's landing step reads the rule book's merge
  method flag before its first merge, rather than defaulting to
  squash-merge; fixture `wei-003` extended to touch a script so it reaches
  that step.

This release's own contribution: the audit pass (`victor-reyes` plus a
scoped `kai-fischer` conciseness pass), this note, and the archive move. No
mechanical fixes were applied this cycle — see §5.

## 3. Files added / removed / renamed / cleaned up

**Added**: `release_notes_v1.29.3.md` (this file);
`evals/cases/wei-019-no-op-wake-per-tick/` (`README.md`, `case.yaml`,
`input/transcript_tail.txt`, `samples/fail.md`, `samples/pass.md`) — landed
by #144, confirmed structurally sound (no symlink, no leaked answer key) by
this release's audit, though its `must_not_find` guard has an open defect
(§5/§6, routed to its surface owner).

**Removed**: nothing.

**Renamed**: `release_notes_v1.29.2.md` (repo root) →
`docs/release_notes_v1.29.2.md` (rule 8 — archived verbatim, content
unchanged).

**Modified** (by the six already-merged commits, #143-#148):
`release_notes_v1.29.2.md` (pre-archive, by #143); `agents/wei-lin.md`,
`agents/haruto-nakamura.md`, `agents/anya-petrov.md`, `agents/kai-fischer.md`
(one to a few lines each); `docs/lessons_ledger.md` (25-line append);
`evals/cases/wei-003-merge-method-from-rulebook/`
(`README.md`, `case.yaml`, `input/PR_14.md`, `samples/fail.md`,
`samples/pass.md`); `evals/cases/wei-013-cap-mid-turn-summary/`
(`case.yaml`, `input/transcript_tail.txt`).

**Modified by this release**: none. Every finding from the audit (§5) sits
on a write surface this release does not own (`agents/*.md` fixture/test
files) — none fall on release notes, version files, or tags
(`haruto-nakamura`'s own surface per rule 19), so there was nothing
mechanical for this release to apply.
`PROJECT_RULES.md`, `README.md`, `PATHWAY_FORWARD.md`, `CLAUDE.md` confirmed
byte-identical to v1.29.2 (`git diff v1.29.2..HEAD -- PROJECT_RULES.md
README.md PATHWAY_FORWARD.md CLAUDE.md` empty).

## 4. Content updates to master documents

None. See §3.

## 5. Audit findings and fixes

`victor-reyes` was dispatched on `v1.29.2..a88b0cc` with Agent-tool access
available this run. It chose not to dispatch sub-specialists, reasoning that
the diff touches no test scripts (no scope for a code-correctness pass) and
that the drift/fixture-design questions were settled by direct inspection
and one grader run; its own words: *"A dispatch would have cost about 10x
without adding an independent view."* Its verdict: **safe to release as a
patch** — no Critical findings, no new agent or command, net 0 line delta to
the shipped prompts.

`kai-fischer` ran separately, scoped to this diff, for the refactor/
conciseness pass (rule 3a). Verdict: **nothing to cut** — the four touched
agent files net 0 lines (13 insertions / 13 deletions), every addition
replaces or extends an existing line in place rather than appending a
duplicate block, and each is a named-recurrence fix (#140, #144, #145,
#147, #148) rather than restated prose.

**Findings (0 Critical)**:

| # | Severity | Location | Issue | Disposition |
|---|---|---|---|---|
| 1 | Medium | `evals/cases/wei-019-no-op-wake-per-tick/case.yaml:31-33` | A correct report can contain a `must_not_find` phrase inside a correct refusal (e.g. "there is no reason to keep my watcher running" trips the guard on "keep my watcher running"); rule 25a requires guarding on a verdict-shaped phrase, not a bare substring. | Deferred — fixture/test surface is `iris-vermeulen`'s (rule 19), not this release's to edit. |
| 2 | Medium | `evals/cases/wei-019-no-op-wake-per-tick/case.yaml:35-39` | No recorded adversarial author pass, unlike the other two fixtures in this diff — the pass that would have caught #1. | Deferred, same owner; mechanical once #1 is resolved. |
| 3 | Minor | `agents/haruto-nakamura.md:272` | Still hard-codes "Squash-merge the release PR," the same defect class #148 just fixed in `agents/wei-lin.md` (read the rule book's merge-method flag rather than defaulting); #147 made this step reachable by routing release commits through a PR. | Deferred — `agents/*.md` is `lian-zhao`'s surface. |
| 4 | Minor | `agents/haruto-nakamura.md:265` vs `:278` | Step 7 lets the note's path follow the root whitelist, but step 12's `gh release create --notes-file` and `tests/release_gate.sh`'s own invocation still assume the root path literally. | Deferred, same owner. |
| 5 | Low | `agents/wei-lin.md:257` | Missing sentence break: "...never raised) Always isolate..." reads as one run-on clause. | Deferred, same owner — a one-line punctuation fix, but still on a surface this release does not write. |
| 6 | Info | `agents/kai-fischer.md:3` vs `PROJECT_RULES.md` rule 19 table | `kai-fischer`'s description now explicitly declines to add behavior, but the ownership table has no row for "add behavior to existing code" (only "simplify" and "create new"). | Routed to `zofia-kaminska` — rule-book coverage question, not a release defect. |
| 7 | Info | `docs/lessons_ledger.md:149` | The ledger records that the prompt-refinement owner declined this edit, yet it landed anyway through inbox triage. | Owner decision, outside this release's scope. |
| 8 | Info | `bash evals/run.sh list` | `wei-003`, `wei-013`, `wei-019` all show NEVER RUN against the current prompt SHA — reporting measure only (rule 25d), not a release gate; `run.sh` cannot invoke an agent. | No action — recorded in §10. |
| 9 | Info | `CITATION.cff:4`, `README.md:177` | Both still read version `"1.27.0"` (dated 2026-09-18) — stale across every release since, including this one. Outside the audited diff range (neither file changed `v1.29.2..a88b0cc`) and outside this release's write surface (`anya-petrov`'s per rule 19). | Routed to `anya-petrov`. |

## 6. Remaining open issues or pending items

- `iris-vermeulen`: `wei-019`'s `must_not_find` guard rejects a plausible
  correct report; rewrite as verdict-shaped phrases and add the adversarial
  pass note the other two fixtures in this diff carry (§5, findings 1-2).
- `lian-zhao`: `agents/haruto-nakamura.md:272` still hard-codes
  "Squash-merge" after #148 fixed the same class of bug in
  `agents/wei-lin.md`; and step 7 vs step 12/`release_gate.sh` disagree on
  whether the note's path is whitelist-derived or root-literal (§5, findings
  3-4).
- `lian-zhao`: `agents/wei-lin.md:257` has a missing sentence break (§5,
  finding 5).
- `zofia-kaminska`: rule 19's ownership table has no row for "add behavior
  to existing code" (§5, finding 6).
- Owner: `docs/lessons_ledger.md:149` records a declined edit that landed
  anyway via inbox triage (§5, finding 7).
- `anya-petrov`: `CITATION.cff` and `README.md`'s BibTeX block both still
  say version `1.27.0`, unchanged since 2026-09-18 across five patch and
  minor releases (§5, finding 9).
- Carried from v1.29.2, unresolved: `docs/lessons_ledger.md` call-count
  disagreements for rows 10-13/10-14 (needs the original inbox digests,
  outside this repo); `wei-017`'s criteria not yet forcing
  lars-eriksson-first ordering; `agents/zofia-kaminska.md:17`'s
  main-checkout test also trips a genuinely isolated fresh clone;
  `commands/autopilot.md:6`'s unreadable-budget default has no home in
  `agents/wei-lin.md` itself; the `v1.29.1` GitHub Release body still shows
  the pre-correction SHA. None were touched by `v1.29.2..a88b0cc`, so none
  are re-verified or re-opened here; still open where v1.29.2 left them.
- Rule 1b line ceiling (5754) has 2 lines of headroom, unchanged this
  release (`agents/`+`commands/` at 5752).

## 7. Totals or cost changes

`bash tests/check.sh`: 1328 passed, 0 failed (v1.29.2) → 1347 passed, 0
failed (this release). `agents/`+`commands/` line count: unchanged at 5752
(ceiling 5754, 2 lines headroom).

## 8. Assumptions used

- `victor-reyes`'s decision not to dispatch sub-specialists was taken at
  face value, on the stated reasoning (no touched test scripts, settled
  drift/fixture questions); this release independently re-ran
  `tests/check.sh` and the fixture-count comparison rather than trusting the
  report's numbers alone.
- `kai-fischer`'s "nothing to cut" verdict was spot-checked against
  `git diff --stat` on the four touched agent files (net 0 lines), not
  re-derived line by line.
- The six already-merged commits (#143-#148) were taken as correctly
  reviewed at merge time (each green on CI individually — confirmed in
  §10); this release re-audits their cumulative effect since v1.29.2, not
  each PR's own review.
- The `CITATION.cff`/`README.md` version-string drift (finding 9) was found
  by direct inspection outside the audited diff range; not independently
  checked against every intermediate release for when it first went stale.
- Per this project's leak-free instruction, CI and release references below
  are recorded by run id / tag / SHA, not by full host URL, and this note
  was grepped for absolute paths and personal names before every push.

## 9. CI run this release was gated on

**Process note.** `main` lands every release commit through a PR, same as
v1.29.1 and v1.29.2 (#147 codified this); direct `git push origin main` was
not attempted for either the release commit or this follow-up. The release
commit landed via PR #149 (branch `release/v1.29.3`, squash-merged),
producing SHA `832e62e6`.

Pre-merge: commit `43ec9655` (the PR branch tip) ran green on both triggers
(`push` on `release/v1.29.3`, run id `38877416595`, and `pull_request`
against `main`, run id `38877433783`, both `success`) before PR #149 was
merged. The squash-merge itself (`832e62e6`) then ran CI green in turn
(`push` on `main`, run id `38877513470`, workflow `structural-invariants`,
conclusion `success`) — read and confirmed green before the tag was
created, per rule 15a. **The tagged SHA is `832e62e6`.**

Pre-tag fresh-clone check (step 11, run manually, distinct from
`tests/release_gate.sh`'s own post-tag `clone` row): a clone of `832e62e6`
into an empty scratch `$HOME`, running exactly what `README.md` documents —
its `## Install` block (`git clone` + `bash install.sh`) then the next
`bash`-tagged block (`bash tests/check.sh`). Cloned SHA matched `832e62e6`
exactly; `install.sh` exited 0 (`consilium installed: 23 agents, 22
commands, 1/1 hooks wired`); `tests/check.sh` exited 0 with **1348 passed, 0
failed** — the same count seen on the release branch (no shallow-clone
check disappearance this time, since the clone carried full history and
tags).

## 10. Trend since v1.29.2 (5fcb044)

- **Gate assertions** (`bash tests/check.sh`): 1328 passed, 0 failed → 1347
  passed, 0 failed. Better (+19 assertions, still 0 red) — growth from the
  six already-merged commits' own fixture (`wei-019`) and checks.
- **Fixture verdicts** (`bash evals/run.sh list` / `score`): 32 cases → 33
  cases (+1: `wei-019`). Verdict currency unchanged at 0% both times (0/32 →
  0/33); never-run rose 23 → 24 (the one new fixture, not yet hand-graded);
  stale unchanged at 9. Neither better nor worse by this measure alone — new
  coverage added, none of it graded yet.
- **Tracked text lines** (`git diff --shortstat v1.29.2..a88b0cc -- '*.md'
  '*.yaml'`, counted repo-wide): 16 files changed, 160 insertions(+), 36
  deletions(-). The full diffstat across all tracked extensions (including
  the new fixture's `input/transcript_tail.txt`) is 18 files, 180
  insertions(+), 37 deletions(-).
- **Board currency** (`PATHWAY_FORWARD.md`): 28 VERIFIED, 1 BROKEN, 0 blank
  `last-checked` rows — identical at both commits; the board was not touched
  by this diff. Its next-due rows (PF-006, PF-021, PF-023, PF-024) come due
  2026-10-18, not yet overdue.
- **CI green-on-first-try rate**: 6/6 pushes since v1.29.2's tag (`5fcb044`)
  through this release's merge-base (`a88b0cc`) concluded `success`, one run
  each, no re-run observed (`gh run list --branch main --json
  conclusion,headSha,attempt` filtered to the SHA range) — 100%, unchanged
  from v1.29.2's 100%.

This section reports; it does not gate. Tracked lines grew modestly (one new
fixture plus prompt edits) while the gate-assertion count improved and the
fixture population grew without being graded — the same shape the last two
releases flagged, with no new mechanical-fixture defects introduced by this
release's own hand (none were made — §5).

## 11. Work record

- audit: `victor-reyes` on `v1.29.2..a88b0cc` (6 commits), with Agent-tool
  access this run, reported 2 Medium (fixture guard false-negative risk and
  missing adversarial pass, both `wei-019`), 2 Minor (`agents/
  haruto-nakamura.md` hard-coded merge method and a note-path
  inconsistency), 1 Low (a missing sentence break), 0 Critical. Verdict:
  safe to release as a patch.
- correctness: 0 Critical, 0 Major; all findings are deferred judgment calls
  on surfaces this release does not own (§5/§6).
- conciseness: `kai-fischer` reviewed the diff, scoped to it — verdict
  "nothing to cut" (§5); line ceiling unchanged at 5752/5754.
- fixes: none applied — no finding fell on `release_notes`, version files,
  or tags (this release's own surface, rule 19). All 9 findings deferred to
  their named owners, none invented.
- docs: `PROJECT_RULES.md`, `README.md`, `PATHWAY_FORWARD.md`, `CLAUDE.md`
  confirmed byte-identical to v1.29.2 (`git diff` empty against all four);
  `PATHWAY_FORWARD.md` board counts confirmed unchanged at both commits (28
  VERIFIED / 1 BROKEN / 0 blank).
- refactor: `kai-fischer` ran, scoped to the release diff (§5) — verdict
  "nothing needed," with specifics (net-0 line delta across the four touched
  agent files, no duplicated blocks, each addition is a named-recurrence
  fix).
- rules: checked directly against `PROJECT_RULES.md` myself (rule 10's
  fixture-justification convention followed by the new fixture's notes;
  rule 1's root-document whitelist unchanged, `tests/check.sh` Check 31
  green; no naming-convention violation; no duplicate fixture id).
  `zofia-kaminska` not separately dispatched this cycle; one rule-book
  coverage gap surfaced by the audit (kai-fischer.md's description vs the
  ownership table) is routed to her in §6, not resolved here.

## 12. Release gate

`bash tests/release_gate.sh release_notes_v1.29.3.md`, run in a fresh clone
of the pushed tag (checked out to `main`, tracking `origin/main`): 5 passed,
0 failed, 0 skipped.

- tree: PASS — clean, one worktree, no lock, level with upstream.
- ci: PASS — green on `832e62e6`.
- publish: PASS — `v1.29.3` pushed and pointing at `832e62e6`.
- release: PASS — GitHub Release exists for `v1.29.3`.
- clone: PASS `832e62e6` — fresh clone of `v1.29.3`, README's install block
  and its first following command both exited 0.
