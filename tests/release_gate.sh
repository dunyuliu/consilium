#!/usr/bin/env bash
# tests/release_gate.sh — the twelve rows a release must satisfy (rule 15b).
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
#
# `release` and `clone` both sit right after `publish`, not at the end: each
# extends the same "is the published artifact real" question one step further
# than `publish` does. `publish` only checks that a tag exists, points at
# HEAD, and is on the remote — a tag is not a release a user can find. Check
# 35 asserts that every tag ON THE REMOTE has a GitHub Release, so it cannot
# speak for a tag that is still local: this gate runs mid-cut, before or just
# after the push, and `release` is the row that names the missing Release
# object for the tag being cut right now rather than leaving it to the next
# suite run. `clone` is what a
# brand-new user actually experiences once a Release exists, so it comes
# next; both belong beside the row they depend on rather than after `rules`,
# which is a human-judgement row about the project as a whole and has
# nothing to do with the published artifact.
ROWS=(audit correctness conciseness fixes docs refactor tree ci publish release clone rules)

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

# The `correctness` row gets a stricter check than the other six recorded
# rows. "audit: two findings, both fixed" is a verdict a reader can act on
# even though nothing forces it to be true; "correctness: looks fine" is
# worse than that, because a correctness pass is specifically a claim that
# something was RUN and checked, and "looks fine" is exactly as consistent
# with a pass that ran nothing as with one that ran everything. The other six
# rows describe judgement calls (was the audit thorough, did the refactor
# leave the system leaner) that have no artifact to cite even when done well;
# `correctness` is different because a real correctness pass almost always
# runs something with a name — a test command, a script, a query — and can
# name it. So: require, in addition to the 12-character floor `recorded()`
# already enforces, a backtick-delimited span of at least 3 characters inside
# the verdict, the shape of an inline code citation for the command that ran.
# This is a heuristic, not a proof — a verdict can fake a backtick span, and a
# real check can still be run against the wrong thing. It only closes the one
# gap this row exists to close: a verdict that cites nothing to run is
# indistinguishable from one that never ran anything, and now fails instead of
# passing on word count alone.
correctness_recorded() {
    local key="correctness" line
    line=$(grep -iE "^[-*] *${key}:" "$NOTE" 2>/dev/null | head -1 || true)
    if [ -z "$line" ]; then
        row_fail "$key" "no '${key}:' line in $(basename "$NOTE") — the pass is unrecorded, which is indistinguishable from unperformed"
        return
    fi
    local verdict; verdict=$(printf '%s' "$line" | sed "s/^[-*] *${key}: *//I; s/ *$//")
    if [ ${#verdict} -lt 12 ]; then
        row_fail "$key" "'${key}:' carries no verdict worth reading (\"$verdict\")"
        return
    fi
    if ! printf '%s' "$verdict" | grep -qE '`[^`]{3,}`'; then
        row_fail "$key" "'${key}:' does not cite a command it ran (\"$verdict\") — a correctness pass with nothing to point at is indistinguishable from one that checked nothing"
        return
    fi
    row_pass "$key" "$verdict"
}

recorded audit
correctness_recorded
for key in conciseness fixes docs refactor; do recorded "$key"; done

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
    publish_result=SKIP
else
    row_pass publish "v$ver pushed and pointing at ${sha:0:8}"
    publish_result=PASS
fi
: "${publish_result:=FAIL}"

# --- row 10: release — the tag has a GitHub Release, not only a git tag -----
# Degrades exactly the way row 8/ci does: SKIP without `gh`, never a silent
# pass and never a false fail for an environment problem. Also SKIPs (never
# fails) when `publish` did not pass, the same prerequisite pattern rows 8
# and 9 already use -- there is nothing to check a Release against until a
# tag is pushed.
if [ "$publish_result" != "PASS" ]; then
    row_skip release "row publish did not pass ($publish_result) — no pushed tag yet to check a Release against"
elif ! command -v gh >/dev/null 2>&1; then
    row_skip release "no gh CLI — read the releases page for v$ver by hand before treating this as published"
else
    rel_tag=$(gh release view "v$ver" --json tagName --jq '.tagName' 2>/dev/null || true)
    if [ "$rel_tag" = "v$ver" ]; then
        row_pass release "GitHub Release exists for v$ver"
    else
        row_fail release "no GitHub Release found for v$ver — the tag is pushed but the release page is empty (rule 15b)"
    fi
fi

# --- row 11: clone — the gate nobody else runs -------------------------------
# Depends on row 9/publish: there is nothing to clone until a tag is pushed,
# so this SKIPs (never fails, never passes silently) when publish did not
# pass — same pattern row 8/ci and row 9/publish already use for a
# prerequisite that does not exist yet (rule 2).
#
# When it can run: clone the pushed tag into a fresh, empty scratch HOME (not
# the real one — README's own install command targets ~/consilium, and
# running that literally against the operator's real home would clobber
# whatever is already there) and execute exactly what README.md documents:
# the fenced ```bash block under "## Install", then the next fenced ```bash
# block that follows it in the file, whatever that turns out to contain. Both
# are read from the README at runtime, never assumed, so a README edit changes
# what this row runs without anyone touching this script.
extract_readme_blocks() {
    # $1 = README path, $2 = output file for the Install section's bash block,
    # $3 = output file for the next bash-tagged block after it (skipping any
    # non-bash fenced blocks, e.g. the Layout tree, in between).
    awk -v oi="$2" -v of="$3" '
        BEGIN { state = 0 }
        state == 0 && /^## Install/          { state = 1; next }
        state == 1 && /^```bash/             { state = 2; next }
        state == 1                            { next }
        state == 2 && /^```/                 { state = 3; next }
        state == 2                            { print > oi; next }
        state == 3 && /^```bash/             { state = 4; next }
        state == 3 && /^```/                 { state = 5; next }
        state == 3                            { next }
        state == 4 && /^```/                 { state = 6; next }
        state == 4                            { print > of; next }
        state == 5 && /^```/                 { state = 3; next }
        state == 5                            { next }
        state == 6                            { next }
    ' "$1"
}

run_clone_row() {
    if [ "$publish_result" != "PASS" ]; then
        row_skip clone "row publish did not pass ($publish_result) — there is no pushed tag yet for a new user to clone"
        return
    fi

    local scratch
    scratch=$(mktemp -d) || { row_fail clone "could not create a scratch directory to clone into"; return; }
    trap 'rm -rf "$scratch"' RETURN

    local origin_url
    origin_url=$(git remote get-url origin 2>/dev/null || true)
    if [ -z "$origin_url" ]; then
        row_fail clone "no 'origin' remote configured — cannot resolve what publish claims is pushed"
        return
    fi

    local fake_home="$scratch/home"
    mkdir -p "$fake_home"

    local install_script="$scratch/install.sh" first_script="$scratch/first.sh"
    : > "$install_script"; : > "$first_script"
    # Pull the two blocks from THIS checkout's README first, only to find out
    # what commands to run — the commands themselves execute against the
    # cloned tag once we know the checkout dir, in case a future README moves
    # or renames its Install section between tags.
    extract_readme_blocks "$REPO_DIR/README.md" "$install_script" "$first_script"
    if [ ! -s "$install_script" ]; then
        row_fail clone "README.md's '## Install' section has no fenced \`\`\`bash block — nothing documented to run"
        return
    fi

    local install_log="$scratch/install.log"
    if ! ( cd "$fake_home" && HOME="$fake_home" bash -e "$install_script" ) >"$install_log" 2>&1; then
        row_fail clone "README's install block failed on a fresh clone of v$ver: $(tail -3 "$install_log" | tr '\n' ' ')"
        return
    fi

    # Locate the checkout the install block just produced. `git clone <url>
    # [dir]` is the only structural assumption made — the destination is
    # either the explicit last argument or git's own default (the URL's
    # basename, minus ".git"), never a hardcoded path.
    local clone_line target repo_dir
    clone_line=$(grep -m1 '^git clone' "$install_script" || true)
    if [ -z "$clone_line" ]; then
        row_fail clone "README's install block has no 'git clone' line — cannot locate the resulting checkout"
        return
    fi
    target=$(printf '%s' "$clone_line" | awk '{print $NF}')
    if printf '%s' "$target" | grep -qE '^([a-zA-Z]+://|[^/[:space:]]+@)'; then
        repo_dir="$fake_home/$(basename "$target" .git)"
    else
        case "$target" in
            "~"*) repo_dir="${fake_home}${target#\~}" ;;
            /*)   repo_dir="$target" ;;
            *)    repo_dir="$fake_home/$target" ;;
        esac
    fi
    if [ ! -d "$repo_dir" ]; then
        row_fail clone "README's install block ran clean but no checkout appeared at the expected path ($repo_dir)"
        return
    fi

    # README's own install command clones whatever branch is default on the
    # remote, not the tag by name — this row's job is "the pushed tag", so
    # confirm the two agree rather than assuming a default-branch clone is
    # the same commit. row `tree` and row `publish` already require HEAD to
    # be level with upstream and the tag to point at HEAD; if this still
    # disagrees, the default branch and the tag have diverged on the remote,
    # which is exactly the seam this row exists to catch.
    local cloned_sha
    cloned_sha=$(git -C "$repo_dir" rev-parse HEAD 2>/dev/null || true)
    if [ "$cloned_sha" != "$sha" ]; then
        row_fail clone "README's install clones ${cloned_sha:-<unreadable>} but tag v$ver points at ${sha:0:8} — the remote's default branch and its tag disagree"
        return
    fi

    if [ ! -s "$first_script" ]; then
        row_fail clone "no fenced \`\`\`bash block follows the Install section — no documented 'first command' to run"
        return
    fi

    local first_log="$scratch/first.log"
    if ! ( cd "$repo_dir" && HOME="$fake_home" bash -e "$first_script" ) >"$first_log" 2>&1; then
        row_fail clone "README's first documented command failed on a fresh clone of v$ver: $(tail -3 "$first_log" | tr '\n' ' ')"
        return
    fi

    row_pass clone "fresh clone of v$ver — README's install block and its first following command both exited 0"
}
run_clone_row

# --- row 12: rules — the rule book's own owner audited it -------------------
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
