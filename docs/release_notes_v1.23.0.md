# v1.23.0 — the Release object stops being optional

**Date:** 2026-09-17

## Summary of scope

Nine commits on top of v1.22.0, net −1,069 lines across tracked text. Three
things changed behaviour; the rest is compression.

1. **`agents/haruto-nakamura.md` step 12a is unconditional.** The autonomous
   carve-out — which let an unattended cut stop at a pushed tag and leave the
   GitHub Release uncreated — is gone. Every cut now creates the Release.
2. **`tests/check.sh` Check 35 lost its newest-tag grace.** The grace existed
   to accommodate that carve-out, and it meant the Release leg never bound on
   the one tag it mattered for. It covered a real gap twice: v1.20.0 and
   v1.22.0 were tagged with no GitHub Release, the gate stayed green, and the
   maintainer published both by hand.
3. **Check 31 now asserts the root release note is the *newest tag's*,** not
   merely that exactly one exists. `tests/lock.sh` refuses a `.` scope, and
   rule 18 says so.

**This release is the first exercise of its own change.** v1.23.0 is cut with
step 12a in force: tag pushed, then `gh release create`, then the gate. A
pushed tag with no Release object is a red gate from here on, not a graced one.

## Files added / removed / renamed / cleaned up

| Change | Path |
|---|---|
| Added | `release_notes_v1.23.0.md` (this file, at the root) |
| Renamed | `release_notes_v1.22.0.md` → `docs/release_notes_v1.22.0.md` |
| Renamed (in `971fc36`) | `release_notes_v1.21.0.md` → `docs/release_notes_v1.21.0.md`, and `docs/release_notes_v1.22.0.md` → root — the inversion Check 31 now prevents |
| Untracked | `resume_claude.sh`, swallowed by an over-broad `git add -A`; `.gitignore` covers it |
| Compressed | `docs/SESSION_LOG_2026-09-16_autopilot-release-robustness.md`, 195 → 33 lines, under its own end-of-life path |
| Compressed | `PROJECT_RULES.md`, 1,558 → 979 |
| Compressed | `tests/check.sh`, 1,402 → 1,321; incident comments across eight checks |
| Compressed | all ten `evals/cases/*/case.yaml` `notes:` blocks, 1,764 → 1,468 |
| Removed | Check 4, provably subsumed by Checks 6 and 7 (mutation-tested by the author) |

## Content updates to master documents

- `PROJECT_RULES.md` — rule 18 refuses a root-scoped lock; book compressed to 979 lines.
- `PATHWAY_FORWARD.md` — PF-015 closed, PF-033 and PF-034 half-closed, PF-035 opened.
- `agents/wei-lin.md` — records the maintainer's grant of merge and tag authority on this repo's default branch, for minor and patch versions only.
- `agents/haruto-nakamura.md` — step 12a unconditional, as above.

## Audit findings and fixes

Phase 1 ran on the pristine tree at `632c439`, before any archiving.
`victor-reyes` routed the deep pass; `zofia-kaminska` audited the rule book;
`kai-fischer` took the refactor pass. **Nothing was applied in this release
commit beyond the note and the archive move** — every finding below sits on a
surface this agent does not own (rule 19).

**Two BLOCK claims raised and both disproved.** Recorded because the reasoning,
not the conclusion, is the useful part:

