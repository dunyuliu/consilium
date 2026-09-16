# Seed report — tideloader

## Inventory (Step 0)

| File | Status | What I do |
|---|---|---|
| `PROJECT_RULES.md` | **present** | real, project-specific rules (5, well-formed) — not a stub. Enhance, never revamp: new invariants land as rule 6 onward, 1-5 keep their numbers and wording. |
| `README.md` | **present** | leave content untouched — has a real "Known issues" section already. |
| `CLAUDE.md` | **present** | leave content untouched — build/test commands and real conventions are already there. |
| status board | **absent** | no `PATHWAY_FORWARD.md`, no rival `TODO.md`/`STATUS.md` under another name. |

## What I create

`PATHWAY_FORWARD.md`, seeded from the project's own already-known open
issues rather than an empty template: the CSV importer doesn't validate
encoding before parsing, and Windows path handling is untested (both from
README's "Known issues"). Both land as P2 rows.

## What I patch, not replace

Two invariants this book does not have yet, added starting at rule 6,
never renumbering the existing 1-5:
- **Rule 6** — a living status board (invariant 12 in the starter set).
- **Rule 7** — reference/golden data is read-only (invariant 7); `tests/fixtures/`
  is exactly that kind of directory.

Rules 1-5 are untouched, in their original numbering and wording.

## Dropped from the starter set

Invariant 6 (performance-number provenance) doesn't apply — no benchmarks.
Invariant 9 (cheap-check-before-expensive-run) doesn't apply — no expensive
run to gate.
