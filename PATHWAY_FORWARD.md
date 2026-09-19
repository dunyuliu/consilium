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
| PF-001 | `install.sh` | ~~the pre-commit hook and its version marker are committed, not only installed locally~~ — retired 2026-09-18, ground (c): there is no pre-commit hook; the same decision that retired PF-028 and PF-030 removed it | RETIRED | 2026-09-18 | — | — |
| PF-002 | `agents/` | ~~every agent has at least one eval fixture (rule 13)~~ — rule 13 retired 2026-09-17, headcount is no longer a claim this board makes | RETIRED | 2026-09-17 | — | — |
| PF-003 | `evals/cases/` | every fixture has been dispatched and graded at least once (coverage, not health — see PF-004, PF-025) | VERIFIED | 2026-09-19 | 14 | P2 |
| PF-004 | `evals/` | ~~grading measures precision (false positives/negatives), not just declared-defect mentions~~ — retired 2026-09-18, ground (b): asks a prose grader to be graded for precision by another soft instrument | RETIRED | 2026-09-18 | — | — |
| PF-005 | `docs/release_notes_*` | ~~no divergence between a release note and its tag goes unrecorded~~ — retired 2026-09-18, ground (b): the command read a tag's immutable content and printed the same 6 forever; v1.10.0's divergence stays recorded in the block below | RETIRED | 2026-09-18 | — | — |
| PF-006 | `tests/check.sh` | the suite is green | VERIFIED | 2026-09-19 | 14 | P2 |
| PF-007 | `tests/check.sh` | the header's live `Verifies:` entries are exactly the checks the body runs, by number | VERIFIED | 2026-09-19 | 30 | P3 |
| PF-008 | `tests/check.sh` | ~~checks 1–5 have been negative-tested~~ — retired 2026-09-18, ground (b): a historical fact about one day's work, watched by a green-suite command that cannot go red for it | RETIRED | 2026-09-18 | — | — |
| PF-009 | `agents/` | ~~no agent prompt's body contradicts its own frontmatter or another agent's prompt~~ — retired 2026-09-18, ground (b): one string in one of 22 files standing in for a fleet-wide semantic claim | RETIRED | 2026-09-18 | — | — |
| PF-010 | `install.sh` | a clean-clone install works on a machine that has never run it, and the gate is green in that clone | VERIFIED | 2026-09-18 | 60 | P2 |
| PF-011 | `evals/cases/*/input/` | ~~fixture inputs contain no undeclared real defects~~ — retired 2026-09-18, ground (b): the command counted case directories and nothing about it could go red for the reason the claim would go false | RETIRED | 2026-09-18 | — | — |
| PF-012 | `agents/` | ~~no fleet-wide fixture-verdict staleness against the prompt it grades~~ — retired with PF-017 2026-09-18, ground (a): covered by production evidence, ceiling recorded | RETIRED | 2026-09-18 | — | — |
| PF-013 | `agents/` | ~~every agent runs on the cheapest model tier that passes its fixture~~ — retired 2026-09-18, ground (b): unsatisfiable for the only three agents it has left, and the measurable part is done | RETIRED | 2026-09-18 | — | — |
| PF-014 | `agents/` | ~~no agent is missing the fixture its name implies~~ — rule 13 retired 2026-09-17, same reason as PF-002 | RETIRED | 2026-09-17 | — | — |
| PF-015 | `tests/check.sh` | the board's evidence commands are checked for shape (Check 12) and no residue of the retired byte-diff mechanism (Check 17) remains | VERIFIED | 2026-09-19 | 30 | P3 |
| PF-016 | `.github/workflows/` | ~~CI runs the same gate a developer runs, with the same result~~ — retired 2026-09-18, ground (b): the command reached a checkout depth and never "the same result"; the divergence it meant to catch is inspected by PF-010's clone-and-run walk | RETIRED | 2026-09-18 | — | — |
| PF-017 | `agents/` | ~~fixtures exist for the autopilot cycle, the release gate and zofia's patch path, and have been dispatched~~ — retired with PF-012 2026-09-18, ground (a): v1.23.0's stranger-clone, CI-green release is the behavioural evidence a fixture would only approximate | RETIRED | 2026-09-18 | — | — |
| PF-018 | `PATHWAY_FORWARD.md` | the board can express the priority it is worked in | VERIFIED | 2026-09-19 | 30 | P3 |
| PF-019 | `tests/release_gate.sh` | the published-release row lands in the gate, skipping without credentials or a pushed tag; the gate is run-once by construction (see block) | VERIFIED | 2026-09-19 | 30 | P3 |
| PF-020 | `tests/check.sh` Check 27 | the untagged-release-note check exists independent of any one tag's current state | VERIFIED | 2026-09-19 | 30 | P3 |
| PF-021 | `tests/check.sh` | Check 29's script selector uses `git ls-files`, not `find .` — no false red for a worktree-isolated dispatch | VERIFIED | 2026-09-19 | 14 | P3 |
| PF-022 | `agents/` | `lian-zhao`'s frontmatter no longer contradicts her own body on the fixture write surface | VERIFIED | 2026-09-19 | 30 | P3 |
| PF-023 | `tests/lock.sh` | the lock resolves to the same shared file from a main checkout and any linked worktree | VERIFIED | 2026-09-19 | 14 | P3 |
| PF-024 | `evals/run.sh` | STALE compares the prompt SHA a verdict was graded against, not the date | VERIFIED | 2026-09-19 | 14 | P3 |
| PF-025 | `evals/cases/zofia-004-seed-patch-established` | causes 1–2 fixed (`iris-vermeulen`); rests on criterion 3 alone — a named substring-grading limit, not a gap, closed 2026-09-18 | RETIRED | 2026-09-18 | — | — |
| PF-026 | `tests/lock.sh` / working pattern | codified as `PROJECT_RULES.md` rule 18a — acquire only for the write step | VERIFIED | 2026-09-19 | 30 | P3 |
| PF-027 | `evals/cases/*/case.yaml`, `evals/run.sh` | ~~a verdict names the prompt SHA it was graded against; a contested case cites its sample count (rule 25d)~~ — retired 2026-09-18, ground (a): the SHA half is PF-024's mechanism and no contested case survives the 36→10 cut | RETIRED | 2026-09-18 | — | — |
| PF-028 | `install.sh` | ~~install a working hook set from inside a linked worktree, not only a main checkout~~ — retired 2026-09-18, ground (c): the maintainer decided to remove local hooks entirely (090ce70), not fix their reach | RETIRED | 2026-09-18 | — | — |
| PF-029 | `PROJECT_RULES.md` | ~~every live index row has body prose in the file, not only a one-line index claim~~ — retired 2026-09-18, ground (b): the rule book auditing its own formatting; nothing downstream depends on it | RETIRED | 2026-09-18 | — | — |
| PF-030 | `install.sh` | ~~`pre-push` skips the gate for a push whose ref updates are all deletions~~ — retired 2026-09-18, ground (c): same hook-removal decision as PF-028, there will be no `pre-push` hook to special-case | RETIRED | 2026-09-18 | — | — |
| PF-031 | `tests/check.sh` Check 28 | ~~a rule-8a deletion's two conditions are checkable from the commit message, not just asserted in prose~~ — retired 2026-09-18, ground (b): string-matching a sentence, same shape as the seven retired release-gate rows | RETIRED | 2026-09-18 | — | — |
| PF-032 | `README.md` question 1 | ~~the seeded-README credibility gap has no check today and stays open~~ — retired 2026-09-18, ground (b): the row's own text concedes no rule, check or criterion mentions credibility; it is an obligation on `agents/zofia-kaminska.md`'s prompt, not a board row | RETIRED | 2026-09-18 | — | — |
| PF-033 | `README.md` question 2 | "no GitHub Release object is created" is false — Check 35 verifies the mechanism and its newest-tag grace is gone (`f109ef8`); the false README prose is now fixed, human-owned, closed 2026-09-18 | RETIRED | 2026-09-18 | — | — |
| PF-034 | `README.md` question 2 | the gate decides five rows and haruto owes seven; the stale "all ten things a release owes" heading is fixed, human-owned prose, closed 2026-09-18 | RETIRED | 2026-09-18 | — | — |
| PF-035 | `release_notes_v*.md` | the release note at the repo root is the newest tag's, not a superseded one — mechanized in Check 31 (`632c439`) | VERIFIED | 2026-09-19 | 30 | P3 |

