# Release notes — v1.28.3 — 2026-10-05

## 1. Version and date

**v1.28.3**, cut 2026-10-05 from `main`, on top of `v1.28.2`
(`18988abd767312162d3e74b9b0b04fe0f8e2098a`, 2026-10-04). Patch bump: five
merged PRs (#86–#90) since the last tag, all prompt/doc/ledger lessons folded
in from the inbox-triage process — no new agent, no new command, one rule
amended (rule 10, relaxed).

## 2. Summary of scope

5 commits, 13 files changed, **+153 / −100** (tracked `.md`/`.sh`/`.py` text,
`git diff --stat v1.28.2..HEAD`).

| Theme | PR | What |
|---|---|---|
| v1.28.2 note completion | #86 | Transcribed the actual CI-run IDs and release-gate rows into `release_notes_v1.28.2.md` §9/§12, which shipped at tag time with pending placeholders |
| Rule 10 relaxed | #87 | Fixtures are owed only for a failure that recurs after its fix lands, not for every agent-behaviour bug; retires PF-003 (hand-dispatched fixture coverage), existing fixtures kept for spot checks |
| Inbox lessons, net −1 | #88 | `mira-volkov`/`priya-nair`/`lars-eriksson` now check every production acceptance check, not just one; `wei-lin`'s merge report quotes run id + conclusion and strips machine-local paths; `zofia-kaminska`'s starter set proposes host-side merge protection to the owner as a day-one decision |
| Inbox lessons, net −3 | #89 | Six sharpened lines (`priya-nair`, `lars-eriksson`, `kai-fischer`, `haruto-nakamura`, `zofia-kaminska`, `wei-lin`, `/autopilot`): claim-population checks, doc compression measured at wrap width, absent CI is a finding not a pass, a fast lane for docs-only PRs; three lessons dismissed as already covered |
| Inbox lessons, net −4 | #90 | `wei-lin` checks repo visibility before the first push and keeps private work lines out of commits/PRs/branches; a board number names its result file, mtime and code SHA; exploratory runs launch under a wall-clock timeout; `/autopilot`'s owner-decision relay stages only its own hunk; `zofia-kaminska` judges a rule present by what it requires, not its heading |

## 3. Files added / removed / renamed / cleaned up

- **Renamed**: `release_notes_v1.28.2.md` → `docs/release_notes_v1.28.2.md`
  (`git mv`, rule 8 — archived, never deleted).
- **Added**: this note, at the repo root, as the only root release note.
- No other file added to or removed from the repo root; root still holds
  exactly rule 1's whitelist (Check 31 confirms mechanically).
- No new agent, command, rule, check, or eval case landed in this range.

## 4. Content updates to master documents

- **`PROJECT_RULES.md`** — 1,005 lines (was 1,003 at v1.28.2), 47 index rows
  unchanged, no renumbering. Rule 10's text and index description changed
  (PR #87): "every agent-behaviour bug gets a fixture before the fix ships" →
  "a fixture only for a failure that recurs after its fix."
- **`PATHWAY_FORWARD.md`** — PF-003 flipped **BROKEN → RETIRED** (2b93b07,
  ground (c): the owner relaxed rule 10, so hand-dispatched fixture coverage
  is no longer a goal). Board total: 13 VERIFIED, 22 RETIRED, 0 BROKEN, 0
  blank (of 35 rows), against 13/21/1/0 at v1.28.2 — see §10. No blank
  `last-checked` date found on any live row.
- **`agents/*.md` (8 files: `haruto-nakamura`, `kai-fischer`, `lars-eriksson`,
  `mira-volkov`, `priya-nair`, `wei-lin`, `zofia-kaminska`), `commands/autopilot.md`**
  — targeted sharpenings from PRs #88–#90 (table in §2); each addition paid
  for by cutting a restatement in the same file, per rule 1b. Net effect on
  the shipped-prompt line count: `agents/`+`commands/` 5,750 → 5,746 lines
  (ceiling unchanged at 5,754, 8 lines of headroom; Check 37 passes).
- **`docs/lessons_ledger.md`** — 305 → 322 lines (+17, 18 insertions net of
  one formatting line), 18 new dated rows (10-04 ×12, 10-05 ×6), aliased
  (`P05`, `P12`, `P15`, `P16`, `P18`, `P19`, `self`) — no project name, path,
  host, or person in any added row, checked by hand.
- **`docs/maintainer.md`** — one line fixed this release (§5, finding 2): the
  stale "New behaviours land with new eval cases" sentence, left behind when
  PR #87 amended rule 10 without moving this doc (rule 11), now reads "A
  fixture is owed only when a failure recurs after its fix (rule 10, relaxed
  2026-10-04) — not for every new behaviour."

## 5. Audit findings and fixes

**Dispatched `victor-reyes`** for the deep pass (self-handled, no
sub-dispatch — 13 files, 578 diff lines, all prompt/doc text, nothing under
`tests/` or `evals/` changed). **Dispatched `zofia-kaminska`** for a rules
verdict on the one Major finding below, since it concerns `PROJECT_RULES.md`
rule 10 and is her surface under rule 19.

**8 consolidated findings — 1 Major, 1 Medium, 3 Low, 3 advisory.**

1. **(Major, `victor-reyes`, confirmed as a violation by `zofia-kaminska`.)**
   Rule 10, rewritten this range (2b93b07, PR #87) to require a fixture only
   when a failure *recurs* after its fix, is already broken by two later
   commits in the same range: `docs/lessons_ledger.md:317` (`92a5eb5`, PR
   #89 — explicitly "recurrence of the 10-03 row") and `:320` (`b7bef3f`,
   PR #90 — explicitly "recurrence of the 10-01 P05 row") each self-certify
   as repeats and each mark the fix "fixture-eligible under rule 10,
   deferred to the owner." `git diff --stat v1.28.2..HEAD -- evals/` is
   empty — neither fixture landed. **`zofia-kaminska`'s verdict, dispatched
   for this finding:** rule 10's text (`PROJECT_RULES.md:303-308`) has no
   "deferred to owner" carve-out — "on a repeat report, fixture first or in
   the same commit" is unconditional, so these are two rule-10 violations,
   not two uses of a documented exception. The rule itself is correctly
   tiered `judgment` (recurrence and minimality both need a reader) and
   does not need a rewrite; what is missing is a mechanical proxy check
   (ledger row says recurrence, but the same commit range touched no
   `evals/cases/` path) that nothing today runs. She routes the ship
   decision to `haruto-nakamura` (this agent) since these are live gaps in
   the release being cut, and the fixture-authoring itself to
   `iris-vermeulen` (judgment about what each fixture should assert, not
   mine to invent). **This agent's call:** not a release blocker —
   `tests/check.sh` has no check for this (a confirmed Tier-3 gap, per
   zofia), so the tag is not withheld over it, but it is flagged here at
   full severity, not softened, for the human to decide whether unfixtured
   "landed" claims should pause until the two fixtures catch up.
2. **(Medium, `victor-reyes` — fixed this release, mechanical, rule 11.)**
   `docs/maintainer.md:97` still said "New behaviours land with new eval
   cases," contradicting the amended rule 10. Fixed in this release (§4);
   this is a one-line doc-sync correction, not a judgment call, so applied
   directly rather than deferred.
3. **(Low, `victor-reyes` — not fixed, owner `iris-vermeulen`.)**
   `evals/run.sh:569-573`'s comment still reads "Rule 10 requires a fixture
   to land BEFORE the fix it guards" — stale relative to the amended rule.
   The script's behaviour is unaffected (the comment only explains why
   `score` isn't a gate); `evals/run.sh` is `iris-vermeulen`'s surface under
   rule 19, so not edited here. Owner: `iris-vermeulen`.
4. **(Low, `victor-reyes` — not fixed, owner `zofia-kaminska`.)**
   `PROJECT_RULES.md:306-308`'s rule 10 body cites "12 of 15 landed fixes in
   one range" with no range or command named — a rule-4 defect confirmed by
   `zofia-kaminska`: "a number with no range or command, so nobody can
   re-derive it." Her read: mechanical to fix (cite the actual commit range
   and the count command), not a rewording. `PROJECT_RULES.md` is her
   surface under rule 19; not edited here.
5. **(Low, `victor-reyes` — not actionable, historical.)** The archived
   `docs/release_notes_v1.28.2.md:511` cites "Rule treats deprecation
   warnings as findings" without naming the rule. Rule 8 forbids revising a
   shipped release note; recorded here as a known gap in that note, not
   fixed.
6. **(Advisory, `victor-reyes` — confirmed cleared, not a finding.)** Five
   "Never" lines removed from agent prompts in PRs #88–#90 (`kai-fischer`,
   `priya-nair` ×2, `lars-eriksson`, `mira-volkov` ×2, `wei-lin`) were each
   checked against the same file and remain covered elsewhere — not a
   silent capability loss.
7. **(Advisory, `victor-reyes`.)** `agents/zofia-kaminska.md`'s starter
   invariant 10 (seeded into other projects) still reads "regression test
   before the fix ships," which may be intentional (code tests, not prompt
   fixtures, are a different claim from rule 10) but the owner should
   confirm the wording is not meant to track rule 10's relaxation too.
   Owner: `lian-zhao`/human.
8. **(Advisory, `victor-reyes` — explained, not a defect.)** The gate read
   924 passed at the v1.28.2 tag and 923 on the pre-release tree just
   before this note was added (`tests/check.sh` unchanged byte-for-byte
   between the two commits — `git diff v1.28.2..HEAD -- tests/check.sh` is
   empty). Check 35 asserts one GitHub Release per existing tag, so its
   assertion count grows with the repo's tag history independent of any
   code change in this range; not a regression.

**Fixes applied this release:** one (finding 2, mechanical doc-sync).
**Deferred, by owner:** finding 1 (Major — `zofia-kaminska`/human, rule
10's enforceability against its own concurrent ledger entries), finding 3
(`iris-vermeulen`), finding 4 (`zofia-kaminska`/human), finding 7
(`lian-zhao`/human). Finding 5 is not fixable under rule 8.

**This pass's own verification, re-run fresh:**
- `bash tests/check.sh` on the pristine pre-release tree: `923 passed, 0
  failed`.
- `cat agents/*.md commands/*.md | wc -l` → `5746`, matching the measured
  count exactly, 8 lines under the 5,754 ceiling.
- Read every new `docs/lessons_ledger.md` row by hand: no project name,
  path, host, or person — only `P0x`/`P1x`/`self` aliases and agent names.
- `git diff v1.28.2..HEAD -- PATHWAY_FORWARD.md`: only the PF-003 state
  flip and its two prose blocks changed; no other row touched.

## 6. Remaining open issues or pending items

1. **(Major, open — confirmed violation, not withheld from the tag.)**
   Two of this range's own commits (`92a5eb5`, `b7bef3f`) violate the rule
   they were made under (rule 10) — see §5 finding 1. `zofia-kaminska`
   confirms rule 10 needs no rewrite, only a mechanical proxy check that
   does not exist today. Owner: `iris-vermeulen` (author the two fixtures;
   consider the proxy check). Human decision needed: pause further
   unfixtured "landed" claims, or accept the judgment-tier debt as-is.
2. **(Low, open.)** `evals/run.sh:569-573`'s stale comment — §5 finding 3.
   Owner: `iris-vermeulen`.
3. **(Low, open.)** Rule 10's uncited "12 of 15" figure — §5 finding 4.
   Owner: `zofia-kaminska`/human.
4. **(Advisory, open.)** `zofia-kaminska.md` starter invariant 10 wording
   — §5 finding 7. Owner: `lian-zhao`/human.
5. **(Carried from v1.28.2, unresolved.)** §6.1's debt — agent-behaviour
   fixes landing with no matching fixture — is now the subject of finding 1
   rather than a separate open item; it has not shrunk, only changed shape
   (fixture-first retired, repeat-only adopted, and the repeat case is
   itself now unfixtured).
6. **(Carried from v1.28.1/v1.28.2, not re-audited this pass.)** No
   rule-19 ownership row for `docs/maintainer.md`, `docs/user/*.md`,
   `docs/lessons_ledger.md` itself — no new evidence either way this range.
7. **(Carried from v1.28.2 §6.9, unresolved.)** CI (`.github/workflows/check.yml`)
   still prints the same two Node.js-20/Ubuntu-26 deprecation annotations on
   every run (confirmed again this release, §9) — rule treats deprecation
   warnings as findings, not noise. Owner: `iris-vermeulen`.

## 7. Totals or cost changes

Both columns measured fresh this session — v1.28.2 in a throwaway detached
worktree at that tag, v1.28.3 on the release branch before the tag was cut.

| Measure | v1.28.2 | v1.28.3 |
|---|---|---|
| Tracked lines (`git ls-files \| xargs wc -l`) | 21,138 | 21,443 |
| `evals/` lines | 4,585 | 4,585 |
| `tests/check.sh` lines | 1,409 | 1,409 |
| `PROJECT_RULES.md` lines | 1,003 | 1,005 |
| `agents/`+`commands/` lines (rule 1b) | 5,754 (ceiling 5,754) | 5,746 (ceiling 5,754) |
| Live checks | 32 | 32 |
| Eval cases | 10 | 10 |
| Agents / commands | 23 / 20 | 23 / 20 |
| Rule-book index rows (incl. sub-rules, retired) | 47 | 47 |
| Board rows VERIFIED / RETIRED / BROKEN (of 35 total) | 13 / 21 / 1 | 13 / 22 / 0 |

## 8. Assumptions used

- **The brief's state was re-verified, not taken.** `main`'s tip (`b7bef3f`),
  the five-PR/five-commit range, the free lock, branch protection (required
  check: `"check"`), and the local `923/0` gate were each re-read by command
  before use, not copied from the dispatch brief.
- **No refactor pass ran** (`kai-fischer` not dispatched) — this range is
  five already-PR-gated prompt/doc commits with no production code touched;
  nothing on his surface to simplify.
- **`zofia-kaminska` was dispatched narrowly**, for a rules verdict on the
  one Major finding (rule 10's enforceability), not a full Mode B audit of
  the rule book; her verdict is folded into §5 finding 1 and §11.
- **§7's v1.28.2 baseline was re-measured in a throwaway detached worktree
  at that tag**, not copied from `docs/release_notes_v1.28.2.md`'s own §7
  table.

## 9. CI run this release was gated on

PR #91 (`release/v1.28.3`) was green on both its triggers before merge: push
run `37406843301` and pull_request run `37406855658`, both **success** on
`f097dc6e7c3e0bc49a22022baa143e3a518fea5e` —
https://github.com/dunyuliu/consilium/actions/runs/37406855658.

Squash-merged to `main` as `369be909c0b8df22915c0b9179b277bd3502b809`. Run
**`37406905318`**, conclusion **success**, on that SHA —
https://github.com/dunyuliu/consilium/actions/runs/37406905318 — read and
confirmed green before the tag was created, per rule 15a. Both runs carried
the same two Node.js-20/Ubuntu-26 deprecation annotations as v1.28.2 (§5
finding 8 is unrelated to this; the deprecation itself is a carried, already
open `iris-vermeulen`-owned item, not new this release).

## 10. Trend since v1.28.2

Every row is the output of a command run this session, at both commits.

| Measure | v1.28.2 | v1.28.3 | Direction |
|---|---|---|---|
| Gate assertions — `bash tests/check.sh` | `924 passed, 0 failed` | `923 passed, 0 failed` (pre-note tree; see §5 finding 8 for the explained −1) | **Unchanged in substance** — the delta is Check 35 scaling with tag count, not a regression. |
| Fixture verdicts — `bash evals/run.sh score` | 10 cases, 0 current (0%), 9 stale, 1 never-run | 10 cases, 0 current (0%), 9 stale, 1 never-run | **Unchanged** — already at the floor from the prior range's fleet-wide prompt edit; this range's smaller, targeted edits did not move it further. |
| Tracked text lines — `git diff --stat v1.28.2..HEAD -- '*.md' '*.sh' '*.py'` | — | 13 files, **153 added / 100 removed, net +53** | **Modest growth**, mostly `docs/lessons_ledger.md` rows (+17) and rule 10's expanded body; 6 of 8 touched agent files shrank or held even per-file (rule 1b paid for each addition). |
| Board currency — `PATHWAY_FORWARD.md` | 13 VERIFIED, 21 RETIRED, 1 BROKEN, 0 blank | 13 VERIFIED, 22 RETIRED, 0 BROKEN, 0 blank | **Better** — the one BROKEN row (PF-003) resolved by retirement on an owner decision, not swept quietly; no row sits blank. |
| CI green-on-first-try — `gh run list` since v1.28.2's tag push | — | 5 push runs (one per merged PR, #86–#90), 5/5 green on attempt 1, 0 reruns | **Unchanged in substance** (100%, same as v1.28.2's own range). |

**Reading, plainly.** The gate holds green and fixture currency sits at its
already-established floor rather than falling further. Tracked-line growth
is modest and attributable to ledger rows and one rule's expanded body, not
duplication — 6 of 8 touched prompts shrank or held flat. The one real piece
of unfinished business is §5/§6 finding 1: the rule this range itself
rewrote is already contradicted by two of this range's own commits, and
that is not swept into the gate's green.

## 11. Work record

- **audit**: `victor-reyes`, self-handled without sub-dispatch (diff judged
  small enough: 13 files, 578 lines, one surface). 8 consolidated findings —
  1 Major, 1 Medium, 3 Low, 3 advisory, all §5. `zofia-kaminska` dispatched
  narrowly for the Major finding's rules verdict.
- **correctness**: `bash tests/check.sh` → `923 passed, 0 failed` on the
  pristine pre-release tree; see §12 for the merged-SHA and tagged-SHA
  re-runs.
- **conciseness**: assessed inline, not independently verified by
  `kai-fischer` (see `refactor:` below). Net +53 tracked lines, mostly ledger
  rows and rule-book prose; 6 of 8 touched agent prompts shrank per rule 1b's
  pay-for-it discipline.
- **fixes**: one applied (docs/maintainer.md one-line doc-sync, §5 finding
  2, mechanical). Four findings deferred by owner (§5/§6): Major finding 1 to
  `zofia-kaminska`/human, findings 3–4 to `iris-vermeulen`/`zofia-kaminska`,
  finding 7 to `lian-zhao`/human — none invented.
- **docs**: reconciled against the filesystem, not the diff. Root walked
  against rule 1's whitelist; every count in §7 re-read off disk this
  session at both commits; `docs/maintainer.md` brought back in line with
  the amended rule 10 (rule 11).
- **refactor**: **`kai-fischer` did not run this release.** Five
  already-PR-gated prompt/doc commits with no production code in the diff —
  nothing on his surface.
- **rules**: `zofia-kaminska` dispatched narrowly on §5 finding 1 only (rule
  10's enforceability against its own concurrent commits), not a full
  tier-split Mode B pass. Verdict: rule 10 is correctly tiered `judgment`
  and enforceable as written — no rewrite needed; the two ledger entries
  (`92a5eb5`, `b7bef3f`) are confirmed violations, not licensed exceptions,
  and the gap is the absence of a mechanical proxy check, not the rule's
  wording. The rule-4 citation defect (§5 finding 4) is mechanical to fix
  on her surface, not done here.

## 12. Release gate

[Filled at step 12, transcribed from `bash tests/release_gate.sh
release_notes_v1.28.3.md` at the tag.]

- tree: —
- ci: —
- publish: —
- release: —
- clone: —
