#!/usr/bin/env bash
# Mechanical checks for the rules that have one.
set -euo pipefail
fails=0

# Rule 1 — the Makefile carries both entry points.
for target in build test; do
    grep -qE "^${target}:" Makefile || { echo "rule 1: no '${target}' target in Makefile"; fails=1; }
done

# Rule 5 — no config access inside the numerical routines.
if grep -rn 'cfg\[' pipeline/solver.py 2>/dev/null; then
    echo "rule 5: solver.py reaches into the config dict"; fails=1
fi

exit "$fails"
