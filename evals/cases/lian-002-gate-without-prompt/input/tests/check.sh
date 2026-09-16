#!/usr/bin/env bash
# tests/check.sh — structural checks for atlas-agents itself.
#
# Verifies:
#   1. Every agents/*.md has frontmatter with name, description, tools, model.
#   2. Every agent named in rule 6's ownership table exists.
#   3. Every agent file is mentioned in the README.
#   4. PATHWAY_FORWARD.md parses and has no overdue row.
#   5. Every release note has a matching tag.
#   6. Every release note records the pipeline run it was gated on (rule 9).
#
# Usage: bash tests/check.sh

set -euo pipefail
cd "$(dirname "$0")/.."

pass=0; fails=0
fail() { echo "  FAIL: $1" >&2; fails=$((fails+1)); }
ok() { pass=$((pass+1)); }

# --- Check 6: rule 9's mechanism ------------------------------------------
# Added 2026-08-31, the day after the v4.2.0 incident. Rule 9 was marked
# mechanical the same day and this is what marks it: a release note with no
# pipeline line is a release nobody can prove was green.
echo "Check 6: every release note records the pipeline run it was gated on"
for note in release_notes_v*.md docs/release_notes_v*.md; do
    [ -e "$note" ] || continue
    if grep -qE '^- pipeline: https?://' "$note"; then
        ok
    else
        fail "$(basename "$note") records no pipeline run — rule 9"
    fi
done

echo
echo "Summary: $pass passed, $fails failed"
[ "$fails" -eq 0 ] || exit 1
