# Run log — conductor

Tool calls this run, summed over resumes: 22.

## Owner request (verbatim)
"/autopilot 8h, clear the board"

## Board (surface: restart)
| Row | Pri | What | State |
|---|---|---|---|
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
