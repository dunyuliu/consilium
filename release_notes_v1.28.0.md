# Release notes — v1.28.0 — 2026-10-02

## 1. Version and date

**v1.28.0**, cut 2026-10-02 from `main`, on top of `v1.27.0` (`4f477d7c`,
2026-09-18). Minor bump, per the maintainer's explicit instruction: 55
untagged commits across 44 merged PRs — a new agent and command, a public
README/docs split, two owner-rule rewrites to the release-tag mechanics, and
ten-odd inbox-triage passes folding external lessons into rules and agents.
Nothing is renumbered and no rule is retired; the shipped surface moved enough
in both the product (`agents/`, `commands/`) and the rule book that a patch
undercounts it.

## 2. Summary of scope

55 commits, 44 files changed, **+2,544 / −1,573** across the full diff
(**+2,407 / −1,509** restricted to tracked `.md`/`.sh`/`.py` text — see §10).
Grouped by theme, not by commit — a 55-row table would be less readable than
the PRs themselves:

| Theme | Representative PRs | What |
|---|---|---|
| New agent + command | #59, #61, #70 | `shu-han` (funding-proposal author) added with its fixture; `/propose` command added; DOI-only lookups for unpublished work |
| Public-facing docs split | #68, #69 | `README.md` cut 788 → 184 lines; `docs/user/{getting-started,agents,commands,citing}.md` and `docs/maintainer.md` created to hold what moved out; `CITATION.cff` added; README's stated goal widened to "accelerating scientific innovation, not only software" |
| Release-tag mechanics (owner rules) | #50, #51, #54, #64 | Rule 15a rewritten: the tag is now created together with its GitHub Release in one `gh release create` call, never pushed separately; red-release repair discipline; stranger-clone-before-the-tag |
| `wei-lin` conductor refinements | #40, #41, #43, #52, #55, #56, #57, #58, #60, #63, #65, #66, #67, #71 | Thread/resource caps, PID-kill and worktree-sweep discipline, board edits via PR, batching non-physics PRs, timed per-agent end-reports, message-amendment scope, deadlines on every wait, verifying a brief's claim before a release merge |
| Rule-book housekeeping | #53, #62 | New rule 1b (shipped-prompt size ceiling); board carve-out; no project names anywhere in the repo (public ledger uses aliases); "always diff the root" |
| Gate/check hygiene | — | Check 30 and Check 24 no longer die silently on their own setup failure; Check 28's rule-8a branch fixed (was defeated by `pipefail`); `tests/check.sh`/`evals/` header prose trimmed; stale fixture names and a check range purged from `README.md` |
| `docs/release_notes_v9.9.9.md` removed | `c843c0f` | The fabricated note from the 2026-09-17 incident, deleted by the human maintainer under rule 8a — all three conditions named in the commit message (see §6, resolving v1.27.0 §6.2) |
| Inbox triage (lessons folded in) | #28–#39, #42, #44–#49 | `docs/lessons_ledger.md` created (new, aliased P01…); roughly ten triage passes across this range folding external-project lessons into `agents/*.md`, `PROJECT_RULES.md` and `PATHWAY_FORWARD.md`; `inbox/` itself stays git-ignored and was never read for this note |
| v1.27.0's own follow-up | `2f4acaa` | The commit that transcribed v1.27.0's CI run and release-gate rows into its own now-archived note |

## 3. Files added / removed / renamed / cleaned up

- **Added**: `CITATION.cff`, `agents/shu-han.md`, `commands/propose.md`,
  `docs/lessons_ledger.md`, `docs/maintainer.md`, `docs/user/agents.md`,
  `docs/user/citing.md`, `docs/user/commands.md`,
  `docs/user/getting-started.md`, `evals/cases/shu-han-001-no-invention/`
  (5 files).
- **Removed**: `docs/release_notes_v9.9.9.md` — the fabricated note, deleted
  under rule 8a by the human maintainer (`c843c0f`); all three of rule 8a's
  conditions are named verbatim in that commit's message and were re-verified
  by this pass (`gh api repos/dunyuliu/consilium/git/refs/tags/v9.9.9` → 404,
  no Release).
