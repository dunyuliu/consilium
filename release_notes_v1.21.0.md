# Release notes — v1.21.0

**Date:** 2026-09-16
**Previous:** v1.20.0 (archived to `docs/`)
**Bump:** minor — a new agent, a new command, a new release-boundary gate
(rules 15a/15b) with its own script, a board-driven autopilot cycle, and a
fleet-wide frontmatter bug fix. No breaking change to any existing surface.

## 1. Summary of scope

Ten commits since v1.20.0 (`a8e9ec1..052e19d`, 71 files, +3767/-134). This
audit (run inline — see §5 on why) found the diff matches its own history:
every file the git log describes is the file that changed, and nothing
outside the described scope moved.

## 2. Files added / removed / renamed / cleaned up

**Added:**
- `CLAUDE.md` — the fourth root document (working notes for editing this
  repo), landed because `zofia-kaminska`'s own seed invariant requires it on
  every project she seeds and it had never existed here.
- `agents/marta-silva.md` — a new agent (figure-generation + print-scale
  audits), wired into the README roster, model table and Layout tree (Checks
  6/7 green) with its fixture `evals/cases/marta-001-print-scale-audit/`.
- `commands/autopilot.md` — the `/autopilot` command, driving `wei-lin`'s
  board-driven queue and milestone cycle from `PATHWAY_FORWARD.md`'s new
  `prio` column.
- `tests/release_gate.sh` — the ten-row release gate (rule 15b), owned by
  `iris-vermeulen`.
- Four eval fixtures: `kai-002-no-worktree-no-write`,
  `wei-lin-002-plan-contradicts-code`, `marta-001-print-scale-audit`,
  `zofia-003-seed-bare-project`, plus `lian-002-gate-without-prompt` — five
  in total, not the two named in this release's brief; the other three
  surfaced only by reading the diff directly (rule 4).
- `evals/results.tsv` — history log for `evals/run.sh score`.

**Removed:** none. **Renamed:** none.

**Archived (this release):** `release_notes_v1.20.0.md` moved to
`docs/release_notes_v1.20.0.md` (rule 8 — `git mv`, not deleted).

**Cleaned up (already landed before this audit, commit `622d75c`):** four
duplicated passages cut fleet-wide, net -46 lines — `CLAUDE.md`'s and
`README.md`'s questions blocks stopped restating each other, `wei-lin.md`
stopped re-deriving what the gate's `tree` row now decides mechanically, and
rules 15a/15b were trimmed to the obligation, leaving the mechanism in their
scripts' own headers.

## 3. Content updates to master documents

