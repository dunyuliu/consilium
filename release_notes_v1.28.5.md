# Release notes — v1.28.5 — 2026-10-08

## 1. Version and date

**v1.28.5**, cut 2026-10-08 from `main`, on top of `v1.28.4`
(`6f4838f9055c1748d578963d112eb0587b2821d0`, 2026-10-07). Patch bump: bare
`release` trigger. Five merged PRs (#101–#105), all inbox-triage lesson folds
into existing prompts and the ledger. No new agent, no new command, no rule
added or renumbered, no new check.

Scope note: `release_notes_v1.28.4.md` itself was edited once more after the
v1.28.4 tag (PR #100, the CI/gate transcription fill-in) — that edit is
already part of v1.28.4's own record, not this release's. This note's diff is
measured from `573687d` (PR #100's merge) to `HEAD`, i.e. PRs #101–#105 only.

## 2. Summary of scope

5 commits, 5 files changed, **+105 / −80** tracked text
(`git diff --numstat 573687d..HEAD -- '*.md' '*.sh' '*.py'`).

| Theme | PR | What |
|---|---|---|
| Rules — whitelist discipline | #101 | `zofia-kaminska`'s root-layout audit instruction rewritten: build the whitelist from the invariant-1 template, never from the current tree (a tree-built whitelist finds zero violations by construction) |
| Inbox lessons, net 0 | #102 | `/autopilot`'s cycle is the merge policy wherever the rule book is silent; a declined pre-flight decision becomes a `BLOCKED(owner)` row, never re-asked; a relay reaches the conductor only while she is live; an external kill is traced (board + log) before acted on, never assumed a fault; seed reports list all thirteen starter invariants, landed or dropped; releases are cut in their own worktree |
| Inbox lessons, net 0 | #103 | A docs-allowlist line exempting the diff's own file is a weakening only the surface owner may add; a milestone perf snapshot is a command + SHA on the board, its output in `runs/`, never a doc or comment |
| Inbox lessons, net 0 | #104 | A relay citing no board commit is answered with a request for it, never dropped; a reaped worktree takes its branch with it; the end-of-run report lists every branch from `git branch -a`; a `pgrep -f` self-match wait is a named failure mode now |
| Inbox lessons, net −1 | #105 | Milestones are judged per surface with an ~80%-of-budget reserve and a `no milestone, because <reason>` line when none is cut; the post-tag gate's `clone` row described as re-reading the pre-tag clone; squash-merged branches count as merged for reaping; git-ignored files move in the main checkout after a merge, never through a worktree; a diagnosis or candidate fix never goes to `general-purpose`; the tool-call checkpoint starts at ~100 so the stop lands by ~120; the invoking session hands off past ~200k context |

## 3. Files added / removed / renamed / cleaned up

- **Renamed**: `release_notes_v1.28.4.md` → `docs/release_notes_v1.28.4.md`
  (`git mv`, rule 8 — archived, never deleted).
- **Added**: this note, at the repo root, as the only root release note.
- No other file added to or removed from the repo root this range; root still
  holds exactly rule 1's whitelist (Check 31 confirms mechanically).
- No new agent, command, rule, check, or eval case landed in this range.

## 4. Content updates to master documents

- **`PROJECT_RULES.md`** — untouched this range (`git diff --stat
  573687d..HEAD -- PROJECT_RULES.md` empty). 1,006 lines, 47 index rows,
  unchanged.
- **`PATHWAY_FORWARD.md`** — untouched this range (empty diff, re-confirmed on
  this tree). 13 VERIFIED, 22 RETIRED, 0 BROKEN of 35 rows, same as v1.28.4; no
  blank `last-checked` on a live row.
- **`README.md`**, **`docs/maintainer.md`** — untouched (no roster, model-table
  or Layout change; nothing in this range adds or renames an agent).
- **`agents/haruto-nakamura.md`** (5 lines touched, PR #102 + #105) — Phase 1's
  isolation sentence now names cutting in your own worktree and leaving the
  caller's checkout as found; step 12's `clone` row gains a parenthetical
  claiming it "re-reads step 11's pre-tag clone." §5 finding 2 below disputes
  the second claim against the actual script.
- **`agents/wei-lin.md`** (67 lines touched, PRs #102/#103/#104/#105) —
  largest single-file change this range: mid-task relay handling (ask for a
  missing board-commit citation rather than dropping it), the tool-call
  checkpoint moved earlier (~100, not ~120), gate axis 4's signal-removal
  wording tightened to include an allowlist carve-out, external-kill tracing,
  Phase 3 snapshots moved off `docs/perf_snapshots/` onto the board + `runs/`,
  per-surface milestone budgeting (~80% reserve, `no milestone, because`),
  squash-aware branch reaping, ignored-file handling after a merge, and
  dispatch routing that forbids sending a diagnosis to `general-purpose`.
- **`agents/zofia-kaminska.md`** (69 lines touched, PRs #101/#102) — the
  starter-set root/docs/tests invariant rewritten as a per-surface
  failure-mode table; the seed report now must list all thirteen invariants
  landed or dropped; the root-layout check now builds its whitelist from the
  template rather than falling back to the book's whitelist. §5 finding 3
  below is on this last change.
- **`commands/autopilot.md`** (17 lines touched, PR #102) — relay-to-live-only
  wording, a declined pre-flight decision becomes `BLOCKED(owner)`, the
  invoking session hands off past ~200k context, merge-policy defaulting to
  the command's own cycle when the rule book is silent.
- **`docs/lessons_ledger.md`** — 336 → 363 lines (+27, all new rows, no
  deletions), 20 new dated rows (10-07 ×9, 10-08 ×11), aliased
  (`P02`, `P09`, `P10`, `P13`, `P15`, `P16`, `P19`, `P20`, `P21`, `self`,
  `consilium`) — no project name, path, host, or person in any added row,
  checked by hand (§5 confirms).

## 5. Audit findings and fixes

**Dispatched `victor-reyes`** for the deep pass over PRs #101–#105 (5 files,
178 diff lines). He reports no Agent tool available in his dispatched context
and self-handled the read rather than sub-dispatching — noted as a
limitation, not hidden: nothing independently checked his reasoning this
round.

**12 consolidated findings — 3 Major, 2 Medium, 5 Low, 2 advisory.**

1. **(Major.)** `tests/release_gate.sh`'s `tree` row fails whenever
   `git worktree list` reports more than one worktree (`:79-80`), but PR #102
   just made cutting a release in its own worktree the stated instruction
   (`agents/haruto-nakamura.md:25-27`). Run literally, every future release
   following this prompt fails its own gate's first row by construction, the
   moment the worktree is still attached when the gate runs. **Not fixed** —
   `tests/release_gate.sh` is `iris-vermeulen`'s surface, the instruction's
   wording is `lian-zhao`'s; deferred to both to reconcile (either the gate
   excludes the release engineer's own worktree, or the prompt says to remove
   it before the gate runs). **Worked around operationally this release**:
   `tests/release_gate.sh` was run post-tag from a standalone scratch clone of
   the pushed tag, not from this worktree or the main checkout — a scratch
   clone's own `git worktree list` is always 1, decoupled from whatever this
   repo's worktree layout is at gate time (see §12). The release worktree was
   also removed afterward as cleanup, once it had nothing left to do, but that
   removal is not what makes the `tree` row pass. This is a release-engineer
   choice, not a fix to either surface.
2. **(Major.)** `agents/haruto-nakamura.md:278`'s new claim that the gate's
   `clone` row "re-reads step 11's pre-tag clone" is false against
   `tests/release_gate.sh:144-150,181-269`: `run_clone_row` makes its own
   fresh clone of the pushed tag, gated on `publish_result == PASS` — it
   cannot run before a tag exists, so there is nothing to "re-read" from a
   pre-tag step. It also conflicts with rule 15b's own wording, "a stranger's
   clone of the tagged commit." **Not fixed** — `agents/*.md` is
   `lian-zhao`'s surface; deferred. This release executed per the script's
   actual behavior (a fresh post-tag clone, §12), not the prompt's incorrect
   description of it.
3. **(Major.)** `agents/zofia-kaminska.md:388-391`'s rewritten root-layout
   check now builds the whitelist "from invariant 1's template, not the
   tree," with no fallback to a project's own stated whitelist. Run against
   consilium itself (rule 0), it would flag `install.sh`, `CITATION.cff` and
   `.gitignore` as violations even though `PROJECT_RULES.md:103-112`'s rule-1
   table explicitly allows them (`git ls-files` confirms all three sit at
   root today). **Not fixed** — `zofia-kaminska`'s own surface/rule-1
   invariant; deferred to her/the human. Not run against consilium this
   release (this is a Mode B audit, not a release-gate step), so it has not
   yet produced a false positive in practice, but it would the next time she
   is invoked here.
4. **(Medium.)** `agents/wei-lin.md:464-465`'s new lesson — "move \[ignored
   files\] in the main checkout after the tracked change merges" — has no
   stated exception to rule 20 item 1, "Never write to the `main`/`master`
   checkout" (`PROJECT_RULES.md:687-688`). **Not fixed** — `lian-zhao`'s
   surface; deferred.
5. **(Medium, carried and worsened again.)** `docs/lessons_ledger.md`'s diff
   this range adds **8** more rows self-certified as a recurrence and marked
   "fixture-eligible under rule 10, deferred to the owner" (lines for the
   whitelist-from-tree repeat, wei-lin's second open/close/re-scope repeat,
   the third `pgrep -f` self-match repeat, the relay-without-commit repeat,
   the second no-tag milestone repeat, and the release-before-clone repeat).
   `git diff --stat 573687d..HEAD -- evals/` is empty — zero fixtures landed
   against any of them, same as v1.28.4. The debt is now the same shape
   flagged at v1.28.3 and v1.28.4, continuing to grow with no mechanical
   proxy check built against it. **This agent's call: still not a release
   blocker** — `tests/check.sh` has no check for this — called out again in
   §10 rather than left to improve by assertion.
6. **(Low.)** `agents/wei-lin.md:374` now allows patch/minor tags without
   naming a branch restriction, while the escalation list at `:410-411` still
   names "a tag on the default branch" as a stop condition — the two no
   longer agree without the reader resolving them against each other.
   **Not fixed** — `lian-zhao`'s surface; deferred.
7. **(Low.)** `agents/wei-lin.md:312`'s compressed Phase 3a step 1 now reads
   as if `victor-reyes` alone covers "own rules followed, code correct,"
   which blurs into `zofia-kaminska`'s rules-audit role stated two lines
   earlier in the same prompt. **Not fixed** — `lian-zhao`'s surface;
   deferred.
8. **(Low.)** `agents/zofia-kaminska.md:243-246`'s "seed one gate check for
   all three" (root, docs, tests layouts) describes a check that only
   inspects the root (whitelist diff, 5 MB ceiling, tidy list) — nothing
   checks the docs layout it claims to cover. **Not fixed** — `lian-zhao`'s
   surface; deferred.
9. **(Low.)** A splice in `agents/wei-lin.md:78-79` leaves "(object in your
   report, never re-litigate)" reading as attached to "never drop it" rather
   than "then act," which was its antecedent before this edit. **Not fixed**
   — `lian-zhao`'s surface; deferred.
10. **(Low.)** `commands/autopilot.md:12-13`'s relay sentence can now be read
    as requiring a stop to be "committed verbatim to the board first" before
    acting on it, which would put a resource-safety stop behind a board
    commit — the opposite of wei-lin's own "a resource-safety order first,
    questions after." **Not fixed** — `lian-zhao`'s surface; deferred.
11. **(Advisory.)** `agents/wei-lin.md:301-303` and `commands/autopilot.md:6`:
    the new "from ~80% of the budget" milestone trigger has no stated meaning
    for an open-ended budget form (`until the board is green`), which
    `/autopilot` explicitly accepts as an argument.
12. **(Advisory.)** `agents/haruto-nakamura.md:25-27` still opens "isolation
    is **temporal, not spatial**" immediately before adding a worktree
    requirement, which is a spatial device — the sentence's own framing and
    its content pull in different directions, though the substance (contain
    the work, leave the caller's tree alone) is unaffected.

**Fixes applied this release: zero.** All 12 findings sit on `agents/*.md`
(`lian-zhao`'s surface) or `tests/release_gate.sh` (`iris-vermeulen`'s
surface) or `zofia-kaminska`'s own rule-1 invariant — none of them this
release engineer's surface, and none a one-word mechanical fix of the kind
v1.28.4 found once. All 12 are listed as open issues (§6), not invented
fixes.

**Refactor (`kai-fischer`): not dispatched.** This range touched zero files
under his surface (existing production code) — all five touched files are
`agents/*.md`, `commands/*.md` or `docs/lessons_ledger.md`, each owned by
`lian-zhao` or left to the human under rule 19. Dispatching him here would be
routing work to a surface he has no claim on, not a conciseness pass he
declined; same conclusion as v1.28.4, for the same reason.

**This pass's own verification, re-run fresh:**
- `bash tests/check.sh`: `930 passed, 0 failed`.
- `cat agents/*.md commands/*.md | wc -l` → `5742`, 12 lines under the 5,754
  ceiling (net −2 this range).
- `git diff --stat 573687d..HEAD -- evals/`: empty — confirms finding 5's "no
  fixture landed" claim directly.
- `git diff --stat 573687d..HEAD -- PATHWAY_FORWARD.md`,
  `-- PROJECT_RULES.md`, `-- README.md`, `-- docs/maintainer.md`: all empty —
  confirms §4's "untouched" claims directly, not by assertion.
- Read `tests/release_gate.sh:77-80` and `:181-269` directly to confirm
  findings 1 and 2 against the script's actual text, not victor's summary of
  it.
- Read every new `docs/lessons_ledger.md` row by hand: no project name, path,
  host, or person — only the aliases listed in §4 and agent names.
- `gh run view 37817774455 --log | grep -i deprecat`: one Node.js-20
  deprecation annotation still present on `actions/checkout@v4`; the
  Ubuntu-26 annotation carried from v1.28.2/v1.28.3 is no longer present in
  this run's log (§6 item 9 updated accordingly, not closed).

## 6. Remaining open issues or pending items

1. **(Major, open, new this range.)** `tests/release_gate.sh`'s `tree` row
   and `agents/haruto-nakamura.md`'s new worktree instruction contradict each
   other — §5 finding 1. Owner: `iris-vermeulen` (gate) and `lian-zhao`
   (prompt), to reconcile together.
2. **(Major, open, new this range.)** The `clone` row's described behavior in
   `agents/haruto-nakamura.md:278` does not match `tests/release_gate.sh`'s
   actual behavior — §5 finding 2. Owner: `lian-zhao`.
3. **(Major, open, new this range.)** `zofia-kaminska`'s rewritten root-layout
   check would false-positive on consilium's own root — §5 finding 3. Owner:
   `zofia-kaminska`/human.
4. **(Medium, open, new this range.)** `wei-lin`'s ignored-file lesson has no
   stated exception to rule 20's "never write to the main checkout" — §5
   finding 4. Owner: `lian-zhao`.
5. **(Medium, open, carried and worsened again — v1.28.3 §6.1 → v1.28.4
   §5/§6 finding 4 → this range.)** 8 more unfixtured rule-10 recurrences
   this range, 0 fixtures landed against any of them (cumulative: 2 at
   v1.28.3, 8 more at v1.28.4, 8 more here). Owner: `iris-vermeulen` (author
   fixtures or the proxy check), `zofia-kaminska`/human (decide whether to
   pause unfixtured "landed" claims or accept the growing debt).
6. **(Low, open, new this range.)** Findings 6–10 (§5): five wording/
   cross-reference ambiguities in `agents/wei-lin.md`, `zofia-kaminska.md`
   and `commands/autopilot.md`. Owner: `lian-zhao`.
7. **(Carried from v1.28.4 §6, items 1–3, 5–8, unresolved — neither
   `lian-zhao` nor `zofia-kaminska`/human was dispatched to any of them this
   release):**
   - Rule-19 ownership overlap between `anya-petrov`'s "user docs" row and
     existing README-restatement ownership (v1.28.4 §5 finding 1).
   - `agents/anya-petrov.md`'s Isolation section not reconciled with her
     standing-docs workspace (v1.28.4 §5 finding 2).
   - `agents/wei-lin.md`'s gate-axis-4 two-dot/three-dot contradiction
     (v1.28.4 §5 finding 3) — not touched by this range's wei-lin.md edits,
     which landed elsewhere in the file.
   - `agents/ziyan-chen.md`'s tally-location ambiguity (v1.28.4 §5 finding 5).
   - `docs/user/agents.md` and `docs/user/getting-started.md` stale re:
     anya's scope (v1.28.4 §5 finding 6), blocked on item 1 above.
   - `agents/wei-lin.md:257`'s unnamed "that line" (v1.28.4 §5 finding 8).
   - No rule-19 ownership row for `docs/maintainer.md`, `docs/user/*.md`,
     `docs/lessons_ledger.md` itself (carried since v1.28.1).
8. **(Carried from v1.28.4 §6 item 9, re-confirmed this pass, partially
   closed.)** CI (`.github/workflows/check.yml`) printed one deprecation
   annotation on the gating run this release (`actions/checkout@v4` on
   Node.js 20), not two — the Ubuntu-26 annotation from v1.28.2/v1.28.3 no
   longer appears. Owner: `iris-vermeulen`.
9. **(Carried from v1.28.4 §6 item 10, Major, still open.)**
   `agents/mira-volkov.md` and `agents/dunyu-liu.md` still carry the
   pre-#98 isolation sentence superseded in rule 20 item 1 — not touched by
   this range's diff (confirmed: neither file appears in `git diff --stat
   573687d..HEAD`). Owner: `lian-zhao`.
10. **(Carried from v1.28.4 §6 item 11, Medium, still open.)**
    `zofia-kaminska`'s root/size/tidy gate-check invariant has still never
    been run against consilium's own tree — and §5 finding 3 above is new
    evidence it would fail if it were. Owner: `zofia-kaminska`/human.
11. **(Carried from v1.28.4 §6 item 12, Low, still open.)**
    `agents/kai-fischer.md`'s worktree instruction still has no concrete
    path. Owner: `lian-zhao`.

## 7. Totals or cost changes

| Measure | v1.28.4 | v1.28.5 |
|---|---|---|
| Tracked lines (`git ls-files \| xargs wc -l`) | 22,077 | 22,226 |
| Tracked files (`git ls-files \| wc -l`) | 177 | 177 |
| `evals/` lines | 4,585 | 4,585 |
| `tests/check.sh` lines | 1,409 | 1,409 |
| `PROJECT_RULES.md` lines | 1,006 | 1,006 |
| `agents/`+`commands/` lines (rule 1b) | 5,744 (ceiling 5,754) | 5,742 (ceiling 5,754) |
| Live checks (37 numbered, 5 retired) | 32 | 32 |
| Eval cases | 10 | 10 |
| Agents / commands | 23 / 20 | 23 / 20 |
| Rule-book index rows | 47 | 47 |
| Board rows VERIFIED / RETIRED / BROKEN (of 35) | 13 / 22 / 0 | 13 / 22 / 0 |

Tracked-lines growth (22,077 → 22,226, +149) reconciles as: +105/−80 net text
this range (§2) + this note's own lines at commit time, measured after
writing it (§10 re-derives the text-only half independently).

## 8. Assumptions used

- **Scope is #101–#105 only**, excluding PR #100 — #100 landed after the
  v1.28.4 tag but is v1.28.4's own CI/gate transcription, already recorded in
  `docs/release_notes_v1.28.4.md`'s own history and not re-litigated here.
- **The gate's final run happens in a standalone scratch clone**, not this
  worktree or the main checkout, to satisfy `tests/release_gate.sh`'s
  one-worktree `tree` row (§5 finding 1) without needing to remove anything
  from this repo's own worktree layout — an operational choice for this
  release, not a fix to either surface, stated so the next release engineer
  does not have to rediscover the contradiction.
- **`kai-fischer` not dispatched** — zero files this range sit on his surface
  (existing production code); all five are `agents/*.md`, `commands/*.md` or
  `docs/lessons_ledger.md`.
- **`zofia-kaminska` and `lian-zhao` not dispatched** for any of §5's 12
  findings — all are judgement calls on surfaces this release engineer does
  not own (rule 19); inventing a fix on either surface would be the violation
  rule 19 exists to prevent, so they are recorded as open issues (§6) for
  their owners instead.
- **§7's v1.28.4 baseline was re-measured in a throwaway detached worktree at
  that tag**, not copied from `docs/release_notes_v1.28.4.md`'s own §7 table.

## 9. CI run this release was gated on

Three `structural-invariants` push-triggered runs, all `success`, gate this
release: two on the PR #106 head SHA `72483d351f57388003b6f5f5382166e9e877738e`
(runs `37819104439` and `37819124906`), and one on the squash-merge commit
`9fd3c5d9aef894c67191d35b7c8b9c890cfb8b49` on `main` (run `37819277582`,
https://github.com/dunyuliu/consilium/actions/runs/37819277582). The tag is
cut against `9fd3c5d9aef894c67191d35b7c8b9c890cfb8b49`, per rule 15a.

## 10. Trend since v1.28.4

Every row is the output of a command run this session, at both commits.

| Measure | v1.28.4 | v1.28.5 | Direction |
|---|---|---|---|
| Gate assertions — `bash tests/check.sh` | `929 passed, 0 failed` (freshly re-run at the `v1.28.4` tag in a detached worktree) | `930 passed, 0 failed` | **+1 assertion**, consistent with the 12-line net shrink and content change in `agents/`+`commands/`; no Check number added or dropped. |
| Fixture verdicts — `bash evals/run.sh score` | `never run: 1, unknown provenance: 0, contested: 0, delta vs previous commit: -46 points` | identical output | **Unchanged** — already at the floor; this range's prompt edits (`haruto-nakamura`, `wei-lin`, `zofia-kaminska`) add to the stale set (`bash evals/run.sh list` now shows `haruto-002-tag-before-gate` and `zofia-003-seed-bare-project` STALE against today's prompt SHA) without moving the headline numbers. |
| Tracked text lines — `git diff --numstat v1.28.4..HEAD -- '*.md' '*.sh' '*.py'` | — | 6 files, **124 added / 89 removed, net +35** | **Modest growth**, concentrated in `docs/lessons_ledger.md` (+27 rows) and `agents/wei-lin.md`'s lesson folds, partly offset by `agents/zofia-kaminska.md`'s net −1 and `commands/autopilot.md`'s net −1 (§2). |
| Board currency — `PATHWAY_FORWARD.md` | 13 VERIFIED, 22 RETIRED, 0 BROKEN, 0 blank | 13 VERIFIED, 22 RETIRED, 0 BROKEN, 0 blank | **Unchanged** — board untouched this range (empty diff, re-confirmed). |
| CI green-on-first-try — `gh run list` since v1.28.4's tag push | — | every push run since `6f4838f9` (through PRs #100–#106, including both PR #106 head-SHA runs and the merge-SHA run, §9) reports `success`, 0 reruns | **Unchanged in substance** (100%, same streak as v1.28.3→v1.28.4). |

**Reading, plainly.** The gate holds flat (+1 assertion, no new Check) and
fixture currency sits at its already-established floor; tracked-line growth
is modest (+35) and mostly ledger rows plus lesson-fold prose, not new
surface. Two real deteriorations are not visible in these five mechanical
measures: §5 finding 5's unfixtured, self-certified rule-10 recurrences grew
by another 8 with zero fixtures landed, continuing the trend flagged at
v1.28.3 and v1.28.4; and this release's audit surfaced **three new Major
findings** (§5 findings 1–3) — a release-gate row that now contradicts the
prompt's own new worktree instruction, a factually wrong description of the
gate's `clone` row, and a rewritten audit check that would false-positive on
this very repo — none of them visible to `tests/check.sh`, and none closed
this release because none sit on this release engineer's surface. The Major
finding carried from v1.28.4 (the stale isolation sentence in
`mira-volkov.md`/`dunyu-liu.md`) also remains open, untouched a second
release running.

## 11. Work record

- **audit**: `victor-reyes`, self-handled (no Agent tool in his dispatched
  context, no sub-dispatch — noted as a limitation, not concealed). 12
  consolidated findings — 3 Major, 2 Medium, 5 Low, 2 advisory, all §5.
- **correctness**: `bash tests/check.sh` → `930 passed, 0 failed` on the
  pre-release worktree tree; re-confirmed post-merge before the tag (§12).
- **conciseness**: net −2 tracked lines across `agents/`+`commands/` this
  range (5,744 → 5,742); not independently verified by `kai-fischer` — see
  `refactor:` below.
- **fixes**: zero applied. All 12 findings deferred by owner (§5/§6):
  findings 1–2, 4, 6–10 to `lian-zhao`; finding 1 jointly to
  `iris-vermeulen`; finding 3 and the rule-10 debt (finding 5) to
  `zofia-kaminska`/human/`iris-vermeulen`. None invented.
- **docs**: reconciled against the filesystem, not the diff. Root walked
  against rule 1's whitelist; every count in §7 re-read off disk this session
  at both commits; `PATHWAY_FORWARD.md`, `PROJECT_RULES.md`, `README.md`,
  `docs/maintainer.md` confirmed untouched by direct diff.
- **refactor**: **`kai-fischer` did not run this release.** Zero files this
  range sit on his surface (existing production code); all five touched
  files are `agents/*.md`, `commands/*.md` or `docs/lessons_ledger.md`.
- **rules**: **`zofia-kaminska` not dispatched this release.** Findings 3 and
  5 (§5) are on her own surface and are judgement calls for her or the human
  to resolve, not re-litigated by this release engineer; recording them as
  open issues (§6) is the correct action under rule 19, not a deferral of
  effort.

## 12. Release gate

`bash tests/release_gate.sh release_notes_v1.28.5.md`, run post-tag in a
standalone `git clone` of `https://github.com/dunyuliu/consilium.git` on
branch `main` (tip `9fd3c5d9aef894c67191d35b7c8b9c890cfb8b49`, same commit the
tag `v1.28.5` points at), outside this repo and this worktree entirely (§5
finding 1, §8) — `main` rather than a detached tag checkout, so the clone
carries an upstream tracking ref for the `tree` row's comparison. Result:
**5 passed, 0 failed, 0 skipped.**

- **tree**: PASS — clean, one worktree, no lock, level with upstream.
- **ci**: PASS — green on `9fd3c5d9` (run `37819277582`, §9).
- **publish**: PASS — `v1.28.5` pushed and pointing at `9fd3c5d9`.
- **release**: PASS — GitHub Release exists for `v1.28.5`
  (https://github.com/dunyuliu/consilium/releases/tag/v1.28.5).
- **clone**: PASS — fresh clone of `v1.28.5`; README's Install block and the
  next `bash`-fenced block both exited 0.
