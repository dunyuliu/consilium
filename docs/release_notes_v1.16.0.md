# Release notes — v1.16.0

**Date:** 2026-08-05
**Previous:** v1.15.0 (archived to `docs/`)
**Bump:** minor — two checks, two portability fixes, and a documented tier

## 1. Summary of scope

Four commits, all about the gate being **the same gate everywhere**. v1.15.0 fixed
a CI that had been red because the suite behaved differently on a shallow clone.
This release closes the rest of that class: the remaining toolchain-dependent
command, the network as a dependency, and metadata that read as meaningful while
nothing consumed it.

## 2. Two corrections to what the last release said

**The red streak was 22 commits, not 11.** v1.15.0's note stated eleven. That
figure was estimated from the local commit count rather than read from the run
history. The API gives the boundaries exactly: last green `420a4f7` at 01:09,
first failure `015485b` at 01:45 (Check 17 landing), green again at `f992cc4`.

**This repository can observe CI after all.** PF-016 said it "has no credentials
to ask". `gh` is not installed — which is what was actually checked — but the
repository is **public**, so the unauthenticated GitHub API answers it and `curl`
is present. Recorded as a manual procedure, deliberately not as evidence; see §4.

Both corrections are appended to the board rather than written over the note,
which is history (rule 8).

## 3. Portability: the gate now gives the same answer on more machines

The axes were tested rather than assumed. **570 passed, 0 failed** from a
different working directory, under `LC_ALL=C`, under `LC_ALL=en_US.UTF-8`, and
under `TZ=Pacific/Kiritimati` — the timezone result is by design, since Check 12
already uses `date -u`.

One real exposure found: five evidence commands ended in `wc -l`, whose output is
**unpadded on GNU and padded on BSD**. On macOS each would have printed
`      26` against a recorded `26`, failing the entire suite for a developer
whose only mistake was using a Mac. Each now ends `| wc -l | tr -d ' '`.

`PF-013` was the last command known to depend on which implementation of a tool
is installed — `uniq -c` pads to an implementation-defined width. Replaced with
an `awk` tally that emits a single space by construction, sorted explicitly
because `for (k in c)` has no defined order. **No evidence command is now known
to vary by toolchain.**

## 4. Check 21 — the gate stays off the network

Check 17 executes every fenced evidence command on every suite run, so an
evidence command **is part of the gate**. One that needs the network fails behind
a firewall, on a machine with no route out, or when a public API rate-limits —
and fails for a reason that has nothing to do with the repository being wrong.
CI was red for twenty-two commits on exactly that class of dependency, so this
one is closed before it is opened rather than after.

The temptation is concrete rather than hypothetical: CI status *is* readable from
here with `curl`, and it was recorded in PF-016 as a **manual procedure**. Check
21 is what stops a later edit from quietly promoting it into evidence.
Negative-tested by doing precisely that.

Named narrowly on purpose: it checks that no evidence command names a network
tool or URL scheme, and is complete for that. It is **not** the general claim
that evidence commands are environment-independent, which is not mechanizable;
the axes tested by hand are recorded on PF-016 instead.

## 5. Check 22 — a tier the tooling ignores is worse than no tier

`evals/run.sh smoke` selects on `^tier: smoke` and nothing reads any other value.
`dunyu-001` carried `tier: dev` with a considered justification beside it, and
nothing has ever acted on it. Metadata that reads as meaningful and is inert
invites the next author to write `tier: slow` and believe something will honour
it.

Check 22 caught it on its first run, which is what it was written for. The tier
is removed and the judgement it recorded is kept as a comment; what is gone is
the appearance that some tool acts on it.

**Three further inconsistencies in the same metadata, all introduced by me:**
`anya-002` and `nadia-002` joined smoke with no justifying comment while the five
older members each carry one, and `zofia-002` had no tier at all while its two
siblings — added the same day, equally fast — were both smoke.

All three refusal controls are now smoke, for a reason rather than symmetry: **an
edit that makes an agent keener breaks a refusal case before it breaks a
detection one**, so they are the cases most likely to catch a prompt edit.

## 6. The smoke tier is documented, and the documentation is uncomfortable

The tier had never been described anywhere — it existed only in a comment in
`run.sh` and in seven case files. `evals/README.md` now carries it: what `smoke`
means, that membership is fixed rather than selected by staleness (a tier whose
membership moves with history cannot be compared across edits), and the part
worth saying out loud:

> **Seven of the nine smoke members have no verdict against the current prompt**
> — four never run, three stale. A green smoke run means "these cases pass
> today", not "nothing regressed", because for seven of them there is nothing to
> have regressed from.

## 7. Audited and found sound

Three suspected defects were probed and none is real. Recorded so the same ground
is not re-covered:

- **`tests/lock.sh` with a corrupt lock is fail-closed.** A truncated lock file
  (owner line only) refuses a foreign writer; an empty lock file refuses
  everyone. Both are the safe direction.
- **An empty scope line means unrestricted, and that is by design** — `acquire`'s
  usage marks path-prefixes optional, so a lock taken without them legitimately
  covers everything.
- **Check 15 already fails a case with no `samples/` directory**, as `nadia-002`
  demonstrated while it was being authored.

The first test was run in a fresh `git clone` and appeared to show the lock
failing to block a foreign writer. It showed nothing: `git clone` does not copy
`.git/hooks`, so the clone had no pre-commit hook until `install.sh` ran. Redone
with hooks installed, the lock behaves correctly.

## 8. Verification

- `bash tests/check.sh` — **612 passed, 0 failed**.
- Check 21 negative-tested by replacing PF-016's evidence with the `curl` call.
- Check 22 negative-tested by reintroducing `tier: slow` on `iris-001`.
- CI verified green on the remote for `f992cc4`, `a21d671`, `a872078` and
  `90ccf4a`, read from the run history rather than assumed.

## 9. Totals

| | v1.15.0 | v1.16.0 |
|---|---|---|
| Agents | 21 | 21 |
| Eval fixtures | 26 | 26 |
| Smoke tier | 7 | **9** |
| Structural checks | 570 | **612** |
| Evidence commands known to vary by environment | 1 | **0** |

## 10. Open issues

1. **Seven of nine smoke members have no current verdict**; refreshing them needs
   agent dispatches.
2. **`haruto-001` has no verdict** — its recorded PASS was leaked via its own
   `input/`.
3. **PF-013** — 18 of 21 tiers never tested by execution.
4. **PF-004** — precision unmeasured in the direction that matters.
5. **CI result is still unobservable from the gate**, deliberately: PF-016 checks
   the workflow's input, and Check 21 now forbids checking its output.

## 11. Assumptions

- Minor, not patch: two new checks and a behavioural change to the smoke tier.
- No criterion was tightened under a recorded verdict.
- No `--no-verify` bypass was used.
