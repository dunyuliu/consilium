# Release notes — v1.29.1 — 2026-10-12

## 1. Version and date

v1.29.1, cut 2026-10-12, patch bump over v1.29.0 (`a5fe24e`, 2026-10-10). Patch
because the range adds no new agent and no new command — six commits of
already-merged inbox-triage refinement to existing prompts, plus the fixtures
that back them.

## 2. Summary of scope

Six commits since v1.29.0, all already merged to `main` (PRs #126-#131):

- `5f03f6c` (#126): v1.29.0's own follow-up commit, transcribing its CI run
  and release-gate rows into `release_notes_v1.29.0.md` (docs-only, no
  prompt change).
- `6dd0c1b` (#127), `b462d8c` (#128), `05de57f` (#129), `d841146` (#130),
  `4e0ff5a` (#131): five inbox-triage landings. Each fixed a reported agent
  defect in `agents/wei-lin.md`, `agents/haruto-nakamura.md`,
  `agents/victor-reyes.md`, `agents/zofia-kaminska.md`, or
  `agents/lars-eriksson.md`, or `commands/autopilot.md` /
  `commands/release.md`, each commit message declaring a "net 0" line delta
  for `agents/`+`commands/` — verified true in this release's audit (§5).
  Eight new eval fixtures landed alongside: `wei-010` through `wei-016`,
  `haruto-004`.

This release's own contribution is the audit pass below, the note, and the
archive move — no prompt or fixture content was changed by this release
itself.

## 3. Files added / removed / renamed / cleaned up

**Added**: `release_notes_v1.29.1.md` (this file);
`evals/cases/wei-010-missing-data-skip-fails/`,
`evals/cases/wei-011-milestone-audit-delegated/`,
`evals/cases/wei-012-privacy-grep-before-push/`,
`evals/cases/wei-013-cap-mid-turn-summary/`,
`evals/cases/wei-014-fast-lane-runs-tier/`,
`evals/cases/wei-015-owner-verb-whole-surface/`,
`evals/cases/wei-016-exhausted-and-milestone/`,
`evals/cases/haruto-004-clone-before-tag/` (each with `case.yaml`, `README.md`,
`input/`, `samples/pass.md`, `samples/fail.md` — landed by the five commits
above, confirmed present and structurally sound by this release's audit).

**Removed**: nothing.

**Renamed**: `release_notes_v1.29.0.md` (repo root) → `docs/release_notes_v1.29.0.md`
(rule 8 — archived verbatim, content unchanged, including the defect noted in
§5).

**Modified** (by the five already-merged inbox-triage commits, #127-#131):
`agents/wei-lin.md`, `agents/haruto-nakamura.md`, `agents/victor-reyes.md`,
`agents/zofia-kaminska.md`, `agents/lars-eriksson.md`, `commands/autopilot.md`,
`commands/release.md`.

**Modified by this release**: none — `PROJECT_RULES.md`, `README.md`,
`PATHWAY_FORWARD.md`, `CLAUDE.md` were not touched by the diff and this
release's audit found no fix mechanical enough to apply on those surfaces
(§5, §6).

## 4. Content updates to master documents

None. `PROJECT_RULES.md`, `README.md`, and `PATHWAY_FORWARD.md` are
byte-identical to their v1.29.0 state (confirmed: `git diff a5fe24e..4e0ff5a --
PROJECT_RULES.md README.md PATHWAY_FORWARD.md` is empty). Whether rule
15/15a/15b should be expanded to state the victor-audit-report requirement,
the clone-before-tag ordering, and the privacy-grep step that
`agents/haruto-nakamura.md` already carries is an open question for
`zofia-kaminska` (§5, §6) — rule 15b's text already delegates those
obligations to the agent by design ("obligations stated once in
`agents/haruto-nakamura.md`"), so this is a completeness judgment call, not a
drift this release can act on.

## 5. Audit findings and fixes

`victor-reyes` was dispatched first; it reported it had no `Agent` tool
available in its session and could not dispatch any specialist, so it ran
only the mechanical checks it could do directly (gate, line budget, "net 0"
arithmetic, fixture file presence) and named the three specialists this
release needed. Per `agents/haruto-nakamura.md`'s instruction for exactly
this case, this release ran those three specialists itself:
`lian-zhao` (prompt/command correctness and routing), `iris-vermeulen`
(fixture soundness), `sophia-okafor` (docs-vs-commit drift). Combined result
across victor's own checks and the three specialists: **0 Critical, 0 Major
treated as release-blocking, 4 Major findings deferred to their surface
owners, 1 Medium (unfixable, disclosed), remainder Low/Advisory.**

- **`lian-zhao`** (1 Major, `agents/victor-reyes.md`'s surface): victor's own
  decision tree has no branch for "the `Agent` tool is unavailable" — every
  specific-specialist branch reads `→ spawn X` with no fallback, yet
  `agents/haruto-nakamura.md` now hard-depends on victor naming specialists
  and reporting non-dispatch in exactly that case. This is not hypothetical —
  it is what victor did in this release, by instinct rather than by prompt
  instruction. Not fixed here: `lian-zhao`'s own convention is no fixture, no
  change, and no two-sided fixture (dispatch-available vs
  dispatch-unavailable) exists yet. Routed to `lian-zhao`, open in §6.
- **`iris-vermeulen`** (3 Major, fixtures are her surface): the
  `must_not_find` guards in `wei-010-missing-data-skip-fails/case.yaml:24`,
  `wei-014-fast-lane-runs-tier/case.yaml:26`, and
  `wei-016-exhausted-and-milestone/case.yaml:24` are declarative (pass Check
  19) but vulnerable to external negation — a correct report that states the
  rule as a refusal or a lesson ("I do not send it as written", "0 failed
  does not mean the gate is green here") contains the guarded phrase verbatim
  and is wrongly FAILed. Reproduced by probe for all three. A fourth, narrower
  instance in `haruto-004-clone-before-tag/case.yaml:26` is Low/Advisory —
  only trips on a verbatim quote-to-refute, not natural correct phrasing.
  None of these fixtures has ever been dispatched (`evals/run.sh list`: all
  NEVER RUN), so no real report has been misgraded yet — the defect is latent,
  not live. Not fixed here (fixtures are `iris-vermeulen`'s surface, rule 19;
  narrowing guard wording is a judgment call on exact phrasing, not a
  mechanical fix). Routed to `iris-vermeulen`, open in §6. All 16 of the
  mandatory pass/fail sample grades (rule 25, Check 15) still pass correctly
  today — the gap is only against phrasings the samples don't use.
- **`sophia-okafor`** (1 Medium, unfixable; 3 Advisory): found a stale,
  already-published defect in `docs/release_notes_v1.29.0.md` (post-archive
  path) — commit `5f03f6c` added the real, filled-in "## 12. Release gate"
  section but left the original placeholder heading ("## 12. Release gate" /
  "__PENDING — transcribed in the single follow-up commit after the tag__")
  in place below it, so the file now contains two "## 12" sections, one
  complete and one stale. This cannot be corrected — rule 8 forbids rewriting
  a prior release note, and as of this release's archive move (§3) that file
  is exactly that. Disclosed here, left as permanent record, open in §6. The
  remaining three Advisory findings (whether rule 15/15a/15b should spell out
  obligations already delegated to the agent by design) are a rule-book
  completeness question for `zofia-kaminska`, not a release blocker (§4).

This release applied no fixes of its own: every finding above belongs to
another agent's write surface (rule 19) or to already-published history rule
8 protects. Nothing in this list was invented or guessed at — each is the
specialist's own finding, quoted, not haruto's interpretation of it.

## 6. Remaining open issues or pending items

Deferred, each to its surface owner:

- `lian-zhao`: add an Agent-tool-unavailable branch to `agents/victor-reyes.md`'s
  decision tree, gated on a new two-sided fixture (dispatch-available stays
  silent; dispatch-unavailable must name specialists) — per her own no-fixture,
  no-change convention.
- `iris-vermeulen`: narrow the three Major `must_not_find` guards
  (`wei-010`, `wei-014`, `wei-016`) and the one Low/Advisory guard
  (`haruto-004`) from phrase-matching to a verdict-line shape immune to
  external negation (rule 25's imperative → declarative → verdict-line
  progression) — or record an explicit owner waiver if deferred further.
- `zofia-kaminska`: whether rule 15/15a/15b should enumerate the
  victor-report, clone-before-tag, and privacy-grep requirements that
  `agents/haruto-nakamura.md` already carries, given rule 15b's text already
  delegates these obligations to the agent by design.
- The stale duplicate "## 12. Release gate" section in
  `docs/release_notes_v1.29.0.md` (§5) — uncorrectable per rule 8, carried
  forward as a known defect in the historical record.
- Carried from v1.29.0: the rule-1b line ceiling (5754) has had 2 lines of
  headroom since that release and still does (`agents/`+`commands/` unchanged
  at 5752 — this release touched no prompt files) — still open for
  `zofia-kaminska` to decide whether to tighten it.
- The eight new fixtures (`wei-010`-`wei-016`, `haruto-004`) remain
  hand-dispatch-and-grade currency, structurally sound but never run — a
  reporting measure (§10), not a release gate, per this project's rules.

## 7. Totals or cost changes

`bash tests/check.sh`: 1131 passed, 0 failed (v1.29.0) → 1278 passed, 0 failed
(this release). `agents/`+`commands/` line count: unchanged at 5752 (ceiling
5754, 2 lines headroom, disclosed again per §6 — this release added no prompt
lines).

## 8. Assumptions used

- The five already-merged inbox-triage commits (#127-#131) were taken as
  correctly reviewed at merge time (each already green on CI, confirmed
  individually in §10); this release re-audits their cumulative effect since
  v1.29.0, not each PR's own review.
- `victor-reyes`'s own report that it had no `Agent` tool available in its
  session was taken at face value and is itself this release's primary
  finding (§5) rather than something independently re-diagnosed.
- Per this project's leak-free instruction, CI and release references below
  are recorded by run id / tag / SHA, not by full host URL; the repo-relative
  path and no-personal-name grep was run on this note before every push (rule
  per `agents/haruto-nakamura.md` step 8).

## 9. CI run this release was gated on

__PENDING — transcribed in the single follow-up commit after the tag, per
agents/haruto-nakamura.md step 12.__

## 10. Trend since v1.29.0 (a5fe24e)

- **Gate assertions** (`bash tests/check.sh`): 1131 passed, 0 failed → 1278
  passed, 0 failed. Better (+147 assertions, still 0 red) — growth is from the
  five already-merged commits' own fixtures and checks, not from this release.
- **Fixture verdicts** (`bash evals/run.sh list` / `score`): 22 cases → 30
  cases (+8: `wei-010`-`wei-016`, `haruto-004`). Verdict currency unchanged at
  0% both times (0/21 → 0/29); never-run rose 12 → 20 (the eight new
  fixtures, not yet hand-graded); stale unchanged at 9. Neither better nor
  worse by this measure alone — new coverage added, none of it graded yet, and
  this release's own audit found 3 Major latent grading defects in that new
  coverage (§5).
- **Tracked text lines** (`git diff --stat v1.29.0..4e0ff5a -- '*.md' '*.sh'`):
  41 files changed, 508 insertions, 39 deletions — almost entirely new
  fixture content (8 directories x 5 files) plus the five inbox-triage prompt
  edits, each individually net 0 for `agents/`+`commands/` (rule 1b held:
  5752 → 5752, confirmed by commit-by-commit arithmetic in `lian-zhao`'s
  audit).
- **Board currency** (`PATHWAY_FORWARD.md`): 35 rows, 22 RETIRED, 13 VERIFIED,
  0 BROKEN, 0 blank-`last-checked` — identical at both commits; the board was
  not touched by this diff.
- **CI green-on-first-try rate**: 6/6 pushes to `main` since v1.29.0's tag
  concluded `success`, one run each, no re-run observed (`gh run list
  --branch main --json conclusion,headSha,event` filtered to `push` events,
  per SHA in the range) — 100%.

This section reports; it does not gate. Tracked lines grew (mostly new
fixture content) while the gate-assertion count improved and the fixture
population grew without being graded — the same shape as v1.29.0 flagged for
its own five new fixtures, now compounded by three of the eight new fixtures
carrying a latent grading defect this release's audit found but did not fix
(§5, §6).

## 11. Work record

- audit: `victor-reyes` on `v1.29.0..4e0ff5a` reported it had no `Agent` tool
  and could not dispatch; ran mechanical checks only (0 Critical/Major from
  its own checks, 2 Advisory, 2 informational brief discrepancies — both
  resolved: `commands/release.md` added to scope, the sixth commit `5f03f6c`
  accounted for in §2) and named three specialists. This release ran them:
  `lian-zhao` (1 Major, 1 Low, 1 Advisory), `iris-vermeulen` (3 Major, 1
  Low/Advisory, all 16 mandatory pass/fail grades still correct), `sophia-okafor`
  (1 Medium unfixable, 3 Advisory). Combined: 0 Critical, 4 Major (deferred to
  owners), 1 Medium (deferred, unfixable), 2 Low, 7 Advisory.
- correctness: no Critical findings against the shipped prompts; the three
  Major fixture-grading defects are latent (never-dispatched fixtures), not a
  live misgrade.
- conciseness: `lian-zhao` verified all five "net 0" commit-message claims
  hold exactly (35 insertions / 35 deletions across the range); no duplication
  flagged beyond what prior releases already removed.
- fixes: none applied by this release — all four Major findings and the one
  Medium finding belong to another agent's write surface (rule 19) or to
  already-published history rule 8 protects; all recorded as open issues
  (§6), none invented.
- docs: `PROJECT_RULES.md`, `README.md`, `PATHWAY_FORWARD.md` confirmed
  byte-identical to v1.29.0 (git diff empty); `sophia-okafor`'s rule-book
  completeness questions left for `zofia-kaminska` (§4, §6), not acted on
  here.
- refactor: no `kai-fischer` pass requested or needed — this diff touches no
  production code (this repo is a prompt library with no production-code
  surface in rule 19's table at all), and prompt-level simplification is
  `lian-zhao`'s surface, already covered by her audit above (no duplication
  found).
- rules: no tier changes; `zofia-kaminska` has two open completeness
  questions from this release (§4, §6), neither a violation, both deferred to
  her judgment.

## 12. Release gate

__PENDING — transcribed in the single follow-up commit after the tag, per
agents/haruto-nakamura.md step 12.__
