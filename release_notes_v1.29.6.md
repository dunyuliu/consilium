# Release notes — v1.29.6 — 2026-10-20

## 1. Version and date

v1.29.6, cut 2026-10-20, patch bump over v1.29.5 (`e171b35`, 2026-10-18).
Patch because the range adds no new agent and no new command — five
already-merged ledger/fixture commits (#166-#170), one post-tag transcription
follow-up (#165, landed under the v1.29.5 tag), and three fix commits this
release's own audit required before cutting (#171-#173).

## 2. Summary of scope

Nine commits since v1.29.5 (`e171b35..0e89bba`):

- `75ded4b` (#165): post-tag follow-up, transcribed v1.29.5's own final CI
  run and release-gate rows into its note (sanctioned by rule 8/step 12 —
  see §5, finding 6).
- `0c5689f` (#166): deferred v1.29.5-audit findings — the specialist cap
  stated once, a stale completion notice matched by PR number or subject
  (squash merges drop the SHA), `zofia-kaminska`'s description scoped off
  "any other script," five untested `must_not_find` phrases dropped.
- `d6c59a1` (#167): narrowed two `must_not_find` guards (`wei-021`,
  `iris-003`) to end in the fail.md colon; corrected the v1.29.5 note's
  stale wei-019 ledger line (rule 8 keeps the note itself unrewritten,
  the ledger carries the correction).
- `52e01e1` (#168): board rows 7, 15, 18, 19, 20, 22, 26, 35 re-run and
  re-dated, no content change.
- `b3557da` (#169): every landing is a PR; the project's own landing gate
  binds a zero-impact fix; a tried-and-reverted patch is named in the
  never-touch line; `/autopilot` greps the rule book before an unblock.
- `2452b9b` (#170): wei-lin's call cap made mechanical (100, running
  total, no new item past 80, board handoff + end at 100); every
  Edit/Write path starts with the conductor's worktree path; the privacy
  grep covers commit body, board row and release note; "until exhausted"
  names source types queried and not.
- `51e4174` (#171, this release): board row 18's command rewritten so it
  actually asserts its claim (was: printed a fixed field count, could not
  fail).
- `1293bee` (#172, this release): two fixture criteria that rejected a
  correct report, fixed (`wei-018`'s hardcoded worktree-name literal;
  `wei-001`'s `must_not_find` guard that also matched a correct denial).
- `0e89bba` (#173, this release): four `agents/wei-lin.md` self-
  contradictions resolved (handoff-write vs. gate-skip; privacy grep vs.
  the required `Agent:` trailer; which tier governs a docs/board/log PR;
  the specialist cap still stated two ways, plus `commands/autopilot.md`
  disagreeing with it).

This release's own contribution: the audit pass (`victor-reyes`), three
fix PRs it required before the cut (#171-#173, this release's loop rule —
no deferral), this note, and the archive move.

## 3. Files added / removed / renamed / cleaned up

**Added**: `release_notes_v1.29.6.md` (this file);
`evals/cases/wei-022-relayed-link-refused/` (landed by #169, structurally
sound — no symlink, no leaked answer key, both samples grade as labelled).

**Removed**: nothing.

**Renamed**: `release_notes_v1.29.5.md` (repo root) →
`docs/release_notes_v1.29.5.md` (rule 8 — archived verbatim, content
unchanged by this release).

**Modified** (#165-#170, already merged before this audit pass):
`release_notes_v1.29.5.md` (pre-archive, by #165, its own post-tag
transcription); `agents/wei-lin.md`, `agents/zofia-kaminska.md`,
`commands/autopilot.md`, `docs/lessons_ledger.md`, `PATHWAY_FORWARD.md`
(rows re-dated), five `evals/cases/*/case.yaml` guard narrowings.

**Modified by this release's own fix PRs** (#171-#173): `PATHWAY_FORWARD.md`
(row 18's command and date); `evals/cases/wei-018-queue-edit-own-worktree/
case.yaml` + `samples/pass.md`; `evals/cases/wei-001-cap-across-resumes/
case.yaml` + `samples/pass.md`; `agents/wei-lin.md`;
`commands/autopilot.md`.

No `CITATION.cff`/`README.md`/`docs/user/citing.md` version bump this
release — the trigger did not ask for one and none of #165-#173 touched
those files.

## 4. Content updates to master documents

`PATHWAY_FORWARD.md`: rows 7, 15, 18, 19, 20, 22, 26, 35 re-dated by #168
(no content change, confirmed by that commit's own diffstat); row 18's
command itself rewritten by #171 (this release) because the prior command
only printed a fixed field count and could not fail — the new command
asserts every non-RETIRED row carries a P1/P2/P3 priority and the table
header ends in `prio`, verified to redden on a stripped-priority scratch
copy before being confirmed genuinely green on the real file. Board tally
unchanged at 22 RETIRED, 13 VERIFIED, 0 BROKEN (35 rows, identical before
and after this whole range — `git diff v1.29.5..HEAD -- PATHWAY_FORWARD.md`
touches only row dates and row 18's command line).
`docs/lessons_ledger.md`: ten rows appended across #166/#169/#170 (five
each in the two inbox-pass commits, plus #166's deferred-findings row).
`PROJECT_RULES.md` and `CLAUDE.md` unchanged this range.

## 5. Audit findings and fixes

`victor-reyes` was dispatched on `v1.29.5..origin/main` (e171b35..2452b9b,
#165-#170; Agent-tool access, no sub-specialist dispatch — audited the
range directly). **Verdict: gate green (1430 passed, 0 failed), no
Critical finding; six Medium, four Low/Advisory.** This release's loop
rule required every finding on a prompt surface (`agents/*.md`,
`commands/*.md`) or an owner surface (`evals/cases/*`, `PATHWAY_FORWARD.md`)
to be fixed before the cut, in its own PR — not deferred to an open-issues
list the way v1.29.5 deferred its own findings.

**Findings and resolution (0 Critical, 6 Medium, 1 Low fixed, 3
Low/Advisory not owner-surface findings)**:

| # | Severity | Location | Issue | Disposition |
|---|---|---|---|---|
| 1 | Medium | `evals/cases/wei-018-queue-edit-own-worktree/case.yaml:23` | Criterion required the literal string `worktrees/queue-c/jobs/queue.txt`, a worktree name absent from the fixture's own `input/` — any correct answer naming a different worktree failed. Confirmed by direct grading (`FAIL — 4 criteria, 1 failed`) before the fix. | **Fixed**, PR #172 (`iris-vermeulen`) — narrowed to `/jobs/queue.txt` (still requires a nested path, not bound to one arbitrary directory name). Re-graded: pass.md 4/4, fail.md 4/4 fails, and a mutation test (worktree renamed to `wt-run-c`) still passes. |
| 2 | Medium | `evals/cases/wei-001-cap-across-resumes/case.yaml:40` | `must_not_find: "merged on its green CI run"` also matched a correct refusal ("PR #12 is not merged on its green CI run this turn"). Confirmed FAIL by direct grading before the fix. | **Fixed**, PR #172 (`iris-vermeulen`) — narrowed to the full wrongful-conclusion clause `"merged on its green CI run, Q-2 closed"`, which a correct denial never completes; `pass.md` rewritten to carry that denial explicitly. Re-graded 6/6 pass, 6/6 fail (unchanged). |
| 3 | Medium | `agents/wei-lin.md:88` vs `:277` | The 100-call handoff-state write read as skipping the gate ("no last merge, gate or poll first"), contradicting "cap pressure never skips a gate" and "every commit reaches the default branch by PR" stated elsewhere in the same prompt. | **Fixed**, PR #173 (`lian-zhao`) — the handoff write is now explicitly a fast-lane board PR whose own cheap gate still runs unattended (`--auto`); the turn ends without waiting on the poll, not by skipping the gate. |
| 4 | Medium | `agents/wei-lin.md:277` vs `:256` | The new privacy grep counts agent names wherever the rule book bars personal names, but line 256 requires every specialist commit to carry an `` `Agent: <name>` `` trailer — every specialist commit would trip its own required trailer. | **Fixed**, PR #173 — the trailer format now reads `` `Agent: <name>` trailer, role in place of name where the rule book bars personal names``, so the required trailer can never trip the grep. |
| 5 | Medium | `agents/wei-lin.md:291` vs `:277` | "The rule book's own landing gate (review, full tier) binds a zero-impact fix too" conflicted with the fast lane's "cheapest tier at merge head, no audit" — unclear which governs a docs/board/log-only PR. | **Fixed**, PR #173 — the full-tier gate now explicitly binds a zero-impact **code** fix; a docs/board/log-only PR is named as staying in the fast lane, pointing at `:277`. |
| 6 | Medium | `agents/wei-lin.md:52` vs `:266`; `commands/autopilot.md:49` | The specialist dispatch cap was still stated two incompatible ways inside `wei-lin.md` (flat "two" vs. "the owner's board cap" override) despite #166's ledger row claiming it was already stated once; `commands/autopilot.md:49` still said "at most two" with no override, disagreeing with the agent prompt. | **Fixed**, PR #173 — `wei-lin.md:266` ("two, or the owner's board cap") is now the sole statement; `:52` points at it instead of restating it; `commands/autopilot.md:49` now carries the same override, so command and prompt agree. |
| 7 | Low | `PATHWAY_FORWARD.md` row 18's command (block near line 373) | The command only printed `awk`'s fixed per-row field count — structurally could never fail — so #168's "holds" re-run proved nothing. | **Fixed**, PR #171 (`zofia-kaminska`) — rewritten to assert every non-RETIRED row carries a P1/P2/P3 priority and the table header ends in `prio`; confirmed it reddens on a stripped-priority scratch copy, genuinely green on the real file today. |
| 8 | Low (not an owner-surface finding, verified independently and closed here) | `release_notes_v1.29.5.md` (`75ded4b`, §9 and §12 rewritten after the tag) | Victor's audit read this as a rule-8 "never rewrite a prior note" violation (62 insertions, 29 deletions, post-tag). **Direct inspection of `git show 75ded4b` shows this is not a violation**: the pre-tag text of those sections literally read "PENDING AT TIME OF WRITING — completed and transcribed into this same file in a follow-up commit before the tag is created, per the v1.29.3/v1.29.4 precedent (`b1dcc86`, `d98fa1b`)" — i.e. the note announced its own sanctioned follow-up, matching this project's documented step-12 mechanism ("the CI run and the gate rows then go into ONE follow-up commit... not an unpublish"). Closed, not carried forward. |
| 9-12 | Advisory | fixture never-dispatched coverage, a ledger-row owner-consultation question, three `must_not_find` guards now colon-anchored, byte growth under a net-0 line count | None names a fixable defect on an owner surface — `bash evals/run.sh list` already shows the `wei-*` fixtures as the honest "never run" inventory (12 cases, all `NEVER RUN`), which is a standing gap this project's own README describes, not a new regression. Recorded, not actioned. |

## 6. Remaining open issues or pending items

- `wei-lin`-targeting fixtures (`wei-001` through `wei-022`, 12 cases) have
  never been dispatched against a live session — `bash evals/run.sh list`
  shows all `NEVER RUN`. PR #173's contradiction fixes are therefore
  verified structurally (gate green, contradiction removed by direct
  inspection of the quoted lines) but not behaviourally. Flagged by
  `lian-zhao` in PR #173 as a follow-up for the next eval pass.
- `zofia-003-seed-bare-project` is STALE (verdict dated 2026-09-16, prompt
  changed 2026-10-18, rule 25d date fallback); `zofia-004`,
  `zofia-005` are `NEVER RUN`.
- Carried from v1.29.5, unresolved and untouched by this range: rule 15a's
  body text vs. its own "How to apply" line on whether a tag is ever
  pushed separately from its Release (`PROJECT_RULES.md` not in this
  diff); `wei-019`'s rewritten guard still not matching its own `fail.md`
  sample; `wei-020`'s third guard still untested by either sample;
  `docs/lessons_ledger.md` call-count disagreements for rows 10-13/10-14;
  `wei-017`'s criteria not yet forcing lars-eriksson-first ordering;
  `agents/zofia-kaminska.md:17`'s main-checkout test also tripping a
  genuinely isolated fresh clone; the `v1.29.1` GitHub Release body still
  showing the pre-correction SHA.
- Rule 1b line ceiling (5754) has 2 lines of headroom, unchanged this
  release (`agents/`+`commands/` at 5752, confirmed net 0 across all nine
  commits in this range).

## 7. Totals or cost changes

`bash tests/check.sh`: 1430 passed, 0 failed at `e171b35` (v1.29.5) → 1430
passed, 0 failed at `0e89bba` (pre-release-commit HEAD) — same count, all
new assertions in #171/#172 fixing existing criteria rather than adding
checks. `agents/`+`commands/` line count: unchanged at 5752 (ceiling 5754,
2 lines headroom).

## 8. Assumptions used

- `victor-reyes`'s six Medium findings (1-6) were taken as requiring a fix
  because each came with a reproduced FAIL or a directly quoted
  self-contradiction, not an inference; finding 6 (the release-note
  rewrite) was independently re-derived from `git show 75ded4b` and found
  to be the project's own sanctioned follow-up mechanism, not the
  violation Victor's summary language suggested — corrected here rather
  than carried forward at face value.
- The three fix PRs (#171-#173) were dispatched to their rule-19 surface
  owners (`zofia-kaminska`, `iris-vermeulen`, `lian-zhao`) rather than
  edited directly by this release; each ran `bash tests/check.sh` green
  both locally and on its own PR's CI before merging, confirmed again here
  after pulling all three to `HEAD`.
- The six already-merged commits (#165-#170) were taken as correctly
  reviewed at merge time (each green on CI individually — confirmed in
  §10); this release re-audits their cumulative effect since v1.29.5, not
  each PR's own review.
- Per this project's leak-free instruction, CI and release references
  below are recorded by run id / tag / SHA, not by full host URL, and this
  note was grepped for absolute paths and personal names before every
  push.

## 9. CI run this release was gated on

**Process note.** `main` lands every release commit through a PR, same as
v1.29.1-v1.29.5; direct `git push origin main` was not attempted.

Pre-tag, on the audited tree (`0e89bba`, after #171-#173 merged): `gh run
list --branch main` shows every push since `e171b35` green on first try,
no re-run observed (`e171b35`→`0e89bba`, 10 pushes, 10 `success`).

`ci:` and `clone:` rows for the release commit itself (PR, merge SHA, and
the pre-tag fresh-clone check) are completed below once the release PR
lands — see the Release gate section.

## 10. Trend since v1.29.5 (e171b35)

- **Gate assertions** (`bash tests/check.sh`): 1430 passed, 0 failed (at
  `e171b35`) → 1430 passed, 0 failed (at `0e89bba`). Unchanged — the three
  fix PRs corrected existing criteria rather than adding or removing
  assertions.
- **Fixture verdicts** (`bash evals/run.sh list` / `score`): 37 cases,
  unchanged count. Verdict currency unchanged at effectively 0% for the
  `wei-*` family (12/12 never run); `zofia-003` stale, `zofia-004`/`005`
  never run. Two of the fixtures this release's audit actually ran
  (`wei-018`, `wei-001`) now pass a genuinely correct sample where they
  previously failed one — the first behavioural improvement this trend
  section has had to report in several releases, not just new coverage.
- **Tracked text lines** (`git diff --shortstat e171b35..HEAD -- '*.md'
  '*.yaml' '*.sh' '*.awk' '*.tsv' '*.cff'`): 24 files changed, 261
  insertions(+), 71 deletions(-).
- **Board currency** (`PATHWAY_FORWARD.md`): 13 VERIFIED, 22 RETIRED, 0
  BROKEN, 0 blank `last-checked` — identical at both commits (35 rows
  total); only row dates and row 18's command text changed.
- **CI green-on-first-try rate**: 10/10 pushes to `main` since v1.29.5's
  tag (`e171b35`) through this release's pre-tag HEAD (`0e89bba`)
  concluded `success`, one run each, no re-run observed (`gh run list
  --branch main --json conclusion,headSha,createdAt`, no SHA appearing
  twice in the range) — 100%, unchanged from v1.29.5's 100%.

This section reports; it does not gate. Lines grew (261 insertions, 71
deletions, net +190 tracked-text lines) against an unchanged gate-assertion
count and an unchanged board tally — but two of those insertions are the
first fixture fixes this trend section has recorded turning a previously
wrong guard into a correct one (finding 1-2 above), not just added prose
with no behavioural payoff, which is an improvement over the shape the
last several releases flagged.

## 11. Work record

- audit: `victor-reyes` on `e171b35..2452b9b` (6 commits, #165-#170).
  Reported 0 Critical, 6 Medium, 4 Low/Advisory. Verdict: gate green, no
  Critical finding, fix every Medium before cutting (this release's loop
  rule, no deferral).
- correctness: 0 Critical, 0 Major introduced; six Medium findings, all
  six fixed by their rule-19 surface owners before the cut (findings 1-6
  above); finding 6's "release-note rewrite" read as a defect was
  independently re-checked and found to be the project's own sanctioned
  follow-up mechanism, not a violation — closed, not deferred.
- conciseness: no dedicated `kai-fischer` pass this release — the three
  fix PRs were each scoped, minimal edits by their surface owners
  (confirmed net 0 on `agents/`+`commands/`, 5752→5752); no refactor
  target identified by the audit beyond those fixes.
- fixes: findings 1-2 fixed by `iris-vermeulen` (PR #172); findings 3-6
  fixed by `lian-zhao` (PR #173); finding 7 fixed by `zofia-kaminska` (PR
  #171); finding 8 closed by direct re-verification, not deferred; nothing
  invented.
- docs: `PATHWAY_FORWARD.md` board re-dating and row 18's command
  reconciled against the live `## Board` table and a genuine re-run
  (§4, §10); `docs/lessons_ledger.md` additions reconciled against the
  commits that produced them; no version-string bump requested or made
  this release.
- refactor: not dispatched this release — scope was three targeted
  contradiction/criterion fixes, each already minimal by its own owner's
  report; no accreted prose identified beyond what those PRs touched.
- rules: checked directly against `PROJECT_RULES.md` myself — Check 7
  (index/body agreement), Check 10 (ownership table), Check 31 (root
  whitelist) all green via `tests/check.sh`; no new rule added, no
  naming-convention violation, no duplicate fixture id; rule 15a's
  pre-existing self-contradiction (carried from v1.29.5) remains open,
  routed to `zofia-kaminska`, not resolved here.

## 12. Release gate

- tree: _completed after the release PR merges — see follow-up below_
- ci: _completed after the release PR merges — see follow-up below_
- publish: _completed after the tag is created — see follow-up below_
- release: _completed after the tag is created — see follow-up below_
- clone: _completed after the tag is created — see follow-up below_
