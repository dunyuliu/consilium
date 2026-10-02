# Release notes — v1.27.0 — 2026-09-18

## 1. Version and date

**v1.27.0**, cut 2026-09-18 from `main` at the release commit, on top of
`v1.26.0` (`fa6f818c`). Minor bump: the release removes a live eval fixture, a
live check, and twelve rule-body blocks. Nothing is renumbered and no rule is
retired, but the shipped surface is materially different from v1.26.0's, which
is more than a patch carries.

## 2. Summary of scope

Eight untagged commits on top of `v1.26.0`. Four predate the campaign round
that closes here and ride along; four are the round itself — a three-part
slim-down of `evals/`, `tests/check.sh` and `PROJECT_RULES.md`, each removal
carrying a stated ground, plus a board close.

Net across the release: **186 insertions, 320 deletions** over 18 tracked text
files. Tracked repo total 19,547 → 19,227 lines.

| Commit | Surface | What |
|---|---|---|
| `dea2c9a` | `release_notes_v1.26.0.md` | corrected v1.26.0's CI and release-gate rows to the actual push/tag sequence |
| `0aab2e5` | `agents/*.md` | four v1.26.0 audit corrections (findings 1, 2, 5, 6), by `lian-zhao` |
| `0e1382c` | `PROJECT_RULES.md` | rule 19's "any of them may take it" replaced with a precedence, by `zofia-kaminska` |
| `7e79813` | `tests/check.sh` | Check 35 matches `github.com` at the host position, not as a substring, by `iris-vermeulen` |
| `f1289f6` | `evals/cases/*/case.yaml` | superseded reasoning aged out of every `notes:` block; `evals/` 4,869 → 4,768 |
| `7973539` | `tests/check.sh` | Check 5 merged into Check 8; 32 → 31 live checks; 1,399 → 1,379 lines |
| `b1b1ad8` | `evals/` | suite revised to claim only what it delivered; 10 → 9 cases; 4,768 → 4,557 |
| `0aa7f84` | `PROJECT_RULES.md`, `PATHWAY_FORWARD.md` | twelve per-rule `**Tier**` blocks folded into the Index Tier column; 1,036 → 984; PF-003/006/007 closed |

## 3. Files added / removed / renamed / cleaned up

- **Removed**: `evals/cases/haruto-001-missing-prior-notes/` in full (8 files,
  245 lines) — detection-only, never a valid verdict, never distinguished two
  reports. Its one real contribution, the 2026-07-31 answer-key leak, is banked
  in `evals/run.sh`'s isolation and in rule 5a, and the incident is still
  narrated in `evals/run.sh:14` and `evals/README.md:166`. Those references are
  history, not pointers to a live case; verified not dangling.
- **Renamed**: `release_notes_v1.26.0.md` → `docs/release_notes_v1.26.0.md`
  (`git mv`, rule 8 — archived, never deleted).
- **Added**: this note, at the repo root, as the only root release note
  (Check 31 c/d).
- No file added to the repo root beyond the note it whitelists.

## 4. Content updates to master documents

- **`PROJECT_RULES.md`** 1,036 → 984 lines. Twelve `**Tier**:` blocks and two
  inline `Tier:` phrases removed from rule bodies; where a block carried a
  reason the Index column did not, the reason was folded into that rule's index
  cell (16, 17, 18a, 19, 23, 28). Rule 8a's block is kept — it explains why its
  condition (1) is unreachable by `tests/check.sh` and names PF-031 as the
  unbuilt check, neither of which fits a cell. 42 rules before and after; one
  `**Tier` line remains, in rule 8a's kept block. One rule-25 corollary removed
  under ground (a), stated more precisely by 25e.
- **`PATHWAY_FORWARD.md`** PF-003, PF-006, PF-007 re-run and closed with their
  commands; 14 VERIFIED, 0 BROKEN, 0 blank last-checked dates — unchanged from
  v1.26.0.
