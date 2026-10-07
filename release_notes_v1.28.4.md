# Release notes — v1.28.4 — 2026-10-07

## 1. Version and date

**v1.28.4**, cut 2026-10-07 from `main`, on top of `v1.28.3`
(`684e75dd578a30acd51e0fd6db2d228e6689dbc7`, 2026-10-05). Patch bump: cadence
trigger (≥5 PRs since last tag) — five merged PRs (#93–#97), all
prompt/doc/ledger lessons folded in from the inbox-triage process plus one
agent-scope expansion. No new agent, no new command, no rule added or
renumbered (rule 10 unchanged this range, only re-cited).

## 2. Summary of scope

5 commits, 8 files changed, **+112 / −86** (tracked `.md` text,
`git diff --stat v1.28.3..HEAD`).

| Theme | PR | What |
|---|---|---|
| v1.28.3 note completion | #93 | Transcribed the release-gate rows and tag-push CI run into `release_notes_v1.28.3.md` §9/§12, which shipped at tag time with pending placeholders |
| Inbox lessons, net 0 | #94 | A benchmark landed on self-consistency alone is "gated, not validated" until an independent oracle at matched resolution (archived one first) passes; a physics or gate-diff merge report cites its audit's link, none means no merge; a hold or time-box is an unblock event only when quoted from current files |
| Inbox lessons, net 0 | #95 | A relayed success names its result file, never "no exception"; a reference check lists one row per assigned ID and tallies IDs marked, not rows |
| Inbox lessons, net 0 | #96 | Judge branch staleness by a three-dot diff (never two-dot) or a trial squash, rebase only on a real conflict or when CI must test the combined tree; reap a dispatched agent's worktree only after its completion notice or a liveness check, never because its PR merged; a widened gate diffs its oracle path against the narrower gate's before launch; a closing report quotes each board row's State cell as read at the final SHA |
| Agent scope expansion, net −3 | #97 | `anya-petrov` becomes standing owner of a project's user docs (Diátaxis split, README first, docs land in the code's PR, executable README commands checked by shape after scripted edits, link check, changelog per bump, confirm the docs site actually publishes) — not only a publication-time pass |

## 3. Files added / removed / renamed / cleaned up

- **Renamed**: `release_notes_v1.28.3.md` → `docs/release_notes_v1.28.3.md`
  (`git mv`, rule 8 — archived, never deleted).
- **Added**: this note, at the repo root, as the only root release note.
- No other file added to or removed from the repo root; root still holds
  exactly rule 1's whitelist (Check 31 confirms mechanically).
- No new agent, command, rule, check, or eval case landed in this range.

## 4. Content updates to master documents

- **`PROJECT_RULES.md`** — 1,005 lines (unchanged from v1.28.3), 47 index rows
  unchanged, no renumbering. One line edited in place (rule 19's ownership
  table, PR #97): `anya-petrov`'s row widened from "publication staging,
  citation files" to "publication staging, citation files, a project's user
  docs." No rule text itself amended this range.
- **`PATHWAY_FORWARD.md`** — untouched this range (`git diff --stat
  v1.28.3..HEAD -- PATHWAY_FORWARD.md` is empty). Board total unchanged: 13
  VERIFIED, 22 RETIRED, 0 BROKEN (of 35 rows) — same as v1.28.3. No blank
  `last-checked` date found on any live row.
- **`README.md`** — one line edited in place (the `anya-petrov` roster row,
  PR #97), reflecting the same scope widening as PROJECT_RULES.md.
- **`agents/anya-petrov.md`** (99 lines touched: 48 ins / 51 del, PR #97) — new
  `## User docs (standing, every PR)` section; tightened Isolation,
  Communication-discipline and Tool-economy prose to pay for it (rule 1b);
  publication-staging section renamed "in priority order" → kept, trimmed of
  now-duplicated README-structure bullets. Net line count for `agents/` +
  `commands/`: 5,746 → 5,743 (ceiling unchanged at 5,754, matches PR #97's
  stated net −3; Check 37 passes with 11 lines of headroom).
- **`agents/wei-lin.md`** (40 lines touched: 20/20, PRs #94/#96) — staleness
  judged by three-dot diff or trial squash (never two-dot); worktree reaping
  gated on a liveness check; hold/time-box must be quoted from current files;
  merge report cites the audit link for a physics/gate diff; widened-gate
  oracle-path diffing; end-of-run report quotes each row's State cell.
- **`agents/ziyan-chen.md`** (4 lines touched: 2/2, PR #95) — one row per
  assigned ID, tally counts IDs marked rather than rows; the no-issues
  single-row case is unchanged.
- **`docs/maintainer.md`** — 3 lines edited in place (PR #97): the ownership
  paragraph, the responsibility-map table row, and the Layout-tree comment for
  `anya-petrov.md`, all widened to "user docs" alongside publication staging.
- **`docs/lessons_ledger.md`** — 322 → 336 lines (+14, all new rows, no
  deletions), 14 new dated rows (10-05 ×1, 10-06 ×6, 10-07 ×6, 1 owner-decision
  row), aliased (`P05`, `P15`, `P16`, `P17`, `P18`, `owner`) — no project name,
  path, host, or person in any added row, checked by hand (§5 confirms). One
  row (10-05, line 323) corrected this release: "sharpens rule 1" → "sharpens
  loop rule 1" — ambiguous with `PROJECT_RULES.md` rule 1, and the ledger
  already uses "loop rule 1" elsewhere (e.g. the 10-03 P16 row) for the same
  referent.

## 5. Audit findings and fixes

**Dispatched `victor-reyes`** for the deep pass (self-handled, no
sub-dispatch — 8 files, 198 diff lines, one surface, no gate or physics logic
touched). Ran `bash tests/check.sh` himself: `926 passed, 0 failed`.

**10 consolidated findings — 0 Major, 4 Medium, 5 Low, 1 advisory.**

1. **(Medium, `victor-reyes`.)** Rule 19's row giving `anya-petrov` "a
   project's user docs" (`PROJECT_RULES.md:731`) is not reconciled against
   this same rule book's existing README-restatement ownership (`:740-742`,
   `:780-787`, which name `lian-zhao`/`iris-vermeulen`/`zofia-kaminska` for
   different README sections). Applied to consilium itself (rule 0), the
   repo's own README and `docs/user/` now have an ambiguous second claimant.
   Check 10 cannot see this — it checks the table is complete and exclusive
   by row, not by meaning. **Not fixed** — `PROJECT_RULES.md` is
   `zofia-kaminska`'s surface; deferred to her/the human.
2. **(Medium, `victor-reyes`.)** `agents/anya-petrov.md`'s Isolation section
   (`:26-27`) still says the working repository a user develops in "is not
   your workspace," unchanged from before PR #97, while the new "Same PR"
   bullet (`~:76`) now has her landing doc changes directly in the code's PR.
   The prompt never reconciles where she works for standing docs work versus
   a publication-staging pass. **Not fixed** — `agents/*.md` is
   `lian-zhao`'s surface; deferred to her.
3. **(Medium, `victor-reyes`.)** `agents/wei-lin.md:153-158`: gate axis 4 now
   says staleness is judged by three-dot diff, "never two-dot," but the
   following paragraph still describes comparing `git show HEAD:path` against
   a worktree file and expecting "no reverted lines" — a two-dot-shaped
   comparison for the copy-back-revert case. The two rules address different
   landing methods (squash-merging a PR vs. copying a shared file back) but
   the prompt does not say so, so a reader cannot tell which applies when.
   **Not fixed** — `lian-zhao`'s surface; deferred.
4. **(Medium, `victor-reyes`, corroborated against `PROJECT_RULES.md` rule 10's
   text directly — carried and worsened from v1.28.3 finding 1.)** Rule 10
   reads: "A fixture is owed only when the same failure is reported again
   after its fix landed... **How to apply**: on a repeat report, fixture
   first or in the same commit" (`PROJECT_RULES.md:301-311`) — no "deferred to
   owner" carve-out. This range's `docs/lessons_ledger.md` diff adds **8** new
   rows (up from 2 at v1.28.3) each self-certified as a recurrence and marked
   "fixture-eligible under rule 10, deferred to the owner," plus 2 more
   dismissed as "covered" despite also reading as recurrences. `git diff
   --stat v1.28.3..HEAD -- evals/` is empty — no fixture landed for any of
   them. `zofia-kaminska`'s v1.28.3 verdict on the identical pattern (rule 10
   is correctly tiered `judgment` and needs no rewrite; the gap is a missing
   mechanical proxy check that nothing today runs; these are violations, not
   a licensed exception) still applies on these facts — not re-dispatched
   this release, since nothing about the rule or the pattern changed, only
   the count. **This agent's call: still not a release blocker** —
   `tests/check.sh` has no check for this — but the debt is now **4x** what
   it was one release ago with zero fixtures landed against it, and that
   trend is called out again in §10 rather than left to improve by assertion.
5. **(Low, `victor-reyes`.)** `agents/ziyan-chen.md`'s new "one row per
   assigned ID" line (`:76-77`) sits beside an unedited "One row per issue"
   elsewhere and "No commentary outside the table" (`:71`), leaving the new
   tally with no stated home; `verified` is not in the issue-label list
   (`:82-83`); "IDs marked" does not say marked as what. The no-issues
   single-row case is unaffected. **Not fixed** — `lian-zhao`'s surface;
   deferred.
6. **(Low, `victor-reyes`.)** `docs/user/agents.md:80` still calls
   `anya-petrov` "Publication-staging engineer" and
   `docs/user/getting-started.md:25`'s routing table has no row for user docs
   — both stale against PR #97's scope widening. **Not fixed** — whether
   `docs/user/*.md` is even `anya-petrov`'s surface to edit, or belongs to
   whichever agent already restates README content there, is finding 1's open
   question; fixing this ahead of that answer would presume it. Deferred to
   `zofia-kaminska`/human alongside finding 1.
7. **(Low, `victor-reyes` — fixed this release, mechanical, no declared
   owner.)** `docs/lessons_ledger.md`'s 10-05 P16 row said "sharpens rule 1,"
   ambiguous with `PROJECT_RULES.md` rule 1 (smallest change) when it meant
   `wei-lin`'s own internal loop rule 1; the ledger already disambiguates this
   exact referent elsewhere as "loop rule 1." Fixed in this release (§4); a
   one-word clarity fix, not a judgment call, and `docs/lessons_ledger.md` has
   no rule-19 ownership row (carried gap, §6.6), same as `docs/maintainer.md`
   at v1.28.3.
8. **(Low, `victor-reyes`.)** `agents/wei-lin.md:257`'s "that line copied
   verbatim into every brief" does not say which line — the whole isolation
   sentence, or only the never-touch-main-checkout clause. **Not fixed** —
   `lian-zhao`'s surface; deferred.
9. **(Low, `victor-reyes` — explained, not a defect.)** `agents/wei-lin.md`'s
   sentence "The transcript of a passing run is not a substitute for your
   run" was deleted with no ledger row; its meaning survives in the adjacent
   "run your OWN fresh check against the project's real reference oracle" —
   reads as a line-budget trim (rule 1b), not a capability loss.
10. **(Advisory, `victor-reyes`.)** Archiving `release_notes_v1.28.3.md` to
    `docs/` via `git mv` at this cut is the normal rule-8 step, not a defect.

**Fixes applied this release:** one (finding 7, mechanical doc-sync).
**Deferred, by owner:** findings 1, 2, 3, 5, 6, 8 (all `lian-zhao` or
`zofia-kaminska`/human — none invented). Finding 4 is carried and worsened,
flagged at the same severity as v1.28.3 rather than re-litigated, since the
rule and the facts are unchanged. Findings 9–10 are explained, not actionable.

**This pass's own verification, re-run fresh:**
- `bash tests/check.sh` on the pristine pre-release tree: `926 passed, 0
  failed`.
- `cat agents/*.md commands/*.md | wc -l` → `5743`, matching Check 37's
  measured count, 11 lines under the 5,754 ceiling.
- Read every new `docs/lessons_ledger.md` row by hand: no project name, path,
  host, or person — only `P05`/`P15`/`P16`/`P17`/`P18`/`owner` aliases and
  agent names.
- `git diff v1.28.3..HEAD -- PATHWAY_FORWARD.md`: empty — board untouched.
- `git diff --stat v1.28.3..HEAD -- evals/`: empty — confirms finding 4's "no
  fixture landed" claim directly, not by assertion.

## 6. Remaining open issues or pending items

1. **(Medium, open.)** Rule-19 ownership overlap between `anya-petrov`'s new
   "user docs" row and this rule book's existing README-restatement
   ownership — §5 finding 1. Owner: `zofia-kaminska`/human.
2. **(Medium, open.)** `agents/anya-petrov.md`'s Isolation section not
   reconciled with her new standing-docs workspace — §5 finding 2. Owner:
   `lian-zhao`.
3. **(Medium, open.)** `agents/wei-lin.md` gate-axis-4 two-dot/three-dot
   internal contradiction — §5 finding 3. Owner: `lian-zhao`.
4. **(Medium, open, carried and worsened from v1.28.3 §6.1/finding 1.)** 8
   new unfixtured rule-10 recurrences this range (0 at v1.28.2→v1.28.3: 2;
   v1.28.3→v1.28.4: 8) — §5 finding 4. Owner: `iris-vermeulen` (author the
   fixtures; consider the proxy check), `zofia-kaminska`/human (decide
   whether to pause unfixtured "landed" claims or accept the growing debt).
5. **(Low, open.)** `agents/ziyan-chen.md`'s tally-location ambiguity — §5
   finding 5. Owner: `lian-zhao`.
6. **(Low, open.)** `docs/user/agents.md` and `docs/user/getting-started.md`
   stale re: anya's scope — §5 finding 6, blocked on finding 1's answer.
   Owner: `zofia-kaminska`/human, then `anya-petrov`.
7. **(Low, open.)** `agents/wei-lin.md:257`'s unnamed "that line" — §5
   finding 8. Owner: `lian-zhao`.
8. **(Carried from v1.28.1–v1.28.3, not re-audited this pass.)** No rule-19
   ownership row for `docs/maintainer.md`, `docs/user/*.md`,
   `docs/lessons_ledger.md` itself — no new evidence either way this range,
   though finding 1/6 above now makes `docs/user/*.md`'s gap concrete rather
   than theoretical.
9. **(Carried from v1.28.2/v1.28.3 §6.9/§6.7, unresolved.)** CI
   (`.github/workflows/check.yml`) still prints the same two Node.js-20 /
   Ubuntu-26 deprecation annotations on every run — not re-confirmed this pass
   (no new CI run read yet at the time of writing; to be confirmed against
   the gating run in §9). Owner: `iris-vermeulen`.

## 7. Totals or cost changes

Both columns measured fresh this session — v1.28.3 in a throwaway detached
worktree at that tag, v1.28.4 on the release branch before the tag was cut.

| Measure | v1.28.3 | v1.28.4 |
|---|---|---|
| Tracked lines (`git ls-files \| xargs wc -l`) | 21,736 | 21,762 |
| `evals/` lines (`git ls-files evals \| xargs wc -l`) | 4,585 | 4,585 |
| `tests/check.sh` lines | 1,409 | 1,409 |
| `PROJECT_RULES.md` lines | 1,005 | 1,005 |
| `agents/`+`commands/` lines (rule 1b) | 5,746 (ceiling 5,754) | 5,743 (ceiling 5,754) |
| Live checks | 32 | 32 |
| Eval cases | 10 | 10 |
| Agents / commands | 23 / 20 | 23 / 20 |
| Rule-book index rows (incl. sub-rules, retired) | 47 | 47 |
| Board rows VERIFIED / RETIRED / BROKEN (of 35 total) | 13 / 22 / 0 | 13 / 22 / 0 |

## 8. Assumptions used

- **The brief's state was re-verified, not taken.** `main`'s tip (`c982eaa`),
  the five-PR/five-commit range, the free lock, branch protection (required
  check: `"check"`), and the local `926/0` gate were each re-read by command
  before use, not copied from the dispatch brief.
- **No refactor pass ran** (`kai-fischer` not dispatched) — this range is
  five already-PR-gated prompt/doc commits with no production code touched;
  nothing on his surface to simplify.
- **`zofia-kaminska` was not re-dispatched** for finding 4 (rule 10's
  enforceability) — her v1.28.3 verdict was obtained on the identical rule
  text and an identical pattern of self-certified, unfixtured recurrences;
  only the count changed (2 → 8), which does not change her stated verdict.
  Re-asking the same question of the same rule against the same facts would
  not have produced new information.
- **§7's v1.28.3 baseline was re-measured in a throwaway detached worktree at
  that tag**, not copied from `docs/release_notes_v1.28.3.md`'s own §7 table.

## 9. CI run this release was gated on

*(pending — filled in after the release PR merges to `main`; rule 15a
requires CI green on the exact SHA being tagged, which does not exist until
after merge. Interim: the release branch's own push-triggered run is quoted
below, and transcribed with the merge-SHA run before the tag is cut.)*

## 10. Trend since v1.28.3

Every row is the output of a command run this session, at both commits.

| Measure | v1.28.3 | v1.28.4 | Direction |
|---|---|---|---|
| Gate assertions — `bash tests/check.sh` | `926 passed, 0 failed` | `926 passed, 0 failed` | **Unchanged** — no new check added or dropped this range. |
| Fixture verdicts — `bash evals/run.sh score` | 10 cases, 0 current (0%), 9 stale, 1 never-run | 10 cases, 0 current (0%), 9 stale, 1 never-run | **Unchanged** — already at the floor; this range's prompt edits (wei-lin, ziyan-chen, anya-petrov) add to the stale set but do not move the headline numbers. |
| Tracked text lines — `git diff --stat v1.28.3..HEAD -- '*.md' '*.sh' '*.py'` | — | 8 files, **112 added / 86 removed, net +26** | **Modest growth**, concentrated in `docs/lessons_ledger.md` (+14 rows) and `agents/anya-petrov.md`'s new section (paid for by trims to the same file, net −3 lines across `agents/`+`commands/`). |
| Board currency — `PATHWAY_FORWARD.md` | 13 VERIFIED, 22 RETIRED, 0 BROKEN, 0 blank | 13 VERIFIED, 22 RETIRED, 0 BROKEN, 0 blank | **Unchanged** — board untouched this range (empty diff). |
| CI green-on-first-try — `gh run list` since v1.28.3's tag push | — | 5 push runs (one per merged PR, #93–#97), 5/5 green on attempt 1, 0 reruns | **Unchanged in substance** (100%, same as v1.28.3's own range). |

**Reading, plainly.** The gate holds exactly flat and fixture currency sits at
its already-established floor. Tracked-line growth is modest and
attributable to ledger rows and one agent's new section, paid for elsewhere
per rule 1b — not a leanness regression. The real deterioration this range is
not visible in any of the five measures above: §5 finding 4's unfixtured,
self-certified rule-10 recurrences **quadrupled** (2 → 8) with zero fixtures
landed against any of them, in either range. That is called out here in plain
language because none of the mechanical measures would otherwise surface it.

## 11. Work record

- **audit**: `victor-reyes`, self-handled without sub-dispatch (diff judged
  small enough: 8 files, 198 lines, one surface, no gate/physics logic
  touched). 10 consolidated findings — 0 Major, 4 Medium, 5 Low, 1 advisory,
  all §5.
- **correctness**: `bash tests/check.sh` → `926 passed, 0 failed` on the
  pristine pre-release tree; see §12 for the merged-SHA and tagged-SHA
  re-runs.
- **conciseness**: assessed inline, not independently verified by
  `kai-fischer` (see `refactor:` below). Net −3 tracked lines across
  `agents/`+`commands/`; `agents/anya-petrov.md`'s new section paid for by
  trims in Isolation/Tool-economy/publication-staging prose in the same file,
  per rule 1b.
- **fixes**: one applied (`docs/lessons_ledger.md` one-line clarity fix, §5
  finding 7, mechanical). Six findings deferred by owner (§5/§6): findings 1,
  6 to `zofia-kaminska`/human; findings 2, 3, 5, 8 to `lian-zhao`; finding 4
  carried forward at the same severity as v1.28.3, worse by count, to
  `iris-vermeulen`/`zofia-kaminska`/human — none invented.
- **docs**: reconciled against the filesystem, not the diff. Root walked
  against rule 1's whitelist; every count in §7 re-read off disk this session
  at both commits; `PATHWAY_FORWARD.md` confirmed untouched by direct diff,
  not assumed from the PR list.
- **refactor**: **`kai-fischer` did not run this release.** Five
  already-PR-gated prompt/doc commits with no production code in the diff —
  nothing on his surface.
- **rules**: **`zofia-kaminska` not dispatched this release** — see §8's
  assumption. Her v1.28.3 verdict on rule 10 (correctly tiered `judgment`,
  enforceable as written, the gap is a missing mechanical proxy check, not the
  rule's wording) is carried forward as still applicable to the same rule and
  the same pattern, now at 4x the volume (§5 finding 4, §10).

## 12. Release gate

*(pending — `bash tests/release_gate.sh release_notes_v1.28.4.md` will be run
against the merged, pre-tag tree and transcribed here before the tag is cut,
per rule 15a; rows `publish`/`release`/`clone` are expected to read SKIP at
that point since no tag exists yet, and will be re-transcribed once PASS
after the tag is created.)*
