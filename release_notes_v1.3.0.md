# Release notes — v1.3.0

**Date:** 2026-07-31
**Previous:** v1.2.0 (archived to `docs/`)
**Bump:** minor — a new gate check, a new rule, and a materially narrowed check

## 1. Summary of scope

Closes the remaining enforcement gaps from v1.2.0. Rule 12 is now fully
gated rather than half-gated, Check 5 no longer blocks on correct prose, and
the concurrency failure that produced v1.1.0's double-tag is written down as
a rule instead of living in a release note.

No agents or commands were added. This release is entirely about making the
existing rules real.

## 2. Content updates

- **`tests/check.sh` — new Check 7.** Every agent must have a README
  roster-table row (a table line whose first cell is the backticked agent
  name) and a Layout-tree line naming its file. Check 6 covered the model
  table; rule 12 names three artifacts and only one was gated.
- **`tests/check.sh` — Check 5 narrowed.** It now skips command stems and a
  short `NON_AGENT_TERMS` allowlist (`pre-push`, `post-merge`, `no-verify`).
  Two new helpers, `is_command` and `is_non_agent_term`. Previously any
  backticked one-hyphen token read as an agent reference, which blocked twice
  on correct prose during the v1.2.0 cycle.
- **`tests/check.sh` — header updated** to document checks 6 and 7 and why
  they exist.
- **`PROJECT_RULES.md` — new rule 18**, "One writer per repo — never run two
  mutating workflows at once," with the 2026-07-31 incident and the specific
  misdiagnosis that caused it.
- **`PROJECT_RULES.md`** — rule 12 updated to record full mechanical
  coverage; rule 17 documents the Check 5 allowlist and warns that every
  entry is a hole; rule 3's rationale corrected from "five structural
  invariants" to seven, enumerated.
- **`README.md`** — Tests section now names README-completeness among the
  invariants checked.

## 3. Audit findings and fixes

| # | Rule | Finding | Status |
|---|---|---|---|
| — | 12 | Roster row and Layout line unchecked; an agent in the model table but missing from its team roster passed the gate | **fixed** — Check 7 |
| — | 17 | Check 5 false-positived on `enforce-rules` and `pre-push`, blocking correct prose | **fixed** — command stems and allowlist skipped |
| — | 18 | The v1.1.0 concurrent-writer collision existed only as a release-note remark | **fixed** — codified as rule 18 |
| — | 11 | Rule 3's rationale and the README Tests section described five checks; there are seven | **fixed** |

## 4. Verification

- `bash tests/check.sh` — **159 passed, 0 failed** (v1.2.0: 119).
- **Negative-tested before landing**, each restored afterward:
  - dropped a roster row → `has no README roster-table row`
  - dropped a Layout line → `missing from the README Layout tree`
  - renamed a live reference to `ghost-agent` → still caught by the narrowed
    Check 5, confirming the allowlist did not blind it
- `install.sh` re-run — 20 agents, 18 commands.
- Release pushed through the pre-push hook with no `--no-verify` bypass.

## 5. Totals

| | v1.2.0 | v1.3.0 |
|---|---|---|
| Agents | 20 | 20 |
| Commands | 18 | 18 |
| Eval fixtures | 5 | 5 |
| Structural checks | 119 | **159** |
| Rules | 17 | **18** |
| Rules mechanically enforced | 5 | 6 |

## 6. Open issues

1. **Eval coverage** — 15 of 20 agents have no fixture. The largest remaining
   gap in the project.
2. **Rule 5 partly unenforceable** — fixture grading is by eye. A runner must
   invoke agents, which costs tokens and cannot run in free CI.
3. **Rule 17 gap** — agent-to-agent backtick references inside `agents/*.md`
   and `commands/*.md` bodies are still unchecked; only `README.md` is
   scanned. A rename breaks them silently.
4. **Rule 18 is judgment-tier** — nothing mechanically prevents two mutating
   workflows from running at once. A lock file would make it Tier 1.

## 7. Assumptions

- Minor, not patch: a new gate check and a new rule change what the repo
  enforces, which is functionality for a prompt library.
- Release note describes the post-audit filesystem, not the raw git diff.
