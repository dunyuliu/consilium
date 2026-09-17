# PATHWAY_FORWARD.md — the to-do book

**The to-do book.** What to do next, in priority order; what is done; and the
standing claims that have to keep being true. Release notes are history and are
never revised (rule 8); this file is revised constantly, and re-prioritising it
is the work, not a symptom of having written it wrong.

**Two kinds of row, one format.** A **task** is something to do — it closes
when it is done. A **standing claim** is something that must stay true — it
never closes, it comes due again on its interval. Both carry the command that
settles them, both carry a priority, and a task with no command is a wish.
`prio` is what the work is taken in — **P1 first, then P2, then P3** — and
adjusting it as the project changes is the maintenance this file exists for.
`/autopilot` reads that column and works the board top down.

**How to close a row.** Run the command in the item's block, read what it
prints, set `last-checked` to today, and — if the state changed — say so in
one line. Rule 21a (amended 2026-09-17) no longer requires pasting the
command's output on a `# →` line or byte-diffing it; the command is the
contract, not a transcript of one run of it. A blank `last-checked` means
nobody has ever checked the row and stays blank until someone does — never
backfilled.

**Compressed 2026-09-17.** This file ran 2,764 lines for 34 rows — thirteen
times heavier per row than EQdyna's `pathway_forward.md` (210 lines, 108 rows),
the working instance this design was measured against. The cause was rule
21a's now-dropped recorded-output requirement: every recheck added a "Re-run"
paragraph defending a pasted transcript instead of just re-reading the command.
**Nothing is destroyed.** The full narrative for every row below — every
"Re-run" entry, every closed investigation — is in git history at `b9430a3`:
`git show b9430a3:PATHWAY_FORWARD.md`. Rows are never deleted (rule 21); what
moved is the history behind an already-settled claim, not the claim or the row.

## Board