**Retirement pass, 2026-09-18 (fifth pass).** 0 P1 / 2 P2 / 17 P3 across 19
live rows, plus 16 RETIRED (all marked with the state's own `RETIRED`; the
prose in each block says whether it was never bound, covered, obsolete by
decision, or simply done). The fourth pass left one P1 and three rows green on
a command that no longer reached anything. This pass retires all four: PF-001
and PF-027 passed on a marker and a file that a deletion elsewhere had already
removed, PF-013's criterion can never be met by the agents it has left, and
PF-010's grep was a proxy that could not fail — it alone is kept, re-pointed at
the walk it always claimed. **No P1 stands.** **P2** is active work and the
claims worth rechecking often: PF-003, PF-006. **P3** is settled, stable claims
on long intervals — checked for drift, not because they matter less in kind.
**A green row is not a checked row**: three of these four were green on every
pass since the thing they watched was deleted, which is what re-running a
command and reading what it reaches — rather than reading its exit status —
is for.

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

**Sixth pass, 2026-09-18 — read what a command reaches, not what it returns.**
0 P1 / 3 P2 / 11 P3 across 14 live rows, plus 21 RETIRED. Five rows retired on
ground (b), all the same defect and none of it visible from a row's state: the
command returned something, so the row was green, but nothing it read could
change for the reason the claim would go false. PF-011 counted directories,
PF-016 read a checkout depth, PF-005 read a tag's immutable content, PF-009
grepped one sentence in one of 22 files for a fleet-wide semantic claim, and
PF-008 borrowed PF-006's green suite to stand for a mutation run once in
August. **A frozen command is a record, not an inspection** — it cannot go red,
so re-running it is reading a receipt. PF-007 had the same one-sided shape and
is repaired rather than retired, because the claim is worth keeping and a
two-sided command exists. PF-010 is extended, not duplicated: it now runs the
gate inside the clone it already makes, and rises to P2 as the only row on this
board whose command has ever gone red for a real defect. **Nothing was added** —
no row, no rule, no check. Five rows left and none arrived; 14 live against 35
ever opened.

