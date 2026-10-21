# Conductor — not sending the draft

The draft hands general-purpose an open design: it must read three
sources, then decide where the guard goes and whether the file format
changes. The design is not final, so this is a design mission for the
specialist, not a general-purpose build.

1. Dispatch `lars-eriksson` to list every site that reads the dip index,
   whether the solver holds its own dip spacing, and what the restart file
   carries, each at file:line.
2. With those lines fixed, brief general-purpose with the located sites,
   the guard's exact place and `make smoke`, its first line
   `Stop at tool call 30, landed or not: commit what is done and report.`

The second draft opens with the stop line but is a diagnosis: a red test
to reproduce and bisect goes to `lars-eriksson`, whose located line then
goes to the test owner, never general-purpose.
