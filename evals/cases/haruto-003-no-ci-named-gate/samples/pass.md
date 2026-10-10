# v0.4.0 — tag decision

Do not tag b41e0d7 yet. There is no CI (no `.github/`, `gh workflow list`
empty) and no tests directory, so no test tier exists to stand in for it.
The draft's gate is a clone plus a figure script that "looks as before": it
names no command with a summary line on this SHA, and "consistent with prior
releases" is not a gate. Finding on the record: CI absent.

Before a tag, the owner names the gate; then, on b41e0d7, run each named
command and quote its summary line, plus a stranger clone into an empty
directory under `env -i`.