- **Renamed**: `release_notes_v1.27.0.md` → `docs/release_notes_v1.27.0.md`
  (`git mv`, rule 8 — archived, never deleted).
- **Added**: this note, at the repo root, as the only root release note
  (Check 31 c/d).
- No other file added to or removed from the repo root; Check 31 confirms the
  root holds exactly rule 1's whitelist.

## 4. Content updates to master documents

- **`PROJECT_RULES.md`** 984 → 1,003 lines; 38 → 39 rule entries (+1: new
  **rule 1b**, the shipped-prompt size ceiling, currently 5,762 — see §6 for
  what that ceiling now means in practice). Rule 15a rewritten and retitled
  ("the tag is pushed last" → "the tag is created with its Release, last");
  rule 15b's gate-ownership statement unchanged in row count but now
  cross-references the single-step tag+Release flow. One project name
  (an external project's `pathway_forward.md`, used as a size comparator) was
  scrubbed to an anonymous "a working instance of the same design elsewhere"
  under the new no-project-names rule.
- **`PATHWAY_FORWARD.md`** 534 lines, 35 rows, unchanged in count. All 14 live
  `VERIFIED` rows re-run and re-dated 2026-09-19. **PF-015's evidence command
  was repaired** (`0c685f0`) — it previously asserted a claim its own command
  could not produce evidence for (v1.27.0 §6.1); the new command
  (`grep -c "parse_board.awk -v section=board" tests/check.sh && ! grep -nE
  "section=evidence|Check 17" tests/check.sh`) answers both halves and this
  pass re-ran it clean.
- **`README.md`** 788 → 184 lines. Roster, model table, Layout tree, Install
  walkthrough and Hiring narrative moved to `docs/maintainer.md` and
  `docs/user/*.md`; the opening paragraph now states the project's goal as
  accelerating scientific innovation, not only shipping software.
- **`docs/lessons_ledger.md`** new, 269 lines — the append-only public record
  of every `inbox/` lesson and its outcome (landed / dismissed / deferred),
  aliased `P01…`, no project name in any row (checked below).
- **`tests/check.sh`** 1,379 → 1,402 lines, 31 → 32 live checks (+1, Check 37:
  the shipped-prompt ceiling gate). Checks 24, 28 and 30 had silent
  own-setup-failure modes closed.
- **`evals/`** 4,557 → 4,585 lines, 9 → 10 cases (+1, `shu-han-001-no-invention`,
  landing with the new agent per rule 10/12).

## 5. Audit findings and fixes

**Full deep audit ran this release** (unlike v1.27.0, which was argued and
accepted as removal-only and skippable) — the diff is +2,544/−1,573 across
55 commits, not a tidy subtraction. Dispatched `victor-reyes`, who routed the
rule-vs-prompt-contradiction question to `sophia-okafor` (read all of
`PROJECT_RULES.md` against the full 1,807-line `agents/`+`commands/` diff;
reported none found) and judged the rest — `check.sh`'s shell-logic changes
— himself as small enough not to need `lars-eriksson`.

**Ten findings, zero Critical, six Major, four Minor — all on a surface this
release does not own.** Every Major is a rule-book or `release_gate.sh`
staleness this diff introduced or exposed; every Minor is a dangling
cross-reference or stale comment. None touches `tests/check.sh`'s actual
check logic (gate stays green, 914/0) and none is on a surface rule 19 gives
`haruto-nakamura`: rule-book contradictions are `zofia-kaminska`'s, and
`tests/release_gate.sh` / `tests/check.sh`'s own prose are
`iris-vermeulen`'s — "a gate owned by the agent it judges is not a gate"
applies here exactly as rule 15b states it. **Fixes applied this release:
none** — every finding is recorded as an open issue below, routed by owner,
per Phase 2's instruction to never invent a fix for a judgment call that
belongs to someone else's surface.

**This pass's own verification, re-run fresh, not taken from the dispatch:**
- `bash tests/check.sh` on the pristine pre-release tree: `914 passed, 0
  failed`.
- Scanned every row added to `docs/lessons_ledger.md` in this range by hand:
  no project name, only `P01…` aliases and agent names — confirms the ledger
  meets its own stated contract and the commissioning brief's constraint
  (this note does not reproduce the search terms used, to avoid the exact
  risk it was checking for).
- Read `tests/check.sh` Checks 27 and 31 directly (not just Victor's
  description of them): confirmed Check 31(d) has no pre-tag grace analogous
  to Check 27's, and that this is **not new** — it is the exact mechanism that
  produced v1.27.0's own two documented pre-tag failures (§9 of that note).
  Rule 15a's rationale names only Check 27's grace, which is stale prose, but
  the behaviour itself is established precedent, not a new risk to this
  release.
- Confirmed `docs/release_notes_v9.9.9.md`'s deletion commit (`c843c0f`) names
  all three of rule 8a's conditions and was authored by the human maintainer,
  not an agent acting outside scope — closes v1.27.0 §6.2.
- Confirmed `PF-015`'s repaired command, re-run clean — closes v1.27.0 §6.1.

## 6. Remaining open issues or pending items

1. **Rule 15a contradicts itself.** Its body (rewritten this range) says "the
   tag and the Release [are created] in one step… never push a tag
   separately." Its unchanged "How to apply" line still reads "tag locally,
   push commit, push tag, then require green." Found by `victor-reyes`;
   `PROJECT_RULES.md` is `zofia-kaminska`'s surface. This release followed the
   body (and this agent's own prompt, which is unambiguous about the
   single-step order) — see §9 for the actual sequence used.
2. **Rule 15a's rationale is incomplete, not wrong.** It credits only Check
   27's pre-tag grace; Check 31(d) (root note must be the newest tag's) hits
   the identical boundary with no stated exception. Behaviourally this is
   already-established precedent (v1.27.0 hit it too), so it changed nothing
   about how this release was cut — but the rule text doesn't say so. Found
   by `victor-reyes`, confirmed independently by this pass reading the check
   code; `zofia-kaminska`'s surface.
