# Release notes — v1.28.1 — 2026-10-03

## 1. Version and date

**v1.28.1**, cut 2026-10-03 from `main`, on top of `v1.28.0` (`e84f40e7`,
2026-10-02). Patch bump, per the maintainer's cadence rule: five merged PRs
(#74–#78) since the last tag, all prompt and doc lessons folded in from the
inbox-triage process — no new agent, no new command, no new rule beyond
cross-references and clarifications to existing ones.

## 2. Summary of scope

5 commits, 11 files changed, **+85 / −41** (tracked `.md` text only — no
`.sh`/`.py` touched this range).

| Theme | PR | What |
|---|---|---|
| v1.28.0 note completion | #74 | Filled the §9 (CI run) and §12 (release gate) sections of `release_notes_v1.28.0.md`, which shipped with "transcribed by the follow-up commit" placeholders — see §6 for the process gap this exposed |
| `haruto-nakamura` release process | #75 | Step 11 now says to squash-merge the release PR and re-read CI on the resulting SHA, since a squash commit is a new SHA the PR's own pre-merge run never tested |
| `/release`, `/enforce-rules` dispatcher-message scope | #75, #77 | A mid-run message from the dispatching session amends the brief; it cannot widen permissions |
| Inbox lessons — `wei-lin`/`/autopilot` | #76, #78 | Pre-flight decisions batched into one question with defaults; MEASURED vs. VERIFIED distinguished for a re-run of the same script; a conductor armed for a session-limit reset time instead of idling; a turn never ends with the conductor's own wait pending; owner relays now cite a board commit |
| Inbox lessons — `mira-volkov`, `victor-reyes`, `zofia-kaminska` | #76 | "Precision noise" banned as a verdict after a bit-identical checkpoint; a plan compared against an existing run gets a no-solve input-equivalence check; a rules audit now checks that a rule's named files/runs/commands are still canonical, not just present |
| `PROJECT_RULES.md` rule 1b ceiling | #76–#78 | Ceiling lowered 5762 → 5755, tracking the net shrink in `agents/`+`commands/` |
| `docs/lessons_ledger.md` | #76–#78 | +21 lines, 18 new rows (16 landed, 1 covered-by-existing-fix, 1 dismissed, plus one noted-positive) |

## 3. Files added / removed / renamed / cleaned up

- **Renamed**: `release_notes_v1.28.0.md` → `docs/release_notes_v1.28.0.md`
  (`git mv`, rule 8 — archived, never deleted).
- **Added**: this note, at the repo root, as the only root release note.
- No other file added to or removed from the repo root; root still holds
  exactly rule 1's whitelist (`git ls-files` at repo root cross-checked by
  hand against the table in `PROJECT_RULES.md` §1 — Check 31 confirms the
  same mechanically).
- No new agent, command, rule, check, or eval case landed in this range.

## 4. Content updates to master documents

- **`PROJECT_RULES.md`** 1,003 lines, unchanged in rule count (39 rule
  numbers / 47 index rows including sub-rules and retired placeholders — see
  §7). Only line changed: rule 1b's `Ceiling: 5762` → `Ceiling: 5755`,
  tracking the net shrink below.