## Items

Each item names its command; run it to close or re-check the row. Full prior
history (every past run, investigation and superseded claim) is compressed out
of this file and lives at git SHA `b9430a3` — see the note above.

### PF-001 — `install.sh` — RETIRED

Ground (c), obsolete by decision, 2026-09-18. There is no pre-commit hook:
`86f4b5d` removed it, under the same decision that retired PF-028 and PF-030.
The row stayed green because its command counted `HOOK_VERSION`, which now
belongs to the `post-merge` symlink-sync convenience at `install.sh:38` — a
marker for a different hook, and not a gate. A row that passes on a proxy for
a thing that no longer exists is worse than no row. Kept per rule 21, carries
no command or interval.

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

Run 2026-09-18, after `f1289f6` rewrote every case's `notes:` block and
`b1b1ad8` cut the suite from ten cases to nine: no output, exit 0 — all nine
surviving cases still carry a dated `Run (...)` line.
```bash
for d in evals/cases/*/; do [ -f "$d/case.yaml" ] || { echo "$(basename "$d"): NO case.yaml"; continue; }; grep -qiE 'run \((19|20)[0-9]{2}-' "$d/case.yaml" || echo "$(basename "$d"): NEVER RUN"; done
```

### PF-004 — `evals/` — RETIRED

Ground (b), never bound. `must_not_find` and `declared_defects` grade presence
of a term, not precision — but the fix the row asked for is a second soft
instrument (a grader) checking a soft instrument (a grader). That is
judgement-simulation, not a mechanism; there is no reverse check to build. Kept
per rule 21, carries no command or interval.

### PF-005 — `docs/release_notes_*` — RETIRED

Ground (b), never bound, 2026-09-18. The command read `v1.10.0`, an immutable
tag: it printed `6` on every pass since 2026-08-05 and will print `6` forever,
so the row could not go red for the reason the claim would go false — it was a
record wearing an inspection's clothes. `anya-001` is not among the ten
surviving fixtures either, so the string it counted no longer names anything
live. **The disclosure itself is not retired, only the pretence of re-checking
it**: v1.10.0 shipped six undisclosed `anya-001` files, that divergence is
uncorrectable under rule 8, and this block is where it stays recorded. Kept per
rule 21, carries no command or interval.

### PF-006 — `tests/check.sh` — VERIFIED
Green means the checks pass, not that the repo is correct (PF-008).
`Summary: 796 passed, 0 failed`, run 2026-09-18 on base `b1b1ad8` after the
rule-book slim in this worktree.
```bash
bash tests/check.sh | tail -1
```

### PF-007 — `tests/check.sh` — VERIFIED

