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
| PF-001 | `install.sh` | the pre-commit hook and hook versioning are committed, not only installed locally | VERIFIED | 2026-08-04 | 30 |
| PF-002 | `agents/` | every agent has at least one eval fixture (rule 13) | OPEN | 2026-08-04 | 30 |
| PF-003 | `evals/cases/` | every fixture has been executed and its outcome recorded | BROKEN | 2026-08-04 | 14 |
| PF-004 | `evals/` | grading measures precision, not only phrasing | OPEN | 2026-08-04 | 60 |
| PF-005 | `docs/release_notes_*` | each release note matches the commit it tags | BROKEN | 2026-08-04 | 30 |
| PF-006 | `tests/check.sh` | the suite is green | VERIFIED | 2026-08-04 | 14 |
| PF-012 | `agents/` | prompt slimming did not change behaviour | OPEN | 2026-08-04 | 30 |
| PF-013 | `agents/` | every agent runs on the cheapest tier that passes its fixture | OPEN | 2026-08-04 | 60 |
| PF-007 | `tests/check.sh` | the header comment describes the checks that exist | VERIFIED | 2026-08-04 | 30 |
| PF-008 | `tests/check.sh` | checks 1–5 have been negative-tested | BROKEN |  | 30 |
| PF-009 | `agents/` | no agent prompt has drifted from its documented behaviour | OPEN |  | 60 |
| PF-010 | `install.sh` | a clean-clone install works on a machine that has never run it | OPEN |  | 60 |
| PF-011 | `evals/cases/*/input/` | fixture inputs contain no undeclared real defects | BROKEN | 2026-08-04 | 30 |

## Items

