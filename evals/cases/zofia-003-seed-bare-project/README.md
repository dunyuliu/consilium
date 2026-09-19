# zofia-003 — seed a bare project (Mode A)

The first fixture that reaches `zofia-kaminska`'s seeding mode. `zofia-001`
tests discovery and `zofia-002` tests refusal; both are Mode B, and Mode A is
roughly a third of her prompt.

## Why

`b9e02d6` shipped her root-document whitelist and recorded its own gap in the
commit message — *"Mode A is 33% of this file and has no fixture at all, so
none of this is verified in either direction"* — where nothing re-reads it. On
2026-09-16 a user reported the predicted failure from a real run: seeding
produced no `CLAUDE.md` and no board.

## The input

`tidalflux`, a depth-averaged tidal-channel solver. No rule book, no
`CLAUDE.md`, and two deliberate near-misses:

1. **`CONTRIBUTING.md`** — recipes (venv, run invocation, `make test`, style).
   A plausible rule-book candidate that is documentation, which Step 0 says to
   name as such and keep looking past.
2. **`TODO.md`** — a real status board under a non-canonical name. Mode A names
   this exact case: propose one rename that carries the content across, never a
   second board beside it.

`README.md` has become a design doc, which Mode A also has a clause for.
`Makefile` carries `test` and `test-regression`, so "adapt, don't paste" has a
real command to name.

Neither trap is hinted at in the prompt.

## Pass bar

Names the four root documents invariant 1 requires; says `CLAUDE.md` and
`PROJECT_RULES.md` were created; proposes the `TODO.md` rename rather than
seeding a second board; classifies `CONTRIBUTING.md` as recipes rather than
rules; adapts a rule to `make test` instead of "run the test suite". The strong
pass also says which starter invariants it dropped and why.

## What it cannot test

Grading reads the report, not the filesystem, so a run that *claims* to have
created `CLAUDE.md` without doing so passes. That limit is the harness's, not
this case's, and it applies to every case whose deliverable is a file. A
writable staging mode is not built.
