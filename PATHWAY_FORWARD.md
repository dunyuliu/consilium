# PATHWAY_FORWARD.md — inspection log

The present tense of this repository, by surface. Release notes are history and are
never revised (rule 8); this file is revised constantly.

**How to read a row.** Each row is a *part of the repo* and *the date it was last
audited* — a firehydrant tag. A blank `last-checked` means **nobody has ever checked
it**, and it stays blank until someone does. A blank is information, not an unfilled
field: never backfill a date to make a row look complete.

**How to close a row.** Run the command in the item's block below, paste what it
actually printed on the `# →` line, set `last-checked` to today, append a dated note.
`VERIFIED` requires a command that ran — a claim with no command is not verified, it is
remembered.

The table is the index; every row has a matching `### <id>` block carrying its command
and evidence. Commands live only in the blocks — a markdown cell cannot hold a `|`
without silently truncating at the first pipe, and a truncated command still looks like
evidence. `tests/check.sh` Check 12 parses both and fails if they disagree (rule 21).

## Board

| id | area | what is claimed | state | last-checked | interval |
|---|---|---|---|---|---|
| PF-001 | `install.sh` | the pre-commit hook and hook versioning are committed, not only installed locally | BROKEN | 2026-08-04 | 14 |
| PF-002 | `agents/` | every agent has at least one eval fixture (rule 13) | OPEN | 2026-08-04 | 30 |
| PF-003 | `evals/cases/` | every fixture has been executed and its outcome recorded | OPEN | 2026-08-04 | 14 |
| PF-004 | `evals/` | grading measures precision, not only phrasing | OPEN | 2026-08-04 | 60 |
| PF-005 | `docs/release_notes_*` | each release note matches the commit it tags | BROKEN | 2026-08-04 | 30 |
| PF-006 | `tests/check.sh` | the suite is green | VERIFIED | 2026-08-04 | 14 |
| PF-012 | `agents/` | prompt slimming did not change behaviour | OPEN | 2026-08-04 | 30 |
| PF-007 | `tests/check.sh` | the header comment describes the checks that exist | BROKEN | 2026-08-04 | 30 |
| PF-008 | `tests/check.sh` | checks 1–5 have been negative-tested | BROKEN |  | 30 |
| PF-009 | `agents/` | no agent prompt has drifted from its documented behaviour | OPEN |  | 60 |
| PF-010 | `install.sh` | a clean-clone install works on a machine that has never run it | OPEN |  | 60 |
| PF-011 | `evals/cases/*/input/` | fixture inputs contain no undeclared real defects | BROKEN | 2026-08-04 | 30 |

## Items

### PF-001 — `install.sh` — BROKEN

The v1.7.0 release note states rule 18 became mechanical via "`tests/lock.sh` and a
versioned `pre-commit` hook installed by `install.sh`". `tests/lock.sh` landed. The hook
and the versioning did not — they exist only in this machine's untracked `.git/hooks/`,
so the enforcement works here and nowhere else. Anyone cloning the repo gets the lock
script and no gate.