- **`PATHWAY_FORWARD.md`** — **untouched this range** (`git diff
  v1.28.0..HEAD -- PATHWAY_FORWARD.md` is empty). All 14 live rows were last
  re-run 2026-09-19; today is 14 days later, which is the edge of PF-003/
  PF-006/PF-021/PF-023/PF-024's interval but not yet overdue — `bash
  tests/check.sh` confirms no row reads red for staleness.
- **`agents/haruto-nakamura.md`**, **`agents/mira-volkov.md`**,
  **`agents/victor-reyes.md`**, **`agents/zofia-kaminska.md`**,
  **`commands/autopilot.md`**, **`commands/enforce-rules.md`**,
  **`commands/release.md`** — each a small, targeted prompt edit (see §2);
  net effect on the shipped-prompt line count is `agents/`+`commands/`:
  5,762 → 5,755 lines (ceiling lowered to match, rule 1b).
- **`docs/lessons_ledger.md`** 269 → 290 lines (+21), 18 new dated rows, all
  aliased (`self`, `P05`, `P09`, `P10`, `P12`, `P13`, `P15`, `P16`, `P18`) —
  no project name in any row (checked by hand against every added line).

## 5. Audit findings and fixes

**Dispatched `victor-reyes`**, who judged the diff small enough (85 lines,
all prompt/doc text) to audit directly without sub-dispatching a specialist —
he ran the gate fresh himself (`917 passed, 0 failed`) rather than trusting
this agent's earlier run.

**12 findings, 0 Critical, 4 Major, 3 Medium, 4 Minor, 1 Advisory — all on
surfaces this release does not own.** Rule 19 gives `agents/*.md` and
`commands/*.md` prompt text to `lian-zhao`, and `tests/release_gate.sh` /
`tests/check.sh` comments to `iris-vermeulen`; none of the twelve is a
`tests/check.sh` check-logic defect (the gate itself stays green). **Fixes
applied this release: none** — every finding is recorded as an open issue
below, routed by owner, per Phase 2's instruction to never invent a fix for a
judgment call on someone else's surface.

**This pass's own verification, re-run fresh:**
- `bash tests/check.sh` on the pristine pre-release tree: `917 passed, 0
  failed`.
- Read every new `docs/lessons_ledger.md` row by hand: no project name,
  only `P0x`/`self` aliases and agent names.
- Confirmed `git diff v1.28.0..HEAD -- PATHWAY_FORWARD.md` is empty (no
  board change needed or made).
- Confirmed `agents/`+`commands/` = 5,755 lines against the new ceiling via
  `cat agents/*.md commands/*.md | wc -l` and `bash tests/check.sh`'s own
  Check 37 output.

## 6. Remaining open issues or pending items

All twelve are `victor-reyes`'s findings; none fixed this release (see §5).

1. **(Major)** `agents/haruto-nakamura.md`'s squash-merge instruction
   (step 11, landed this range) rests on a stated premise that is still not
   quite complete: it names the squash commit as "a new SHA," correctly, but
   doesn't say the PR's own pre-merge CI run therefore never tested the SHA
   that gets tagged — step 11 already requires a second CI read on the
   merged SHA, so the behaviour is right, only the stated reasoning is thin.
   Owner: `lian-zhao`.
2. **(Major)** `commands/autopilot.md` says the invoking session "writes
   nothing to the repo" and in the same breath requires owner decisions
   "committed verbatim to the board first" — without saying who makes that
   commit, and the board is `zofia-kaminska`'s surface under rule 19 with no
   carve-out for an invoking session. Owner: `lian-zhao` (prompt text);
   possibly a rule-19 carve-out, `zofia-kaminska`'s call.
3. **(Major)** `agents/wei-lin.md`'s new MEASURED-vs-VERIFIED distinction
   ("a re-run of the same script is MEASURED; VERIFIED needs an independent
   oracle") conflicts with rule 21's definition of VERIFIED ("cites a command
   that ran") and with every VERIFIED row on this project's own board, each
   closed by re-running its own command — and `tests/check.sh` Check 12 has
   no MEASURED state to parse. Owner: `lian-zhao`, or `zofia-kaminska` if
   rule 21 itself should change.
4. **(Major)** Rule 10 ("every agent-behaviour bug gets an eval fixture
   before the fix ships") is unmet by this very range: roughly 15
   `docs/lessons_ledger.md` rows mark real-deployment behaviour fixes
   "landed" (P10, P12, P13, P15, P16, P18) with no new fixture under
   `evals/`. Rule 10 says this debt "lands before the next version tag" —
   that tag is this one. Owner: `iris-vermeulen`.
5. **(Medium)** `release_notes_v1.28.0.md` shipped at tag time with
   "transcribed by the follow-up commit" placeholder text in §9 and §12,
   filled in by a later commit (PR #74) after the tag already existed. The
   fill-in only added evidence and changed no claim, so this is not a rule-8
   rewrite — but the tagged commit's note and the current root note now
   permanently differ with nothing recording that, and
   `agents/haruto-nakamura.md` has no step describing this two-commit
   pattern, which this very release repeats (§9/§12 below). Owner:
   `lian-zhao` (the process is `haruto-nakamura`'s prompt text, which she
   owns).
6. **(Medium)** Three different standards exist for accepting a mid-run
   message from a dispatcher: `/release` accepts any message; `/enforce-rules`
   and `wei-lin`'s own §4 require a cited board commit; `wei-lin`'s specialist-
   brief template requires no citation at all. Two gaps besides: seed mode has
   no board yet to cite, and a resource-safety order's status is unstated.
   Owner: `lian-zhao`.
7. **(Medium)** `commands/autopilot.md` says every verb the owner wrote,
   "including release," is committed scope, while two other lines in the same
   file say "make no default-branch merges" absent a stated policy and "never
   a major bump" — no precedence given between them. Owner: `lian-zhao`.
8. **(Minor)** `agents/wei-lin.md`'s tag condition weakened from "a main
   commit whose own CI run passed" to "CI and the gate **ran** on the tag's
   own SHA" — effect limited since `haruto-nakamura`'s step 11 still requires
   green. Owner: `lian-zhao`.
9. **(Minor)** `agents/wei-lin.md` says tagging goes through "haruto's
   checklist" including "a session log exists," but no such check exists in
   `agents/haruto-nakamura.md` (grepped, no match). Owner: `lian-zhao`.
10. **(Minor)** `agents/mira-volkov.md` dropped the qualifier "for
    deterministic, readable reference code" from its bit-identical-porting
    guidance, so "bit-identical is achievable" now reads unconditional, which
    is false for a non-deterministic reference (e.g. MPI reductions). Owner:
    `lian-zhao`.
11. **(Minor)** `commands/enforce-rules.md`'s new lesson ("a message citing a
    board commit amends the brief") has no matching text in
    `agents/zofia-kaminska.md` itself, so a direct `Agent` dispatch of her
    never sees it — contrary to rule 0's "the discipline goes in the agent
    first." Owner: `lian-zhao`.
12. **(Advisory)** `agents/wei-lin.md` dropped a line about the session log
    being project-gitignored "if preferred — ask once at Phase 0," with
    nothing stating whether the removal was intentional. Owner: `lian-zhao`.

**Carried from v1.28.0, still open** (not re-audited this pass, no new
evidence either way): §6.6 (no rule-19 ownership row for
`docs/maintainer.md`, `docs/user/*.md`, `docs/lessons_ledger.md`); §6.8
(fixture verdict currency) — see §10, unchanged at 20% this range, not
worsened but not repaired either.

## 7. Totals or cost changes

| Measure | v1.28.0 | v1.28.1 |
|---|---|---|
| Tracked lines (`git ls-files \| xargs wc -l`) | 20,788 | 20,832 |
| `evals/` lines | 4,585 | 4,585 |
| `tests/check.sh` lines | 1,409 | 1,409 |
| `PROJECT_RULES.md` lines | 1,003 | 1,003 |
| `agents/`+`commands/` lines (rule 1b) | 5,762 (ceiling 5,762) | 5,755 (ceiling 5,755) |
| Live checks | 32 | 32 |
| Eval cases | 10 | 10 |
| Agents / commands | 23 / 20 | 23 / 20 |
| Rule-book index rows (incl. sub-rules, retired) | 47 | 47 |
| Board rows VERIFIED / RETIRED (of 35 total) | 14 / 21 | 14 / 21 |

(Both columns measured fresh this session — v1.28.0 in a throwaway clone at
that tag, v1.28.1 on the release branch before this note was added — using
one consistent command per row, not copied from either note.)

## 8. Assumptions used

- **The brief's state was re-verified, not taken.** `main`'s tip
  (`c1a846f`), the five-PR/five-commit range, the 917/0 local gate, the free
  lock, and branch protection (`required check: "check"`, `enforce_admins:
  true`, no force-push/deletion) were each re-read by command before use.
- **§7's v1.28.0 baseline was measured in a throwaway full clone at that
  tag**, not copied from `docs/release_notes_v1.28.0.md`'s own §7 table (whose
  "tracked lines" figure, 20,487, used a different accounting than this
  note's 20,788 — not reconciled, re-measured with one stated method instead,
  same resolution v1.28.0 applied to its own v1.27.0 comparison).
- **No refactor pass ran** (`kai-fischer` not dispatched) — this range is
  five already-PR-gated prompt/doc commits with no production code touched;
  nothing on his surface to simplify.
- **No dedicated rules audit ran** (`zofia-kaminska` not dispatched) — this
  agent cross-checked `PROJECT_RULES.md` and `PATHWAY_FORWARD.md` directly
  (full read) for internal consistency against the diff and found nothing
  broken by it, which is not a substitute for her tier-split/violation
  verdict.

## 9. CI run this release was gated on

PENDING — this release follows the same two-commit pattern §6.5 flags as a
process gap: the tag can only be created after CI is read green on the
post-squash-merge SHA, which does not exist until after this note is first
committed and merged. This section is completed in a follow-up commit once
that SHA's CI run is confirmed, before the tag is created, matching
`v1.27.0`/`v1.28.0` precedent — recorded here rather than silently, per rule
2, as an explicit forward reference rather than an invented fact.

## 10. Trend since v1.28.0

Every row is the output of a command run this session, at both commits.

| Measure | v1.28.0 | v1.28.1 | Direction |
|---|---|---|---|
| Gate assertions — `bash tests/check.sh` | `917 passed, 0 failed` | `917 passed, 0 failed` | **Unchanged.** No new check, no new failure. |
| Fixture verdicts — `bash evals/run.sh list` / `score` | 10 cases, 2 current (20%), 7 stale, 1 never-run, 0 unknown | identical: 10 cases, 2 current (20%), 7 stale, 1 never-run, 0 unknown | **Unchanged.** This range commissioned no new dispatch to refresh a verdict; four of the five edited agents (`haruto`, `mira`, `victor`, `zofia`) were already stale before this diff landed. |
| Tracked text lines — `git diff --stat v1.28.0..HEAD -- '*.md' '*.sh' '*.py'` | — | 11 files, **85 added / 41 removed, net +44** | **Modest growth**, almost entirely `docs/lessons_ledger.md` rows documenting already-landed fixes, not duplication — a much smaller delta than v1.28.0's own net +898. |
| Board currency — `PATHWAY_FORWARD.md` | 14 VERIFIED, 0 BROKEN, 0 blank | identical, byte-for-byte (`git diff` empty) | **Unchanged**, untouched this range. |
| CI green-on-first-try — `gh run list` since v1.28.0's tag push | — | 45 runs, 2 failures, 0 reruns (attempt=1 throughout) | **Unchanged in substance.** The 2 failures are the already-documented `v1.28.0` tag-boundary pair (pre-rebase PR branch, §9 of that note) — excluding them, 43 of 43 first-try green, matching the 100% rate v1.28.0 itself reported. |

**Reading, plainly.** Unlike v1.28.0, this release has nothing to report as
deterioration: the gate held exactly flat, the board was untouched, tracked
lines grew only modestly and the growth is ledger rows, not duplication, and
CI stayed at 100% first-try excluding a pre-existing boundary artifact.
Fixture verdict currency did not improve — it also did not fall, because this
range made no agent-behaviour change to `evals/`-covered surfaces that a
fresh dispatch would need to re-grade; §6's carried item (v1.28.0 §6.8) stays
open on the same terms.

## 11. Work record

- **audit**: `victor-reyes`, self-handled without sub-dispatch (diff judged
  too small to need a specialist). 12 findings — 0 Critical, 4 Major, 3
  Medium, 4 Minor, 1 Advisory, all §6.
- **correctness**: `bash tests/check.sh` → `917 passed, 0 failed`, run on the
  pristine pre-release tree; to be re-run on the merged commit before tagging
  (§12).
- **conciseness**: assessed inline, not independently verified by
  `kai-fischer` (see `refactor:` below). Net +44 tracked lines, almost
  entirely new ledger rows; no duplication found.
- **fixes**: **none applied.** All 12 findings sit on `lian-zhao`'s
  (`agents/*.md`, `commands/*.md`) or `iris-vermeulen`'s (`evals/` fixture
  coverage) surfaces under rule 19, recorded as open issues (§6), routed by
  owner, not invented fixes.
- **docs**: reconciled against the filesystem, not the diff. Root walked
  against rule 1's whitelist; `PATHWAY_FORWARD.md` confirmed untouched and
  within interval; every count in §7 re-read off disk this session.
- **refactor**: **`kai-fischer` did not run this release.** Five
  already-PR-gated prompt/doc commits with no production code in the diff —
  nothing on his surface.
- **rules**: **`zofia-kaminska` did not run a fresh Mode B pass for this
  cut.** This agent verified mechanically: 39 rule numbers / 47 index rows
  unchanged, no renumbering, one value changed (rule 1b's ceiling, tracking
  the measured shrink). No tier-split, violation list, or
  unenforceable-rule verdict was produced, because no dedicated rules audit
  ran.

## 12. Release gate

PENDING — completed in the same follow-up commit as §9, after
`bash tests/release_gate.sh release_notes_v1.28.1.md` is run at the tag. Not
fabricated here; see §9 for why.
