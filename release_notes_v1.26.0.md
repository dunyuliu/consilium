# Release notes — v1.26.0 — 2026-09-18

## Summary of scope

Fifteen commits since v1.25.0, three strands. First: the shipped product
(`agents/` + `commands/`) shrank for the first time this campaign — 5,677 to
5,508 tracked lines, net -169 — via four prompt-slimming passes by
`lian-zhao`, each done in an isolated worktree and reviewed and amended by
the conducting agent before landing: `wei-lin` 555→512 (`c387444`),
`haruto-nakamura` 414→385 (`e143558` — this agent's own prompt), `zofia-
kaminska` 526→501 (`2da8142`), `mira-volkov` 513→440 (`262749b`). Second: a
fresh-clone walk (`227bf9e`) found and fixed two real defects — README
claimed three git hooks where one exists, and `tests/check.sh` Check 35
resolved GitHub Releases through a non-GitHub origin, producing 28 false
FAILs in a plain clone on 2026-09-18 — plus (`acc6d63`) two root documents
still describing retired Check 17 as live. Third: the board (`b662eca`) went
19 VERIFIED / 16 RETIRED to 14 VERIFIED / 21 RETIRED — five rows retired on
ground (b), one repaired, one extended; 35 rows total, unchanged. No agent,
check, command, rule or root file was added or removed.

## Files added / removed / renamed / cleaned up

- `docs/release_notes_v1.25.0.md` — moved from the repo root (rule 8; never
  deleted).
- `release_notes_v1.26.0.md` — this file, new at the root.
- Nothing else added, removed or renamed. Verified against the filesystem:
  the repo root holds `README.md`, `PROJECT_RULES.md`, `PATHWAY_FORWARD.md`,
  `CLAUDE.md`, `LICENSE`, `install.sh`, this note, and the
  `agents/ commands/ docs/ evals/ tests/` directories — rule 1's whitelist —
  plus one untracked file, `resume_claude.sh`, present in the working tree
  but never `git add`ed and not part of this release's diff; flagged below,
  not touched.
- On disk at this tag: 22 agents, 19 commands, 32 live checks, 10 fixtures,
  35 board rows of which 14 are live.

## Content updates to master documents

- **`README.md`, `CLAUDE.md` (`227bf9e`, `acc6d63`)** — the hook count
  corrected (one `post-merge` hook, not three) rather than re-derived; the
  uncheckable front-door counts deleted outright since the two prior
  releases' attempts to correct them in place kept landing wrong in
  different directions. Both documents' remaining references to Check 17
  now consistently say "retired," matching `tests/check.sh`'s own header.
- **`tests/check.sh` Check 35 (`227bf9e`)** — added a guard: an origin URL
  not matching `*github.com*` skips the Release-half assertion per tag with
  a named reason instead of failing all of them, which is what a
  local-path-origin clone did on 2026-09-18 (28 false FAILs). The note leg
  of rule 15 still binds unconditionally.
- **`PATHWAY_FORWARD.md` (`b662eca`)** — sixth retirement pass. 19 VERIFIED
  → 14; 16 RETIRED → 21. Five rows retired, one repaired, one extended; 0
  blank `last-checked` dates before or after.
- **`agents/wei-lin.md`, `agents/haruto-nakamura.md`,
  `agents/zofia-kaminska.md`, `agents/mira-volkov.md`** — slimmed per
  above. Removal test applied by `lian-zhao`: would an agent reading the
  prompt without a passage act differently? What came out was incident
  narration and sections restating other sections of the same file.

## Audit findings and fixes

**Phase 1 audit ran; the milestone cycle's deep and refactor passes did
not, and that is a deviation this note owns, not a step that happened.**
The conducting agent (not this release-cutting pass) ran `zofia-kaminska`
(board, Mode B) and `sophia-okafor` (cross-file drift on all four slimmed
prompts at `b662eca`, no drift found) but skipped `victor-reyes` (technical
audit) and `kai-fischer` (refactor). Ground offered: this release's diff is
prompts, documentation, and a four-line guard in `tests/check.sh`, and
`kai-fischer`'s surface is existing production code, which has no diff
here. That ground covers `kai-fischer`; it does not cover skipping
`victor-reyes`, whose surface includes prompt and doc correctness and who
was the right router for exactly the contradiction found below. Recorded as
a deviation, not excused.

This release-cutting pass ran the audit `victor-reyes` should have run
before the cut, on the pristine tree at `b662eca`, read-only, plus this
agent's own `PROJECT_RULES.md` and evals checks. Four findings, **zero
applied** — every one falls outside this agent's write surface under rule
19's ownership table (`agents/*.md` is `lian-zhao`'s, `tests/check.sh` is
`iris-vermeulen`'s, `PROJECT_RULES.md` is `zofia-kaminska`'s), including the
one in this agent's own prompt file. Editing another surface to fix a
release-blocking-looking finding would itself be the violation; none of the
four is release-blocking (the gate is green, the contradiction is prose,
not code that runs).

| # | Sev | Where | Finding | Disposition |
|---|---|---|---|---|
| 1 | Major | `agents/haruto-nakamura.md:385` | Hard-rule footer reads "Commit first, CI second, tag last" immediately after restating rule 15a's own resolution of the ordering deadlock. Read as "create the tag last" it contradicts step 9 (tag created locally before either push); read as "push the tag last" it is correct and matches steps 10-12. Ambiguous, not wrong — needs a one-word disambiguation ("push the tag last"). | Deferred, routed to `lian-zhao` (owns `agents/*.md`, including this agent's own prompt) |
| 2 | Major | `agents/zofia-kaminska.md:383-385` | Tier-1 checklist still reads "that command still runs and still prints what the board records. Re-execute it; do not trust the recorded line" — rule 21a (amended 2026-09-17) explicitly dropped the byte-diffed `# →` line this instruction assumes exists; on this board there is nothing to re-derive against, so followed literally this would manufacture a false violation on every audit. | Deferred, routed to `lian-zhao` |
| 3 | Minor | `PROJECT_RULES.md:748-759` | Multi-surface README sentences say "any of them may take it" with no named precedence, the same two-writer shape rule 19 exists to prevent. | Deferred, routed to `zofia-kaminska` |
| 4 | Minor | `tests/check.sh:1314-1325` | Check 35's new guard matches origin URL by substring (`*github.com*`), so a path containing that substring but not actually hosted there (e.g. a local mirror named `.../github.com-mirror/...`) would be misread as GitHub; an empty `$origin_url` renders as "origin is not a GitHub remote ()" — loud but imprecise. Correct in the case that motivated it (2026-09-18's plain local-path clone); the edge case is theoretical here. | Deferred, routed to `iris-vermeulen` |

Two markdown lint items (missing blank line before an ATX heading,
`agents/mira-volkov.md:308-309` and `agents/wei-lin.md:77-78`) surfaced by
the same pass, cosmetic, routed to `lian-zhao` alongside findings 1-2 rather
than listed as separate rows.

What the audit confirmed, with evidence:

- No load-bearing content lost in the four slimmed prompts — every removed
  constraint traced to a surviving line elsewhere (mira's parity-first
  gate, stale-reference defense, same-commit feature tests; wei-lin's war
  stories mapping onto the gate axes and cardinal rules that remain).
- Hook and Check-17 drift: fully resolved, `README.md` and `CLAUDE.md` now
  match `install.sh` and `tests/check.sh`'s own header.
- Rule 19 vs. frontmatter: the three README ownership rows match the
  isolation bullets in the three agents' own prompts; no unscoped writer.
- No placeholder, TODO, TBD, or half-finished edit anywhere in the diff.
- `bash tests/check.sh` → 806 passed, 0 failed, confirmed independently by
  both this pass and the audit dispatch.

## Remaining open issues

- Findings 1-4 above, routed to their surface owners per rule 19; none is
  release-blocking.
- **The four prompt edits are fixture-ungated, by rule.** Rule 13 (every
  agent needs a fixture) was retired 2026-09-17; three of the four slimmed
  agents (`wei-lin`, `zofia-kaminska`, `mira-volkov`) have no eval case at
  all, and the fourth (`haruto-nakamura`) has two, both now STALE against
  today's prompt SHA and un-regradable without a human pasting the staged
  prompt into a live session. What ran instead was `lian-zhao` inspecting
  every criterion against the slimmed prompt and `sophia-okafor` auditing
  all four diffs for cross-file drift, finding none. That is inspection,
  not measurement, and this note does not claim otherwise.
- **This agent's own prompt, `agents/haruto-nakamura.md`, is in this
  release's diff** (`e143558`), and finding 1 above is inside it. This
  release-cutting pass read and executed from the post-slim version and
  found no other defect in the workflow it followed step-by-step.
- `resume_claude.sh` sits untracked at the repo root, outside rule 1's
  whitelist. Not part of this release's diff (never staged, never
  committed); flagged and left alone.
- `PROJECT_RULES.md:748-759`'s multi-surface README ambiguity (finding 3)
  is the same shape as v1.25.0's now-resolved rule-19 dispute; routing it
  to `zofia-kaminska` now is cheaper than waiting for a second incident to
  force it.

## Totals or cost changes

- Gate assertions: 806 passed, 0 failed — up from 800 at v1.25.0; the six
  extra are Check 35's per-tag Release assertions, which grow by one per
  release, not a new invariant.
- Board: 19 VERIFIED / 16 RETIRED → 14 VERIFIED / 21 RETIRED; 35 rows total,
  unchanged; 0 P1, 3 P2, 11 P3 across the 14 live rows; 0 blank
  `last-checked` dates, unchanged.
- Tracked text (`*.md *.sh *.py`, v1.25.0..HEAD): 377 added / 419 removed,
  **net -42**. Narrower to the shipped product (`agents/` + `commands/`
  only): 120 added / 289 removed, **net -169** (5,677 → 5,508 lines).
- Rules: 28, unchanged in number and tier; no rule added, retired, or
  reworded this release.

## Assumptions used

- The maintainer's grant of merge and tag authority on `main`, minor and
  patch only, no major bump, no force-update or rewrite of an existing tag,
  nothing outward-facing beyond this repo, is taken from this cut's
  dispatch instruction and not re-verified beyond it.
- `sophia-okafor`'s cross-file drift finding ("none") on the four slimmed
  prompts at `b662eca` is taken on the conducting agent's report, not
  re-run by this pass; `victor-reyes`'s audit dispatched by this pass
  independently checked the same four prompts for internal coherence and
  load-bearing-content loss and reached the same "no loss" conclusion by a
  different method, which is corroboration, not a re-run of her exact pass.
- `git diff --stat` line counts use `*.md *.sh *.py` as the tracked-text
  extension set, matching v1.25.0's note; no `*.py` files exist in this
  diff.
- The v9.9.9 note in `docs/` remains the deleted-tag incident's artifact,
  not a version; highest real predecessor is v1.25.0, so this is v1.26.0.
- **`release minor` over a smaller-diff cadence.** Nothing in this diff is
  a new user-visible feature in the traditional sense — it is prose
  correction, prompt trimming, and a board update. The instruction was
  explicit ("Cut v1.26.0 — a minor release") and the grant covers minor;
  taken as given rather than second-guessed, since the alternative (a
  patch) would require overriding an explicit version number, which this
  agent is not authorized to do.

## CI

**The run this release is gated on:** run `35400999575`,
https://github.com/dunyuliu/consilium/actions/runs/35400999575, conclusion
`success`, workflow `structural-invariants`, SHA
`b662eca0e1e330e2d06604fac20cb21c278abcfc` — already green on the exact
pre-release-commit HEAD before this note or the tag existed, run on push.

## Trend since v1.25.0

Report, not gate. A dedicated leanness pass on the rest of the repo (rules,
board prose, tests) remains deferred by the maintainer — this release's own
-169-line product shrink is the exception, not evidence the deferral is
over.

| Measure | v1.25.0 | v1.26.0 | Direction |
|---|---|---|---|
| Gate assertions (`bash tests/check.sh`, both run today, both at the tagged commit) | 800 passed, 0 failed | 806 passed, 0 failed | Unchanged in substance (+6 are per-tag Release assertions) |
| Fixture verdicts (`bash evals/run.sh list` / `score`) | 4/10 current (40%) | 3/10 current (30%) | Worse — and expected to read worse than this by the next audit, since four of the ten graded prompts changed today |
| Tracked text lines (`git diff --stat v1.25.0..HEAD -- '*.md' '*.sh' '*.py'`) | — | 377 added / 419 removed, net -42 | Better — first net-negative stretch this campaign; narrower to the shipped product alone, net -169 |
| Board currency (`PATHWAY_FORWARD.md`) | 19 VERIFIED, 16 RETIRED, 0 blank dates | 14 VERIFIED, 21 RETIRED, 0 blank dates | Mixed — five more rows closed by retirement, not by work; still zero rot (no blank dates, no BROKEN) |
| CI green on first try (`gh run list` since v1.25.0's tag push) | — | 14 of 14 pushes green with no re-run | Unchanged (was 6 of 6 at v1.25.0) |

Reading, plainly: this is the first release since v1.20.0 where the shipped
product got smaller, and it is real — `lian-zhao`'s four prompt cuts survive
both `sophia-okafor`'s drift audit and this release's own `victor-reyes`
audit with no load-bearing loss found. But the number this note is
obligated to report worse is fixture trustworthiness: 30%, down from 40%,
and the four prompts that just got smaller are exactly the ones whose
fixtures are now stalest or nonexistent. A campaign that reversed a
1,300-line growth trend by removing prose is not the same achievement as one
that proved the removal safe by running something — inspection filled that
gap this time, and the gap is now on the record twice (this note and the
open issues section), not closed.

## Work record

- audit: this release-cutting pass ran `victor-reyes` (routed, read-only,
  pristine tree at `b662eca`) — 4 findings (2 Major, 2 Minor) plus two
  cosmetic lint items; plus this agent's own `PROJECT_RULES.md`/evals pass,
  which added no further findings. The conducting agent's prior audit
  (`zofia-kaminska` + `sophia-okafor`, both reported "no violation"/"no
  drift") is recorded above but was not re-run by this pass beyond
  corroborating it.
- correctness: `bash tests/check.sh` → 806 passed, 0 failed, both at the
  pristine `b662eca` and again on the release commit before the push.
  `victor-reyes` traced the Check 35 guard's logic and found it loud and
  non-silent in substance, with the substring-match edge case at finding 4.
- conciseness: not independently re-verified by `kai-fischer` this
  release — see deviation above. `victor-reyes`'s audit is the only pass
  that assessed the four slimmed prompts' internal coherence, and its
  verdict is "no load-bearing loss, no leftover contradiction beyond
  finding 1."
- fixes: none applied. All four findings deferred to their rule-19 owners
  (`lian-zhao` ×3 incl. two lint items, `zofia-kaminska` ×1,
  `iris-vermeulen` ×1); none is release-blocking.
- docs: reconciled against the filesystem, not the diff — root whitelist
  read with `ls` and matched against rule 1's table (plus the untracked
  `resume_claude.sh`, flagged); agent/command/check/fixture/board counts
  read off disk (22/19/32/10/35 rows, 14 live) and checked against this
  note's own claims.
- refactor: **`kai-fischer` did not run this release** — deviation, ground
  stated above (no production-code diff in this release; his surface is
  existing production code, not prompts/docs/tests). Not a "nothing needed"
  verdict from him; a step that did not happen.
- rules: `zofia-kaminska` did not run a fresh pass for this specific cut
  beyond the prior board work already in the diff; her rule-19 ownership
  table is what routed all four findings above, and this pass verified the
  table itself (surface-by-surface) rather than re-auditing the full rule
  book. No rule added, retired, or found unenforceable this release.

## Release gate

`bash tests/release_gate.sh release_notes_v1.26.0.md`, run with HEAD at the
tagged commit and the remote in agreement.

- tree: (transcribed below, verbatim)
- ci: (transcribed below, verbatim)
- publish: (transcribed below, verbatim)
- release: (transcribed below, verbatim)
- clone: (transcribed below, verbatim)