- **`PROJECT_RULES.md`**: rules 15a (CI-before-tag) and 15b (the ten-row
  gate) added; the root whitelist promoted from prose to a machine-readable
  table (Check 31); every rule's tier annotation in the index now names its
  actual check or says why it has none (e.g. rule 18 — "mechanical in name
  only").
- **`PATHWAY_FORWARD.md`**: `prio` column added to the board (PF-018,
  VERIFIED) and a full board pass re-ran every row's evidence command on
  2026-09-16 — `bash tests/check.sh` now reports 1318 assertions (up from
  789 at the last stale count), a jump driven mostly by a shallow-clone
  exemption ending, not new coverage (PF-006's own note says so).
- **`README.md`**: gained a "The questions" block (Check 32: shares no
  question with `CLAUDE.md`'s working-form list).
- **`CLAUDE.md`**: new file (§2).

## 4. Audit findings and fixes

**No Agent tool is available in this environment**, so the deep audit
normally routed through `victor-reyes` (and, for refactor/conciseness and
rule-book verdicts, `kai-fischer` and `zofia-kaminska`) could not be
dispatched. Per this project's own fallback clause, all three passes below
were run inline by me instead of delegated, and are recorded as such — not
signed as though the named specialist ran.

**Findings, from reading the full diff and the board directly:**

1. **Fleet-wide frontmatter bug, already fixed in this diff.** Five agents
   (`ziyan-chen`, `lian-zhao`, `mira-volkov`, `priya-nair`, `rafael-santos`)
   had a `description:` field containing an unquoted apostrophe or the YAML
   frontmatter's own quoting hazard; commit `f34eead` and its siblings quote
   all five. Verified: `tests/check.sh` Check 1 passes on all five today.
2. **Rule 10 debt, real and already disclosed — not fixed here.**
   `PATHWAY_FORWARD.md` PF-017 (BROKEN, P1) already names it: ~190 lines of
   new release-and-queue behavior landed in `agents/wei-lin.md` and
   `agents/haruto-nakamura.md` with no fixture exercising the autopilot
   cycle, the release gate, or `zofia-kaminska`'s patch-vs-seed branch.
   `zofia-003` covers seeding a bare project only. Writing that fixture is
   `lian-zhao`'s/`iris-vermeulen`'s surface, not mine, and the constraint on
   this release run forbids touching `agents/*.md`, `tests/*.sh` or
   fixtures — carried forward as an open issue rather than invented here.
3. **PF-019 (OPEN, P2), also pre-existing.** `tests/release_gate.sh`'s
   `publish` row checks the tag, not a GitHub Release page. Unaddressed for
   the same ownership reason as #2.
4. **No new structural or correctness defects found.** `bash tests/check.sh`
   is green at 1318 assertions on the pristine pre-release tree; the ten-row
   gate script's `ROWS` array matches the schema in this very file (Check
   33, green); `tests/release_gate.sh`'s row logic was read in full and its
   `tree`/`ci`/`publish` computations match rule 15a/15b as written.

**Refactor / conciseness (`kai-fischer`'s row, run inline for the same
reason as #4 above):** the diff's growth (+3767/-134) traces entirely to
named, disclosed features — the ten-row gate, `/autopilot`, the board's
`prio` column and questions blocks, and five new fixtures — plus the
same-session trim (`622d75c`) that had already removed the four duplicated
passages found by that pass. Reading the diff a second time found no further
duplication and no code touched outside its stated scope. This is not a
substitute for Kai's own review.

**Rule-book verdict (`zofia-kaminska`'s row, run inline for the same
reason):** `PROJECT_RULES.md`'s index has no duplicate or renumbered rule
(rule numbers only ever grow by sub-rule, per its own convention); the root
whitelist in rule 1 matches the actual root (Check 31, green); exactly one
board exists (Check 34, green); rules 15a and 15b's tier claims match the
mechanisms they cite (`tests/release_gate.sh`, Check 33). No violation
found. Not a substitute for Zofia's own audit.

**Fixes applied this release:** none beyond what commit `f34eead` and its
four siblings already did before this audit started — nothing in scope for
`haruto-nakamura` to mechanically fix was found.

## 5. Remaining open issues or pending items

Carried forward from `PATHWAY_FORWARD.md`, unchanged by this release:

1. PF-017 (BROKEN, P1) — no fixture for the autopilot cycle, the release
   gate, or zofia's patch-vs-seed branch (§4.2).
2. PF-003 (BROKEN, P1) — 11 of 32 fixtures have never been executed,
   including three of the five landed this session (`kai-002`,
   `wei-lin-002`, `zofia-003`; `lian-002` also never run).
3. PF-019 (OPEN, P2) — the release gate has no published-GitHub-Release row
   (§4.3).
4. PF-004, PF-009, PF-012, PF-013 (OPEN) — precision-of-grading,
   whole-prompt-set audit, post-slim regression check, and model-tier review
   respectively; none touched by this release's diff.

## 6. Totals

| | v1.20.0 | v1.21.0 |
|---|---|---|
| Agents | 21 | 22 (+`marta-silva`) |
| Commands | 18 | 19 (+`/autopilot`) |
| Eval fixtures | 27 | 32 (+5) |
| Structural checks | 29 | 34 (+31, 32, 33, 34) |
| `tests/check.sh` assertions | 752 (pre-tag) | 1318 |
| Eval-suite trustworthiness (`evals/run.sh score`) | not tracked this way | 11/32 current (34%), delta -12 vs previous commit — expected: 5 new fixtures unrun, several prompts touched by the board pass |

## 7. Assumptions used

- **Minor, not patch**, per the trigger: a new agent, a new command, two new
  rule sub-rules with their own enforcing script, and a fleet-wide bug fix
  are more than a patch under this project's own precedent (v1.20.0 and
  v1.19.0 were both minor for a comparable mix).
- The five new fixtures beyond the two named in this release's brief
  (`kai-002`, `wei-lin-002`, `marta-001`) are treated as in-scope history to
  report, not as something this release needed to run — running them is
  PF-003's open task, not a release-gate requirement.
- Ownership constraints on this run (`agents/*.md`, `tests/*.sh`, fixtures
  are other agents' surfaces) mean findings #2 and #3 in §4 are recorded as
  open issues, never as invented fixes.

## 8. The CI run this release was gated on

PENDING AT NOTE-AUTHORING TIME — this line and the `ci:` row below describe
a specific commit's SHA and its CI conclusion, which cannot exist until that
commit is created and pushed. Finalized in a follow-up commit before the tag
is created, per the note below; see the operator's final report for the
confirmed run id, conclusion and SHA if this line was not updated in place.

## Release gate

- audit: inline (no Agent tool here — victor-reyes unavailable); full diff v1.20.0..HEAD read, PROJECT_RULES.md and PATHWAY_FORWARD.md cross-checked, 5 findings above, 2 pre-existing and deferred
- correctness: no code paths touched outside iris-vermeulen's tests/release_gate.sh and tests/check.sh; release_gate.sh's row logic read in full and matches rules 15a/15b as documented; check.sh green at 1318 assertions
- conciseness: kai-fischer unavailable (no Agent tool); inline re-read of the diff found no duplication beyond what commit 622d75c already cut; growth traces to named features only
- fixes: none applied by haruto-nakamura this release; the fleet-wide frontmatter fix (5 agents) was already committed before this audit began and was independently verified, not authored here
- docs: PATHWAY_FORWARD.md board and CLAUDE.md/README.md questions blocks reconciled against the filesystem via bash tests/check.sh (1318 passed) and bash evals/run.sh list/score, not against the git diff alone
- refactor: kai-fischer unavailable (no Agent tool); inline scan found nothing to simplify beyond the already-landed trim commit 622d75c; not a substitute for his pass
- tree: pending — see script output at gate time
- ci: PENDING — see §8; will be replaced with the verified API conclusion, run URL and SHA before the tag is created
- publish: pending — v1.21.0 is tagged only after ci confirms green, and pushed only after the gate script passes
- rules: zofia-kaminska unavailable (no Agent tool); inline check found no duplicate/renumbered rule, root whitelist matches Check 31, exactly one board (Check 34), rules 15a/15b tiers match their cited mechanisms — no violation found; not a substitute for her audit
