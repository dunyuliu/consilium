#!/usr/bin/env bash
# tests/lock.sh — one writer per repo (PROJECT_RULES.md rule 18).
#
# A mutating workflow (a release, a merge, a multi-file refactor) takes the
# lock for its duration. The pre-commit hook installed by install.sh refuses
# a commit from anyone else while it is held.
#
#   export CONSILIUM_LOCK_OWNER=wei-lin        # who you are
#   bash tests/lock.sh acquire "release v1.7.0" [path-prefix ...]
#   ... do the work ...
#   bash tests/lock.sh release
#
#   bash tests/lock.sh status            # who holds it, and are they alive
#   bash tests/lock.sh release --force   # clear a lock you did not take
#
# Why a file and not an advisory note: on 2026-07-31 the v1.1.0 release was
# cut by hand while a dispatched release agent was still running. Both wrote
# tags to the same repo seconds apart. The tags happened to be correct — the
# good outcome was luck, and luck is not a merge strategy.
#
# Ownership is an OWNER LABEL, not a pid. The first version of this script
# stored $$ and checked liveness — and the lock read as stale the instant it
# was taken, because $$ is the pid of the short-lived lock.sh shell itself.
# Agents issue each command in a fresh shell, so no pid outlives the work it
# is supposed to protect. Found by running it (rule 0).
#
# A lock is NEVER auto-cleared, however old. "Probably stale" is exactly the
# reasoning that produced the incident: an agent was assumed dead because a
# task list looked empty, and it was very much alive.
#
# SCOPE. Optional path prefixes after the description declare what the holder
# intends to touch; the pre-commit hook then refuses a commit that stages
# anything outside them. This exists because the lock alone did not prevent
# the v1.10.0 incident: the lock stops OTHER writers from committing, and does
# nothing about the holder running `git add -A` and swallowing an author
# agent's half-written files. Six of them shipped inside a tagged release
# whose notes did not mention them. Guarding "who may commit" is not the same
# as guarding "what may be committed".

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LOCK="$REPO_DIR/.git/consilium.lock"

OWNER="${CONSILIUM_LOCK_OWNER:-${USER:-unknown}}"

age_of() {  # minutes since the ISO timestamp on line 3
    local then now
    then=$(date -u -d "$1" +%s 2>/dev/null) || { echo "?"; return; }
    now=$(date -u +%s)
    echo $(( (now - then) / 60 ))
}

case "${1:-status}" in

acquire)
    what="${2:-}"
    if [ -z "$what" ]; then
        echo "usage: lock.sh acquire \"what you are doing\" [path-prefix ...]" >&2
        exit 2
    fi
    shift 2 || true
    scope="$*"
    # A path containing a space cannot be represented. The scope is stored as one
    # space-separated line and the pre-commit hook splits it on whitespace, so
    # `evals/cases/a b/` becomes the two prefixes `evals/cases/a` and `b/` — and
    # the guard then ACCEPTS `b/anything`, which was never in scope. Demonstrated
    # 2026-08-05: a commit of `b/anything.txt` under that scope succeeded. The
    # guard fails OPEN, which is the wrong direction, so refuse the input rather
    # than silently widen.
    for p in "$@"; do
        case "$p" in *[[:space:]]*)
            echo "REFUSED: scope path '$p' contains whitespace." >&2
            echo "  The scope is one space-separated line and the pre-commit hook splits on" >&2
            echo "  whitespace, so such a path would silently widen the guard rather than" >&2
            echo "  narrow it. Rename the path, or lock a parent directory instead." >&2
            exit 2 ;;
        esac
    done
    if [ -f "$LOCK" ]; then
        holder=$(sed -n '1p' "$LOCK"); desc=$(sed -n '2p' "$LOCK"); when=$(sed -n '3p' "$LOCK")
        if [ "$holder" = "$OWNER" ]; then
            # Re-acquiring your own lock used to print "already held by you" and
            # exit 0 while DISCARDING the newly requested scope. Exit 0 plus that
            # wording reads as success, so the caller stages files in the scope it
            # asked for and is refused by the hook with a scope it never chose.
            # Rule 18 governs concurrent WRITERS; one writer adjusting its own
            # scope is not a collision, so update it and say so.
            old_scope=$(sed -n '4p' "$LOCK")
            if [ "$scope" != "$old_scope" ]; then
                printf '%s\n%s\n%s\n%s\n' "$OWNER" "$what" \
                    "$(sed -n '3p' "$LOCK")" "$scope" > "$LOCK"
                echo "already held by you ($OWNER) — scope UPDATED"
                echo "  was:  ${old_scope:-<unrestricted>}"
                echo "  now:  ${scope:-<unrestricted>}"
                exit 0
            fi
            echo "already held by you ($OWNER) — $desc"
            exit 0
        fi
        echo "REFUSED: held by '$holder' for $(age_of "$when") min — $desc" >&2
        echo "  Rule 18: wait for it, or stop it explicitly and confirm it stopped." >&2
        echo "  If you are certain it is gone: bash tests/lock.sh release --force" >&2
        exit 1
    fi
    printf '%s\n%s\n%s\n%s\n' "$OWNER" "$what" "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$scope" > "$LOCK"
    echo "acquired by '$OWNER' — $what"
    if [ -n "$scope" ]; then
        echo "  scope: $scope (pre-commit refuses anything staged outside this)"
    else
        echo "  scope: UNRESTRICTED — no path prefixes given." >&2
        echo "  If any author agent is live, declare a scope; \`git add -A\` will" >&2
        echo "  otherwise sweep their in-flight files into your commit." >&2
    fi
    ;;

release)
    if [ ! -f "$LOCK" ]; then
        echo "no lock held"
        exit 0
    fi
    holder=$(sed -n '1p' "$LOCK"); desc=$(sed -n '2p' "$LOCK")
    if [ "${2:-}" != "--force" ] && [ "$holder" != "$OWNER" ]; then
        echo "REFUSED: lock belongs to '$holder' — $desc" >&2
        echo "  Releasing another writer's lock mid-run is the collision itself." >&2
        echo "  Use --force only after confirming that writer has stopped." >&2
        exit 1
    fi
    rm -f "$LOCK"
    echo "released (was '$holder' — $desc)"
    ;;

status)
    if [ ! -f "$LOCK" ]; then
        echo "free"
        exit 0
    fi
    holder=$(sed -n '1p' "$LOCK"); desc=$(sed -n '2p' "$LOCK"); when=$(sed -n '3p' "$LOCK")
    sc=$(sed -n '4p' "$LOCK")
    echo "HELD by '$holder' for $(age_of "$when") min (since $when) — $desc"
    [ -n "$sc" ] && echo "  scope: $sc" || echo "  scope: unrestricted"
    ;;

*)
    echo "usage: lock.sh {acquire \"what\"|release [--force]|status}" >&2
    exit 2
    ;;
esac