3. **`tests/release_gate.sh` describes a flow this range retired.** Its header
   says "Run… before the tag is pushed… Exit 0 means the release may be
   tagged," and the `publish` row's SKIP message says to "push it after row ci
   is green" — both describe the old push-a-local-tag flow, not the current
   `gh release create` single step. Found by `victor-reyes`. This script is
   explicitly `iris-vermeulen`'s surface (rule 15b); not edited here.
4. **`tests/check.sh` Check 35's header comment is stale.** It says Haruto
   "does not itself run `gh release create`" — as of rule 15a's rewrite, step
   12 does exactly that. Cosmetic; doesn't affect the check's logic. Found by
   `victor-reyes`; `iris-vermeulen`'s surface.
5. **Two dangling cross-references in `PROJECT_RULES.md` rule 1.** "README
   'Hiring'" no longer exists in `README.md` (moved to
   `docs/maintainer.md:410`); "README's Install and CI sections" is half-stale
   — README has an Install section but no CI section, and neither does
   `docs/maintainer.md`. Found by `victor-reyes`; `zofia-kaminska`'s surface.
6. **No rule-19 ownership row for `docs/maintainer.md`, `docs/user/*.md` or
   `docs/lessons_ledger.md`**, all created in this range. Check 10 cannot flag
   a surface nobody owns. Found by `victor-reyes`; needs a human decision on
   who takes it (candidates include `lian-zhao` for the Layout-tree
   restatement; the user docs and the ledger have no obvious existing owner).
   Deliberately left to the maintainer rather than assigned here.
7. **Rule 1b's ceiling is now matched exactly, not approached.** `agents/` +
   `commands/` measure 5,762 lines against a ceiling of 5,762 (limit 5,877).
   Not a defect — Check 37 is green — but the next prompt edit that adds a
   line without cutting one fails the gate outright, not just the 2% grace
   band. Found by this pass; flagged for the maintainer before the next
   `agents/`/`commands/` change.
8. **Fixture verdict currency is still low, and fell further.** 2/10 (20%)
   verdicts current against their prompt's SHA, down from 3/9 (33%) at
   v1.27.0 — 7 stale, 1 never-run (`shu-han-001-no-invention`, brand new, not
   yet dispatched). Carried from v1.27.0 §6.3; not closed, and closing it
   costs human dispatches, not a commit.