- **`README.md`** one word: the eval machinery "works at nine cases" (was ten).
- **`evals/README.md`** scoring section rewritten around the renamed metric.

## 5. Audit findings and fixes

**Deliberate deviation, stated as such.** The conducting agent (`wei-lin`)
skipped both standing pre-milestone audits — `zofia-kaminska` Mode B and
`victor-reyes` — on the ground that the release's whole content is ~230 lines
of net removal across four files, that `zofia-kaminska` authored a quarter of
it hours earlier, and that a standing audit cycle over a removal-only diff is
the manufactured work this campaign exists to stop. This release therefore has
**one** audit: the release engineer's Phase 1 pass, recorded below. No
`victor-reyes` consolidated findings list exists for v1.27.0.

**This pass agrees the skip was the right call, with one qualification.** A
removal-only diff has one characteristic failure mode — the dangling reference
to something no longer on disk — and that mode is mechanical, not a judgement
call. It was swept for directly and found clean (below). A standing audit cycle
would have spent two dispatches re-reading subtractive content. The
qualification: the agreement rests on the sweep having been run, not on the
diff's shape alone. Had the sweep found a live dangling reference, the skip
would have been wrong and this release would have stopped.

**Phase 1 audit — release engineer, own pass, `PROJECT_RULES.md` + release
domain. Seven checks, seven clean, zero findings requiring a fix.**

| # | Claim audited | Command | Result |
|---|---|---|---|
| A1 | Gate green on the pristine pre-release tree | `bash tests/check.sh` | `Summary: 796 passed, 0 failed` |
| A2 | 31 live checks, Check 5 retired not renumbered | `grep -oE '^echo "Check [0-9]+' tests/check.sh` | 31 distinct: 1-3, 6-16, 18-20, 22-24, 26-36. 4, 5, 17, 21, 25 absent |
| A3 | 9 eval cases, list still runs | `ls evals/cases`; `bash evals/run.sh list` | 9 cases, all nine print a verdict line |
| A4 | `haruto-001` removal left no live pointer | `grep -rn haruto-001` excluding `docs/` | 4 hits, all historical prose in `evals/run.sh` and `evals/README.md`; no path reference to the deleted directory |
| A5 | `Check 5` removal left no live pointer | `grep -rn 'Check 5\b'` excluding `docs/` | 2 hits, both records of the merge (`PATHWAY_FORWARD.md:197`, `tests/check.sh:280`) |
| A6 | No stale count claim left in a root document | `grep -nE '[0-9]+ (checks\|fixtures\|cases\|agents)' README.md` | The one live sentence was updated to "nine cases"; the remaining three are dated narrative about the v1.22.0 cut, correct as history. v1.25.0's deferred README count findings (3 and 4) are already gone from the file |
| A7 | 42 rules, nothing renumbered | rule-index read, `git diff v1.26.0..HEAD -- PROJECT_RULES.md` | 42 before and after; no number moved; one corollary removed, one sentence replaced |

**Version and release-domain checks, also clean**: tree clean, one worktree, no
lock held, `main` level with `origin/main` at `0aa7f84`; every commit in range
carries a message that matches its diff; no debug flag, no floating dependency,
no placeholder text in the diff; `v1.27.0` does not exist locally or on the
remote.

**One correction to the brief, not a defect.** The commissioning brief listed
`b662eca` and `fa6f818` among the untagged pre-existing commits. Both are
ancestors of `v1.26.0` (`fa6f818` *is* the v1.26.0 release commit). The eight
untagged commits are those in §2; `0aab2e5`, unlisted in the brief, is one of
them. The release's content is what §2 states, not what the brief enumerated.

**Fixes applied this release: none.** Nothing the audit found needed one.
Nothing was deferred silently; the two open issues below were found by
`wei-lin` before this pass and are recorded, not fixed.

## 6. Remaining open issues or pending items

