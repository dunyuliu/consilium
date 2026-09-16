#!/usr/bin/env bash
# tests/release_gate.sh — the ten rows a release must satisfy (rule 15b).
#
# Run by `haruto-nakamura` before the tag is pushed, and by `wei-lin` before a
# milestone opens on top of a release. Exit 0 means the release may be tagged.
#
# OWNERSHIP. This file is `iris-vermeulen`'s surface under rule 19, not the
# release engineer's. A gate owned by the agent it judges is not a gate — the
# same reason rule 20 has the merge judged by someone other than the author.
# Haruto runs it and reads it; he does not edit it to get past it.
#
# WHY A SCRIPT AND NOT A LONGER PROMPT. A release step written only in prose is
# satisfied by an agent believing it did the step. Ten items had accumulated
# that way — audit, correctness, conciseness, fixes, docs, refactor, clean
# tree, CI, publication, rule book — and exactly three of them were checked by
# anything. This script draws the line between what can be decided mechanically
# and what can only be RECORDED, and refuses both kinds when they are absent:
#
#   * Rows 7, 8, 9 are decided here. The tree, the CI conclusion, the
#     publication state — all readable, so no verdict is taken on trust.
#   * Rows 1-6 and 10 cannot be decided by a script: no program judges whether
#     an audit was thorough or a refactor left the system leaner. What IS
#     decidable is whether the pass happened and produced a verdict, so the
#     release note must carry a line for each, and a missing line fails the
#     gate. Quality stays a reader's judgement; the ABSENCE of the work stops
#     being invisible.
#
# Network-dependent rows report SKIP with the reason and do not pass silently
# (rule 2). A skipped row is a release the human decides on, not one the script
# waves through — the summary says so and the exit code stays 1 unless every
# skip was explicitly accepted with --accept-skips.
#
# Usage:
#   bash tests/release_gate.sh <release-note-path> [--accept-skips]
#
# Exit: 0 all rows pass; 1 any row fails, or a row skipped without
#       --accept-skips; 2 usage error.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_DIR"

NOTE="${1:-}"
ACCEPT_SKIPS=0
[ "${2:-}" = "--accept-skips" ] && ACCEPT_SKIPS=1

if [ -z "$NOTE" ]; then
    echo "usage: bash tests/release_gate.sh <release-note-path> [--accept-skips]" >&2
    exit 2
fi
if [ ! -f "$NOTE" ]; then
    echo "FAIL  note        $NOTE does not exist — the note is the record every recorded row lives in" >&2
    exit 1
fi

# ROW KEYS. Check 33 asserts this list matches the release-note schema in
# agents/haruto-nakamura.md exactly, in this order. A row added here and not
# there is a gate nobody documented; a row there and not here is a promise
# nothing enforces.
ROWS=(audit correctness conciseness fixes docs refactor tree ci publish rules)

pass=0; failed=0; skipped=0
row() { printf '%-5s %-11s %s\n' "$1" "$2" "$3"; }
row_pass() { pass=$((pass+1)); row PASS "$1" "$2"; }
row_fail() { failed=$((failed+1)); row FAIL "$1" "$2"; }
row_skip() { skipped=$((skipped+1)); row SKIP "$1" "$2"; }

# A recorded row: the note carries "- <key>:" followed by something. An empty
# verdict is the same as no verdict, and "n/a" must be spelled out with a
# reason rather than left blank.
recorded() {
    local key="$1" line
    line=$(grep -iE "^[-*] *${key}:" "$NOTE" 2>/dev/null | head -1 || true)
    if [ -z "$line" ]; then
        row_fail "$key" "no '${key}:' line in $(basename "$NOTE") — the pass is unrecorded, which is indistinguishable from unperformed"
        return
    fi
    local verdict; verdict=$(printf '%s' "$line" | sed "s/^[-*] *${key}: *//I; s/ *$//")
    if [ ${#verdict} -lt 12 ]; then
        row_fail "$key" "'${key}:' carries no verdict worth reading (\"$verdict\")"
    else
        row_pass "$key" "$verdict"
    fi
}

for key in audit correctness conciseness fixes docs refactor; do recorded "$key"; done

# --- row 7: tree — the anchor the next milestone starts from ----------------
tree_problems=()
[ -n "$(git status --porcelain 2>/dev/null)" ] && tree_problems+=("uncommitted or untracked files")
wt=$(git worktree list 2>/dev/null | wc -l | tr -d ' ')
[ "$wt" != "1" ] && tree_problems+=("$wt worktrees — a worktree outlives the agent that held it")
[ -f .git/consilium.lock ] && tree_problems+=("repo lock still held (tests/lock.sh status)")
if git rev-parse --abbrev-ref '@{upstream}' >/dev/null 2>&1; then
    [ -n "$(git log '@{upstream}'..HEAD --oneline 2>/dev/null)" ] && tree_problems+=("commits not pushed to upstream")
else
    tree_problems+=("no upstream — local and remote cannot be compared")
fi
if [ "${#tree_problems[@]}" -eq 0 ]; then
    row_pass tree "clean, one worktree, no lock, level with upstream"
else
    row_fail tree "$(IFS='; '; echo "${tree_problems[*]}")"
fi

# --- row 8: ci — green on the exact SHA being tagged (rule 15a) -------------
sha=$(git rev-parse HEAD)
if ! command -v gh >/dev/null 2>&1; then
    row_skip ci "no gh CLI — read the run for ${sha:0:8} by hand before tagging"
else
    concl=$(gh run list --commit "$sha" --limit 1 --json conclusion \
            --jq '.[0].conclusion' 2>/dev/null || true)
    case "$concl" in
        success)  row_pass ci "green on ${sha:0:8}" ;;
        "")       row_skip ci "no run found for ${sha:0:8} — push the commit and let CI start" ;;
        null)     row_fail ci "run for ${sha:0:8} has not concluded — poll it, do not tag on an in-progress run" ;;
        *)        row_fail ci "run for ${sha:0:8} concluded '$concl'" ;;
    esac
fi

# --- row 9: publish — the note's version, the tag, and the remote agree -----
ver=$(basename "$NOTE" | sed -n 's/^release_notes_v\(.*\)\.md$/\1/p')
if [ -z "$ver" ]; then
    row_fail publish "$(basename "$NOTE") is not named release_notes_v<X.Y.Z>.md, so no tag can be derived from it"
elif ! git rev-parse "v$ver" >/dev/null 2>&1; then
    row_fail publish "no local tag v$ver for this note (rule 15: a note with no tag is not a release)"
elif [ "$(git rev-parse "v$ver^{commit}")" != "$sha" ]; then
    row_fail publish "tag v$ver does not point at HEAD — the note describes a tree the tag does not"
elif ! git ls-remote --tags origin "refs/tags/v$ver" 2>/dev/null | grep -q .; then
    row_skip publish "v$ver is local only — push it after row ci is green, then re-run"
else
    row_pass publish "v$ver pushed and pointing at ${sha:0:8}"
fi

# --- row 10: rules — the rule book's own owner audited it -------------------
recorded rules

echo
echo "release gate: $pass passed, $failed failed, $skipped skipped"
if [ "$failed" -gt 0 ]; then
    echo "a release is never cut over a red gate — repair and re-run, or abort" >&2
    exit 1
fi
if [ "$skipped" -gt 0 ] && [ "$ACCEPT_SKIPS" -eq 0 ]; then
    echo "skipped rows are undecided, not passed — re-run once decidable, or accept them explicitly with --accept-skips and say why in the note" >&2
    exit 1
fi
exit 0
