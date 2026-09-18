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
| PF-004 | `evals/` | ~~grading measures precision (false positives/negatives), not just declared-defect mentions~~ — retired 2026-09-18, ground (b): asks a prose grader to be graded for precision by another soft instrument | RETIRED | 2026-09-18 | — | — |
| PF-005 | `docs/release_notes_*` | no divergence between a release note and its tag goes unrecorded (v1.10.0's known divergence stays recorded, uncorrectable per rule 8) | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-006 | `tests/check.sh` | the suite is green | VERIFIED | 2026-09-17 | 14 | P2 |
| PF-007 | `tests/check.sh` | the header comment's check count matches the checks that exist | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-008 | `tests/check.sh` | checks 1–5 have been negative-tested | VERIFIED | 2026-08-04 | 60 | P3 |
| PF-009 | `agents/` | no agent prompt's body contradicts its own frontmatter or another agent's prompt | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-010 | `install.sh` | a clean-clone install works on a machine that has never run it | VERIFIED | 2026-08-05 | 60 | P3 |
| PF-011 | `evals/cases/*/input/` | fixture inputs contain no undeclared real defects | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-012 | `agents/` | ~~no fleet-wide fixture-verdict staleness against the prompt it grades~~ — retired with PF-017 2026-09-18, ground (a): covered by production evidence, ceiling recorded | RETIRED | 2026-09-18 | — | — |
| PF-013 | `agents/` | every agent runs on the cheapest model tier that passes its fixture | OPEN | 2026-09-17 | 60 | P1 |
| PF-014 | `agents/` | ~~no agent is missing the fixture its name implies~~ — rule 13 retired 2026-09-17, same reason as PF-002 | RETIRED | 2026-09-17 | — | — |
| PF-015 | `tests/check.sh` | the board's evidence commands are checked for shape (Check 12) and no residue of the retired byte-diff mechanism (Check 17) remains | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-016 | `.github/workflows/` | CI runs the same gate a developer runs, with the same result | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-017 | `agents/` | ~~fixtures exist for the autopilot cycle, the release gate and zofia's patch path, and have been dispatched~~ — retired with PF-012 2026-09-18, ground (a): v1.23.0's stranger-clone, CI-green release is the behavioural evidence a fixture would only approximate | RETIRED | 2026-09-18 | — | — |
| PF-018 | `PATHWAY_FORWARD.md` | the board can express the priority it is worked in | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-019 | `tests/release_gate.sh` | the published-release row lands in the gate, skipping without credentials or a pushed tag; the gate is run-once by construction (see block) | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-020 | `tests/check.sh` Check 27 | the untagged-release-note check exists independent of any one tag's current state | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-021 | `tests/check.sh` | Check 29's script selector uses `git ls-files`, not `find .` — no false red for a worktree-isolated dispatch | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-022 | `agents/` | `lian-zhao`'s frontmatter no longer contradicts her own body on the fixture write surface | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-023 | `tests/lock.sh` | the lock resolves to the same shared file from a main checkout and any linked worktree | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-024 | `evals/run.sh` | STALE compares the prompt SHA a verdict was graded against, not the date | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-025 | `evals/cases/zofia-004-seed-patch-established` | causes 1–2 fixed (`iris-vermeulen`); rests on criterion 3 alone — a named substring-grading limit, not a gap, closed 2026-09-18 | RETIRED | 2026-09-18 | — | — |
| PF-026 | `tests/lock.sh` / working pattern | codified as `PROJECT_RULES.md` rule 18a — acquire only for the write step | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-027 | `evals/cases/*/case.yaml`, `evals/run.sh` | a verdict names the prompt SHA it was graded against; a contested case cites its sample count (rule 25d) | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-028 | `install.sh` | ~~install a working hook set from inside a linked worktree, not only a main checkout~~ — retired 2026-09-18, ground (c): the maintainer decided to remove local hooks entirely (090ce70), not fix their reach | RETIRED | 2026-09-18 | — | — |
| PF-029 | `PROJECT_RULES.md` | ~~every live index row has body prose in the file, not only a one-line index claim~~ — retired 2026-09-18, ground (b): the rule book auditing its own formatting; nothing downstream depends on it | RETIRED | 2026-09-18 | — | — |
| PF-030 | `install.sh` | ~~`pre-push` skips the gate for a push whose ref updates are all deletions~~ — retired 2026-09-18, ground (c): same hook-removal decision as PF-028, there will be no `pre-push` hook to special-case | RETIRED | 2026-09-18 | — | — |
| PF-031 | `tests/check.sh` Check 28 | ~~a rule-8a deletion's two conditions are checkable from the commit message, not just asserted in prose~~ — retired 2026-09-18, ground (b): string-matching a sentence, same shape as the seven retired release-gate rows | RETIRED | 2026-09-18 | — | — |
| PF-032 | `README.md` question 1 | ~~the seeded-README credibility gap has no check today and stays open~~ — retired 2026-09-18, ground (b): the row's own text concedes no rule, check or criterion mentions credibility; it is an obligation on `agents/zofia-kaminska.md`'s prompt, not a board row | RETIRED | 2026-09-18 | — | — |
| PF-033 | `README.md` question 2 | "no GitHub Release object is created" is false — Check 35 verifies the mechanism and its newest-tag grace is gone (`f109ef8`); the false README prose is now fixed, human-owned, closed 2026-09-18 | RETIRED | 2026-09-18 | — | — |
| PF-034 | `README.md` question 2 | the gate decides five rows and haruto owes seven; the stale "all ten things a release owes" heading is fixed, human-owned prose, closed 2026-09-18 | RETIRED | 2026-09-18 | — | — |
| PF-035 | `release_notes_v*.md` | the release note at the repo root is the newest tag's, not a superseded one — mechanized in Check 31 (`632c439`) | VERIFIED | 2026-09-17 | 30 | P3 |

**Retirement pass, 2026-09-18 (fourth pass).** 1 P1 / 2 P2 / 19 P3 across 22
live rows, plus 13 RETIRED (all marked with the state's own `RETIRED`; the
prose in each block says whether it was never bound, covered, obsolete by
decision, or simply done). Twelve rows were open or broken going
in; eight of those were already done, obsoleted by a decision, or simulating
judgement, and are retired or closed below rather than carried forward. Only
one row — PF-013 — returns anything actionable, and it is promoted to P1.
**P1** is PF-013 (every agent on the cheapest model tier that passes its
fixture): the only open row that saves the maintainer money, and it sat at P3
through a housekeeping campaign. **P2** is active work and the claims worth
rechecking often: PF-003, PF-006. **P3** is settled, stable claims on long
intervals — checked for drift, not because they matter less in kind.

**On the board's own size.** The retirement discipline already given to the
rule book (rule 13, retired for headcount over evidence) and the eval suite
(cut 36 fixtures to 10 on positive evidence) now applies to the board itself.
A board that can be cut by two thirds in one reading was not describing real
work: PF-004 and PF-031 asked a soft grader to police itself the way the
seven retired release-gate rows once passed on a string; PF-029 and PF-032
audited formatting nothing downstream reads; PF-012/PF-017 chased a
prose-grading ceiling that a real release already answered better than a
fixture could; PF-028/PF-030 asked for a mechanism the maintainer had already
decided to remove. None of that was found by waiting — it was found by
reading each row against what it actually catches. A row earns its place by
returning something on re-check, not by having once seemed important.

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

### PF-004 — `evals/` — RETIRED

Ground (b), never bound. `must_not_find` and `declared_defects` grade presence
of a term, not precision — but the fix the row asked for is a second soft
instrument (a grader) checking a soft instrument (a grader). That is
judgement-simulation, not a mechanism; there is no reverse check to build. Kept
per rule 21, carries no command or interval.

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

### PF-012 — `agents/` — RETIRED

Retired together with PF-017, ground (a), 2026-09-18. The two are one
question — nothing verifies fixture verdicts against the prompt they grade —
and the campaign's own finding is that dispatch-and-grade-prose tops out near
50%, a ceiling of the method, not a backlog: a row demanding more
prose-grading to repair a prose-grading metric chases its own tail. The real
worry underneath — that cutting the release gate from twelve rows to five had
no coverage — was answered better than a fixture could: v1.23.0 was a real
release, stranger-cloned into an empty directory, CI green on the exact SHA.
Behavioural evidence from production is the stronger version of what a
fixture would only approximate. The staleness ceiling is now a recorded known
property, not a reopenable gap. Kept per rule 21, carries no command or
interval.

### PF-013 — `agents/` — OPEN

**Promoted to P1, 2026-09-18.** The only open row on this board that returns
anything — it saves the maintainer money — and it sat at P3 through a
housekeeping campaign. Owner: `lian-zhao`. Model tier per agent has never been
checked against "cheapest tier that still passes its fixture" — only assigned
by judgment at creation time.
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

### PF-017 — `agents/` — RETIRED

Retired together with PF-012, ground (a) — see that block for the shared
reasoning. Kept per rule 21, carries no command or interval.

### PF-018 — `PATHWAY_FORWARD.md` — VERIFIED
```bash
awk -f tests/parse_board.awk -v section=board PATHWAY_FORWARD.md | head -1 | awk -F'|' '{print NF}'
```

### PF-019 — `tests/release_gate.sh` — VERIFIED

Re-pointed 2026-09-17: `67c5a68` cut `ROWS` from twelve to five, so the old
command grepped a line that no longer exists and returned 0 under a VERIFIED
row. The claim itself is unchanged — `release` is still a row and still skips
rather than failing when `gh` is absent or the tag is not on the remote.

**Limitation, intrinsic (determined by `iris-vermeulen` against the five-row
gate, 2026-09-17).** The gate is not re-runnable after the release it gated:
`publish` compares the tag against HEAD and reds the moment any commit lands on
main, with `release` and `clone` skipping behind it, and checking out the tag
does not recover it because `tree` needs an upstream a detached HEAD has not
got. Removing the seven note rows did not dissolve this. So the gate is run
once, in the window where HEAD is the tagged commit and the remote agrees; its
output is the artifact and is pasted at that moment; a later red `publish` is
not a regression. Check 35 is what answers "is this tag still properly
published" afterwards, being tag-relative rather than HEAD-relative. Recorded
here rather than as a new row: it is a property of this row's surface, and a
row whose command can never go green is not a row.
```bash
grep -qE '^ROWS=\(.* release .*\)' tests/release_gate.sh && grep -c 'row_skip release' tests/release_gate.sh
# → 2
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

### PF-025 — `evals/cases/zofia-004-seed-patch-established` — RETIRED

Closed 2026-09-18. Criterion 3 (README/CLAUDE leave-alone guard) is a named,
understood limit of substring grading, not a fixable gap — a limit we have
named is not a gap. Kept per rule 21, carries no command or interval.

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

### PF-028 — `install.sh` — RETIRED

Ground (c), obsolete by decision, 2026-09-18. The row asked for hooks to
install from inside a linked worktree; the maintainer instead decided to
remove local hooks entirely (`090ce70`) — they were inverted, wired in the
main checkout and absent in every worktree, blocking careful work on `main`
three times while the one rogue run had none. Fixing this row's ask would
have made the obstruction universal, not the protection real. Implementing it
would reverse the decision, not fulfil it. The genuine residue — a script
that installs nothing must not report success — is handled outside this row,
in `install.sh`, by `iris-vermeulen`; no new row is opened for it. Kept per
rule 21, carries no command or interval.

### PF-029 — `PROJECT_RULES.md` — RETIRED

Ground (b), never bound, 2026-09-18. The row is the rule book auditing its own
formatting — a one-line index claim with no `##` body. Nothing downstream
depends on the body existing and no reader was misled by its absence. Kept
per rule 21, carries no command or interval.

### PF-030 — `install.sh` — RETIRED

Ground (c), obsolete by decision, 2026-09-18. Same decision as PF-028: there
will be no `pre-push` hook, so a deletion-only skip has nothing to special-case.
Kept per rule 21, carries no command or interval.

### PF-031 — `tests/check.sh` Check 28 — RETIRED

Ground (b), never bound, 2026-09-18. Checking rule 8a's two deletion
conditions "from the commit message" is string-matching a sentence — the
identical shape as the seven release-gate rows already retired for passing on
a twelve-character string. Kept per rule 21, carries no command or interval.

### PF-032 — `README.md` question 1 — RETIRED

Ground (b), never bound, 2026-09-18. The row's own text concedes no rule,
check or fixture criterion mentions credibility. That makes it an obligation
on `agents/zofia-kaminska.md`'s prompt, not a board row. Kept per rule 21,
carries no command or interval.

### PF-033 — `README.md` question 2 — RETIRED

Closed 2026-09-18. Mechanical half closed 2026-09-17: `f109ef8` removed Check
35's newest-tag grace, and v1.23.0 was cut on `7e7e1bb`, CI-green, published as
a real GitHub Release under the now-unconditional step. Human-owned half
closed by hand: the false "no GitHub Release object is created" line at
`README.md:129` is gone. Kept per rule 21, carries no command or interval.

### PF-034 — `README.md` question 2 — RETIRED

Closed 2026-09-18. The row's stale heading — "all ten things a release owes"
against a body enumerating twelve — was dropped in `eedd052`. Kept per rule
21, carries no command or interval.

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
