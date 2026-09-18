# Release notes — v1.25.0 — 2026-09-18

## Summary of scope

A settling release: five commits, all removals or corrections, nothing new
shipped. The rule-19 dispute that v1.24.0's note deliberately left open is
closed. The hook removal that v1.24.0 started in `install.sh` is finished
everywhere else — nineteen live references to a `pre-commit` and `pre-push`
that no longer exist, across two agent-facing prompts and two scripts. The
board takes its fifth retirement pass and comes out with zero P1 rows for the
first time. No agent, check, command or root file was added or removed.

## Files added / removed / renamed / cleaned up

- `docs/release_notes_v1.24.0.md` — moved from the repo root (rule 8; never
  deleted).
- `release_notes_v1.25.0.md` — this file, new at the root.
- Nothing else added, removed or renamed. Verified against the filesystem:
  the repo root holds exactly `README.md`, `PROJECT_RULES.md`,
  `PATHWAY_FORWARD.md`, `CLAUDE.md`, `LICENSE`, `install.sh`, this note, and
  the `agents/ commands/ docs/ evals/ tests/` directories — rule 1's
  whitelist, nothing beside it.
- On disk at this tag: 22 agents, 19 commands, 32 live checks, 10 fixtures,
  35 board rows of which 19 are live.

## Content updates to master documents

- **`PROJECT_RULES.md` — the rule-19 adjudication (`baaa1a0`).** Rule 19's
  "Human-owned surfaces" paragraph is rewritten: README prose that restates
  another surface is owned by that surface's owner and moves in the same
  commit. The model roster is `lian-zhao`'s, because
  `agents/nadia-hadid.md`'s frontmatter is what falsified it; the Install
  section is `iris-vermeulen`'s, because `install.sh` is. The remainder of
  `README.md`, and all of `CLAUDE.md`, has no agent owner, drifts by design,
  and is guarded by nothing but the fresh-clone walk at a release. Rule 11's
  trigger widened from agent changes to any surface the README describes.
  **No rule 19a exists**: a rule that only forgives cannot bind, and the
  carve-out lives inside rule 19 instead.
- **`PROJECT_RULES.md` — new Conventions bullet, "A rule that only forgives
  is not a rule" (`baaa1a0`).** A deletion criterion: it says which rules to
  remove, and that bare permissions belong as carve-outs inside the rule they
  except. It flags nothing in the present 28-rule book —
  `zofia-kaminska` checked the two permission-shaped candidates (8a, 21a) and
  both carry real obligations. It landed anyway, over the conducting agent's
  own doubt, on the argument that Conventions bullets are write-time criteria
  and this one had already changed what got written twice.
- **`PATHWAY_FORWARD.md` — fifth retirement pass (`796463a`).** 22 live rows
  → 19; 0 P1 / 2 P2 / 17 P3, plus 16 RETIRED. PF-001, PF-013 and PF-027
  retired; PF-010 kept and re-pointed.
- **`agents/haruto-nakamura.md`, `commands/release.md` (`087ae95`);
  `tests/lock.sh`, `tests/check.sh` (`eba4aff`)** — the hook removal
  completed. Rule 15a's deadlock resolution and release step 10 are
  re-grounded on the hand-run gate (rule 9, now a norm with nothing enforcing
  it) instead of on a `pre-push` hook that `install.sh` stopped wiring in
  v1.24.0. `tests/check.sh` drops `pre-push` from `NON_AGENT_TERMS`.

## Audit findings and fixes

Three passes ran on the pristine tree at `eba4aff`, before any archival or
write: `victor-reyes` (deep, routed), `kai-fischer` (refactor and
conciseness, scope-capped to the diff), `zofia-kaminska` (rules, read-only).
Seven findings, **zero applied** — the dispatching instruction for this cut
capped the writable surface at the release note, the version references a
release owes, and `docs/` archival, and told me to route everything else
rather than fix it. Every finding below is therefore deferred, not dismissed,
and is repeated in "Remaining open issues" with its routing.