- *Claim:* Check 35 without its grace deadlocks the push — the pre-push hook
  runs the suite, sees a local tag with no Release, and aborts, while
  `gh release create --verify-tag` cannot run before the tag is pushed.
  *Disproved:* `/home/utig5/dliu/consilium/.git/hooks/` is empty. No hooks are
  installed in this checkout, per the decision recorded in `56ec728` ("local
  hook enforcement comes out after the release"). The push phase is not gated
  locally today.
- *Claim:* Check 31's new arm (d) is red for the whole pre-tag half of a
  release. *Disproved as a blocker:* it is red only if the suite is run in the
  window between writing the root note and creating the tag, and that window is
  avoidable — this release wrote the note, committed, tagged, and only then ran
  the suite.

**The hazard behind both claims is real and is recorded as open, not fixed.**
See open issues F6 and F7.

| # | Severity | Location | Finding | Disposition |
|---|---|---|---|---|
| F1 | Medium | `PROJECT_RULES.md:74` | Rule 21b is indexed `mechanical — Check 21`; Check 21 was retired and no longer exists in `tests/check.sh`. Present identically at v1.22.0 — not introduced here. | Deferred → `sophia-okafor` / `zofia-kaminska` |
| F2 | Medium | `PROJECT_RULES.md:75` | Rule 25b has an index row, a tier label and a live enforcing check (22), but no rule body anywhere in the book. Also pre-existing at v1.22.0. | Deferred → `sophia-okafor` / `zofia-kaminska` |
| F3 | Medium | `README.md:145`, `README.md:671` | README still cites rule 13 and Check 25, both retired in v1.22.0. | Deferred → `sophia-okafor` |
| F4 | Medium | `CLAUDE.md:58`, `CLAUDE.md:71` | CLAUDE.md states Check 17 re-runs board commands and Check 25 proves each agent has a fixture; both retired. Hand-maintained, no agent owner. | Deferred → human |
| F5 | Low | `tests/check.sh:5-49` | Retirement bookkeeping in the `Verifies:` header is inconsistent: 25 keeps a `(retired …)` line while 4, 17 and 21 are simply absent, so a reader cannot tell a retirement from an omission. | Deferred → `iris-vermeulen` |
| F6 | Medium | `tests/check.sh:1294-1306` | With the grace gone, Check 35 fails on any local tag that has no GitHub Release — including, unavoidably, the window between `git tag` and `gh release create` on every future cut. Harmless today because no hooks are installed; it bites the moment `install.sh`'s hook enforcement is restored. | Deferred → `iris-vermeulen` |
| F7 | Low | `tests/check.sh:1109-1117` | Check 31(d) is red in the window between writing the root note and creating the tag, for the same structural reason as F6. Avoidable by ordering, but the gate cannot distinguish a release in progress from an inversion. | Deferred → `iris-vermeulen` |
| F8 | Low | `tests/release_gate.sh` (row `release` header comment) | The comment still describes Check 35's newest-tag grace and step 12a's autonomous carve-out as live; both were removed in this stretch. The script's logic is correct — only the comment is stale. | Deferred → `iris-vermeulen` |
| F9 | **High** | `agents/haruto-nakamura.md` step 11 | The "exactly one red CI assertion between the two pushes" clause is unsatisfiable now that Check 31(d) asserts tag-absence a second time. Hit on this very cut. See the CI section for the evidence and the proposed wording. | Deferred → `lian-zhao` |

**Confirmed clean.** Check 4's removal leaves no gap: Check 6 requires a
model-table row per agent and Check 7 a roster row and a Layout line, both
iterating every `agents/*.md`, and either is strictly stronger than the
bare-mention test Check 4 performed. No binding rule text cited by a live check
was lost in the 1,558 → 979 compression. `tests/lock.sh:78-91` refuses `""`,
`.`, `./` and `/`, matching rule 18's amended text with no drift. The root
whitelist matches disk exactly. No merge-conflict markers, no dangling file
paths.

## Remaining open issues

F1 through F8 above, all unfixed and all deferred by ownership, not by
difficulty. F1–F4 are doc-versus-code drift; F5–F8 are the test surface. None
of them changes what this release ships; F6 is the one that will cost something
if it is left until hook enforcement returns.

## Totals or cost changes

- Checks: 36 → 32 (Check 4 removed this stretch; 17, 21 and 25 retired earlier).
- Gate assertions: 791 passed, 0 failed at `632c439`.
- Tracked text: −1,069 lines this stretch (`git diff --stat v1.22.0..HEAD -- '*.md' '*.sh' '*.py' '*.yaml'` → 1,078 insertions, 2,147 deletions).
- Campaign figures, measured by `wei-lin` on main and used here rather than
  re-derived: 19,681 → 18,391 tracked lines this stretch; 33,085 at campaign
  start, so −44% overall. By area now: agents 5,474 / evals ~4,869 / docs
  ~3,502 / root markdown ~2,358 / tests ~1,917 / commands 200.

## Assumptions used

- The maintainer's grant of default-branch merge and tag authority to `wei-lin`
  for minor and patch versions, now written into `agents/wei-lin.md`, covers
  this cut. This agent did not verify that grant against the maintainer
  directly; it is taken from the prompt and from the committed file.
- The previous tag's gate and eval numbers in the trend section below were taken
  from a `git archive v1.22.0` extraction with no `.git` directory. Git-dependent
  checks and provenance resolution degrade in that environment. Stated inline
  where it matters; not silently averaged away.
- `git worktree list` reports two worktrees because `wei-lin` created one for
  this cut. It is not abandoned work.

## CI

**The run this release was gated on:** run `35253828372`,
https://github.com/dunyuliu/consilium/actions/runs/35253828372, conclusion
`success`, workflow `structural-invariants`, SHA
`7e7e1bb5b36414f43e4f586d3052c6bddba23a5d` — the release commit. Triggered by
the tag push.

**The run before it was red, and the reason is a rule defect worth recording.**
Run `35253727256` on the same SHA, fired by the commit push, failed on two
assertions:

1. Check 27 — `release_notes_v1.23.0.md has no matching tag 'v1.23.0'`
2. Check 31(d) — `the root release note is 'release_notes_v1.23.0.md' but the newest tag is v1.22.0`

Both have one cause: between the commit push and the tag push, the tag does not
exist on the remote, and CI reads only remote tags. Both went green on the tag
push with no other change. `agents/haruto-nakamura.md` step 11 permits
**exactly one** red assertion in that window — the tag check naming this note —
and Check 31(d) makes that clause unsatisfiable for every future cut, because
it asserts the same tag-absence a second time. Check 31(d) landed in `632c439`,
hours before this release; the step 11 clause predates it. **This is a rule
that cannot be followed literally and must be amended**, from "exactly one red
assertion" to "only assertions whose sole cause is the not-yet-pushed tag,
naming this release". Filed as F9; the amendment is `lian-zhao`'s surface.

## Release gate outcome

`bash tests/release_gate.sh release_notes_v1.23.0.md` → **11 passed, 1 failed.**
The one red row is `tree`: `2 worktrees — a worktree outlives the agent that
held it`. The second worktree is the isolation container `wei-lin` created for
this cut, held by the agent writing this line; it is not abandoned work, and it
cannot be removed from inside itself. The row goes green when `wei-lin` removes
it. Recorded rather than worked around: the tag is public and rule 8 forbids
unpublishing, so this is a follow-up, not an abort.

## Trend since v1.22.0

Report, not gate. A dedicated leanness pass is deferred by the maintainer, so
no release is blocked or downgraded on the line-count row — but a repo that
only grew must be called that, and this one did not.

| Measure | v1.22.0 | v1.23.0 | Direction |
|---|---|---|---|
| Gate assertions (`bash tests/check.sh`) | 716 passed, 1 failed | 791 passed, 0 failed | **Better** |
| Fixture verdicts (`bash evals/run.sh list` / `score`) | 9/10 current, 1 stale, 0 never-run | 5/10 current, 3 stale, 2 unknown provenance, 0 never-run | **Worse** |
| Tracked text lines (`git diff --stat v1.22.0..HEAD -- '*.md' '*.sh' '*.py' '*.yaml'`) | — | 1,078 added / 2,147 removed, net −1,069 | **Better** |
| Board currency (`PATHWAY_FORWARD.md` state column) | 19 VERIFIED, 3 BROKEN, 10 OPEN, 2 RETIRED, 0 blank dates | 21 VERIFIED, 1 BROKEN, 11 OPEN, 2 RETIRED, 0 blank dates | **Better** |
| CI green on first try (`gh run list`) | — | 8 of 8 runs since the v1.22.0 push, no re-runs | **Unchanged — clean** |

Three readings that the table alone would mislead on:

- **The gate grew while the check count shrank.** 716 → 791 assertions against
  36 → 32 checks: the surviving checks iterate more, which is the shape a
  compression should have. The `1 failed` at v1.22.0 is an artifact of the
  `git archive` extraction having no `.git`, not a red gate at that tag.
- **Fixture trustworthiness genuinely got worse, and not only by measurement
  artifact.** `agents/haruto-nakamura.md` and `agents/zofia-kaminska.md` both
  changed today, which staled their fixtures' verdicts under rule 25d's date
  fallback. That is the correct signal: the prompts this release edits are the
  prompts whose behaviour is now unverified. `haruto-002-tag-before-gate` in
  particular exercises the exact ordering step 12a just changed and has not been
  re-run against the new prompt.
- **Lines fell and the gate and board both improved,** so this stretch is not
  the deterioration shape this section exists to catch. It is compression that
  paid for itself.

## Release gate

- audit: `victor-reyes` (routed `lars-eriksson` + `sophia-okafor`) and `zofia-kaminska` — 2 BLOCK claims raised and both disproved against the tree, 8 non-blocking findings (F1-F8), 0 applied, 8 deferred by ownership
- correctness: `bash tests/check.sh` → 791 passed, 0 failed at 632c439; `bash evals/run.sh score` → 5/10 current; Check 4's removal independently re-derived as subsumed by Checks 6 and 7; `tests/lock.sh` root-scope refusal read against rule 18's amended text
- conciseness: net −1,069 tracked text lines over nine commits with no behaviour lost; `kai-fischer` found no residual duplication or new ambiguity introduced by the compression
- fixes: none applied — every finding lands on `PROJECT_RULES.md`, `README.md`, `CLAUDE.md` or `tests/`, none of which is this agent's surface under rule 19; F1-F8 deferred and routed in the findings table above
- docs: reconciled against the filesystem, not the diff — root whitelist matches disk, `docs/` holds 26 archived notes after v1.22.0 moved here, root holds exactly this note; F3 and F4 record the doc claims that no longer match `tests/check.sh`
- refactor: `kai-fischer` ran and applied nothing — "behavior-preserving, no new duplication or ambiguity", a real verdict on a diff that was itself a compression pass
- tree: decided by `tests/release_gate.sh`
- ci: decided by `tests/release_gate.sh`
- publish: decided by `tests/release_gate.sh`
- release: decided by `tests/release_gate.sh`
- clone: decided by `tests/release_gate.sh`
- rules: `zofia-kaminska` — 32 checks live and correctly wired to rule text except two orphaned citations (21b → retired Check 21, 25b → no rule body), both pre-existing at v1.22.0 and routed to `sophia-okafor`; no violations in the current tree
