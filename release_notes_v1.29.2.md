# Release notes — v1.29.2 — 2026-10-14

## 1. Version and date

v1.29.2, cut 2026-10-14, patch bump over v1.29.1 (`9d630d9`, 2026-10-12).
Patch because the range adds no new agent and no new command — seven
already-merged inbox-triage commits refining existing prompts and fixtures,
plus this release's own guard fixes.

## 2. Summary of scope

Seven commits since v1.29.1, all already merged to `main` (PRs #134-#140):

- `9c65c85` (#134): v1.29.1's own follow-up, transcribing its final CI run
  and release-gate rows into `release_notes_v1.29.1.md` (docs-only).
- `bb3964d` (#135): narrowed the `must_not_find` guards in `wei-010`,
  `wei-014` and `wei-016` so a correct refusal no longer false-fails (the
  v1.29.1 audit finding) — left one bare phrase behind in `wei-014` and
  `wei-016` each, found and fixed by this release's audit (§5).
- `eb831b0`-`464db0e` (#136-#140): five inbox-triage landings adding one
  shared clause to all 23 `agents/*.md` files ("a search stays inside the
  repo or worktree, and leaves no command running past its report"), a
  24-line substantive edit to `agents/wei-lin.md` (general-purpose
  hand-off/cap rules), a one-line edit to `commands/autopilot.md`, a 25-line
  append to `docs/lessons_ledger.md`, and three new eval fixtures
  (`wei-017-general-purpose-design-open`, `wei-018-queue-edit-own-worktree`,
  `zofia-005-board-edit-unisolated`).

This release's own contribution: the audit pass, four mechanical guard
fixes to new/edited fixtures, this note, and the archive move.

## 3. Files added / removed / renamed / cleaned up

**Added**: `release_notes_v1.29.2.md` (this file);
`evals/cases/wei-017-general-purpose-design-open/` (`README.md`, `case.yaml`,
`input/RUN_LOG.md`, `samples/pass.md`, `samples/fail.md`);
`evals/cases/wei-018-queue-edit-own-worktree/` (same five-file shape);
`evals/cases/zofia-005-board-edit-unisolated/` (`README.md`, `case.yaml`,
`input/PATHWAY_FORWARD.md`, `input/brief.md`, `input/captured.md`,
`samples/pass.md`, `samples/fail.md`) — all landed by #136-#140, confirmed
structurally sound (no symlink, no leaked keyword, pass/fail samples grade
correctly against their final criteria) by this release's audit.

**Removed**: nothing.

**Renamed**: `release_notes_v1.29.1.md` (repo root) →
`docs/release_notes_v1.29.1.md` (rule 8 — archived verbatim, content
unchanged, including the open items it carried).

**Modified** (by the seven already-merged commits, #134-#140): all 23
`agents/*.md` files (one shared clause each), `agents/wei-lin.md` (24-line
hand-off/cap edit), `commands/autopilot.md`, `docs/lessons_ledger.md`,
`evals/cases/wei-010-missing-data-skip-fails/case.yaml`+`samples/fail.md`,
`evals/cases/wei-014-fast-lane-runs-tier/case.yaml`+`samples/fail.md`,
`evals/cases/wei-016-exhausted-and-milestone/case.yaml`+`samples/fail.md`,
`docs/release_notes_v1.29.1.md` (pre-archive, by #134).

**Modified by this release** (mechanical fixes, §5): `evals/cases/wei-014-fast-lane-runs-tier/case.yaml`,
`evals/cases/wei-016-exhausted-and-milestone/case.yaml`,
`evals/cases/wei-017-general-purpose-design-open/case.yaml`,
`evals/cases/wei-018-queue-edit-own-worktree/case.yaml` — in each, one
residual bare `must_not_find` keyword removed (fused coverage from the
adjacent keyword already catches the fail sample; the bare phrase was a
substring of a plausible correct refusal). `PROJECT_RULES.md`, `README.md`,
`PATHWAY_FORWARD.md`, `CLAUDE.md` not touched — confirmed byte-identical to
v1.29.1 (`git diff 9d630d9..HEAD -- PROJECT_RULES.md README.md
PATHWAY_FORWARD.md CLAUDE.md` empty).

## 4. Content updates to master documents

None. See §3.

## 5. Audit findings and fixes

`victor-reyes` was dispatched first on `9d630d9..464db0e`. It reported no
`Agent` tool available in its session (same gap as v1.29.1) and ran only
direct checks (diff read, grep probes against the grader's substring logic,
symlink/leak checks on all six touched fixtures, line/word counts). It named
two specialists it could not reach; this release dispatched both itself,
per `agents/haruto-nakamura.md`'s instruction for exactly this case:
`lian-zhao` (prompt coherence on `agents/zofia-kaminska.md` and
`commands/autopilot.md`) and `iris-vermeulen` (fixture-design judgment on
`wei-017`). `kai-fischer` also ran, scoped to this diff, for the
refactor/conciseness pass (rule 3a).

**4 Major, found and fixed by this release** (victor-reyes, confirmed by
reading each `case.yaml` against its `samples/fail.md`/`samples/pass.md`
before editing):
- `evals/cases/wei-016-exhausted-and-milestone/case.yaml:37` — bare
  `"the draft is accurate"` is a substring of a plausible correct refusal
  ("nobody can claim the draft is accurate"). Removed; the two already-fused
  keywords above it still catch the fail sample's actual wording.
- `evals/cases/wei-014-fast-lane-runs-tier/case.yaml:38` — bare
  `"no tier for a docs PR"` is a substring of a plausible correct refusal
  ("CI skipping docs paths does not mean no tier for a docs PR"). Removed;
  not present verbatim in the fail sample at all, so nothing was lost.
- `evals/cases/wei-018-queue-edit-own-worktree/case.yaml:26` — bare
  `"pushed to main"` is a substring of a plausible correct refusal
  ("nothing is pushed to main; it lands by PR"). Removed; the command-shaped
  keyword above it (`"&& git push origin main"`) already catches the fail
  sample.
- `evals/cases/wei-017-general-purpose-design-open/case.yaml:37` — bare
  `"sending it to general-purpose now"` is a substring of a plausible
  correct refusal ("I am not sending it to general-purpose now"). Removed;
  the fused keyword above it already catches the fail sample.

All four are the same defect class #135 had just fixed for other guards in
the same files, one instance missed per file. `bash tests/check.sh` reran
green (1325 passed, 0 failed) after all four edits.

**2 Minor, deferred — cannot be settled from inside this repo**:
- `docs/lessons_ledger.md` rows 10-13/10-14 and `evals/cases/wei-017-.../case.yaml`
  (notes, lines 26/48/50) disagree on call counts across several builds (e.g.
  10-13: ledger says "84 and 55", the fixture says "58 and 92"; 10-14: ledger
  says "one run at 137 calls", the fixture says "seven runs to 150 calls").
  The commit subjects for #136-#140 carry no numbers, so nothing in the repo
  settles which reading is right. Routed to whoever maintains the ledger
  entries, against the original inbox digests (outside this repo).
- `docs/lessons_ledger.md`'s own 10-13 and 10-14 rows arguably self-contradict
  on totals (10-14: "7 runs" + "3 runs" read as "10 of the 11 briefs"; 10-13:
  "P06 (63 calls)" sits next to "63 calls past a 40-call cap"). Same routing.

**1 judgment call, real but not fixed — fixture design** (`iris-vermeulen`):
checked whether `wei-017`'s `expected` criteria groups 2-3 (which grade a
*later* general-purpose brief's cap-line wording) could reject a correct
report that solves the scenario without ever drafting such a brief.
Verdict: **not a defect** — the scenario's agent roster (`lars-eriksson`
doesn't propose fixes, `kai-fischer` won't add new behavior, `iris-vermeulen`
never edits production code, `dunyu-liu` needs a separate owner OK) makes a
"specialist finishes it end-to-end" alternative unreachable; every correct,
complete report for this prompt necessarily ends in a capped
general-purpose brief, which is why `samples/pass.md` does too. Iris flagged
one narrower, separate gap worth the fixture author's attention: nothing in
`expected` currently forces the *lars-eriksson-first* ordering, so a report
that skipped straight to a general-purpose brief with the cap line, without
ever justifying why no specialist can do the build, would still pass. Not
fixed here (fixture criteria are `iris-vermeulen`'s surface, rule 19);
routed to her, open in §6.

**2 judgment calls, real but latent — prompt architecture** (`lian-zhao`):
- `agents/zofia-kaminska.md:17` — the main-checkout test ("top-level path
  equals the first `git worktree list` entry") is also true of any
  standalone fresh clone, so a writer briefed with a branch inside a
  genuinely isolated fresh clone would wrongly refuse to write. Confirmed
  real. Not currently reachable through the shipped workflow — the one
  documented dispatcher (`wei-lin`) only ever hands writers a worktree, never
  a fresh clone — so this is a latent gap, not a live misfire. Fixing it is
  a scoping decision (restrict "isolation" to worktree-only, matching
  `wei-lin`'s own convention, or add a provenance signal), not a one-line
  edit. Routed to `zofia-kaminska`/`lian-zhao`, open in §6.
- `commands/autopilot.md:6` — the new "(the brief says so)" clause depends
  on an unreadable-budget default that exists only in `autopilot.md`, not in
  `agents/wei-lin.md` itself (confirmed: no "unreadable" text anywhere in
  `wei-lin.md`), so the same ambiguity reached via direct dispatch (which
  `wei-lin.md`'s own description explicitly supports) is undefined. A real
  doc-architecture gap — a rule living in the dispatch brief rather than the
  agent's own prompt, which `autopilot.md`'s own "never restate her rules"
  line says should not happen. Needs an owner decision on where the rule
  belongs, not a mechanical rewording. Routed to `lian-zhao`, open in §6.

**Conciseness** (`kai-fischer`, scoped to this diff only): verdict —
**nothing to cut**. The `wei-lin.md` edit is lean: every added clause maps
1:1 to a cited ledger row, the file's one genuine line removal (the "cost
lands on whoever wakes up next" sentence) is a deliberate cut that pays for
part of the addition, and the new `Batch` sentence closes a gap (boilerplate
already present in 23 other agent files that `wei-lin.md` was missing) rather
than duplicating anything. No duplication across the three new fixtures —
distinct incidents, correctly three fixtures per rule 10, not three copies
of one. `tests/check.sh` Check 37: 5752/5754 lines, 2 lines of headroom
against the 5869 hard limit — unchanged from v1.29.1, flagged again as
worth the next prompt edit budgeting for.

**1 informational, inherited, deferred**: `docs/release_notes_v1.29.1.md`
(post-archive) still names `cf87275` as the tagged SHA in its §9 prose,
while the file's own §1/§12 and `git log -1 v1.29.1` agree the tag resolves
to `9d630d9` — a SHA corrected on the root copy by #134 that evidently
wasn't propagated to the GitHub Release body for `v1.29.1`. Not this
release's tag or tree to alter; flagged for the owner to decide whether to
run `gh release edit v1.29.1` to sync the published body. Open in §6.

## 6. Remaining open issues or pending items

- `docs/lessons_ledger.md` call-count figures for 10-13/10-14 disagree with
  `evals/cases/wei-017-.../case.yaml`'s notes, and arguably with themselves —
  needs checking against the original inbox digests, outside this repo (§5).
- `iris-vermeulen`: `wei-017`'s `expected` criteria don't yet force the
  lars-eriksson-first ordering a correct report should follow — a narrower
  design gap than the one audited and cleared this release (§5).
- `zofia-kaminska`/`lian-zhao`: `agents/zofia-kaminska.md:17`'s main-checkout
  test also trips on a genuinely isolated fresh clone — latent, not live,
  scoping decision needed (§5).
- `lian-zhao`: `commands/autopilot.md:6`'s unreadable-budget default has no
  home in `agents/wei-lin.md` itself — owner decision on where the rule
  belongs (§5).
- Owner: the `v1.29.1` GitHub Release body still shows the pre-correction SHA
  `cf87275`; the repo's own archived note already reads `9d630d9` (§5).
- Carried from v1.29.1: the rule-1b line ceiling (5754) has 2 lines of
  headroom, unchanged this release (agents/+commands/ at 5752 — the 23
  one-line additions and the wei-lin.md edit net to the same total as the one
  line removed from wei-lin.md balanced the clause added there, and the 23
  shared-clause additions are offset by nothing — see §10 for the actual
  line delta, which is 0 for `agents/`+`commands/` specifically even though
  the diff below counts ``*.md``/``*.yaml`` repo-wide).
- `wei-010`, `wei-014`, `wei-016`, `wei-017`, `wei-018`, `zofia-005`: all
  NEVER RUN per `bash evals/run.sh list` — structurally sound (this
  release's audit), but no human has graded a live dispatch against any of
  them yet. A reporting measure (§10), not a release gate, per this
  project's own rules (`run.sh` cannot invoke an agent).

## 7. Totals or cost changes

`bash tests/check.sh`: 1281 passed, 0 failed (v1.29.1) → 1325 passed, 0
failed (this release, post-fix). `agents/`+`commands/` line count: unchanged
at 5752 (ceiling 5754, 2 lines headroom).

## 8. Assumptions used

- `victor-reyes`'s report that it had no `Agent` tool available was taken at
  face value, consistent with the same gap at v1.29.1; this release
  dispatched the two specialists it named (`lian-zhao`, `iris-vermeulen`)
  itself, per `agents/haruto-nakamura.md`'s instruction for exactly this
  case.
- The seven already-merged commits (#134-#140) were taken as correctly
  reviewed at merge time (each green on CI individually — confirmed in §10);
  this release re-audits their cumulative effect since v1.29.1, not each
  PR's own review.
- `docs/lessons_ledger.md`'s call-count figures were taken as the ledger
  author's own claims, not independently re-derived from each inbox run's
  transcript (no access from this repo) — flagged open in §6 rather than
  guessed at.
- Per this project's leak-free instruction, CI and release references below
  are recorded by run id / tag / SHA, not by full host URL; a repo-relative
  path and no-personal-name grep was run on this note before every push.

## 9. CI run this release was gated on

PENDING_CI_SECTION

## 10. Trend since v1.29.1 (9d630d9)

- **Gate assertions** (`bash tests/check.sh`): 1281 passed, 0 failed → 1325
  passed, 0 failed. Better (+44 assertions, still 0 red) — growth from the
  seven already-merged commits' own fixtures and checks plus this release's
  four guard-fix diffs.
- **Fixture verdicts** (`bash evals/run.sh list` / `score`): 29 cases → 32
  cases (+3: `wei-017`, `wei-018`, `zofia-005`). Verdict currency unchanged
  at 0% both times (0/29 → 0/32); never-run rose 20 → 23 (the three new
  fixtures, not yet hand-graded); stale unchanged at 9. Neither better nor
  worse by this measure alone — new coverage added, none of it graded yet.
- **Tracked text lines** (`git diff --shortstat 9d630d9..HEAD -- '*.md'
  '*.yaml'`, counted across the whole repo, not only `agents/`+`commands/`):
  PENDING_DIFFSTAT
- **Board currency** (`PATHWAY_FORWARD.md`): 28 VERIFIED, 1 BROKEN, 0 blank
  `last-checked` rows — identical at both commits; the board was not touched
  by this diff.
- **CI green-on-first-try rate**: 7/7 pushes since v1.29.1's tag (`9d630d9`)
  through this release's pre-merge commit concluded `success`, one run each,
  no re-run observed (`gh run list --branch main --json
  conclusion,headSha,attempt` filtered to the SHA range) — 100%, unchanged
  from v1.29.1's 100%.

This section reports; it does not gate. Tracked lines grew (mostly the three
new fixtures plus this release's guard-fix comments) while the gate-assertion
count improved and the fixture population grew without being graded — the
same shape v1.29.1 flagged, now with four of the latent grading defects it
disclosed fixed (§5) and one new fixture-design question added (§6).

## 11. Work record

- audit: `victor-reyes` on `9d630d9..464db0e` (7 commits) reported no `Agent`
  tool available, ran direct checks only, and named `lian-zhao` and
  `iris-vermeulen`. Its own direct checks found 4 Major (must_not_find guard
  false-positives, all fixed this release), 2 Minor (ledger/fixture
  call-count disagreements, deferred — unsettleable from this repo), 1
  informational (inherited v1.29.1 Release-body SHA drift, deferred). This
  release ran the two named specialists itself: `lian-zhao` found 2 real but
  latent prompt-architecture gaps (`agents/zofia-kaminska.md:17`,
  `commands/autopilot.md:6`), both judgment calls, deferred; `iris-vermeulen`
  cleared `wei-017`'s criteria design as sound (not a defect) and flagged one
  narrower, separate ordering gap, deferred.
- correctness: 0 Critical; 4 Major false-positive fixture-grading bugs found
  and fixed; every other finding is a deferred judgment call or an
  unsettleable cross-document discrepancy, none live/blocking.
- conciseness: `kai-fischer` reviewed the full diff, scoped to it — verdict
  "nothing to cut" (§5); line ceiling unchanged at 5752/5754.
- fixes: applied — 4 mechanical `must_not_find` guard fixes (`wei-014`,
  `wei-016`, `wei-017`, `wei-018`), each verified against its own
  `samples/pass.md`/`samples/fail.md` and against `tests/check.sh` staying
  green. Deferred, each to its named owner: 2 ledger/fixture count
  mismatches, 1 fixture-ordering gap, 2 prompt-architecture gaps, 1 inherited
  Release-body SHA drift — none invented, all in §6.
- docs: `PROJECT_RULES.md`, `README.md`, `PATHWAY_FORWARD.md`, `CLAUDE.md`
  confirmed byte-identical to v1.29.1 (`git diff` empty against all four);
  `PATHWAY_FORWARD.md` board counts confirmed unchanged at both commits (28
  VERIFIED / 1 BROKEN / 0 blank).
- refactor: `kai-fischer` ran, scoped to the release diff (§5) — verdict
  "nothing needed," with specifics (the `wei-lin.md` edit maps 1:1 to ledger
  rows and pays for part of itself with a genuine cut; no new fixture
  duplication).
- rules: checked directly against `PROJECT_RULES.md` myself (rule 10's
  fixture-justification convention followed in each new fixture's notes;
  rule 1's root-document whitelist unchanged, `tests/check.sh` Check 31
  green; no naming-convention violation; no duplicate fixture id). No
  tier/violation findings this cycle. `zofia-kaminska` not separately
  dispatched — nothing surfaced needing her rule-book authority beyond the
  two prompt-scoping judgment calls already routed to her in §5/§6.

## 12. Release gate

PENDING_GATE_SECTION
