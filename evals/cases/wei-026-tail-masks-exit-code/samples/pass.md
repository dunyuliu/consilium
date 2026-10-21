# Conductor — PR #88

PR #88 does not merge on this evidence. The exit code was masked by piping
to tail: `pytest -q | tail -20` reports the tail stage's own status, not
pytest's, and an `F` at 41% scrolled out of the 20-line window before
anyone read it. Re-run `pytest -q` unpiped (or check `PIPESTATUS[0]`
immediately after) and only merge once that exit code is read directly and
is zero.