### PF-001 — `install.sh` — VERIFIED

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
grep -c 'PRECOMMIT\|HOOK_VERSION' install.sh
# → 10
```

**Closed 2026-08-04.** The hook and the versioning are now in the tracked
installer, not only in this machine's untracked `.git/hooks/`. All three hooks
carry `consilium-hook-v3`, appended after writing rather than typed into the
quoted heredoc — the earlier attempt drifted because a literal stamp and the
version variable were maintained separately.

### PF-002 — `agents/` — OPEN

Rule 13 requires a fixture per agent. Seven have none (`lian-zhao` landed as
the 21st agent; `lian-001-no-fixture-no-cut` is a directory with no
`case.yaml`, so it does not count — see PF-003).

```bash
for d in evals/cases/*/; do [ -f "$d/case.yaml" ] && basename "$d"; done | sed 's/-[0-9].*//' | sort -u | wc -l
# → 15
#   → 14 of 21 agents covered
```

### PF-003 — `evals/cases/` — BROKEN

The cited command no longer tells the truth: `evals/cases/lian-001-no-fixture-no-cut/`
has no `case.yaml`, and `cmd_list` in `evals/run.sh` exits 2 partway through the
directory scan instead of reporting the missing file (a silent failure, rule 2).
Piping through `grep -c` hides the crash and quietly undercounts — this is why the
number below was found by bypassing `evals/run.sh list`, not by re-running the block
as originally written. Route: the crash is a code bug in `evals/run.sh` →
`lars-eriksson`; the missing fixture is a coverage gap → `iris-vermeulen`.

```bash
for d in evals/cases/*/; do
  [ -f "$d/case.yaml" ] || { echo "$(basename "$d"): NO case.yaml"; continue; }
  grep -qiE 'first run \(|second run \(' "$d/case.yaml" || echo "$(basename "$d"): NEVER RUN"
done
# → anya-001-cycle-stats-release: NEVER RUN
# → lars-002-clean-control: NEVER RUN
# → selin-001-supershear-resolution: NEVER RUN
# → lian-001-no-fixture-no-cut: NO case.yaml
```

### PF-004 — `evals/` — OPEN

`must_not_find` guards phrasings, not precision: a report finding the planted defect
plus four things that are not there scores identically to a clean one. The
`declared_defects:` mechanism is written up and not built.

```bash
grep -c 'declared_defects' evals/README.md evals/run.sh
# → evals/README.md:1
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
# → Summary: 366 passed, 0 failed
```

### PF-007 — `tests/check.sh` — VERIFIED

Checks 12–14 landed since this row was last written; the header comment now
documents 14 checks and 14 exist. Fixed, not just re-counted — re-check this on
any future change to the number of checks.

```bash
grep -c '^echo "Check' tests/check.sh
# → 14
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
# → (no output)
```

### PF-009 — `agents/` — OPEN — never audited

Never audited as a set. Only agents with fixtures have any behavioural evidence at all,
and a fixture tests one planted defect, not whether the prompt still says what its
description claims.

```bash
# no command run
# → (no output)
```

### PF-010 — `install.sh` — OPEN — never audited

Every install to date has been a re-run on this machine, where the symlinks and hooks
already existed. The clean-clone path — the one a new user takes — has never been
executed.

```bash
# no command run
# → (no output)
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

Case count grew 15 → 17 since this row was last checked (`lars-002-clean-control`,
`lian-001-no-fixture-no-cut` landed). Neither has been audited under the
adversarial-self-pass rule yet, so the "2 authored / N predate it" split below
is stale — re-derive it before citing it, do not just trust the new total.

```bash
ls evals/cases | wc -l
# → 17
```

### PF-012 — `agents/` — OPEN

Duplicated boilerplate cut fleet-wide (4564 → 4279 lines): the communication
block was byte-identical across all 20 agents, the code-discipline preamble
across 13. Agent-specific tails inside those sections were preserved — the
first pass deleted them and was reverted.

Only `lars-001` has been re-run (PASS, and its report is as strong as before —
he lost the largest share at 35%). The other fixtures have not been re-run
since the cut, so "no regression" is currently a claim about one agent.
`lian-zhao` landed after this slimming pass and adds lines unrelated to it, so
the raw total below is no longer directly comparable to the 4279 figure
without subtracting her file first.

```bash
cat agents/*.md | wc -l
# → 4758
#   remaining fixtures still unverified against the cut
```

### PF-013 — `agents/` — OPEN

Three tiers tested by `model` override against the agent's own fixture, no file
changed until a pass:

- `ziyan-chen` sonnet → **haiku**: PASS 5/5, 11.9k tokens (was 14.4k), and more
  precise — exactly the two planted defects, where the sonnet run listed nine.
- `selin-aydin` opus → **sonnet**: PASS 9/9. Derived Λ₀ = 318 m from parameters
  scattered across three sections, got 1.27 cells at 250 m, caught the
  coarsening "convergence" test, and credited the station-exclusion control
  rather than attacking it.
- `priya-nair` sonnet → haiku: **FAIL**. It marked the 9.7% CAGR correct by
  recomputing with the document's own formula. The planted trap is that the
  formula is wrong, so re-deriving *with* it confirms the error. Kept on sonnet.

The dividing line is not task difficulty: it is whether the job requires
refusing the document's framing. Comparing stated text to stated text works on
haiku; refusing a premise did not.

Also cut `mira-volkov`'s 88-line optimization recipe book (601 → 513 lines);
`mira-001` PASS 5/5 afterwards at 27k tokens vs 34.7k, 4 tool calls vs 12.

Untested: 4 opus and 10 sonnet agents whose tiers have never been challenged, plus
`lian-zhao` (sonnet), who landed after this row was last written and has not been
challenged either way — the untested count grows by one, it does not shrink.

```bash
grep -H '^model:' agents/*.md | sed 's|agents/||' | awk '{print $2}' | sort | uniq -c
# → 3 haiku
```

### PF-014 — `agents/` — OPEN — never audited

`lian-zhao` and the four fixtures in this batch are unlanded. Two agents have
no fixture at all (`lian-zhao`, `zofia-kaminska`), so by rule 13 and by
lian-zhao's own cardinal rule neither may be refined — including by itself.

```bash
for a in agents/*.md; do s=$(basename "$a" .md); ls evals/cases 2>/dev/null | grep -q "^${s%%-*}-" || echo "$s"; done | wc -l
# → 6
```

## Deferral log

Append-only. A deferral not written here did not happen. An item may be deferred at
most twice; a third time is a decision, not a deferral, and belongs in the item block.

| date | id | until | reason |
|---|---|---|---|