**Resolved since v1.27.0** (both closing that note's open issues):
v1.27.0 §6.1 (PF-015's command) — fixed in `0c685f0`, re-verified above.
v1.27.0 §6.2 (`docs/release_notes_v9.9.9.md`) — deleted by the human
maintainer under rule 8a in `c843c0f`, re-verified above.

## 7. Totals or cost changes

| Measure | v1.27.0 | v1.28.0 |
|---|---|---|
| Tracked lines (`git ls-files \| xargs wc -l`) | 19,516 | 20,487 |
| `evals/` lines | 4,557 | 4,585 |
| `tests/check.sh` lines | 1,379 | 1,402 |
| `PROJECT_RULES.md` lines | 984 | 1,003 |
| `agents/`+`commands/` lines (rule 1b) | 5,510 | 5,762 (ceiling 5,762) |
| Live checks | 31 | 32 |
| Eval cases | 9 | 10 |
| Agents / commands | 22 / 19 | 23 / 20 |
| Rule entries | 38 | 39 |
| Board rows VERIFIED / BROKEN / blank-dated | 14 / 0 / 0 | 14 / 0 / 0 |

(v1.27.0 column re-measured fresh in a throwaway clone at that tag, not copied
from that note — see §8 and §10 for why the tracked-line figure here differs
slightly from the one v1.27.0 reported for itself.)

## 8. Assumptions used

- **The brief's state was re-verified, not taken.** `main`'s tip, the
  `v1.27.0` tag date, the 55-commit/44-PR count, the 914/0 local gate, the
  free lock, and branch protection (`required check: "check"`,
  `enforce_admins: true`, no force-push/deletion) were each re-read by
  command before use, not copied from the dispatch brief.
- **The v1.27.0 baseline was measured in a throwaway full clone at that tag**,
  not in the working checkout, so no measurement mutated this tree. Its
  `bash tests/check.sh` there reads `796 passed, 3 failed` — the 3 are
  `PATHWAY_FORWARD.md` rows (PF-021/023/024) reading as calendar-overdue
  because they are being checked *today* against a 14-day interval set when
  that tag was cut, not a defect that existed in the released v1.27.0 tree
  itself. §10 uses 796 as the honest same-conditions-today baseline and says
  so, the same way v1.27.0's own note explained its 809-vs-806 baseline
  discrepancy.
- **§7's tracked-line totals use one consistent command run at both commits
  this session**; v1.27.0's own note reported 19,227 for itself using a
  different accounting (likely excluding or including a different file set).
  Not reconciled against that number — re-measured, and the method is stated
  so the next release can reproduce it.
- **The 44-merged-PR, 55-commit range is `git log v1.27.0..HEAD`**, confirmed
  against `gh pr list --state merged` count rather than assumed from the
  brief.
- **No refactor pass ran.** 55 already-PR-gated commits land as a single
  minor release at the maintainer's explicit instruction; see the
  `refactor:` line in §11.

## 9. CI run this release was gated on

transcribed by the follow-up commit

## 10. Trend since v1.27.0

Every row is the output of a command run this session, at both commits. The
v1.27.0 column comes from a throwaway full clone checked out at
`v1.27.0^{}` = `4f477d7c`.

| Measure | v1.27.0 | v1.28.0 | Direction |
|---|---|---|---|
| Gate assertions — `bash tests/check.sh` | `796 passed, 3 failed` (3 are calendar-overdue board rows, not a v1.27.0 defect — see §8) | `914 passed, 0 failed` | **Better.** +118 assertions (one new check, three more agents/commands, one more rule, one more fixture, each carrying its own assertions), zero failures. |
| Fixture verdicts — `bash evals/run.sh list` / `score` | 9 cases, 3 current (33%), 5 stale, 1 unknown provenance, 0 never-run | 10 cases, 2 current (**20%**), 7 stale, 0 unknown provenance, 1 never-run | **Worse.** Both the count and the share of current verdicts fell; this is a real regression, not an artifact — six more fixtures have drifted stale than were current to begin with, and the one new case has never been dispatched. |
| Tracked text lines — `git diff --stat v1.27.0..HEAD -- '*.md' '*.sh' '*.py'` | — | 38 files, **2,407 added / 1,509 removed, net +898** | **Larger, not smaller.** Unlike v1.27.0's net −134, this release grew the tracked surface substantially — mostly new user-facing docs and the new agent, but real growth nonetheless (see reading, below). |
| Board currency — `PATHWAY_FORWARD.md` | 14 VERIFIED, 0 BROKEN, 0 blank dates | 14 VERIFIED, 0 BROKEN, 0 blank dates | **Unchanged**, and all 14 were re-run against the new tree (2026-09-19) rather than carried. |
| CI green on first try — `gh run list` since v1.27.0's tag push | 8 of 8 (v1.26.0 baseline) | **98 of 98** pushes green on first try since the v1.27.0 Release, excluding the single already-documented failure/success pair at the v1.27.0 tag boundary itself (that pair is v1.27.0's own §9, not a new-release event) | **Unchanged in substance** — still 100% first-try green; the denominator is just much larger over a longer, busier range. |

**Reading, plainly — this is not a uniformly clean release under its own
trend standard.** The gate and board measures improved or held; the line-count
and fixture-currency measures did not, and schema item 10 requires saying so
even though the release gate itself is green. Tracked lines grew by ~900 and
`agents/`+`commands/` now sits exactly at rule 1b's ceiling with no margin
left (§6.7) — most of that growth is legitimate new product (a new agent, a
public docs split, a lessons ledger) rather than duplication, but it is growth
all the same, not the leanness streak v1.26.0→v1.27.0 had going. Fixture
verdict currency fell in both absolute and percentage terms, which this
release did not budget a dispatch to repair (§6.8, carried from v1.27.0). The
honest summary: **green gate, flat board, worse fixture currency, larger
codebase** — reported as deterioration where it is one, not smoothed into
"held flat."

## 11. Work record

- **audit**: `victor-reyes` consolidated pass (one specialist dispatch,
  `sophia-okafor`, for rule-vs-prompt contradictions — none found), plus this
  agent's own mechanical re-verification (gate, ledger scan, check-code read,
  two v1.27.0 open-issue closures). **10 findings** — 0 Critical, 6 Major,
  4 Minor, all §6.