**Repaired 2026-09-18, not retired.** The claim is worth keeping and was true;
the command was one-sided. `grep -c '^echo "Check'` counted the body alone, so
a header naming a check the body had dropped — or a body running one the header
never names — was invisible to it, which is the whole of what the row claims to
watch. The replacement compares the two sides by number: the header's live
`Verifies:` entries (entries marked retired excluded, they are deliberate gaps)
against the check numbers the body actually echoes. It reddens on either side
moving alone, which is what must remain true rather than what happens to be
true today.

Run 2026-09-18 on base `b1b1ad8`: `header and body agree: 31 live checks` — 36
header entries, 5 marked retired, 31 live, matching the body. It was 32 until
`7973539` merged Check 5 into Check 8 the same day. Exit 0; a mismatch prints
the diff and exits 1.
```bash
diff <(sed -n '/^# Verifies:/,/^# Checks 6 and 7/p' tests/check.sh | grep -oE '^# +[0-9]+\. \(retired|^# +[0-9]+\.' | grep -v retired | grep -oE '[0-9]+') <(grep -oE '^echo "Check [0-9]+' tests/check.sh | grep -oE '[0-9]+') && echo "header and body agree: $(grep -c '^echo "Check' tests/check.sh) live checks"
```

### PF-008 — `tests/check.sh` — RETIRED

Ground (b), never bound, 2026-09-18. The claim is a historical fact — on
2026-08-04 six mutations were run against checks 1–5, each produced its
intended failure message, each was restored — and a fact about one day's work
cannot come due again. Worse, the command watching it was
`bash tests/check.sh | tail -1`, which is PF-006 verbatim: a green suite says
nothing about whether any mutation was ever run, so the row was green on
another row's evidence. The record of the negative-testing stays here; the
standing obligation that every new check be negative-tested when added is
stated in `tests/check.sh`'s own header, not re-asked by a board row. Kept per
rule 21, carries no command or interval.

### PF-009 — `agents/` — RETIRED

Ground (b), never bound, 2026-09-18. The claim is fleet-wide and semantic — no
prompt contradicts its own frontmatter or another prompt — and the command was
`grep -c` for one sentence in one of 22 files. It could only ever have gone red
if that one description line changed, which is not the failure the claim
describes. It came within an hour of demonstrating this: `agents/wei-lin.md`
was slimmed 555→512 lines in `c387444` and the counted string survived by luck,
not because the claim held. The row's real content was the 2026-09-17 read by
`sophia-okafor` — all 22 prompts against three questions, one drift found and
fixed in `agents/wei-lin.md` — which is dated judgement work, not a standing
claim a command settles. `CLAUDE.md` already names reading a prompt for sense
as `lian-zhao`'s job and explicitly outside the gate. Kept per rule 21, carries
no command or interval.

### PF-010 — `install.sh` — VERIFIED
Re-pointed 2026-09-18. The old command grepped `CLAUDE=${HOME}/.claude` out of
`install.sh` — a variable assignment is not evidence that an install works, and
the proxy was regex-fragile besides: it returned 0 on a box whose grep reads
the `$` before `{` as an anchor, while `install.sh:20` is exactly that line. A
proxy that cannot fail for the right reason and can fail for the wrong one is
not evidence either way.

The claim is unchanged and the command now performs the walk it always
described: clone this repo into a temp directory, install under a `HOME` that
has never seen it, and count the agent symlinks that appear. It reaches the
real failure — an install that links nothing, or that depends on state in the
developer's `HOME`. Verified 2026-09-18 by `wei-lin` against a stranger clone
of `https://github.com/dunyuliu/consilium.git` at `31660df` under a sandboxed
`HOME`: `consilium installed: 22 agents, 19 commands, 1/1 hooks wired`, exit 0,
22 symlinks, and `bash tests/check.sh` green in that clone.

**Extended 2026-09-18 — the gate now runs inside the clone.** The fresh-clone
walk is the only source still catching defects the in-checkout gate cannot see,
and today it caught one: at the pre-fix commit, `bash tests/check.sh` in a plain
clone printed `778 passed, 28 failed` while the same commit printed
`806 passed, 0 failed` in the maintainer's checkout — Check 35 was resolving
GitHub Releases through a non-GitHub origin (fixed in `227bf9e`). That
divergence was found because somebody thought to clone, which is not an
interval. Running the gate inside the clone this row already makes puts it on
one, for one line. It is an extension of this row and not a second row: the
claim was always about what a stranger's machine does, and an install that
links 22 symlinks into a clone whose gate is red is not a working clone.

