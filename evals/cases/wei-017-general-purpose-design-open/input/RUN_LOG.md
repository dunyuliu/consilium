# Run log — conductor

Tool calls this run, summed over resumes: 22.

## Owner request (verbatim)
"/autopilot 8h, clear the board"

## Board (surface: restart)
| Row | Pri | What | State |
|---|---|---|---|
| R6 | P1 | the full tier is red on one restart test that passes alone; an earlier test leaves state behind | OPEN |
| R5 | P2 | a coupled restart with a dip spacing unlike the strike spacing misaligns the fault grid silently; stop it loudly at restart read | OPEN |

## Notes
- `src/restart_io.f90` indexes the dip coordinate with the strike spacing
  at four sites. Whether the solver holds its own dip spacing anywhere is
  unknown; the restart file's metadata has never been listed.
- No agent in the roster owns routine builds in this repo.

## Drafted dispatch (not yet sent)
To: general-purpose, isolation worktree.
"Read `src/globals.f90`, `src/read_input.f90` and the restart file's
metadata, decide where the guard belongs and whether the file needs a
new attribute to carry the spacing, then implement it with a test.
Gate: `make smoke`. Open a PR; do not merge."

## Drafted dispatch 2 (not yet sent)
To: general-purpose, isolation worktree.
"Stop at tool call 30, landed or not: commit what is done and report.
Reproduce the full-tier failure in `tests/test_restart_roundtrip.py`,
bisect which earlier test leaves state behind, and fix it.
Gate: `make full`. Open a PR; do not merge."