- **correctness**: `bash tests/check.sh` → `914 passed, 0 failed`, run on the
  pristine pre-release tree and intended to be re-run on the merged commit
  before tagging (§12).
- **conciseness**: assessed inline, not independently verified by
  `kai-fischer` (see `refactor:` below). The +2,407/−1,509 tracked-text diff
  is mostly new, legitimate product surface, not duplication — but it is net
  growth, and §10 reports it as such rather than as neutral.
- **fixes**: **none applied.** All 10 findings sit on `zofia-kaminska`'s
  (`PROJECT_RULES.md`) or `iris-vermeulen`'s (`tests/release_gate.sh`,
  `tests/check.sh` comments) surfaces under rule 19 and are recorded as open
  issues (§6), routed by owner, not invented fixes.
- **docs**: reconciled against the filesystem, not the diff or the dispatch
  brief. Root walked with `git ls-files` against rule 1's whitelist; every
  count in §7 re-read off disk this session.
- **refactor**: **`kai-fischer` did not run this release.** The maintainer's
  instruction was to cut the release over 55 already-PR-gated commits, not to
  open a leanness pass on top of them. This pass's own conciseness read
  (above) is not a substitute for his verdict — stated as a step that did not
  happen, not as "nothing needed."
- **rules**: **`zofia-kaminska` did not run a fresh Mode B pass for this
  cut.** This pass verified mechanically: 39 rule entries, no number moved,
  one new sub-rule (1b) landed with its own ceiling, and two rule-book
  staleness items surfaced by the audit (§6.1, §6.2) that are hers to resolve.
  No tier-split, violation list, or unenforceable-rule verdict was produced,
  because no dedicated rules audit ran.

## 12. Release gate

transcribed by the follow-up commit