| id | area | to do, or claim to keep true | state | last-checked | interval | prio |
|---|---|---|---|---|---|---|
| PF-001 | `install.sh` | the pre-commit hook and its version marker are committed, not only installed locally | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-002 | `agents/` | ~~every agent has at least one eval fixture (rule 13)~~ — rule 13 retired 2026-09-17, headcount is no longer a claim this board makes | RETIRED | 2026-09-17 | — | — |
| PF-003 | `evals/cases/` | every fixture has been dispatched and graded at least once (coverage, not health — see PF-004, PF-025) | VERIFIED | 2026-09-17 | 14 | P2 |
| PF-004 | `evals/` | grading measures precision (false positives/negatives), not just declared-defect mentions | OPEN | 2026-09-16 | 60 | P1 |
| PF-005 | `docs/release_notes_*` | no divergence between a release note and its tag goes unrecorded (v1.10.0's known divergence stays recorded, uncorrectable per rule 8) | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-006 | `tests/check.sh` | the suite is green | VERIFIED | 2026-09-17 | 14 | P2 |
| PF-007 | `tests/check.sh` | the header comment's check count matches the checks that exist | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-008 | `tests/check.sh` | checks 1–5 have been negative-tested | VERIFIED | 2026-08-04 | 60 | P3 |
| PF-009 | `agents/` | no agent prompt's body contradicts its own frontmatter or another agent's prompt | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-010 | `install.sh` | a clean-clone install works on a machine that has never run it | VERIFIED | 2026-08-05 | 60 | P3 |
| PF-011 | `evals/cases/*/input/` | fixture inputs contain no undeclared real defects | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-012 | `agents/` | no fleet-wide fixture-verdict staleness against the prompt it grades | OPEN | 2026-09-17 | 14 | P1 |
| PF-013 | `agents/` | every agent runs on the cheapest model tier that passes its fixture | OPEN | 2026-09-17 | 60 | P3 |
| PF-014 | `agents/` | ~~no agent is missing the fixture its name implies~~ — rule 13 retired 2026-09-17, same reason as PF-002 | RETIRED | 2026-09-17 | — | — |
| PF-015 | `tests/check.sh` | the board's evidence commands are checked for shape (Check 12) and no residue of the retired byte-diff mechanism (Check 17) remains | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-016 | `.github/workflows/` | CI runs the same gate a developer runs, with the same result | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-017 | `agents/` | fixtures exist for the autopilot cycle, the release gate and zofia's patch path, and have been dispatched | OPEN | 2026-09-16 | 14 | P1 |
| PF-018 | `PATHWAY_FORWARD.md` | the board can express the priority it is worked in | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-019 | `tests/release_gate.sh` | the published-release row lands in the gate, skipping without credentials or a pushed tag | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-020 | `tests/check.sh` Check 27 | the untagged-release-note check exists independent of any one tag's current state | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-021 | `tests/check.sh` | Check 29's script selector uses `git ls-files`, not `find .` — no false red for a worktree-isolated dispatch | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-022 | `agents/` | `lian-zhao`'s frontmatter no longer contradicts her own body on the fixture write surface | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-023 | `tests/lock.sh` | the lock resolves to the same shared file from a main checkout and any linked worktree | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-024 | `evals/run.sh` | STALE compares the prompt SHA a verdict was graded against, not the date | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-025 | `evals/cases/zofia-004-seed-patch-established` | causes 1–2 fixed (`iris-vermeulen`); rests on criterion 3 alone — a named substring-grading limit, not a gap | OPEN | 2026-09-16 | 14 | P2 |
| PF-026 | `tests/lock.sh` / working pattern | codified as `PROJECT_RULES.md` rule 18a — acquire only for the write step | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-027 | `evals/cases/*/case.yaml`, `evals/run.sh` | a verdict names the prompt SHA it was graded against; a contested case cites its sample count (rule 25d) | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-028 | `install.sh` | install a working hook set from inside a linked worktree, not only a main checkout (owner: `iris-vermeulen`) | BROKEN | 2026-09-17 | 14 | P1 |
| PF-029 | `PROJECT_RULES.md` | every live index row has body prose in the file, not only a one-line index claim (re-scoped 2026-09-17 to four rows; 13a is retired and needs none) | OPEN | 2026-09-17 | 60 | P2 |
| PF-030 | `install.sh` | `pre-push` skips the gate for a push whose ref updates are all deletions (rule 9a; owner: `iris-vermeulen`) | OPEN | 2026-09-17 | 30 | P2 |
| PF-031 | `tests/check.sh` Check 28 | a rule-8a deletion's two conditions are checkable from the commit message, not just asserted in prose (owner: `iris-vermeulen`) | OPEN | 2026-09-17 | 30 | P2 |
| PF-032 | `README.md` question 1 | the seeded-README credibility gap ("nothing holds a seeded README to being credible") has no check today and stays open — a true "Not yet", not drift | OPEN | 2026-09-17 | 60 | P3 |
| PF-033 | `README.md` question 2 | "no GitHub Release object is created" is false — Check 35 verifies the mechanism and its newest-tag grace is gone (`f109ef8`); the false README prose is the only half left, human-owned | OPEN | 2026-09-17 | 30 | P2 |
| PF-034 | `README.md` question 2 | the release gate has twelve rows, not ten — Check 33's header comment is corrected (`f109ef8`); README still says ten, human-owned prose | OPEN | 2026-09-17 | 30 | P2 |
| PF-035 | `release_notes_v*.md` | the release note at the repo root is the newest tag's, not a superseded one — mechanized in Check 31 (`632c439`) | VERIFIED | 2026-09-17 | 30 | P3 |

**Re-tiered 2026-09-17 (third pass, after PF-035 closed)**: 4 P1 / 8 P2
/ 21 P3 across 33 live rows, plus 2 RETIRED. The prior paragraph's arithmetic
was wrong — it enumerated five P1s while claiming four, and 12 P2 / 15 P3
against an actual 8 / 19; the counts below are the table's.
**P1** is what is actively broken or is an unclosed gap in a mechanism the rest
of the board depends on: PF-004 (grading cannot tell a precise finding from a
lucky one), PF-012 (3 STALE verdicts today), PF-017 (no dispatched fixture for
autopilot / the release gate / the patch path), PF-028 (install is broken from
a worktree). PF-015 leaves P1 — its task was already done before the row was
written (see its block) — and nothing was promoted in its place: today's three
closures were all follow-through on landed work, not discoveries.
**P2** is active work and the claims worth rechecking often: PF-003, PF-006,
PF-025, PF-029, PF-030, PF-031, PF-033, PF-034. PF-035 leaves P2 for P3: its
claim is mechanized in Check 31 and now recheck-for-drift like any other
settled claim. PF-033 and PF-034 stay
P2 after losing their mechanical halves because the remaining half is a false
statement in the user-facing README — prose drift that misdescribes a shipped
gate, not a cosmetic one.
**P3** is settled, stable claims on long intervals — checked for drift, not
because they matter less in kind.

## Items

Each item names its command; run it to close or re-check the row. Full prior
history (every past run, investigation and superseded claim) is compressed out
of this file and lives at git SHA `b9430a3` — see the note above.

### PF-001 — `install.sh` — VERIFIED
Hook source and its version marker are tracked in `install.sh`, not only in a
local `.git/hooks/`.
```bash
grep -c 'PRECOMMIT\|HOOK_VERSION' install.sh
```

### PF-002 — `agents/` — RETIRED
Rule 13 (`PROJECT_RULES.md`) is retired: it mandated a fixture per agent by
headcount, not by evidence of coverage. 20 of 36 fixtures have never recorded
a FAIL, which is what a headcount rule buys. `tests/check.sh` Check 25, which
enforced this row's claim, retires with it — `iris-vermeulen`'s surface. This
row is kept, not deleted (rule 21); it no longer asserts anything, so it
carries no command and no interval.

### PF-003 — `evals/cases/` — VERIFIED
Coverage only — a superseded or FAILing verdict still counts. See PF-004 for
precision and PF-025 for the one known-defective criterion set.
```bash
for d in evals/cases/*/; do [ -f "$d/case.yaml" ] || { echo "$(basename "$d"): NO case.yaml"; continue; }; grep -qiE 'run \((19|20)[0-9]{2}-' "$d/case.yaml" || echo "$(basename "$d"): NEVER RUN"; done
```

### PF-004 — `evals/` — OPEN
`must_not_find` and `declared_defects` grade presence of a term, not whether a
report's findings are precise: a report that finds the planted defect plus
four things that aren't there scores the same as a clean one. The reverse
check (map every report finding back to a declared defect) is not buildable —
findings aren't delimited in prose. Route: `iris-vermeulen`.
```bash
grep -c 'declared_defects' evals/README.md evals/run.sh evals/cases/*/case.yaml | grep -v ':0$' | wc -l | tr -d ' '
```

### PF-005 — `docs/release_notes_*` — VERIFIED
Claim deliberately narrowed 2026-08-05 from "matches the tag" (false forever
for v1.10.0, uncorrectable under rule 8) to "no divergence goes unrecorded."
v1.10.0's six undisclosed `anya-001` files stay recorded here, permanently.
```bash
git show --stat v1.10.0 --name-only | grep -c anya-001
```

### PF-006 — `tests/check.sh` — VERIFIED
Green means the checks pass, not that the repo is correct (PF-008).
`794 passed, 0 failed` at `18c9cef` on 2026-09-17, the v1.23.0 release base.
```bash
bash tests/check.sh | tail -1
```

### PF-007 — `tests/check.sh` — VERIFIED
No longer self-maintaining now that Check 17 is retired (PF-015) — recheck on
interval like any other row. 32 checks as of the v1.23.0 cut.
```bash
grep -c '^echo "Check' tests/check.sh
```

### PF-008 — `tests/check.sh` — VERIFIED
Closed 2026-08-04: six mutations run against checks 1–5, each produced its
intended failure message, each restored.
```bash
bash tests/check.sh | tail -1
```

### PF-009 — `agents/` — VERIFIED
Closed 2026-09-17 (`sophia-okafor`): all 22 prompts read against three
questions — description-vs-body, cross-prompt contradiction, stale claims.
One drift found and fixed (`agents/wei-lin.md`'s description vs. its `:248`
delegation). Point-in-time; nothing re-checks this mechanically between reads.
```bash
grep -c "Commissions and enforces project rules" agents/wei-lin.md
```

### PF-010 — `install.sh` — VERIFIED
Executed 2026-08-05 against a real clean clone under a sandboxed `HOME`.
```bash
grep -c 'CLAUDE=${HOME}/.claude' install.sh
```

### PF-011 — `evals/cases/*/input/` — VERIFIED
```bash
ls evals/cases | wc -l | tr -d ' '
```

### PF-012 — `agents/` — OPEN
Fleet-wide staleness: fixture verdicts recorded against a prompt SHA that has
since moved. Route: `iris-vermeulen`.

**Worse on 2026-09-17, not better**: the command prints `3`. Fixture
trustworthiness went 9/10 to 5/10 in a day because `agents/haruto-nakamura.md`
and `agents/zofia-kaminska.md` both changed and staled their own verdicts —
including `haruto-002-tag-before-gate`, which exercises the exact ordering step
that changed and has not been re-dispatched against the new prompt. Staleness
here is a prompt edit outrunning its evidence, which is the row's point, not a
tooling fault. Stays P1.
```bash
bash evals/run.sh list | grep -c STALE
```

### PF-013 — `agents/` — OPEN
Model tier per agent has never been checked against "cheapest tier that still
passes its fixture" — only assigned by judgment at creation time.
```bash
grep -h '^model:' agents/*.md | awk '{c[$2]++} END{for(k in c) printf "%d %s\n", c[k], k}' | sort -k2
```

### PF-014 — `agents/` — RETIRED
Same rule-13 retirement as PF-002: this row measured headcount-by-name
coverage, which rule 13 mandated and no longer does. Check 25 goes with it
(`iris-vermeulen`). Kept per rule 21, carries no command or interval.

### PF-015 — `tests/check.sh` — VERIFIED
**The row was wrong when it was written (settled 2026-09-17).** It asked for
the removal of Check 17, the byte-diff of recorded board evidence — but Check
17 had already been retired in `1faaa1f`, which is an ancestor of the commit
that set this row's own last-checked date. The row asked someone to remove a
thing that was not there, and would have been closed by reading the gate rather
than by changing it: an inherited claim taken as current state (rule 4).

What did exist was residue, and it is now gone: the header's `Verifies:` list
still named retired Check 21, and three comments cited Check 17 by number. The
claim is re-scoped from "remove Check 17" to "no residue of it remains", which
is a standing claim a command can settle, and drops to P3 accordingly.
```bash
grep -c 'section=evidence' tests/check.sh
```

### PF-016 — `.github/workflows/` — VERIFIED
```bash
grep -c '^ *fetch-depth: 0$' .github/workflows/check.yml
```

### PF-017 — `agents/` — OPEN
Fixtures for the autopilot cycle, the release gate and zofia's patch path
exist but have not all been dispatched.
```bash
ls evals/cases | grep -cE 'autopilot|release-gate|seed-patch'
```

### PF-018 — `PATHWAY_FORWARD.md` — VERIFIED
```bash
awk -f tests/parse_board.awk -v section=board PATHWAY_FORWARD.md | head -1 | awk -F'|' '{print NF}'
```

### PF-019 — `tests/release_gate.sh` — VERIFIED
```bash
grep -c "^ROWS=(audit correctness conciseness fixes docs refactor tree ci publish release clone rules)" tests/release_gate.sh
```

### PF-020 — `tests/check.sh` Check 27 — VERIFIED
```bash
grep -c "no matching tag" tests/check.sh
```

### PF-021 — `tests/check.sh` — VERIFIED
```bash
grep -c "git ls-files '\*\.sh'" tests/check.sh
```

### PF-022 — `agents/` — VERIFIED
```bash
grep -c "refuses to touch a prompt that has none" agents/lian-zhao.md
```

### PF-023 — `tests/lock.sh` — VERIFIED
```bash
grep -q 'git rev-parse --git-common-dir' tests/lock.sh && test -d "$(git rev-parse --git-common-dir)"
```

### PF-024 — `evals/run.sh` — VERIFIED
```bash
grep -c 'provenance indeterminate' evals/run.sh
```

### PF-025 — `evals/cases/zofia-004-seed-patch-established` — OPEN
Criterion 3 (README/CLAUDE leave-alone guard) is a named limit of substring
grading, not a fixable gap — recorded, not chased further.
```bash
grep -c 'README/CLAUDE' evals/cases/zofia-004-seed-patch-established/case.yaml
```

### PF-026 — `tests/lock.sh` / working pattern — VERIFIED
Codified as rule 18a. This row cites the lock's own status only to confirm
the mechanism exists — it is not evidence the lock is currently free, and
should not be read as such (that was the failure mode this amendment removed).
```bash
grep -c '^### 18a\. Acquire only for the write step' PROJECT_RULES.md
```

### PF-027 — `evals/cases/*/case.yaml`, `evals/run.sh` — VERIFIED
```bash
grep -c 'contested: true' evals/cases/zofia-004-seed-patch-established/case.yaml
```

### PF-028 — `install.sh` — BROKEN
Hook install does not work from inside a linked worktree, only from a main
checkout. Owner: `iris-vermeulen` (rule 19).
```bash
test -d "$(git rev-parse --git-common-dir)/hooks" && echo "hooks dir exists (shared)" || echo "no shared hooks dir"
```

### PF-029 — `PROJECT_RULES.md` — OPEN
**Re-scoped 2026-09-17, still open.** The rule-book compression (`13a21aa`) did
not close this: 5b, 21b, 23a and 25b remain index rows with no `##` body
anywhere in the file, and their normative text is not folded into their parents
either — rule 5's body covers 5a's planted-keyword ban and never mentions a
symlinked answer key, and the same holds for 21/23/25. So the row's claim is
right about those four: each is a real rule, each names a real mechanical check
(23, 20, 22 respectively) — except 21b, whose Check 21 was retired
2026-09-17 in `1faaa1f`, and a reader who wants to know what the rule
actually requires has only the one-line index claim to read.

13a drops out of the claim. It is retired with rule 13, and the index row says
so; a retired sub-rule owes no body. The command is narrowed to the four.
```bash
for r in 5b 21b 23a 25b; do grep -q "^## $r\." PROJECT_RULES.md || echo "$r: no ## heading"; done
```

### PF-030 — `install.sh` — OPEN
Owner: `iris-vermeulen` (rule 19).
```bash
grep -c "all-zero\|deletion-only\|ref-delete" install.sh
```

### PF-031 — `tests/check.sh` Check 28 — OPEN
Owner: `iris-vermeulen` (rule 19).
```bash
grep -c "rule 8a" tests/check.sh
```

### PF-032 — `README.md` question 1 — OPEN

README's own "Enforced/Not yet" section carries no evidence tier at all —
`awk` over it finds zero fenced blocks — so this row and PF-033/PF-034 give
each standing claim in that section the tier every `PF-` row already carries.
Question 1's "Not yet" reads: "nothing holds a seeded README to being
*credible* — concise is asked for, evidence-backed is not." That is still
true, not drift: no rule, no check, and no fixture criterion mentions
credibility. `agents/zofia-kaminska.md`'s Mode A seeds a README and
`evals/cases/zofia-003-seed-bare-project` grades that seeding, but neither
checks the seeded prose against reality — only that it exists and is
concise. This is a Tier-3 finding on the claim, not a violation: it names
what would make it checkable (a criterion in `zofia-003` asserting the
seeded README's claims match a fixture's planted ground truth) rather than
manufacturing a command that only looks like enforcement.

```bash
grep -ci 'credible' PROJECT_RULES.md tests/check.sh
# → PROJECT_RULES.md:0
# → tests/check.sh:0
```

### PF-033 — `README.md` question 2 — OPEN

**Mechanical half closed 2026-09-17.** `f109ef8` removed Check 35's newest-tag
grace. The grace was why the row stayed BROKEN: it passed trivially for old
tags and forgave the only tag that could fail, so the Release leg never bound —
and it let v1.20.0 and v1.22.0 ship tagged with no GitHub Release, gate green
both times, each published by hand afterwards. `agents/haruto-nakamura.md` step
12a is now unconditional in the same campaign (`9461844`), so an autonomous cut
creates the Release too. **Exercised 2026-09-17**: v1.23.0 was cut on `7e7e1bb`,
CI-green (run 35253828372), and published as a real GitHub Release — the first
cut under the unconditional step, so the mechanism is now run, not just
asserted.

**Human-owned half stays open.** `README.md:129` still states "no GitHub
Release object is created", which is false and now doubly so. That is prose, on
`sophia-okafor`'s surface, not this board's to fix — the row stays visible
until the README says what the gate does.

The command asserts the mechanism is present, not a Release count: a count
moves every release and would redden this row on its own success.
```bash
grep -c 'gh release view' tests/check.sh; grep -c 'GitHub Release' tests/release_gate.sh
```

### PF-034 — `README.md` question 2 — OPEN

**Code-comment half closed 2026-09-17.** Check 33's header comment said "ten
row keys" against a twelve-entry `ROWS` array; `f109ef8` corrected it, and
`grep -c 'ten row' tests/check.sh` is now 0. `tests/release_gate.sh` was always
right (its own header says twelve).

**Human-owned half stays open.** README question 2 still reads "all ten are
rows in `tests/release_gate.sh`". Same treatment as PF-033: prose drift routed
to `sophia-okafor`, kept visible here rather than closed on the code fix alone.
```bash
grep -o 'ROWS=([^)]*)' tests/release_gate.sh | tr ' ' '\n' | grep -c .; grep -c 'ten row' tests/check.sh
```

### PF-035 — `release_notes_v*.md` — VERIFIED

Opened 2026-09-17 out of `971fc36`, which found the repo root holding
`release_notes_v1.21.0.md` while v1.22.0's note sat in `docs/` — rule 8 has it
exactly the other way round. The files are now right. The row exists for the
part that was not fixed: Check 31 asserts that *exactly one* release note sits
at the root and never that it is the newest tag's, which is why the inversion
was green. A defect fixed with nothing re-asking about it is a board row, not a
new rule. Teaching Check 31 the version is `iris-vermeulen`'s surface.

**Closed 2026-09-17, mechanized.** `632c439` gave Check 31 a fourth arm: with
exactly one note at the root, it must name the newest `v*` tag, with a
no-tags-in-this-clone degradation like Checks 27/28. Negative-tested by its
author and independently — renaming the root note to
`release_notes_v1.21.0.md` on main took the suite to `789 passed, 2 failed`
with `FAIL: the root release note is 'release_notes_v1.21.0.md' but the newest
tag is v1.22.0`; tree restored. The v1.23.0 cut is the first release the arm
gated. The row becomes a standing claim on the mechanism rather than on
today's filenames, per rule 21a: a command comparing the current note to the
current tag reports a fact that changes every release, so it greps for the arm
instead.
```bash
grep -c 'the root release note is' tests/check.sh
```

## Deferral log

Append-only. A deferral not written here did not happen. An item may be
deferred at most twice; a third time is a decision, not a deferral, and
belongs in the item block.

| date | id | until | reason |
|---|---|---|---|
