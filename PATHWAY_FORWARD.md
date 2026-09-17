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
| PF-002 | `agents/` | every agent has at least one eval fixture (rule 13) | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-003 | `evals/cases/` | every fixture has been dispatched and graded at least once (coverage, not health — see PF-004, PF-025) | VERIFIED | 2026-09-17 | 14 | P2 |
| PF-004 | `evals/` | grading measures precision (false positives/negatives), not just declared-defect mentions | OPEN | 2026-09-16 | 60 | P1 |
| PF-005 | `docs/release_notes_*` | no divergence between a release note and its tag goes unrecorded (v1.10.0's known divergence stays recorded, uncorrectable per rule 8) | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-006 | `tests/check.sh` | the suite is green | VERIFIED | 2026-09-16 | 14 | P2 |
| PF-007 | `tests/check.sh` | the header comment's check count matches the checks that exist | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-008 | `tests/check.sh` | checks 1–5 have been negative-tested | VERIFIED | 2026-08-04 | 60 | P3 |
| PF-009 | `agents/` | no agent prompt's body contradicts its own frontmatter or another agent's prompt | VERIFIED | 2026-09-17 | 30 | P3 |
| PF-010 | `install.sh` | a clean-clone install works on a machine that has never run it | VERIFIED | 2026-08-05 | 60 | P3 |
| PF-011 | `evals/cases/*/input/` | fixture inputs contain no undeclared real defects | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-012 | `agents/` | no fleet-wide fixture-verdict staleness against the prompt it grades | OPEN | 2026-09-17 | 14 | P1 |
| PF-013 | `agents/` | every agent runs on the cheapest model tier that passes its fixture | OPEN | 2026-09-17 | 60 | P3 |
| PF-014 | `agents/` | no agent is missing the fixture its name implies | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-015 | `tests/check.sh` | the board's evidence commands are checked for shape (Check 12); pending — remove the now-dead byte-diff mechanism (Check 17), retired by the rule 21a amendment | OPEN | 2026-09-17 | 14 | P1 |
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
| PF-026 | `tests/lock.sh` / working pattern | codified as `PROJECT_RULES.md` rule 18a — acquire only for the write step | VERIFIED | 2026-09-16 | 30 | P3 |
| PF-027 | `evals/cases/*/case.yaml`, `evals/run.sh` | a verdict names the prompt SHA it was graded against; a contested case cites its sample count (rule 25d) | VERIFIED | 2026-09-16 | 14 | P3 |
| PF-028 | `install.sh` | install a working hook set from inside a linked worktree, not only a main checkout (owner: `iris-vermeulen`) | BROKEN | 2026-09-17 | 14 | P1 |
| PF-029 | `PROJECT_RULES.md` | every index row has body prose in the file, not only a one-line index claim | OPEN | 2026-09-17 | 60 | P2 |
| PF-030 | `install.sh` | `pre-push` skips the gate for a push whose ref updates are all deletions (rule 9a; owner: `iris-vermeulen`) | OPEN | 2026-09-17 | 30 | P2 |
| PF-031 | `tests/check.sh` Check 28 | a rule-8a deletion's two conditions are checkable from the commit message, not just asserted in prose (owner: `iris-vermeulen`) | OPEN | 2026-09-17 | 30 | P2 |
| PF-032 | `README.md` question 1 | the seeded-README credibility gap ("nothing holds a seeded README to being credible") has no check today and stays open — a true "Not yet", not drift | OPEN | 2026-09-17 | 60 | P3 |
| PF-033 | `README.md` question 2 | "no GitHub Release object is created" is false — Check 35 already creates and verifies the mechanism, but its newest-tag grace has no override, the open half of rule 28 | BROKEN | 2026-09-17 | 30 | P2 |
| PF-034 | `README.md` question 2 / `tests/check.sh` Check 33 | the release gate has twelve rows, not ten — README and Check 33's own header comment both say ten while `tests/release_gate.sh`'s own header and its `ROWS` array say twelve | BROKEN | 2026-09-17 | 30 | P2 |

**Re-tiered 2026-09-17**, from 4 P1 / 8 P2 / 19 P3 to 4 P1 / 12 P2 / 15 P3.
**P1** is reserved for what is actively broken or is a real, currently-unclosed
gap in the mechanisms the rest of the board depends on: PF-004 (grading can't
tell a precise finding from a lucky one), PF-012 (fleet staleness, unmeasured
drift between prompts and their verdicts), PF-017 (no fixture coverage yet for
autopilot/release-gate/the patch path), PF-028 (install is broken today from a
worktree). PF-015 is P1 because it is this change's own direct follow-through
— Check 17 needs removing now that 21a no longer requires it, not on its own
60-day drift. **P2** is active work-in-progress and standing claims worth
rechecking often (PF-003, PF-006, PF-009's next read, PF-025, PF-029–031).
**P3** is settled, stable claims — most already VERIFIED and unlikely to
regress on their own — checked on a long interval for drift, not because they
matter less in kind.

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

### PF-002 — `agents/` — VERIFIED
```bash
for d in evals/cases/*/; do [ -f "$d/case.yaml" ] && basename "$d"; done | sed 's/-[0-9].*//' | sort -u | wc -l | tr -d ' '
```

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
```bash
bash tests/check.sh | tail -1
```

### PF-007 — `tests/check.sh` — VERIFIED
No longer self-maintaining now that Check 17 is retired (PF-015) — recheck on
interval like any other row.
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
```bash
bash evals/run.sh list | grep -c STALE
```

### PF-013 — `agents/` — OPEN
Model tier per agent has never been checked against "cheapest tier that still
passes its fixture" — only assigned by judgment at creation time.
```bash
grep -h '^model:' agents/*.md | awk '{c[$2]++} END{for(k in c) printf "%d %s\n", c[k], k}' | sort -k2
```

### PF-014 — `agents/` — VERIFIED
```bash
for a in agents/*.md; do s=$(basename "$a" .md); ls evals/cases 2>/dev/null | grep -q "^${s%%-*}-" || echo "$s"; done | wc -l | tr -d ' '
```

### PF-015 — `tests/check.sh` — OPEN
Check 17 (byte-diff of recorded board evidence) is dead weight now that rule
21a no longer requires a `# →` line — it still runs but checks nothing 21a
asks for. Route: `iris-vermeulen`, to remove it.
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
```bash
for r in 5b 13a 21b 23a 25b; do grep -qx "## $r\." PROJECT_RULES.md || grep -q "^## $r\." PROJECT_RULES.md || echo "$r: no ## heading"; done
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

### PF-033 — `README.md` question 2 — BROKEN

README:129 states "no GitHub Release object is created." False: `gh release
list` on this repo returns 24 published Releases, and `tests/check.sh` Check
35 (added since this README prose was last true) already shells out to
`gh release view` to verify a GitHub Release exists for the newest tag,
degrading honestly when `gh` is unavailable. The mechanism this claim says
does not exist, exists. Routed to `sophia-okafor` (doc-vs-code drift) for
the README correction itself, which is human-owned prose this row does not
touch.

The row does not re-assert "24 Releases exist" — that number moves every
release and would falsely redden this claim on its own success, the exact
failure rule 21a's provenance note describes. It asserts the mechanism is
still present, which is what actually answers question 2:

```bash
grep -c 'gh release view' tests/check.sh; grep -c 'GitHub Release' tests/release_gate.sh
# → 1
# → 4
```

Cross-reference: `PROJECT_RULES.md` rule 28, incident 3 — Check 35's
newest-tag grace was held by the fabricated `v9.9.9` tag with no override,
which is the still-open half of this row (a gate blocking a correct release
with no corrective path inside the check itself).

### PF-034 — `README.md` question 2 / `tests/check.sh` Check 33 — BROKEN

README's question 2 opens: "Audit the changes, correctness, ... and the rule
book followed. **Enforced**: all ten are rows in `tests/release_gate.sh`."
`tests/check.sh` Check 33's own header comment (line 1313) independently
says "ten row keys." Both are wrong: `tests/release_gate.sh`'s `ROWS` array
has twelve entries, and the script's own header (line 2) correctly says
"the twelve rows." Three sources, two different numbers, inside one repo
whose own rule 11 requires docs to move with the code they describe.
Routed to `sophia-okafor` — the drift is in prose (README) and in a code
comment (Check 33's header), not in behavior; `tests/release_gate.sh` itself
is correct and unaffected.

```bash
grep -o 'ROWS=([^)]*)' tests/release_gate.sh | tr ' ' '\n' | grep -c .; grep -c 'twelve rows' tests/release_gate.sh; grep -c 'ten row' tests/check.sh
# → 12
# → 1
# → 1
```

## Deferral log

Append-only. A deferral not written here did not happen. An item may be
deferred at most twice; a third time is a decision, not a deferral, and
belongs in the item block.

| date | id | until | reason |
|---|---|---|---|
