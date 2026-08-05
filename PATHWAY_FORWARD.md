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
| PF-002 | `agents/` | every agent has at least one eval fixture (rule 13) | VERIFIED | 2026-08-04 | 30 |
| PF-003 | `evals/cases/` | every fixture has been executed and its outcome recorded | BROKEN | 2026-08-04 | 14 |
| PF-004 | `evals/` | grading measures precision, not only phrasing | OPEN | 2026-08-04 | 60 |
| PF-005 | `docs/release_notes_*` | each release note matches the commit it tags | BROKEN | 2026-08-04 | 30 |
| PF-006 | `tests/check.sh` | the suite is green | VERIFIED | 2026-08-04 | 14 |
| PF-012 | `agents/` | prompt slimming did not change behaviour | OPEN | 2026-08-04 | 30 |
| PF-013 | `agents/` | every agent runs on the cheapest tier that passes its fixture | OPEN | 2026-08-04 | 60 |
| PF-007 | `tests/check.sh` | the header comment describes the checks that exist | VERIFIED | 2026-08-04 | 30 |
| PF-008 | `tests/check.sh` | checks 1–5 have been negative-tested | VERIFIED | 2026-08-04 | 60 |
| PF-009 | `agents/` | no agent prompt has drifted from its documented behaviour | OPEN |  | 60 |
| PF-010 | `install.sh` | a clean-clone install works on a machine that has never run it | OPEN |  | 60 |
| PF-011 | `evals/cases/*/input/` | fixture inputs contain no undeclared real defects | BROKEN | 2026-08-04 | 30 |
| PF-014 | `agents/` | no agent is missing the fixture its name implies | OPEN |  | 30 |
| PF-015 | `tests/check.sh` | the board's recorded evidence is re-executed, not just cited | VERIFIED | 2026-08-04 | 14 |

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

### PF-002 — `agents/` — VERIFIED

**Closed 2026-08-04.** All 21 agents covered. Rule 13 satisfied for the first
time since it was written.

Rule 13 requires a fixture per agent. Seven have none (`lian-zhao` landed as
the 21st agent; `lian-001-no-fixture-no-cut` is a directory with no
`case.yaml`, so it does not count — see PF-003).

```bash
for d in evals/cases/*/; do [ -f "$d/case.yaml" ] && basename "$d"; done | sed 's/-[0-9].*//' | sort -u | wc -l
# → 21
#   → 21 of 21 agents have at least one fixture
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
for d in evals/cases/*/; do [ -f "$d/case.yaml" ] || { echo "$(basename "$d"): NO case.yaml"; continue; }; grep -qiE 'first run \(|second run \(' "$d/case.yaml" || echo "$(basename "$d"): NEVER RUN"; done
# → anya-001-cycle-stats-release: NEVER RUN
# → lars-002-clean-control: NEVER RUN
# → selin-001-supershear-resolution: NEVER RUN
```

### PF-004 — `evals/` — OPEN

`must_not_find` guards phrasings, not precision: a report finding the planted defect
plus four things that are not there scores identically to a clean one. The
`declared_defects:` mechanism is written up and not built.

```bash
grep -c 'declared_defects' evals/README.md evals/run.sh
# → evals/README.md:1
# → evals/run.sh:0
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
# → Summary: 479 passed, 0 failed
```

### PF-007 — `tests/check.sh` — VERIFIED

The header comment documents 17 checks and 17 exist. This row is now
self-maintaining: Check 17 re-runs the command below on every suite run, so
adding a check without updating the header reddens the gate the same day.

```bash
grep -c '^echo "Check' tests/check.sh
# → 17
```

### PF-008 — `tests/check.sh` — VERIFIED

**Closed 2026-08-04.** Six mutations run, each producing the intended failure
message, each restored:

  bad model value          -> "model 'gpt4' not in {opus, sonnet, haiku}"
  name != filename stem    -> "name 'wrong-name' does not match filename stem"
  command invokes a ghost  -> "invokes nonexistent agent 'ghost-person'"
  README command drift     -> "commands table out of sync with commands/ on disk"
  agent unmentioned        -> "not mentioned in README"
  stale backtick reference -> "references 'kai-fischerr' but no agents/... exists"

Checks 1-5 are now known gates rather than assumed ones. They predated the
negative-test convention by several releases and had never been shown to fail.

```bash
bash tests/check.sh | tail -1
# → Summary: 479 passed, 0 failed
```

#### Prior record (2026-08-04, before the mutations were run)

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

**Re-derived 2026-08-04.** The "nine that predate the rule" figure was stale and
is retired. Derivation is now stated so it can be repeated: a case counts as
audited under the rule if its `case.yaml` or `README.md` records the control
being verified. Nine do — `elena-001`, `anya-001`, `selin-001`, `nadia-001`,
`victor-001`, `wei-lin-001`, `lian-001`, `marco-001`, `zofia-001`. **Fourteen do
not**: `dunyu-001`, `haruto-001`, `ingrid-001`, `iris-001`, `jordan-001`,
`kai-001`, `lars-001`, `lars-002`, `mira-001`, `priya-001`, `rafael-001`,
`sophia-001`, `sophia-002`, `ziyan-001`. Git dates cannot be used for this split
— every case directory traces to one commit — so the record in the case is the
only evidence there is.