1. **PF-015's evidence command answers neither half of its claim.** The row is
   VERIFIED and claims two things — that the board's evidence commands are
   checked for shape (Check 12), and that no residue of the retired byte-diff
   mechanism (Check 17) remains. Its command,
   `grep -c 'section=evidence' tests/check.sh`, prints `0` and **exits 1**. For
   the second half a zero is the good answer; for the first half it is no
   evidence at all, and the non-zero exit makes the row's own verification
   indistinguishable from a broken command. Found by `zofia-kaminska`;
   `PATHWAY_FORWARD.md` is her surface; deliberately out of this release's
   scope. Reproduce: `grep -c 'section=evidence' tests/check.sh; echo $?` →
   `0`, `1`.
2. **`docs/release_notes_v9.9.9.md` is the fabricated note from the v9.9.9
   incident and is still tracked.** All three of rule 8a's conditions appear to
   hold — no `v9.9.9` tag exists locally or on `origin`. Rule 8a reserves the
   deletion to **the human maintainer only**, and neither `wei-lin` nor this
   pass will reason past that clause. The file stays; the maintainer decides.
   This pass did not re-verify condition (1) independently and does not claim
   to have.
3. **Five of nine fixture verdicts are stale and one has indeterminate
   provenance** — see §10. Expected: five graded prompts changed on 2026-09-18.
   Not closed, and closing it costs human dispatches, not a commit.

## 7. Totals or cost changes