| # | Source | Sev | Where | Finding | Disposition |
|---|---|---|---|---|---|
| 1 | victor | Major | `PROJECT_RULES.md:738-757` vs `:715-730` | The rewritten rule-19 prose assigns README's model roster to `lian-zhao` and the Install section to `iris-vermeulen`, but rule 19's write-surface table — the one Check 10 validates — has no `README.md` row at all. Ownership declared in prose that the mechanism cannot see. | Deferred, routed to `wei-lin` |
| 2 | victor | Major | `agents/lian-zhao.md` | Rule 19 now makes `lian-zhao` owner of the README model-roster line; her prompt never mentions README. The commit that widened rule 11 ("docs move with the surface") is the commit that did not honour it. | Deferred, routed to `wei-lin` |
| 3 | victor | Major | `README.md:28` | "30 regression fixtures covering all 21 agents" — disk has 10 fixtures and 22 agents, and `README.md:674` says "10 cases cover a subset of the 22 agents", contradicting line 28 inside the same file. Pre-existing, but the rewritten rule 11/19 is what now routes this prose to an owner. | Deferred, routed to `wei-lin` |
| 4 | victor | Minor | `README.md:23` | "33 checks"; `tests/check.sh` defines 32 live checks (1-36, with 4, 17, 21, 25 absent). | Deferred, routed to `wei-lin` |
| 5 | victor | Minor | `tests/check.sh:5-50` | The `Verifies:` header names 25 as retired but silently omits 4, 17 and 21, so the header cannot be used to reconcile the count. | Deferred, routed to `wei-lin` (`iris-vermeulen`'s surface) |
| 6 | victor | Minor | `CLAUDE.md:57` | Claims "Check 17 re-runs every board command on every suite run and byte-diffs the result" — Check 17 was retired 2026-09-17. Distinct from the hook drift at `:40`/`:48`. | Deferred, maintainer's (see open issues) |
| 7 | haruto | Minor | this cut's diffstat | The stretch is **net +109 tracked text lines** (209 added / 100 removed across `*.md *.sh *.py`), not net-negative as the dispatch brief stated. Script deletions are outweighed by board retirement prose, the rule-19 rewrite, and v1.24.0's own 50-line note amendment. | Recorded in "Trend", not fixed |

Points of disagreement between the passes, recorded rather than resolved:
`victor-reyes` calls findings 1-3 blocking ("releasable with the two Major
rule-19 rows fixed first"); `zofia-kaminska`, reading the same tree, found no
rule violation beyond the known `CLAUDE.md` deferral and judges rule 19 and
rule 11 self-consistent. I did not adjudicate. The mechanical gates — 797
assertions and the five release-gate rows — are green either way, so the cut
proceeds and the disagreement goes to the maintainer intact.

What the passes confirmed, with evidence:

- No remaining live reference to the removed `pre-commit`/`pre-push` hooks
  anywhere except the known `CLAUDE.md:40`/`:48`. Every other hit in
  `PROJECT_RULES.md`, `README.md:228` and `agents/haruto-nakamura.md:29` is
  an explicit "no such hook exists" statement or a `--no-verify` prohibition;
  `PATHWAY_FORWARD.md`'s hits are retirement grounds; `docs/` hits are the
  archival record (rule 8).
- The shell edits change behaviour in exactly one way, a tightening: Check 5
  would now flag a backticked `pre-push` in README, and there is none left.
  All `exit 2` paths, the `sed -n '4p'` scope read, the `printf` lock write
  and `set -euo pipefail` are byte-identical in control flow. No swallowed
  exit code, no check that now asserts nothing.
- The board's arithmetic holds: 35 rows = 19 VERIFIED + 16 RETIRED, the
  header's "0 P1 / 2 P2 / 17 P3 across 19" matches the live rows, no live row
  cites a retired ID, and no board row has a blank last-checked date.

## Remaining open issues

- **`CLAUDE.md:40` and `:48` still describe the removed `pre-commit` and
  `pre-push` hooks as enforcing the scope guard and the gate; `:57` still
  cites the retired Check 17.** `CLAUDE.md` has no agent owner under rule 19
  as just amended — it is the human's. This is the first case the new
  ownership boundary routes rather than silently absorbs, which is the
  boundary working. Flagged for the maintainer; deliberately not edited here.
- Findings 1-5 above, routed to `wei-lin` as the conducting agent, to be
  scheduled as their own changes rather than folded into a release diff
  (rule 1).
- PF-013 is retired, not solved: `elena-hartmann`, `victor-reyes` and
  `marco-bianchi` stay on opus as a recorded judgement, because the criterion
  "cheapest tier that passes its fixture" is unsatisfiable for three agents
  with no fixture, and building three fixtures to unblock a board row is the
  headcount reflex rule 13 was retired for.
- The agent worktree this cut ran in is a second worktree, which the release
  gate's `tree` row counts (see "Release gate"). It is removed when this
  dispatch ends; the shared checkout must be fast-forwarded to this tag.

## Totals or cost changes

- Gate assertions: 797 passed, 0 failed — identical at `v1.24.0` and at this
  tag. No check added or removed. (v1.24.0's note recorded 794; the three
  extra assertions are Check 35's per-tag Release assertions, which grow by
  one per release, not new checks.)
- Board: 22 live rows → 19; 13 RETIRED → 16; 1 OPEN → 0; 0 BROKEN, unchanged;
  1 P1 → 0 P1.
- Tracked text: 209 added / 100 removed across `*.md *.sh *.py`, **net +109**.
- Rules: 28, unchanged in number; rule 19 and rule 11 rewritten, one
  Conventions bullet added, no rule added or retired.

## Assumptions used

- The maintainer's grant to `wei-lin` of merge and tag authority on `main`,
  minor and patch only, is taken from this cut's dispatch and from
  `agents/wei-lin.md`, not re-verified with the maintainer directly.
- `wei-lin`'s own evidence of 2026-09-18, taken on their word and recorded as
  theirs, not re-run by me: a stranger-clone walk of
  `https://github.com/dunyuliu/consilium.git` at `31660df` into an empty
  directory under a sandboxed `HOME` (`consilium installed: 22 agents, 19
  commands, 1/1 hooks wired`, exit 0, 22 symlinks; `bash tests/check.sh` →
  797 passed, 0 failed); a re-run of every live board evidence command on
  `main`, which is what produced the retirement pass's central finding; and a
  hand-run of `tests/lock.sh`'s rewritten refusal and acquire paths.
- **`release`-triggered cadence over strict semver.** The instruction was
  `minor`, and this note carries it. On content alone this stretch is a patch:
  every commit is a correction or a removal and nothing user-visible was
  added. Recorded as a deviation, not silently overridden; the grant covers
  minor.
- The v9.9.9 note in `docs/` is the deleted-tag incident's artifact, not a
  version. Highest real predecessor is v1.24.0, so this is v1.25.0.

## CI

**The run this release was gated on:** recorded in the follow-up commit that
amends this section, because the run does not exist until this commit is
pushed. Not yet run at the time this file was committed — see the "Release
gate" section below for the same reason, and rule 15a for why the field is
written rather than left silent.

The commit-push run is expected to be red on exactly the assertions whose
sole cause is that `v1.25.0` is not yet on the remote — Check 27
(`release_notes_v1.25.0.md has no matching tag`), Check 31d (root note newer
than the newest tag) and Check 35 (a tag with no GitHub Release), the same
set v1.23.0 and v1.24.0 named. Any red outside that set stops the cut.

## Trend since v1.24.0

Report, not gate. A dedicated leanness pass is deferred by the maintainer, so
no release is blocked on the line-count row — but a repo that only grew must
be called that, and this one grew.

| Measure | v1.24.0 | v1.25.0 | Direction |
|---|---|---|---|
| Gate assertions (`bash tests/check.sh`, both run today, both against the GitHub remote) | 797 passed, 0 failed | 797 passed, 0 failed | Unchanged |
| Fixture verdicts (`bash evals/run.sh list` / `score`) | 4/10 current (40%), 4 stale, 2 unknown provenance, 0 never-run | 4/10 current (40%), 4 stale, 2 unknown provenance, 0 never-run | Unchanged — but the stale four now include both `haruto-nakamura` fixtures, staled by this cut's own edit to that prompt |
| Tracked text lines (`git diff --stat v1.24.0..HEAD -- '*.md' '*.sh' '*.py'`) | — | 209 added / 100 removed, **net +109** | Worse |
| Board currency (`PATHWAY_FORWARD.md`) | 21 VERIFIED, 0 BROKEN, 1 OPEN, 13 RETIRED, 0 blank dates | 19 VERIFIED, 0 BROKEN, 0 OPEN, 16 RETIRED, 0 blank dates | Better |
| CI green on first try (`gh run list`) | — | 6 of 6 pushes since the v1.24.0 tag push, no re-runs | Unchanged (was 8 of 8 in the prior stretch) |

Reading, plainly: **the gate did not move and the repo grew.** 797 assertions
before, 797 after; fixture trustworthiness flat at 40% and about to be
measured against a prompt this cut edited; +109 tracked lines. The only
measure that improved is the board, and it improved by retiring rows, not by
closing them with work. Three of the four retired rows were green on commands
that no longer reached anything — which is a real finding and the best thing
in this stretch — but retiring a row is subtraction from the ledger, not
progress against it. This stretch bought correctness (a settled dispute,
nineteen dead references removed, three false-green board rows exposed) at
the price of 109 lines of prose explaining it. That is a defensible trade for
a governance cut and an indefensible one if repeated; the leanness pass the
maintainer deferred has now been deferred across two consecutive releases
whose net line change was positive.

## Work record

- audit: `victor-reyes` (routed deep pass, read-only, on the pristine tree at
  `eba4aff`) — 6 findings, 2 Major, 3 Minor, 1 Minor on `CLAUDE.md`; plus my
  own `PROJECT_RULES.md` pass and diffstat check — 1 further finding (the net
  line change). 7 total, deduped.
- correctness: `bash tests/check.sh` → 797 passed, 0 failed at `eba4aff`
  before any write, and again on the release commit before the push. The same
  command at `v1.24.0` in a fresh clone with the GitHub remote → 797 passed,
  0 failed. No correctness defect in the shell edits: `victor-reyes` traced
  every changed hunk in `tests/lock.sh` and `tests/check.sh` and found one
  behaviour change, a tightening of Check 5.
- conciseness: `kai-fischer`'s verdict — "lean for what it accomplishes". The
  bulk is board retirement prose and audit narrative following the house
  style rule 21 already requires; every board-row change corresponds to an
  actual retirement or a re-pointed command, not padding. My own measurement
  disagrees on the aggregate and is recorded as finding 7 and in "Trend": lean
  per hunk, +109 lines in total.
- fixes: none applied. All seven findings deferred — five routed to
  `wei-lin`, one (`CLAUDE.md`) to the maintainer, one recorded as a trend
  measurement. The dispatch capped my writable surface at the release note
  and `docs/` archival, and rule 1 binds hardest on a release diff.
- docs: reconciled against the filesystem, not the diff — root whitelist
  read with `ls` and matched against rule 1's table; `docs/` confirmed to
  hold the archived v1.24.0 note; agent/command/check/fixture/board counts
  read off disk (22 / 19 / 32 / 10 / 35 rows, 19 live) and checked against
  README's claims, which is how findings 3 and 4 surfaced.
- refactor: `kai-fischer` ran, scope-capped to the diff — "nothing needed".
  No new shell branching, no duplicated logic; rules 11 and 19 are
  complementary ("update the README in the same commit" vs. "who owns which
  README line"), not a restatement of each other. Nothing routed.
- rules: `zofia-kaminska` ran, read-only. Tier split unchanged — rule 11 stays
  `judgment` (widening a trigger adds no mechanism), rule 19 stays
  `mechanical — Check 10`; no index row is missing a tier and no rule or
  sub-rule was added. Violations: none beyond the recorded `CLAUDE.md`
  deferral. Unenforceable set unchanged — 3, 8a, 9, 15a, 18, 18a, 18b, 21a,
  21b, 25d (partial), 27 remain norms, each correctly self-declaring. The new
  Conventions bullet flags nothing in the present book; it is prophylactic.
  One soft gap, not a violation: rule 1's root-document table gives no signal
  that `README.md` now has mixed agent-and-human editorship.

## Release gate

The five rows below are transcribed from `bash tests/release_gate.sh
release_notes_v1.25.0.md`, which runs after this commit is tagged and pushed
and therefore after this file is written. They are recorded in the follow-up
commit that amends this section — the same sequence v1.24.0 used (`d445d0b`).
Known in advance and not a defect of the release: the `tree` row counts
worktrees, and this cut ran from a dispatch-isolated second worktree, so that
row reports its count rather than a clean one until the worktree is removed
and the shared checkout is fast-forwarded to this tag.

- tree: recorded in the follow-up commit from `tests/release_gate.sh` output
- ci: recorded in the follow-up commit from `tests/release_gate.sh` output
- publish: recorded in the follow-up commit from `tests/release_gate.sh` output
- release: recorded in the follow-up commit from `tests/release_gate.sh` output
- clone: recorded in the follow-up commit from `tests/release_gate.sh` output