**Audited 2026-08-04: `kai-001`, `ingrid-001` — inputs clean.** Both were read
end to end against their notes. `kai-001`'s uniform out-of-range clamping and
`ingrid-001`'s `dx`-halving refinement schedule were each examined and are
correct as written; calling either a defect would have been an invented finding,
which is the failure this row exists to prevent. Twelve remain.

**Three real fixture defects found in the same pass**, none of them in the input
code, all of them in the answer key or the process around it:

  1. `lars-001` notes cited three line numbers and **all three were wrong** —
     15→16, 17→19, 24→27. Check 9 validates that a criterion's `anchor` sits
     inside its `line_range`; nothing validates the prose. So the machine-read
     answer key was right and the human-read one pointed at a blank assignment
     and two docstrings. A human re-auditing the fixture — precisely what this
     row asks for — is sent to the wrong lines.
  2. `kai-001` cited `bin_distances (line 37)`; line 37 is blank, the `def` is
     on 38.
  3. Untracked `__pycache__` directories sat inside `dunyu-001/input/` and
     `lars-002/input/`. Nothing was committed, so no clone is affected, but they
     are proof that an agent was pointed at the case directory instead of the
     staged copy — twice, unlogged. This is the `victor-001` read-only violation
     recurring after `evals/run.sh stage` was built to make it impossible.
     Removed.

**No check was added for defect 1, deliberately.** The honest candidates all fail:
requiring cited lines to be non-blank catches `kai-001` and misses `lars-001`;
requiring them to fall inside a declared `line_range` fails on every narrative
citation (`bin_depths (line 23)` is not a defect pointer). A gate that catches one
of four known instances while reading as a gate is worse than no gate (rule 2).
The durable statement is the finding itself: **a line number in `notes:` is an
unvalidated duplicate of `anchor` + `line_range`, which are validated.** Prefer
the anchor; when prose must cite a line, expect it to rot.

```bash
ls evals/cases | wc -l
# → 23
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
# →       3 haiku
# →       5 opus
# →      13 sonnet
```

### PF-014 — `agents/` — OPEN — never audited

`lian-zhao` and the four fixtures in this batch are unlanded. Two agents have
no fixture at all (`lian-zhao`, `zofia-kaminska`), so by rule 13 and by
lian-zhao's own cardinal rule neither may be refined — including by itself.

```bash
for a in agents/*.md; do s=$(basename "$a" .md); ls evals/cases 2>/dev/null | grep -q "^${s%%-*}-" || echo "$s"; done | wc -l
# → 0
```

### PF-015 — `tests/check.sh` — VERIFIED

Rule 21a (execute the board's evidence and diff it against the recorded
output) was attempted on 2026-08-04 and REVERTED. The awk parser split
multi-line commands into fragments, fed them to `bash -c`, and the check
blocked — the suite stopped printing its Summary line, which is worse than
not having the check at all.

Two real obstacles, both underestimated:
  - board commands are multi-line shell (`for d in ...; do ... done`), so a
    line-oriented fence parser cannot recover them
  - one row's command is `bash tests/check.sh` itself, which recurses

Neither is fatal — store commands as single lines, and exempt self-referential
ones explicitly — but it is more than a small patch, and a half-working gate
that swallows the rest of the suite is the exact failure mode rule 2 forbids.

**Closed 2026-08-04.** Landed as Check 17, and the diagnosis above was wrong in
its most important part. The awk parser was a real obstacle but not the fatal
one: `check.sh` runs under `set -euo pipefail`, so the first evidence command to
exit nonzero — `grep -c` finding nothing is routine — killed the run before the
Summary line. The check did not block because it mis-parsed; it blocked because
it was executed under errexit. Evidence commands now run with errexit suspended
and their exit status ignored, because the contract is what a command *prints*.

The multi-line obstacle is now a rule rather than a workaround: a fence with more
than one command line fails the check outright. `PF-003` was rewritten as one
line. The self-referential rows (`PF-006`, `PF-008`, whose command is
`bash tests/check.sh`) are named and skipped in the output, not silently dropped.

It reddened on landing, which is the point. Five rows had drifted since they were
written — `PF-002` (15 -> 21), `PF-003` (a case.yaml that now exists), `PF-004`
and `PF-013` (only the first line of multi-line output had been recorded, so the
"literal stdout" claim was already false), `PF-007` (14 -> 16) — and `PF-007`
drifted again during this very change, from 16 to 17, because adding Check 17
changed the number of checks. Every one of those rows carried the date it was
last written, and none of them was still true.

```bash
grep -c 'section=evidence' tests/check.sh
# → 1
```

## Deferral log

Append-only. A deferral not written here did not happen. An item may be deferred at
most twice; a third time is a decision, not a deferral, and belongs in the item block.

| date | id | until | reason |
|---|---|---|---|
