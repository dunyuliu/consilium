# CLAUDE.md — working notes for editing consilium

`README.md` says what consilium is and how to use it. `PROJECT_RULES.md` is the
binding rule book. `PATHWAY_FORWARD.md` is the present tense of every surface.
This file is the fourth job: how to *work on* this repo — the order a change
goes in, what the gate does and does not cover, and the traps that have already
cost time. It restates no rule; where a rule governs, it is cited by number.

## What the repo is

`agents/*.md` and `commands/*.md` are the shipped artifacts. There is no build
step, no import graph, and no runtime that would object to a mistake: a broken
cross-reference between two prompts has no symptom until an agent follows it in
a live session. `tests/check.sh` is the only compiler this repo has, and
`evals/cases/` is the only thing that measures whether a prompt edit helped.

## Commands

```bash
bash tests/check.sh                        # the gate — pure bash, no deps (rule 3)
bash evals/run.sh list                     # every fixture, and whether its verdict is current
bash evals/run.sh smoke                    # the fast tier — run after any prompt edit
bash evals/run.sh stage <case-id>          # isolated copy of input/ + the prompt to paste
bash evals/run.sh grade <case-id> rep.md   # score a report against case.yaml
bash evals/run.sh score                    # how much of the suite still means anything
bash install.sh                            # reconcile the ~/.claude symlinks (idempotent)
bash tests/lock.sh status                  # who holds the repo lock, and since when
```

`run.sh` never invokes an agent. Dispatching needs API access, so a fixture's
verdict means a human pasted the staged prompt into a real session and graded
what came back — `list` is where you find out whether that happened before or
after the prompt changed.

## Order of operations for a change

1. **Take the lock** if the change is mutating and spans files:
   `export CONSILIUM_LOCK_OWNER=<you>`, then
   `bash tests/lock.sh acquire "<what>" <path-prefix>…`. The path prefixes are
   the scope guard — the pre-commit hook refuses anything staged outside them,
   which is what stops a `git add -A` from swallowing another writer's
   half-finished work. A lock is never auto-cleared, however stale it looks
   (rule 18).
2. **Edit one surface.** Rule 19's table says which agent owns which; rule 1
   says keep the edit small and prefer sharpening a rule to adding one.
3. **Fixture before fix** for anything an agent actually got wrong (rule 10).
   A prompt edit with no fixture is an opinion about behaviour.
4. **Run the gate locally, then smoke** (rule 9). The pre-push hook runs the
   gate anyway; `--no-verify` is a deliberate act, not a shortcut.
5. **Move the docs in the same commit** (rule 11). A new agent owes a README
   roster row, a model-table row, a Layout line (rule 12) and a fixture that
   names it (rule 13). A new rule owes an index row carrying its tier. A new
   check owes the `Verifies:` list in the header of `tests/check.sh` and the
   board row that counts them.
6. **Close the board row you touched**: run its command, paste the literal
   stdout on the `# →` line, set the date (rule 21a). Check 17 re-runs every
   board command on every suite run and byte-diffs the result, so a date bump
   without a run reddens the gate the same day.

## What the gate cannot see

The checks cover structure — frontmatter, cross-references, README-to-disk
sync, write-surface ownership, isolation-first prompts, board currency, and the
eval suite's own criteria. The header of `tests/check.sh` lists all of them.
None of them read a prompt for sense. Specifically uncovered:

- Whether a prompt is any good — coherent persona, sane routing, no
  contradiction between two sections. That is `lian-zhao`'s job, not a check's.
- Whole sections of a prompt that no fixture exercises. Check 25 proves each
  agent *has* a fixture, never that its fixtures reach every mode the prompt
  describes; `bash evals/run.sh list` is the honest inventory.
- Two checks disappear in a shallow clone (27 and 28: no tags, no history), and
  they say so rather than passing quietly. Green in a shallow clone is a weaker
  claim than green in a full one.

## Traps, each already paid for

- **The answer key lives above `input/`.** `evals/run.sh stage` copies `input/`
  outside the repo precisely so `case.yaml` and the case README are
  unreachable. Never point an agent at a case directory (that leak happened,
  2026-07-31, and leakage is invisible in the output). Never plant an expected
  keyword in the input (rule 5a, Check 18). Never put a symlink in `input/` —
  staging copies the link verbatim and an absolute one reads straight back out
  of the isolated copy (Check 23).
- **Grading is substring matching.** An `expected` keyword that ordinary
  finding-free prose already contains will pass a report that found nothing:
  the bare word "correct" once scored three criteria, zero failed. Check 30
  holds the corpus that decides whether a term is safe.
- **A criterion can also reject a correct report.** Every case ships
  `samples/pass.md` and `samples/fail.md`, and Check 15 grades both, because a
  criterion that rejects a report written to satisfy it is a typo with
  authority.
- **Rule numbers never move.** A refinement becomes a sub-rule (1a, not 32) and
  a dropped rule keeps its number. Renumbering breaks every commit and report
  that cited one.
- **Filename case is load-bearing.** `PROJECT_RULES.md`, in exactly that
  spelling: a lowercase twin was written once and neither writer could see the
  other's file (2026-07-31).
- **Do not write the `~/.claude` symlink paths literally in any `.sh` but
  `install.sh`.** Check 29 greps for them and its own first draft flagged the
  checker's comment.
- **A blank date on the board is data**, not an unfilled field: it means nobody
  has ever checked that surface, and backfilling it is the exact failure the
  board exists to prevent (rule 21).
- **A new root file needs an explicit ask.** Rule 1's table is the whitelist and
  Check 31 diffs the real root against it; new content almost always belongs in
  one of the four root documents, or under `docs/`, `tests/`, `evals/`,
  `agents/` or `commands/`.

## This file

No agent owns it. Rule 19's table covers agent write surfaces and `CLAUDE.md`
is not one of them, so it is maintained by hand: `zofia-kaminska` refuses to
edit it while auditing, and `sophia-okafor` reports doc-versus-code drift
rather than fixing it.

Keep it a working doc. Usage belongs in `README.md` and is cited here, never
copied; a binding constraint belongs in `PROJECT_RULES.md`; a dated open issue
belongs in `PATHWAY_FORWARD.md` and nowhere else. A fact living in two of the
four will be wrong in one of them, and not in the one you happen to be reading.