| Measure | v1.26.0 | v1.27.0 |
|---|---|---|
| Tracked lines (`git ls-files \| xargs wc -l`) | 19,547 | 19,227 |
| `evals/` lines | 4,869 (at `f1289f6`'s parent) | 4,557 |
| `tests/check.sh` lines | 1,399 | 1,379 |
| `PROJECT_RULES.md` lines | 1,036 | 984 |
| Live checks | 32 | 31 |
| Eval cases | 10 | 9 |
| Agents / commands | 22 / 19 | 22 / 19 |
| Rules | 42 | 42 |
| Board rows VERIFIED / BROKEN / blank-dated | 14 / 0 / 0 | 14 / 0 / 0 |

Campaign context: 33,085 tracked lines at campaign start, 19,605 this morning,
19,227 here.

## 8. Assumptions used

- **The brief's state report was re-verified, not taken.** Tree cleanliness,
  `origin/main` at `0aa7f84`, the 796/0 gate, the lock being free, and the
  v1.26.0 note's root location were each re-read by command before use. The
  line counts in §7 were re-measured, not copied.
- **The four pre-existing commits were read, not audited to their own
  diffs.** Their messages were read in full and their subjects matched to the
  files they touch; this pass did not re-derive `iris-vermeulen`'s four Check 35
  negative tests or `lian-zhao`'s four v1.26.0 corrections. They were green in
  CI individually and are green in aggregate here.
- **A4 and A5 are grep sweeps over tracked text, excluding `docs/`.** Prior
  release notes legitimately name removed artifacts; a hit there is history, so
  `docs/` was excluded by design rather than overlooked.
- **The trend baseline was measured in a throwaway full clone at `v1.26.0`**,
  not in the working checkout, so no measurement mutated the tree. Its
  `bash tests/check.sh` reads 809, not the 806 v1.26.0's own note recorded: the
  clone was made after v1.26.0's tag was pushed, so the three per-tag Release
  assertions Check 35 adds for `v1.26.0` itself now exist. The comparison in
  §10 uses 809 as the honest same-conditions baseline and says so.
- **No refactor pass ran.** The maintainer capped this release's scope at what
  is already on `main`; see the `refactor:` line in §11 for what that means and
  does not mean.

## 9. CI run this release was gated on

Run **`35405748621`**, conclusion **success**, on SHA
`4f477d7cbce7450433e9a38b40323a47160e8b10` —
https://github.com/dunyuliu/consilium/actions/runs/35405748621. This is the
tag-push run; the commit-push run on the same SHA, **`35405677909`**
(https://github.com/dunyuliu/consilium/actions/runs/35405677909), concluded
**failure** on exactly and only the two rule-15a tag-absence assertions and
nothing else, quoted verbatim from its log:

```
FAIL: release_notes_v1.27.0.md has no matching tag 'v1.27.0' — a release note with no tag is not a release (rule 15)
FAIL: the root release note is 'release_notes_v1.27.0.md' but the newest tag is v1.26.0 — the current release's note belongs at the root and the older one in docs/ (rule 8)
Summary: 738 passed, 2 failed
```

Both went green the moment the tag reached the remote, with no code change
between the two runs — the same SHA, read twice. The tag was created only after
that red was read line by line and tied to the missing tag; nothing else was
failing.

**Structural residue, stated rather than faked.** A release note cannot carry
the id of the CI run for its own commit: the run does not exist until the note
is committed and pushed, and the SHA it runs against is determined by the note's
own bytes. Every release in this repo hits this. The sequence actually followed
here, and the rule-15a reading it satisfies:

1. This note is committed and the commit pushed **alone** — no `--tags`, no
   `--follow-tags`.
2. CI is read for that exact SHA and must be **green** before the tag is
   created. Nothing red is tagged; nothing is pushed on an in-progress run.
3. The tag is created on that commit and pushed on its own, then the GitHub
   Release is created from this file.
4. The run id, its conclusion and its SHA are transcribed into this section by
   a **follow-up commit** on top of the tag, which is the only commit in this
   release that is not itself tagged.

Step 4 has landed: the numbers at the head of this section were written by that
follow-up commit, and the tagged version of this file carried the disclosure
rather than a guess or a blank.

## 10. Trend since v1.26.0

Every row below is the output of a command run in this session, at both
commits. The v1.26.0 column comes from a full clone checked out at
`v1.26.0^{}` = `fa6f818c`.

| Measure | v1.26.0 | v1.27.0 | Direction |
|---|---|---|---|
| Gate assertions — `bash tests/check.sh` | `Summary: 809 passed, 0 failed` | `Summary: 796 passed, 0 failed` | **Fewer assertions, not worse.** −13 is arithmetic: one fixture removed (its per-case assertions) and Check 5's README scan merged into Check 8 (one assertion instead of two per file). Zero failures at both. |
| Fixture verdicts — `bash evals/run.sh list` / `score` | 10 cases, 3 current (30%), 6 stale, 1 unknown provenance, 0 never-run | 9 cases, 3 current (**33%**), 5 stale, 1 unknown provenance, 0 never-run | **Unchanged in substance.** The percentage rose only because the denominator lost a case that had no valid verdict; three current verdicts at both. The metric is also renamed and de-targeted this release ("verdict currency"), so the two numbers are not the same measure. |
| Tracked text lines — `git diff --stat v1.26.0..HEAD -- '*.md' '*.sh' '*.py'` | — | 18 files, **186 added / 320 removed, net −134** | **Better.** Second consecutive net-negative release. |
| Board currency — `PATHWAY_FORWARD.md` | 14 VERIFIED, 0 BROKEN, 0 blank dates | 14 VERIFIED, 0 BROKEN, 0 blank dates | **Unchanged**, and three of the fourteen (PF-003, PF-006, PF-007) were re-run against the new tree rather than carried. |
| CI green on first try — `gh run list` since v1.26.0's tag push | — | **8 of 8** pushes green, no re-run | Unchanged (was 14 of 14 at v1.26.0). |

**Reading, plainly.** Tracked lines fell and nothing else moved: no board row
rotted, no gate assertion failed, no fixture verdict was lost that had ever been
valid. Under this section's own standard that is not deterioration — the
line-count measure improved and the gate, fixture and board measures held flat
rather than declining to pay for it.

The honest caveat is that "held flat" is a weaker claim at 9 cases than at 10,
and a weaker claim at 31 checks than at 32. This release removed measurement
capacity along with prose: 13 fewer assertions and one fewer fixture. Each
removal carries a stated ground and each was argued as redundant or
never-binding, and this pass re-read both arguments and accepts them — but the
arguments are the evidence, not a run that proved the removed assertions
unreachable. The suite is smaller and equally green; whether it is equally
*sensitive* is inspected, not measured. Five stale verdicts sit under that same
gap. This section reports it; it does not gate on it.

## 11. Work record

- **audit**: release engineer's own Phase 1 pass, 7 checks (A1-A7, §5), **0
  findings**. `victor-reyes` and `zofia-kaminska` Mode B were deliberately
  skipped by `wei-lin` — ground in §5, and this pass states in §5 why it agrees.
  No consolidated multi-specialist findings list exists for v1.27.0, and this
  note does not pretend one does.
- **correctness**: `bash tests/check.sh` → `Summary: 796 passed, 0 failed`, run
  on the pristine tree at `0aa7f84` and again on the tagged tree. Seven checks
  this campaign was unsure of (13, 14, 20, 22, 23, 26, 36) were mutation-tested
  in `7973539` and every one reddened on its own failure state; this pass read
  that record and did not re-run the mutations.
- **conciseness**: the diff is 186 added / 320 removed and its entire subject is
  leanness — there is nothing in it to trim. Assessed by this pass by reading
  the diff; not independently verified by another agent.
- **fixes**: **none applied** — the audit found nothing needing one. Two items
  found before this pass are deferred and recorded as open issues §6.1 (PF-015,
  `zofia-kaminska`'s surface) and §6.2 (`docs/release_notes_v9.9.9.md`, reserved
  to the human maintainer by rule 8a). Neither was fixed inside this release's
  scope, by instruction.
- **docs**: reconciled against the filesystem, not the diff. Root read with
  `ls`/`git ls-files` and matched to rule 1's whitelist (one release note at the
  root, this one, matching the newest tag). Counts in §7 read off disk:
  22 agents, 19 commands, 31 live checks, 9 fixtures, 42 rules, 14 VERIFIED
  board rows. `README.md`'s remaining fixture-count sentences were read and
  confirmed to be dated narrative, not live claims.
- **refactor**: **`kai-fischer` did not run this release.** The maintainer
  explicitly capped scope at what is already on `main` and forbade further
  slimming, and the release's own content is three rounds of removal already
  argued and landed. This pass assessed the diff's leanness inline (see
  `conciseness:`) and found nothing to route to him. This is a step that did not
  happen with a stated reason — not a "nothing needed" verdict from him.
