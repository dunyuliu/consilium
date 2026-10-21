# Release notes — v1.29.7

## 1. Version and date
v1.29.7 — 2026-10-21. Patch (`release`): fourth inbox pass plus one audit-driven
fix round since v1.29.6, no agent roster or command surface change.

## 2. Summary of scope
Five commits since v1.29.6 (tag `ba0f7ac`): `b8973f9` (#175, the v1.29.6 CI/gate
transcription, docs-only), then four inbox-pass fixes `8701b20` (#176),
`cdac273` (#177), `bd769a4` (#179), `a7d486b` (#180) — each a prompt-wording
sharpening plus its matching fixture extension (rule 10), `agents/` +
`commands/` net 0 lines throughout. Plus this release's own audit round
(below), also net 0.

## 3. Files added / removed / renamed / cleaned up
- `docs/release_notes_v1.29.6.md` — archived from root (rule 8); never edited.
- `release_notes_v1.29.7.md` — this file, new at root.
- `agents/wei-lin.md`, `agents/anya-petrov.md` — word-level edits only (see
  §5); no lines added or removed.

## 4. Content updates to master documents
None. `PROJECT_RULES.md` and `PATHWAY_FORWARD.md` are unchanged this cut; no
board row was closed or opened by this release.

## 5. Audit findings and fixes
`victor-reyes` audited `v1.29.6 (ba0f7ac)..a7d486b` (the four inbox-pass
commits; `b8973f9` is a docs-only transcription of the prior, already-audited
release and was not re-opened). Verdict: **no blockers — 6 findings: 0
Critical, 2 Medium, 2 Low, 2 Advisory.** `tests/check.sh` at `a7d486b`: 1443
passed, 0 failed (confirmed independently by iris-vermeulen within the audit).

Fixed before the cut (prompt/owner-surface findings, applied by
`lian-zhao`, net 0 lines):
- **Medium** — `agents/wei-lin.md`'s landing-gate fresh clone required only "a
  bare `git clone` under `env -i`" with no scratch `HOME`, leaving open the
  exact loophole (`agents/haruto-nakamura.md`'s pre-tag clone was fixed
  against in #176/#179: a tool falling back to a real home directory skips its
  install and proves nothing). wei-lin's clause now requires
  `env -i HOME=<an empty scratch dir>` to match.
- **Low** — `agents/anya-petrov.md`'s cap-stop line read "checkpoint and
  stop" where every sibling agent carries the #180 clause requiring the
  report to be sent at the cap. Added the matching clause.
- **Advisory** — `agents/wei-lin.md` and `PROJECT_RULES.md`/
  `agents/haruto-nakamura.md` used "fix-forward" in two senses (a milestone
  not closed by one, vs. a red post-release row remedied by one). Reworded
  wei-lin's line to "never closed by a milestone fix-forward" to disambiguate;
  the rule book and haruto's file were not touched.

Deferred as open issues (fixture-design, not a prompt/owner-surface finding —
see §6):
- **Medium** — `evals/cases/haruto-004-clone-before-tag/case.yaml` criteria
  reference wording that lives only in `agents/wei-lin.md`, so the fixture
  cannot tell whether `agents/haruto-nakamura.md` itself changed.
- **Low** — `evals/cases/wei-017-general-purpose-design-open/case.yaml`'s
  keyword predates this release's edit; still discriminates correctly today,
  flagged for attention if the surrounding text moves again.
- **Advisory** — the `HOME=` substring criterion in haruto-004 is generic
  enough that an unrelated mention would satisfy it.

One claim in the audit's own aggregation was independently wrong and is noted
rather than carried forward: the dispatched reviewer's claim that
`commands/autopilot.md` changed in this range does not hold — `git
diff --name-only` over the range touches no file under `commands/`.

## 6. Remaining open issues or pending items
The three deferred fixture-design findings in §5, routed to `lian-zhao` /
`iris-vermeulen` surfaces, not fixed in this release.

## 7. Totals or cost changes
`agents/` + `commands/`: 5752 lines, unchanged (ceiling 5754, limit 5869). No
inbox-pass ledger rows this release — this is a release cut, not an inbox
pass.

## 8. Assumptions used
None beyond what the commands in this note produced, run directly against the
commits and SHAs named.

## 9. CI run this release was gated on
`<run id/URL, conclusion, SHA — recorded after the release PR's CI completes, step 11>`

## Trend since v1.29.6
- **Gate assertions.** `bash tests/check.sh` — v1.29.6 (`ba0f7ac`): 1433
  passed, 0 failed. v1.29.7 (release commit, staged tree): 1444 passed, 0
  failed. Better (more checks running, none failing).
- **Fixture verdicts.** `bash evals/run.sh list` / `score` at both commits:
  identical breakdown — 37 cases, 9 stale, 28 never-run, 0 passing/failing on
  a current-SHA sample, verdict currency 0/37 both times. Unchanged (expected:
  `run.sh` never dispatches an agent; currency only moves when a human
  re-grades a fixture).
- **Tracked text lines.** `git diff --cached --stat ba0f7ac -- '*.md' '*.sh'
  '*.py'` (repo's tracked text extensions) at the release commit: 32 files
  changed, +237/−42 (includes this note itself, ~130 new lines).
- **Board currency.** `PATHWAY_FORWARD.md` at both commits: 28 VERIFIED, 1
  BROKEN, 0 blank `last-checked`. Unchanged.
- **CI green-on-first-try rate.** `gh run list --limit 15` since v1.29.6's
  push (2026-10-20T21:20Z) through this release's cut: 15/15 runs listed
  `success`, no failed run visible in that window. Read with the caveat that
  `gh run list` lists each triggered run once and does not itself flag
  re-attempts of the same run; no re-run was issued by this release.

This section reports; it does not gate. Tracked lines grew (+237/−42, net
+195, of which ~130 is this note and the rest is inbox-pass prompt wording
plus fixture extensions) while the gate and fixture numbers moved in step or
stayed flat — no deterioration to call out.

## Work record
- audit: victor-reyes's report on `ba0f7ac..a7d486b` (quoted above) — 6
  findings, 0 Critical, 2 Medium, 2 Low, 2 Advisory, no blockers.
- correctness: the two Medium findings were real prompt-surface gaps (clone
  scratch-HOME parity, cap-report clause parity); both confirmed and fixed.
- conciseness: no refactor pass requested or run this release — word-level
  fixes only, net 0 lines; no simplification scope was opened.
- fixes: 3 applied (wei-lin clone wording, anya-petrov cap clause, wei-lin
  fix-forward wording), all net 0 lines, by lian-zhao. 3 deferred (fixture
  findings, §6).
- docs: PATHWAY_FORWARD.md and PROJECT_RULES.md checked against the
  filesystem this release touched; no drift found, nothing updated.
- refactor: not run — `kai-fischer` not dispatched; this release's diff is
  inbox-pass prompt wording plus three one-line audit fixes, no surface
  needing simplification was identified by the audit.
- rules: no `zofia-kaminska` pass run this release; `tests/check.sh` (the
  mechanical rule gate) is green, 1443 passed / 0 failed, at `a7d486b`
  (pre-cut) and re-confirmed at the final commit below.

## Release gate
- tree: `<filled at cut — clean, one worktree, no lock, level with upstream>`
- ci: `<filled after step 11>`
- publish: `<filled after step 10/12 — note version, tag, remote>`
- release: `<filled after step 12 — gh release view against the pushed tag>`
- clone: `<filled after the pre-tag stranger clone, step 11/12>`
