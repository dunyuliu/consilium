# Release notes — v1.17.0

**Date:** 2026-08-05
**Previous:** v1.16.0 (archived to `docs/`)
**Bump:** minor — two checks, and five defects found by probing claims in their
hard case

## 1. Summary of scope

Four commits. Every defect in this release was found the same way: **taking a
claim that had only ever been tested in its easy case and testing it in its hard
one.** None was found by the gate, and none would have been.

The pattern is worth naming, because it produced five defects in a row after
weeks of structural checks had produced none:

| claim | tested only as | tested as | result |
|---|---|---|---|
| "install reports what it did" | empty `~/.claude` | dirty `~/.claude` | reported 21 installed having installed **0** |
| "staging isolates the input" | plain files | a symlink | read the answer key straight through |
| "a case's criteria are executable" | pass and fail samples | an **empty** report | one word passed the precision fixture |
| "the lock scopes commits" | one acquire | two acquires | second scope silently discarded |
| "the scope guard narrows" | paths without spaces | a path with a space | silently **widened** |

Four of the five fail **open** — permissive, silent, and in the direction that
lets bad work through.

## 2. `install.sh` said it installed 21 agents having installed none

PF-010's clean-clone test installs into an empty `~/.claude`, which is the one
case where the count cannot be wrong. On a target already holding foreign
entries:

```
every target a foreign real file  →  "consilium installed: 21 agents"
                                     "21 item(s) skipped"
                                     links actually into the repo: 0
```

`ls "$CLAUDE/agents" | wc -l` counted every entry in the target directory —
skipped symlinks, refused real files, and hand-written agents that have nothing
to do with consilium. **The success line prints above the skip count**, so a
reader skimming sees the reassuring number and stops.

Now counts links that resolve into this checkout: all-foreign reports 0 of 21,
mixed reports 19 of 21 with 2 skipped, clean reports 21.

The **no-clobber claim itself holds** — a foreign symlink is skipped with
`points to /etc/hostname; use --force`, a real file with `real file exists;
refusing to replace`, `--force` replaces both and names what it replaced, and an
unrelated hand-written agent survives every run. That is why the count was worth
checking separately: the headline behaviour was right and the reporting was not.

## 3. Check 23 — a symlink in `input/` reads through the staging isolation

`stage` copies with `cp -R`, which copies a symlink **as a symlink**. An absolute
link therefore resolves from the staged copy back to whatever it names —
including the `case.yaml` one directory above `input/`.

Demonstrated: a probe case with `input/leak.md → <repo>/…/case.yaml` staged
cleanly, and reading it from `/tmp` printed the full `expected:` block. A second
link to `/etc/hostname` read the host's name. A *relative* link happened to break
— `../../case.yaml` from `/tmp/consilium-evals` resolves outside `/tmp` — but
that is luck, not containment.

**Refusing beats dereferencing.** `cp -RL` would inline the target's content into
the staged copy, leaking the same bytes while looking clean. `stage` now stops
with the offending path named, and Check 23 fails at commit time as well —
refusing at stage time is late, since the author would find out only when
somebody tried to run the case. It is the companion to Check 18: that one stops
the key being *written* inside `input/`, this stops it being *linked* there.

No existing case ships a symlink, so this was latent rather than active.

## 4. Check 24 — a one-word report passed the precision fixture

Every `must_not_find` guard is satisfied by an empty report: a report that says
nothing cannot contain a forbidden phrase. So a case is only as strong as its
**positive** criteria, and a weak one is passed by doing no work.

`lars-002` — the single fixture in this suite whose purpose is measuring whether
an agent **invents** defects — listed the bare word `"correct"` among its
expected terms:

```
report: "correct"
  PASS  keyword  (matched: correct)
  PASS  must_not_find
  PASS  must_not_find
PASS — 3 criteria, 0 failed
```

Saying nothing scored full marks on the precision test.

**This is the mirror of the guard defects of v1.13.0–v1.15.0.** Those were
criteria a *correct* report could not satisfy; this is criteria an *empty* one
could. Same structural error, opposite sign — and it took twelve releases of
looking at one side before the other was checked.

The term is removed (safe: `lars-002` has no recorded run, so no verdict is
invalidated). Check 24 grades an empty file against all 26 cases and requires a
non-PASS. Named narrowly: it cannot tell you a *weak* report fails — "how much
work does this show" is not mechanizable, and `lars-002` was found by hand.

## 5. Two `tests/lock.sh` defects, both failing open

**Re-acquiring your own lock with a different scope silently kept the old one.**
It printed `already held by you (a) — first` and exited 0 — wording and exit
status both reading as success — while discarding the scope just requested. The
caller then stages files in the scope it asked for and is refused by the hook
citing a scope it never chose.

This cost time repeatedly during this session's own work, where it read as the
rules being strict rather than as a defect. Rule 18 governs concurrent *writers*;
one writer adjusting its own scope is not a collision. It now reports
`scope UPDATED / was: agents/ / now: tests/`.

**A scope path containing whitespace silently widened the guard.** The scope is
stored as one space-separated line and the hook splits on whitespace, so
`evals/cases/a b/` became the two prefixes `evals/cases/a` and `b/`.
Demonstrated: with that scope declared, committing `b/anything.txt` — never in
scope by any reading — **succeeded**. Now refused at acquire time; the ambiguity
is in the storage format, and a guard that fails open is worse than one that
refuses to start.

Probed at the same time and **correct**: `release` with no lock is a benign
no-op, `release` by a non-holder is refused, `release --force` works and names
whose lock it took, a foreign holder still blocks `acquire`.

## 6. Also probed and found sound

Recorded so the ground is not re-covered: an empty report already failed all 26
cases; a nonexistent report errors cleanly; a binary report FAILs; every case has
at least one `expected` criterion; filenames with spaces and filenames beginning
with a dash stage correctly.

## 7. Verification

- `bash tests/check.sh` — **664 passed, 0 failed**.
- Check 23 negative-tested by linking `lars-001`'s own `case.yaml` into its
  `input/`.
- Check 24 negative-tested with a deliberately weak case.
- Both lock fixes verified after the change: the updated scope is honoured, a
  path outside it is still refused, a foreign holder still blocks `acquire`.
- CI green on the remote for `a84ee95`, `12aba24` and `e041e0e`.
- Every probe ran in a scratch clone with hooks installed under a sandboxed
  `HOME`. The real `~/.claude` was never touched.

## 8. Totals

| | v1.16.0 | v1.17.0 |
|---|---|---|
| Agents | 21 | 21 |
| Eval fixtures | 26 | 26 |
| Structural checks | 612 | **664** |
| Guards that fail open, known | 2 | **0** |

## 9. Open issues

1. **Seven of nine smoke members have no verdict** against the current prompt.
2. **`haruto-001` has no verdict** — its recorded PASS was leaked via its own
   `input/`.
3. **PF-013** — 18 of 21 tiers never tested by execution.
4. **PF-004** — precision unmeasured in the direction that matters. Check 24
   closes the *silence* half; the *invention* half still needs a human read.
5. **The pre-push and post-merge hooks** have never been probed the way
   `pre-commit` now has.

## 10. Assumptions

- Minor, not patch: two new checks and behavioural changes to `install.sh` and
  `tests/lock.sh`.
- `lars-002` was tightened, which rule 5 permits only because it has no recorded
  run; every other criteria change in this release was a loosening.
- No `--no-verify` bypass was used.