- **rules**: **`zofia-kaminska` did not run a fresh pass for this cut.** She
  authored `0aa7f84` and `0e1382c` in this release and declined, with reasons,
  the proposed retirement of rule 25's eight-corollary structure — that refusal
  is part of this release's content and is recorded here rather than reopened.
  This pass verified mechanically what her Mode B would have read first: 42
  rules, no number moved, no rule retired, the Index Tier column populated for
  every rule whose body block was removed, and rule 8a's block correctly kept.
  No tier split, violation list, or unenforceable-rule verdict was produced this
  release, because no rules audit ran.

## Release gate

`bash tests/release_gate.sh release_notes_v1.27.0.md` at the tag, after the
GitHub Release was created: **5 passed, 0 failed, 0 skipped**, exit 0.
Transcribed verbatim.

- tree: PASS — clean, one worktree, no lock, level with upstream
- ci: PASS — green on `4f477d7c` (run `35405748621`, the tag-push run)
- publish: PASS — v1.27.0 pushed and pointing at `4f477d7c`
- release: PASS — GitHub Release exists for v1.27.0,
  https://github.com/dunyuliu/consilium/releases/tag/v1.27.0
- clone: PASS — fresh clone of v1.27.0; README's install block and its first
  following command both exited 0

`bash tests/check.sh` at the tag: `Summary: 799 passed, 0 failed` (796 at the
pristine pre-release tree; the +3 are Check 35's per-tag Release assertions for
v1.27.0 itself).

The tagged version of this file carried five `transcribed by the follow-up
commit` rows in place of these five; the follow-up commit named in §9 replaced
them. No row was ever left blank, guessed, or written before the gate printed
it.
