# Release notes — v1.18.0

**Date:** 2026-08-05
**Previous:** v1.17.0 (archived to `docs/`)
**Bump:** minor — five checks, and the discovery that five rules marked
"mechanical" had nothing enforcing them

## 1. Summary of scope

Four commits. One finding shaped the release: **`tests/check.sh` did not enforce
the rule book it claims to enforce.** Of the rules marked *mechanical* in
`PROJECT_RULES.md`, five had no mechanism at all — and one of them had already
been violated twice without anything noticing.

That was found by accident. Rule 13 turned out to have no check, which prompted
reading the whole index against the checks that exist. Nobody had done that
before; the tier column had been trusted as a description of reality rather than
read as a claim.

## 2. `pre-push` let you push a commit that deleted the gate

The hook body was wrapped in `if [ -f "$REPO/tests/check.sh" ]`, so a working
tree without the gate pushed silently with exit 0. **The change most certainly
guaranteed to bypass the gate was a commit that deleted it.**

Demonstrated in a sandbox clone with hooks installed: `mv tests/check.sh aside`,
commit, `git push` → `main -> main`, exit 0, no warning, nothing run.

A missing gate is not a passing gate (rule 2). It now refuses and names
`git push --no-verify` as the deliberate bypass. `HOOK_VERSION` is bumped to
`consilium-hook-v4` so existing installs replace the old body — **the first time
that marker has been needed** since it was introduced.

Probed at the same time and correct: a failing gate aborts the push; a tag-only
push runs the gate; a ref deletion runs the gate; `post-merge` is
`exec install.sh` whose exit status git ignores, so a missing installer is noisy
rather than damaging.

## 3. Five rules marked mechanical, with no mechanism

| rule | claim | was enforced by | now |
|---|---|---|---|
| 13 | an agent lands with a fixture | a board row's recorded number | **Check 25** |
| 7 | `input/` is read-only fixture data | "remember to run `git status`" | **Check 26** |
| 15 | a note plus a matching tag | me, by hand, after each release | **Check 27** |
| 8 | never delete evidence | nothing | **Check 28** |
| 14 | one installer, one canonical path | nothing | **Check 29**, in part |

**Rule 13** was enforced as a side effect of a number: a fixture-less agent would
have surfaced only because PF-014's recorded `# → 0` became `1` and Check 17
byte-diffs it. It also matched fixture to agent by the stem before the first
*hyphen* — `lars-eriksson` → `lars` → satisfied by `lars-001`. A second agent
named Lars would have been satisfied by somebody else's fixture. Check 25 matches
the exact `agent:` field every `case.yaml` already carries.

**Rule 7 had already been violated twice.** Its stated procedure is "`git status`
inside `evals/` must be clean after any eval run" — a thing a human remembers to
do. `__pycache__` directories were found inside `dunyu-001/input/` and
`lars-002/input/`, **untracked** and therefore invisible to `git status` on a
clean tree. They were spotted by eye while listing files for something else, and
removed by hand. They are proof that an agent was pointed at the case directory
rather than the staged copy — the read-only violation `stage` exists to prevent.
Check 26 fails on a generated artefact under any `input/`, tracked or not.

**Rule 15's command had been run by hand after every release of this session.**
That is exactly a rule that is mechanical in name and habit in practice, and
habits lapse silently.

**Rule 14 is only partly mechanizable, and the tier now says so** —
"mechanical (in part)". Check 29 enforces that no shell script but `install.sh`
touches the symlink directories. A second checkout competing for the same links,
or a user wiring something by hand, remains judgment. A label that overstates
what a check does is the same defect as no check at all, one step removed.

## 4. Two mistakes in the checks themselves, both caught before landing

**Check 29's first two drafts flagged `tests/check.sh`** — a checker matching
first its own comment, then its own grep pattern. Fixed by building the pattern
from pieces so the literal appears nowhere in the file, rather than by exempting
the file: an exemption would also have excused a genuine second installer that
happened to live there.

**Checks 27 and 28 needed the shallow-clone guard.** `actions/checkout` fetches
no tags by default, and that exact dependency turned CI red for twenty-two
commits when Check 17 landed. Both skip **by name**. Check 27 keys on
`git tag --list` being empty rather than on shallowness, because a full clone
fetched `--no-tags` is not shallow and still has no tags — the narrower guard
would have missed it.

## 5. Verification

- `bash tests/check.sh` — **739 passed, 0 failed**.
- All five checks negative-tested with the **expected failure line confirmed**,
  not merely that the check ran:
  - `kai-fischer: no eval fixture declares 'agent: kai-fischer' (rule 13)`
  - `kai-001…: /input/__pycache__ is a generated artefact inside fixture input`
  - `release_notes_v9.9.9.md has no matching tag 'v9.9.9'`
  - `release_notes_v1.0.0.md was deleted and exists in neither the root nor docs/`
  - `./tests/rogue.sh references the Claude symlink directories`
- Verified green on a `--depth 1 --no-tags` clone, where Checks 27 and 28 report
  themselves not checkable.
- CI green on the remote for `0610e56`, `f01e987`, `2a2245b` and `9496f74`.

**One negative test in this cycle was invalid and is recorded as such.** The
first attempt at Check 25 repointed `lars-001` at a fictitious agent — but
`lars-002` also names `lars-eriksson`, so the agent still had a fixture and
nothing fired. The check printed its header and that was nearly read as a pass.
A negative test that does not fail proves nothing.

## 6. Totals

| | v1.17.0 | v1.18.0 |
|---|---|---|
| Agents | 21 | 21 |
| Eval fixtures | 26 | 26 |
| Structural checks | 664 | **739** |
| Checks in `tests/check.sh` | 24 | **29** |
| Rules marked mechanical with no mechanism | 5 | **0** |

## 7. Open issues

1. **Seven of nine smoke members have no verdict** against the current prompt.
2. **`haruto-001` has no verdict** — its recorded PASS was leaked via its own
   `input/`.
3. **PF-013** — 18 of 21 tiers never tested by execution.
4. **PF-004** — precision unmeasured in the direction that matters.
5. **PF-009** — agent prompts have never been read as a set against their
   fixtures and roster lines. It is the only OPEN row needing no agent dispatch.

## 8. Assumptions

- Minor, not patch: five new checks and a behavioural change to the `pre-push`
  hook.
- `HOOK_VERSION` v4 means every existing clone replaces its `pre-push` on the
  next install. This repository's own hook was updated by writing the file
  directly, since running `install.sh` would have reconciled the real
  `~/.claude`.
- No `--no-verify` bypass was used.