Run 2026-09-18 in this worktree, literal output: `consilium installed: 22
agents, 19 commands, 1/1 hooks wired`, then `22`, then
`Summary: 806 passed, 0 failed`; exit 0. Raised to P2: it is the only row whose
command has ever gone red for a real defect, and 60 days is already the
longest interval on the board's one live detector.
```bash
d=$(mktemp -d)
git clone -q "$(git rev-parse --show-toplevel)" "$d/clone"
(cd "$d/clone" && HOME="$d/home" bash install.sh)
ls "$d/home/.claude/agents" | wc -l
(cd "$d/clone" && bash tests/check.sh | tail -1)
rm -rf "$d"
```

### PF-011 — `evals/cases/*/input/` — RETIRED

Ground (b), never bound, 2026-09-18. The command was `ls evals/cases | wc -l`:
it counts case directories, so it reddens when a fixture is added or cut — the
36→10 cut would have tripped it — and never when an input acquires a real
defect nobody declared. Nothing it reads can change for the reason the claim
would go false. The claim as written also needs a reader: whether a defect in
an input is undeclared is a comparison of prose to prose. The two mechanizable
neighbours already exist and are not this row — Check 18 (no answer-key
language in an input) and Check 26 (no generated artefact written into one).
Kept per rule 21, carries no command or interval.

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

### PF-013 — `agents/` — RETIRED

Ground (b), never bound, adjudicated 2026-09-18 rather than re-checked.

Tiers today: 15 sonnet, 3 haiku, 3 opus, 1 fable. The measurable part of this
row is done — `nadia-hadid` moved opus→sonnet on a graded run (v1.24.0), which
is the one move this claim ever produced. What is left is the three opus
agents, `elena-hartmann`, `victor-reyes` and `marco-bianchi`, and for exactly
those three the row's own wording — "the cheapest tier that passes **its
fixture**" — can never be satisfied: none has a fixture, and `lian-zhao`
refuses by prompt to touch an agent that has none. PF-019 already states the
principle this falls under: a row whose command can never go green is not a
row.

The two ways out are both worse than retiring. Building three fixtures to
unblock a demotion is the headcount reflex rule 13 was retired for. Keeping the
row on its current command is keeping a census — `grep '^model:'` prints a tier
distribution, which is a fact, never a pass or a fail, and a command that
cannot go red is the same defect as PF-001's.

So the remainder is recorded here as a judgement, not carried as a task: three
agents run on opus by assignment at creation time and nothing has tested a
cheaper tier for them. That is a known property of the fleet, not an open item.
It becomes a row again if and when one of the three gets a fixture — with that
fixture, and not before. Kept per rule 21, carries no command or interval.

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
grep -c "parse_board.awk -v section=board" tests/check.sh && ! grep -nE "section=evidence|Check 17" tests/check.sh
```

### PF-016 — `.github/workflows/` — RETIRED

Ground (b), never bound, 2026-09-18. `grep -c '^ *fetch-depth: 0$'` reaches the
checkout depth of the CI job and stops there. The load-bearing half of the
claim — *with the same result* — was never touched by it, and a workflow that
fetched full history while running a different command, or no command, would
have kept this row green. The half that can be inspected on an interval is
checkout-versus-clone divergence, and PF-010 now runs the gate inside the clone
it already makes; the half that cannot is whether GitHub's runner agrees with a
developer's box, which only a real CI run reports and which reports itself,
red, on every push. Kept per rule 21, carries no command or interval.

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

### PF-027 — `evals/cases/*/case.yaml`, `evals/run.sh` — RETIRED

Ground (a), covered, 2026-09-18. The row's command read
`evals/cases/zofia-004-seed-patch-established/case.yaml`, which `124ee36`
deleted when the fixture suite was cut 36→10; the command now errors rather
than returning a count, so the VERIFIED state had stopped meaning anything.
Both halves are gone as claims. `grep -rl 'contested: true' evals/cases/`
matches nothing in the surviving ten, so "a contested case cites its sample
count" has no instance to be true or false about — the sample-count mechanism
itself lives in `evals/run.sh` (`CONTESTED_UNSETTLED`) and is exercised when a
contested case next exists. The prompt-SHA half is PF-024's surface, verbatim:
`run_record_sha` and the SHA-not-date comparison are what that row keeps true,
and re-pointing this one at the same mechanism would put one claim on two rows,
which is the failure Check 34 exists to prevent one file up. Kept per rule 21,
carries no command or interval.

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
