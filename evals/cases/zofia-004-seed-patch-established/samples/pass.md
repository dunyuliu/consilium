# Seed report — tideloader

## Inventory (Step 0)

- **PROJECT_RULES.md exists.** Five real, well-formed rules (station-ID
  normalization, UTC timestamps, `normalized/` as generated output, a
  regression-fixture rule, and a `pytest tests/` gate). This is an existing
  rule book, not an absent one — enhance, never revamp.
- **README.md exists**, user-facing, concise, with a real "Known issues"
  section. README.md is left alone; nothing here has become a design doc.
- **CLAUDE.md exists**, with build/test commands and real conventions.
  CLAUDE.md stays as is — nothing missing that the project needs to work
  from it.
- **No status board.** No `PATHWAY_FORWARD.md`, and no rival `TODO.md` or
  `STATUS.md` under another name either — this slot is genuinely absent.

## What I create

- `PATHWAY_FORWARD.md` — genuinely absent, seeded from the project's own
  already-known open issues rather than an empty template: the CSV importer
  doesn't validate encoding before parsing (README's "Known issues"), and
  Windows path handling is untested (also README's "Known issues"). Both
  land as P2 rows with the command that would settle them once one exists.

## What I patch, not replace

Two invariants this book does not have yet, added as **new rules starting at
rule 6** — never renumbering the existing 1-5:
- **Rule 6** — a living status board, prioritised (invariant 12 in the
  starter set), because this project currently has no record of its own open
  issues outside this README's static section.
- **Rule 7** — reference/golden data is read-only (invariant 7), because
  `tests/fixtures/` is exactly that kind of directory and nothing here says
  so yet.

Rules 1-5 are untouched, in their original numbering and wording.

## Dropped from the starter set

Invariant 6 (performance-number provenance) doesn't apply — this project has
no benchmarks. Invariant 9 (cheap-check-before-expensive-run) doesn't apply
either; there is no expensive run in this codebase to gate.
