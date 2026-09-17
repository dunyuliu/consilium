# Session log — autopilot, 2026-09-16 — release robustness (compressed)

**Compressed 2026-09-17 under the session-log end-of-life path** (defined in
`docs/SESSION_LOG_2026-09-16_pf-003-first-real-dispatches.md`): a log is
compressed once the release carrying its findings is cut. v1.21.0 and v1.22.0
are both cut and PR #16 is merged, so everything below except the last section
is history. Full text at `fd47ddb`:
`git show fd47ddb:docs/SESSION_LOG_2026-09-16_autopilot-release-robustness.md`.

## Findings, and where each landed

- Check 27 deadlock (gate blocked its own fix) — grace keyed to tree state, not
  wall-clock; `8c7717e`. Generalised into rule 28.
- Stranger-clone gate, `correctness` row tightened — `tests/release_gate.sh`.
- Per-release trend eval — release-note schema, `agents/haruto-nakamura.md`.
- GitHub Release gap (23 tags, no Release objects) — workflow step 12a, Check 35.
  Its autonomous carve-out and the matching grace both came back out 2026-09-17
  after the gap recurred twice; see that days landings.
- `commands/*.md` had no owner in rule 19s table — row added.
- PF-003s four never-run fixtures dispatched and graded (`lian-002` FAIL 3/6,
  `selin-001` FAIL 6/9, `wei-lin-002` PASS 4/4 with a precision miss the
  mechanical grade cannot see, `zofia-003` FAIL 6/7); verdicts in each
  `case.yaml`. `wei-lin-002` and `lian-002` were among the fixtures retired in
  v1.22.0.
- Merge-boundary refusal: three layers correctly refused to widen wei-lins
  autonomous authority on an agent-relayed instruction. Resolved 2026-09-17 by a
  direct maintainer grant, encoded in `agents/wei-lin.md`.

## Not landed anywhere — still live

- A tree-wide `git checkout <ref> -- .` inside a worktree holding another
  agents uncommitted diff clobbered it (recovered in full). Use a disposable
  clone to test against a real tag. No rule, check or prompt carries this.