Root cause: the *effect* was verified (marker present in `.git/hooks/`, a second
writer's commit observed being blocked) and the *source being committed* never was.
Rule 4 was applied to the artifact, not to the claim. Nothing re-checked it for four
days because nothing existed whose job was to re-check — which is why this file exists.

```bash
git log --oneline -S 'PRECOMMIT' -- install.sh | wc -l
# → 0
```

### PF-002 — `agents/` — OPEN

Rule 13 requires a fixture per agent. Six have none.

```bash
ls evals/cases | sed 's/-[0-9].*//' | sort -u | wc -l
# → 14 of 20 agents covered
```

### PF-003 — `evals/cases/` — OPEN

```bash
bash evals/run.sh list | grep -c 'NEVER RUN'
# → 2 (anya-001, selin-001)
```

### PF-004 — `evals/` — OPEN

`must_not_find` guards phrasings, not precision: a report finding the planted defect
plus four things that are not there scores identically to a clean one. The
`declared_defects:` mechanism is written up and not built.

```bash
grep -c 'declared_defects' evals/README.md evals/run.sh
# → evals/README.md:1  evals/run.sh:0 — proposed, absent from the grader
```

### PF-005 — `docs/release_notes_*` — BROKEN

The v1.10.0 tagged commit contains six `anya-001` input files. Its note says "Eval
fixtures: 13" and describes no new fixture. They were swept in by `git add -A` run while
the author agent was still writing them.

The lock did not prevent this: it stops *other* writers from committing and does nothing
about the holder's own `git add -A`. Guarding *who may commit* is not guarding *what may
be committed*. Not corrected by rewriting the pushed tag — rule 8 forbids destroying
evidence. This row is the correction.

```bash
git show --stat v1.10.0 --name-only | grep -c anya-001
# → 6
```

### PF-006 — `tests/check.sh` — VERIFIED

Narrower than it looks: green means the checks pass, not that the repo is correct. See
PF-008.

```bash
bash tests/check.sh | tail -1
# → Summary: 327 passed, 0 failed
```

### PF-007 — `tests/check.sh` — BROKEN

The header comment enumerates checks 1–9 and has been wrong since Checks 10 and 11
landed. Same defect class as PF-001: a record of what a file does that stopped matching
the file.

```bash
grep -c '^echo "Check' tests/check.sh
# → 11 checks exist; header documents 9
```

### PF-008 — `tests/check.sh` — BROKEN — never audited

Checks 6–11 were each negative-tested at the moment they landed (a missing model-table
row, a wrong model, a dropped roster line, a stale anchor, an unscoped writer, a
stripped isolation section). Checks 1–5 predate that convention and have never been
adversarially tested. They may be gates; nobody has demonstrated it.

`last-checked` is deliberately blank rather than dated today, because reading the code
is not the same as watching it fail.

```bash
# no command run — this row records an absence of evidence, not a result
# → never audited
```

### PF-009 — `agents/` — OPEN — never audited

Never audited as a set. Only agents with fixtures have any behavioural evidence at all,
and a fixture tests one planted defect, not whether the prompt still says what its
description claims.

```bash
# no command run
# → never audited
```

### PF-010 — `install.sh` — OPEN — never audited

Every install to date has been a re-run on this machine, where the symlinks and hooks
already existed. The clean-clone path — the one a new user takes — has never been
executed.

```bash
# no command run
# → never audited
```

### PF-011 — `evals/cases/*/input/` — BROKEN

Four fixtures shipped with undeclared real defects in regions documented as clean:
`sophia-001` (an undeclared silent-failure return), `sophia-002` (negative keys
documenting defaults the code had no fallback for), `ziyan-001` (control references
never `\cite`d, one control overclaiming its own abstract), and `ziyan-001` again on
re-run. In every case the agent under test was right and the fixture was wrong.

An undeclared true defect in a control makes a *complete* audit score worse than an
incomplete one — the inverse of what the suite is for. `evals/README.md` now requires
verifying a control as rigorously as the planted defect, and two authors (`victor-001`,
`anya-001`) have since caught their own contaminants before shipping. The other nine
cases have not been re-audited under that rule.

```bash
ls evals/cases | wc -l
# → 15 cases; 2 authored under the adversarial-self-pass rule, 13 predate it
```

### PF-012 — `agents/` — OPEN

Duplicated boilerplate cut fleet-wide (4564 → 4279 lines): the communication
block was byte-identical across all 20 agents, the code-discipline preamble
across 13. Agent-specific tails inside those sections were preserved — the
first pass deleted them and was reverted.

Only `lars-001` has been re-run (PASS, and its report is as strong as before —
he lost the largest share at 35%). The other 14 fixtures have not been re-run
since the cut, so "no regression" is currently a claim about one agent.

```bash
cat agents/*.md | wc -l
# → 4279 lines, was 4564; lars-001 re-run PASS, 14 fixtures unverified
```

## Deferral log

Append-only. A deferral not written here did not happen. An item may be deferred at
most twice; a third time is a decision, not a deferral, and belongs in the item block.

| date | id | until | reason |
|---|---|---|---|
