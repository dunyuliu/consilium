# Release notes — v1.0.0 — 2026-05-14

## Summary of scope

Initial release of Consilium: a portable Claude Code customization kit providing
10 specialist subagents and 2 slash commands, installed via symlinks into `~/.claude/`.
This release also incorporates all fixes from the inaugural self-audit.

## Files added / removed / renamed / cleaned up

**Added**
- `agents/elena-hartmann.md` — Editor in Chief; holistic science manuscript review
- `agents/victor-reyes.md` — Audit orchestrator; routes technical work to specialists
- `agents/mary-chen.md` — Citation and scientific validity reviewer
- `agents/priya-nair.md` — Quantitative claim auditor (raw anchor data)
- `agents/lars-eriksson.md` — Code-level auditor (math bugs, edge cases, sign conventions)
- `agents/jordan-kim.md` — Data integrity auditor (extraction + pipeline)
- `agents/sophia-okafor.md` — Spec-vs-implementation drift auditor
- `agents/dev-nakamura.md` — Release and CI/CD engineer
- `agents/rafael-santos.md` — Physical validity checker (units, conservation, BCs)
- `agents/ingrid-lindqvist.md` — Mathematical rigor checker (derivations, stability, proofs)
- `commands/audit.md` — `/audit` slash command (8-section scientific project audit)
- `commands/release.md` — `/release` slash command (versioned release workflow)
- `scripts/install.sh` — Idempotent symlink installer
- `AUDIT.md` — Inaugural self-audit findings and fixes
- `README.md`, `LICENSE`
- `docs/` — Created for future release note archival

## Content updates to master documents

- `README.md` — Clone URL corrected from SSH (`git@github.com:…`) to HTTPS (`https://github.com/…`)
- `commands/release.md` — Step 4 made optional: skip `PROJECT_RULES.md` audit if file absent rather than halting
- `agents/victor-reyes.md` — Two path references to `commands/audit.md` updated to `~/.claude/commands/audit.md`
- `scripts/install.sh` — Removed dead `skills/` directory block (directory never existed, never documented)

## Audit findings and fixes

All four findings from `AUDIT.md` were resolved prior to this release:

| Finding | Fix applied |
|---|---|
| README clone URL was SSH; remote is HTTPS | Changed to HTTPS in `README.md:32` |
| `/release` halted if `PROJECT_RULES.md` absent | Made optional in `commands/release.md:26` |
| Dead `skills/` block in `install.sh:70–80` | Removed |
| `victor-reyes.md` referenced `commands/audit.md` by ambiguous relative path | Updated to `~/.claude/commands/audit.md` |

## Remaining open issues

None.

## Totals / cost changes

N/A — no numeric or financial data.

## Assumptions

- Project is a pure-text/shell repo; sections covering physics, numerics, and scaling in `AUDIT.md` are marked N/A.
- `docs/` directory is empty at this release; it exists solely for future release note archival.
