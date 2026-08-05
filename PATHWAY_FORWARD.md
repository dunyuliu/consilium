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
| PF-005 | `docs/release_notes_*` | each release note matches its tag, or the divergence is recorded here | VERIFIED | 2026-08-05 | 30 |
| PF-006 | `tests/check.sh` | the suite is green | VERIFIED | 2026-08-04 | 14 |
| PF-012 | `agents/` | prompt slimming did not change behaviour | OPEN | 2026-08-05 | 30 |
| PF-013 | `agents/` | every agent runs on the cheapest tier that passes its fixture | OPEN | 2026-08-05 | 60 |
| PF-007 | `tests/check.sh` | the header comment describes the checks that exist | VERIFIED | 2026-08-04 | 30 |
| PF-008 | `tests/check.sh` | checks 1–5 have been negative-tested | VERIFIED | 2026-08-04 | 60 |
| PF-009 | `agents/` | no agent prompt has drifted from its documented behaviour | OPEN | 2026-08-05 | 60 |
| PF-010 | `install.sh` | a clean-clone install works on a machine that has never run it | VERIFIED | 2026-08-05 | 60 |
| PF-011 | `evals/cases/*/input/` | fixture inputs contain no undeclared real defects | VERIFIED | 2026-08-05 | 30 |
| PF-014 | `agents/` | no agent is missing the fixture its name implies | VERIFIED | 2026-08-05 | 30 |
| PF-015 | `tests/check.sh` | the board's recorded evidence is re-executed, not just cited | VERIFIED | 2026-08-04 | 14 |
| PF-016 | `.github/workflows/` | CI runs the same gate a developer runs, with the same result | VERIFIED | 2026-08-05 | 14 |

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
for d in evals/cases/*/; do [ -f "$d/case.yaml" ] && basename "$d"; done | sed 's/-[0-9].*//' | sort -u | wc -l | tr -d ' '
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
# → anya-002-clean-publishable: NEVER RUN
# → lars-002-clean-control: NEVER RUN
# → nadia-002-criterion-not-agent: NEVER RUN
# → selin-001-supershear-resolution: NEVER RUN
# → zofia-002-rule-already-exists: NEVER RUN
```

### PF-004 — `evals/` — OPEN

`must_not_find` guards phrasings, not precision: a report finding the planted defect
plus four things that are not there scores identically to a clean one.

**Half built 2026-08-05, and the other half established as unbuildable.**
`declared_defects:` now lists every real defect in a case's `input/`, including
the ones nobody planted, and `grade` reports how many were mentioned as a
diagnostic that cannot move the verdict (rule 5 admits one eval pass criterion).
It makes a correct-but-uncredited finding visible; before this those defects
lived in prose that nothing read. Landed on eight cases — `jordan-001`, `mira-001`,
`lars-001`, `sophia-001`, `sophia-002`, `dunyu-001`, `ziyan-001`, `lars-002`.
Each of the first three pass samples immediately scored short by exactly the
defect that was undeclared before the PF-011 audit (1 of 2, 3 of 4, 2 of 3), and
`sophia-001` reads 2 of 3, `ziyan-001` 2 of 4.

A low ratio is not automatically bad: `dunyu-001` reads 0 of 4 and `lars-002`
0 of 1, both correctly — a deferral does not enumerate the physics it defers,
and a clean control's bar is "nothing false", not "report everything".

Populating the eight surfaced one more defect of a familiar shape.
`ziyan-001` shipped the term `"2 \\times 10"`: terms are matched literally with
no unescaping, so the author's YAML-style escaping reached `grep -F` as a double
backslash and **the criterion could never fire**. Swept all three criteria
sections of all 23 cases for backslashes — it was the only one. No check added:
the only complete test is "flag any `\\`", and a `ziyan` report quoting a LaTeX
line break would trip it.

The reverse direction — listing report findings that map to NO declared defect,
and returning INCONCLUSIVE when any are unmapped — is **not buildable**. It
requires enumerating findings from prose, where findings are not delimited.
Counting rows counts non-findings, and that error has already been made twice
here: `lars-002` and `sophia-002` both had a pass bar written in report rows and
both had to be rewritten in distinct defects. `grade` therefore prints
"NOT MEASURED" rather than an INCONCLUSIVE derived from a count that would
itself be wrong. This row stays OPEN because precision is still not measured —
what changed is that the gap is now quantified on one side and named on the
other.

```bash
grep -c 'declared_defects' evals/README.md evals/run.sh evals/cases/*/case.yaml | grep -v ':0$' | wc -l | tr -d ' '
# → 12
```

### PF-005 — `docs/release_notes_*` — VERIFIED

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

**Claim deliberately changed 2026-08-05; this paragraph is the record of that
decision.** The old claim was *"each release note matches the commit it tags"*.
It is false, it will be false forever, and rule 8 forbids the only act that
would make it true. A standing claim that can never hold is not a claim — it is
a permanent alarm, and a board with a permanently red row teaches its reader to
ignore red rows.

`DEFERRED` is also wrong: deferral means *later*, and there is no later. The row
now tracks the invariant that can actually be held — **no divergence goes
unrecorded** — and the v1.10.0 divergence stays above in full, with its cause and
the reason it was not corrected.

This is a weakening, and weakening a bar so it passes is what rule 25 warns
against. The distinction claimed, for the reader to judge: the fact is unchanged
and still on the board, the obligation on every future release is unchanged, and
what was dropped is only the demand that a past commit be other than what it is.

### PF-006 — `tests/check.sh` — VERIFIED

Narrower than it looks: green means the checks pass, not that the repo is correct. See
PF-008.

```bash
bash tests/check.sh | tail -1
# → Summary: 740 passed, 0 failed
```

### PF-007 — `tests/check.sh` — VERIFIED

The header comment documents 29 checks and 29 exist. This row is now
self-maintaining: Check 17 re-runs the command below on every suite run, so
adding a check without updating the header reddens the gate the same day.

```bash
grep -c '^echo "Check' tests/check.sh
# → 29
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
# → Summary: 740 passed, 0 failed
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

### PF-009 — `agents/` — OPEN

The prompts have never been audited as a set — only individually, when someone
was already editing one.

**Partially audited 2026-08-05.** Three narrow claims were checked completely.
The row stays OPEN because the headline claim is broader than what was checked,
and saying otherwise would be the v1.7.0 mistake again.

**Checked, and clean — dispatch coherence.** All five agents holding the `Agent`
tool name other agents they route to (`victor-reyes` 11, `wei-lin` 8, `elena-
hartmann` 4, `lian-zhao` 4, `haruto-nakamura` 3), so none holds a capability it
never uses. No agent lacking `Agent` is instructed to dispatch. `nadia-hadid`
was the one candidate — she names three agents and has a `### Dispatch` heading —
and reading it settles the question: it is a *field in the report she writes*
("Right agent: yes / no / borderline"), a judgement about someone else's
dispatch, not an instruction to perform one. Correct as written.

**Checked, and clean — read-only claims against tool lists.** A deliberately
loose grep for read-only language flagged three agents that hold `Edit`/`Write`.
All three were read and all three are consistent: `haruto-nakamura` says
"read-only for auditing; use Bash for release steps when asked to execute";
`zofia-kaminska` says "never edit the code you are auditing" while owning the
rule book under rule 19; `nadia-hadid`'s hits were the dispatch language above.
The agents that declare themselves purely read-only (`lars-eriksson`,
`sophia-okafor`, `jordan-kim`, `priya-nair`, and the reviewers) carry no `Edit`.

**SETTLED 2026-08-05, and the other way.** The paragraph below stands as what was
observed; this is what auditing the *content* concluded. Uniformity is correct
here. Reading files and reporting costs the same whoever does it, and there is
exactly **one** axis on which the economics genuinely differ — whether the agent
spawns subagents, which costs ~10x doing the work itself. The prompts already
differentiate on precisely that axis and nothing else: the four `Agent`-holders
carry a dispatch-cost paragraph the other sixteen do not, and `lian-zhao` carries
a variant because dispatching is her main cost rather than an occasional one.
Verified: the warning is present in exactly the agents holding the tool, with no
mismatch in either direction.

So the useful invariant was never "these sections differ per agent" — it is that
the one real difference stays aligned with the capability that causes it.
**Check 20** now enforces that, negative-tested both ways (stripping the warning
from `victor-reyes`; adding it to `priya-nair`). This is no longer recorded as a
gap.

**Observed, and originally read as a limit — Checks 13 and 14 verify presence, not
content.** `## Communication discipline` is **byte-identical in all 21 agents**:
one distinct body. `## Tool economy` has three distinct bodies across 21 (16
share one, the four `Agent`-holders share another, `lian-zhao` has its own). The
content is good and deliberately generic, so this is not a defect — but it means
those two checks prove that 21 copies of a paragraph exist, not that 21 agents
each declared a budget suited to their own work. An agent whose needs differ from
the default and was never tailored is invisible to both.

**Not checked, and named so the gap is not mistaken for coverage**: whether each
agent's body actually implements its frontmatter `description`; whether any
agent's procedure contradicts another's; whether the persona sections are
honoured in practice. Those need reading twenty-one prompts against their
fixtures, not a command.

```bash
for f in agents/*.md; do awk '/^## Communication discipline/{f=1;next} /^## /{f=0} f' "$f" | md5sum; done | sort -u | wc -l | tr -d ' '
# → 1
```

### PF-010 — `install.sh` — VERIFIED

Every install to date had been a re-run on this machine, where the symlinks and hooks
already existed. The clean-clone path — the one a new user takes — had never been
executed.

**Executed 2026-08-05.** `git clone` to a scratch directory, then `install.sh`
run under a sandboxed `HOME` so the real `~/.claude` was never touched — the
installer hardcodes `CLAUDE=${HOME}/.claude` with no override, so overriding
`HOME` is the only way to exercise the real code path safely.

  gate on the fresh clone     502 passed, 0 failed
  first install               21 agents, 18 commands
  second install              identical — idempotent
  broken symlinks             0
  hooks written               post-merge, pre-commit, pre-push
  hooks carrying v3 marker    3 of 3

Both `pre-commit` guards were fired deliberately rather than assumed: a commit
by a different `CONSILIUM_LOCK_OWNER` was refused with "repo is held by
'someone-else'", and a commit by the holder staging a path outside the declared
scope was refused with "staged files fall OUTSIDE the declared lock scope".

One thing checked and NOT a defect: with no lock file present the hook exits 0
and the commit proceeds. That is `[ -f "$LOCK" ] || exit 0` working as written —
rule 18 governs concurrent writers, not every commit.

**Re-audited 2026-08-05 on a DIRTY target, and the success line was lying.** The
clean-clone test above installs into an empty `~/.claude`, which is the one case
where the count could not be wrong. Installing into a directory that already
holds foreign entries exposes it:

    every target a foreign real file   ->  "consilium installed: 21 agents"
                                           21 item(s) skipped
                                           links actually pointing into the repo: 0

It reported twenty-one installed having installed **none**. `ls "$CLAUDE/agents"
| wc -l` counts every entry in the target directory — foreign symlinks that were
skipped, real files that were refused, and hand-written agents that have nothing
to do with consilium. The success line prints *above* the skip count, so a reader
skimming sees the reassuring number first.

Fixed by counting links that resolve into this checkout. Verified across three
targets: all-foreign now reports 0 of 21, a mixed target reports 19 of 21 with
2 skipped, a clean target reports 21.

**Rule 3 violated by me while cutting v1.18.0, 2026-08-05, and recorded rather
than quietly fixed.** The pre-release gate run printed `739 passed, 1 failed` and
I committed anyway. The failure was Check 27 reporting
`release_notes_v1.18.0.md has no matching tag 'v1.18.0'` — the check working
exactly as designed, on a release note whose tag did not exist yet.

Nothing red reached the remote: the `pre-push` hook re-runs the gate, and by then
`git tag` had run, so it passed at 740. The outcome was fine and the discipline
was not. Rule 3 says green before merge, and "it will be green in a moment" is
the reasoning every skipped gate has.

**Check 27 makes a release transiently red by construction**, between writing the
note and creating the tag. That is correct — a note without a tag is not a
release — but it means the release procedure must **tag before running the
gate**, not after. Anyone following the old order will meet a red gate and be
tempted to do what I did.

**A number in the v1.18.0 note is wrong.** It records `739 passed, 0 failed`; the
true figure at the release commit was **740**, because the note itself adds a
Check 27 assertion. Corrected here rather than in the note, which is history
(rule 8) — the same treatment given to v1.15.0's "eleven commits red", which was
twenty-two.

**Tier audit, 2026-08-05: which "mechanical" rules actually have a mechanism.**
Rule 13 was marked mechanical and had none, and nobody noticed for weeks. That
prompted reading the whole index against the checks that exist. Result: of the
27 rules and sub-rules marked mechanical, **four had no mechanism** — 7, 8, 14
and 15. Rule 7 is fixed below; the other three are named here rather than
quietly left.

  rule 7   `input/` is read-only fixture data      -> Check 26
  rule 8   never delete evidence                    -> Check 28
  rule 14  one installer, one canonical path        -> Check 29, IN PART
  rule 15  a release is a note plus a matching tag  -> Check 27

**All four closed 2026-08-05.** Rule 15's command had been run by hand after
every release of this session; Check 27 now runs it. Rule 8 tests the BASENAME of
every note ever deleted, so archiving root -> `docs/` is permitted and vanishing
is not. Both skip, **by name**, in a clone with no tags or no history — the
shallow-checkout mistake that cost twenty-two red commits is not repeated.

Rule 14 is honest about being **partly** mechanizable: Check 29 enforces that no
shell script other than `install.sh` touches the symlink directories, and the
tier now reads "mechanical (in part)" rather than claiming more than it does. A
second checkout competing for the same links, or a user wiring something by hand,
remains judgment.

Check 29's first two drafts flagged `tests/check.sh` itself — a checker matching
its own comment, then its own grep pattern. Fixed by building the pattern from
pieces so the literal appears nowhere in the file, rather than by exempting the
file: an exemption would also have excused a genuine second installer that
happened to live there.

Rule 15 is the sharpest of the three remaining, because its check is one command
and **has been run by hand after every release this session** — the exact shape
of a rule that is mechanical in name and habit in practice. Rule 8 is checkable
against `git log --diff-filter=D`. Rule 14 is the vaguest and may not be
mechanizable at all; that should be decided rather than assumed.

**Rule 7 had no mechanism, and its violation had already happened twice.** The
rule's stated procedure is "`git status` inside `evals/` must be clean after any
eval run" — something a human remembers to do, which is the definition of not
being a gate. `__pycache__` directories were found inside `dunyu-001/input/` and
`lars-002/input/` on 2026-08-05, **untracked** and therefore invisible to
`git status` on a clean tree. They were spotted by eye while listing files for
something else, and removed by hand. They are proof that an agent was pointed at
the case directory rather than the staged copy — the read-only violation
`evals/run.sh stage` exists to prevent.

Check 26 now fails on a generated artefact under any `input/`, tracked or not. A
tracked artefact is a committed mistake; an untracked one is the mistake still
happening, on the machine where it happened. Negative-tested by planting
`__pycache__` in `kai-001/input/` and confirming the failure line appeared.

**The `pre-push` hook failed open when the gate file was absent, 2026-08-05.**
The body was `if [ -f "$REPO/tests/check.sh" ]; then ... fi`, so a working tree
without the gate pushed silently with exit 0 — and **the one change most
certainly guaranteed to bypass the gate was a commit that deleted it.**
Demonstrated: `mv tests/check.sh aside`, commit, push, `main -> main`, exit 0,
no warning.

Now refuses, naming `--no-verify` as the deliberate bypass. `HOOK_VERSION` bumped
to `consilium-hook-v4` so existing installs replace the old body rather than
keeping it — the version marker exists for exactly this.

Probed at the same time and correct: a failing gate aborts the push; a **tag-only**
push runs the gate; a **ref deletion** runs the gate. The `post-merge` hook is
`exec install.sh`, and git ignores a post-merge exit status, so a missing
installer is noisy rather than damaging.

This repository's own hook was updated by writing `.git/hooks/pre-push` directly
rather than by running `install.sh`, which would have reconciled the real
`~/.claude`. A clone picks up v4 on its next install.

**`tests/lock.sh` probed 2026-08-05 — two defects, both failing OPEN.**

  1. **Re-acquiring your own lock with a different scope silently kept the old
     one.** It printed `already held by you (a) — first` and exited 0, which
     reads as success, while discarding the scope just requested. The caller then
     stages files in the scope it asked for and is refused by the hook citing a
     scope it never chose. This cost time repeatedly during this session's own
     work before it was recognised as a defect rather than as the rules being
     strict. Rule 18 governs concurrent *writers*; one writer adjusting its own
     scope is not a collision, so it now updates and says so:
     `scope UPDATED / was: agents/ / now: tests/`.

  2. **A scope path containing whitespace silently WIDENED the guard.** The scope
     is stored as one space-separated line and the pre-commit hook splits on
     whitespace, so `evals/cases/a b/` became the two prefixes `evals/cases/a`
     and `b/`. Demonstrated: with that scope declared, committing `b/anything.txt`
     — never in scope by any reading — **succeeded**. Such a path is now refused
     at acquire time, because the ambiguity is in the storage format and a guard
     that fails open is worse than one that refuses to start.

Probed at the same time and correct: `release` with no lock held is a benign
no-op; `release` by a non-holder is refused with "releasing another writer's lock
mid-run is the collision itself"; `release --force` by a non-holder works and
names whose lock it took; a foreign holder still blocks `acquire`.

**The no-clobber claim itself holds**, which is why this was worth checking
separately from the claim. A foreign symlink is skipped with `points to
/etc/hostname; use --force`; a real file with `real file exists; refusing to
replace`; `--force` replaces both and reports what it replaced; and a
hand-written `my-own-agent.md` that consilium does not own survives every run,
including `--force`.

```bash
grep -c 'CLAUDE=\${HOME}/.claude' install.sh
# → 1
```

### PF-011 — `evals/cases/*/input/` — VERIFIED

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
which is the failure this row exists to prevent.

**Audited 2026-08-04: `rafael-001` — input clean.** Its notes pre-declare four
non-defects (cfl = 0.4, the insulating far edge, the `lap[0]` mirror condition,
the 50-cell shear-zone mask); each was re-derived independently and each is
correct as written. One off-by-one line citation fixed (41 -> 42).

**Audited 2026-08-04: `jordan-001` — UNDECLARED REAL DEFECT.** `side` is read on
`ingest_merge.py:18`, only to fix its dtype, and never used again — grep returns
exactly one hit in the file. `enrich()` therefore computes an unsigned
`notional = qty * price`, and `sector_summary()` sums it while the module
docstring calls the result "exposure". Measured on the fixture's own CSVs
(26 BUY / 24 SELL): every sector is reported with the wrong sign and 3.5x-7x the
net magnitude — total reported 1,607,795 against a net of -230,785.

The declared defect (a silent inner join dropping 10 of 50 rows) reproduces
exactly, so the fixture still tests what it says. But an auditor that also
reported the unsigned rollup would have been right and earned nothing, which is
the scoring inversion this row tracks. Declared in the case notes and
deliberately **not** added to `expected`: the recorded PASS was graded against
the criteria as they stood, and moving the bar afterwards leaves a verdict that
corresponds to no run (rule 5).

**Audited 2026-08-04: `priya-001` — clean.** All seven declared figures
re-derived from the committed CSV and every one reproduces: 9.6792% arithmetic,
9.5937% geometric over 59 intervals, 9.4265% over 5.0 years, 56.8959% total
return, worst −1.90% (2019-07), best +2.60% (2019-08). The run log's claim that
the reported −1.5% is the third-worst month also holds (2020-11).

**Audited 2026-08-04: `lars-002` — its one real defect is declared, so it passes
this row.** `_STD_FLOOR = 1e-12` is absolute and still in the module by decision:
run 2 found it, it is real, and the bar was revised rather than the code because
a correct auditor should be able to report it. A pointer was added to the opening
block, which listed five axes as "deliberately correct" thirty lines above the
paragraph conceding the defect. The opposite failure direction was hypothesised
and tested — a flat large-magnitude window slipping past the floor on rounding
residue — and does **not** occur: seven flat windows from 0.1 to 3.3e15 all give
std exactly 0.0 and all raise. Recorded so nobody re-derives it, and not reported
as a defect, because it is not one.

**Audited 2026-08-04: `sophia-002` — FALSE CLAIM ABOUT THE CODE, corrected.** Its
notes and its `must_not_find` comment both stated that `worker.py:20-21` reads
`queue_name` and `batch_size` "via bare `cfg[...]` subscripts with no `.get`, no
signature default, no fallback of any kind anywhere in the file", and gave the
ABSENCE of a fallback as the reason those keys are out of scope. The code reads
`cfg.get("queue_name", "default")` and `cfg.get("batch_size", 50)`; grep returns
three `cfg.get` calls and no bare subscript.

The verdict survives and the criteria are unchanged — a fallback exists but
*agrees* with the documented default, so there is still no doc-vs-code conflict.
The stated mechanism did not survive, and it was load-bearing: an agent applying
the prompt rule this fixture exists to lock ("cite a code-side fallback before
calling it a default mismatch") would have found precisely the fallback the
fixture claimed was absent. This is a worse class than the stale line numbers —
those pointed at the wrong line, this described code that is not there.

`sophia-001` already declares its own contaminant (a symmetric spike filter
documented as one-sided), found on its 2026-07-31 re-run. Its input has not been
independently re-read; only the declaration was verified.

**Audited 2026-08-04: `ziyan-001` — THE FIXTURE FORBADE ITS OWN RIGHT ANSWER.**
Its declared defect 4 is *`manuscript.tex:34` uses "et al." for a two-author
paper (Williams, Patricia and Davis, Andrew)* — verified against the bib. Its
`must_not_find` guard was the bare tokens `"Williams"` and `"overclaimed"`, OR'd,
so **any report containing the word Williams failed the case**, including one
that correctly reported defect 4, which cannot be stated without the name.
`samples/pass.md` contains zero mentions of Williams and could not have reported
it. This is exactly the error the comment on the very next guard entry describes
— fixed there when Check 15 caught it, missed one entry above.

Demonstrated both ways rather than asserted: `samples/pass.md` plus one correct
sentence naming the defect grades
`FAIL must_not_find — report contains: "Williams"` against the old guard and
`PASS — 5 criteria, 0 failed` against the new one. The guard was only loosened,
so the recorded PASS stays valid (rule 5).

**Audited 2026-08-04: `mira-001` — UNDECLARED REAL DEFECT.** `resample_file`
(line 62) does `side = int(np.sqrt(raw.size))` and reshapes to `(side, side)`,
assuming a square grid, while the C reference takes `nr` and `nc` explicitly.
When the element count happens to be a perfect square the mis-reshape is
**silent**: a 32x72 grid is 2304 = 48² elements, reshapes to 48x48 with no error,
and the result differs from the correct reshape by 0.390 max abs. A port that
silently changes the reference's calling contract is Mira's own subject matter,
so an agent reporting it is right and earns nothing. Declared in the case notes,
not added to `expected`.

Also checked and NOT a defect: the sampling convention. The C uses
`x = j*(nc-1)/(out_cols-1)`, which is exactly `np.linspace(0, nc-1, out_cols)` —
the classic off-by-half parity bug is not present here. Two off-by-one prose
citations fixed (`:19` -> `:18`, `:27` -> `:26`); the case's own run log already
said `:18` and `:26`, so the notes contradicted themselves.

**Audited 2026-08-04: `lars-002` and `dunyu-001` — TWO MORE GUARDS THAT FAIL A
CORRECT REPORT.** The `ziyan-001` finding was not a one-off. Both demonstrated by
execution, not argued:

    lars-002  pass.md + "there is no fillna(0) masking here"
              -> FAIL must_not_find — report contains: "fillna"
    dunyu-001 pass.md + "Before any friction law is added, the base state must
              reach equilibrium"
              -> FAIL must_not_find — report contains: "friction law"

`lars-002` is the one fixture whose entire purpose is measuring precision, and
its own notes describe the absence in exactly those words ("the `fillna(0)`
failure mode `lars-001` plants, deliberately absent here"). `dunyu-001`'s right
answer is a *deferral*, which cannot be written without naming the work being
deferred. `"look-ahead bias"`, `"slipping"` and `"slip is"` were the same shape.

All replaced with verdict assertions, and checked in both directions — the
corrected reports now PASS, while `"has look-ahead bias"` and `"implemented the
friction law"` still FAIL, so the guards were loosened and not gutted.

**The class is NOT mechanizable, and no check was added.** Three candidates were
built and measured against all 23 fixtures:

  - *guard term also appears in the case's own notes* — flags 8 terms, misses
    `"Williams"`, `"friction law"` and `"slipping"`, and most hits are
    legitimate (a guard is often quoted in the notes that explain it).
  - *guard must be >= 3 words* — false-positives every good short verdict
    (`"parity holds"`, `"safe to ship"`, `"reconciles cleanly"`).
  - *guard must contain a verb* — correct in principle and not detectable in
    bash; that is the whole difficulty.

The real rule is the one `evals/README.md` already states — **guard on a phrase
only a wrong answer produces** — and it is a convention enforced by review, not
by a parser. Shipping any of the three above would have caught part of the class
while reading as a gate, which is worse than none (rule 2). Four instances are
now on record (`ziyan-001`, `lars-002`, `dunyu-001` x3); the durable defence is
that a fixture author writes the correct report's *negation* and grades it before
shipping.

**Audited 2026-08-04: `iris-001` and `sophia-001` — inputs clean.** `iris-001`'s
three other markdown files each carry an H1 on line 1, so `reference.md`'s `##`
is the only violation. `sophia-001`'s two defects — the dead `output_units` key
with a hardcoded `* 1000.0`, and the symmetric spike filter documented as
one-sided — are both already declared, and nothing else in `ingest.py` diverges
from the README.

**Audited 2026-08-04: `haruto-001` — THE ANSWER KEY WAS INSIDE `input/`.** Its
`input/README.md` read: *"`release_notes_v0.2.0.md` is **deliberately absent** —
v0.2.0 was tagged in git history but never got a notes file. This is the planted
defect the agent is supposed to surface."*

`evals/run.sh stage` exists because of this fixture's 2026-07-31 leak. Staging
isolates `input/` from `case.yaml` and the case README — and copies `input/`
verbatim, by definition, so it cannot help when the key is inside. The case's
second run is recorded as *"scoped to `input/`, PASS"*. **Scoping to `input/` was
the fix; the answer key was in `input/`.** That run's central finding is the one
sentence its own input handed it, so under rule 5 it has no verdict. Its
reasoning beyond the key (the Rule #2 archival analysis) was not available from
the README, so the run was not merely parroting — but that is a mitigation, not
a verdict.

Sharper still: `evals/run.sh grade` VOIDs any report containing "planted
defect". An agent that faithfully quoted this fixture's own input would have
been VOIDed for reading what it was given.

`input/README.md` rewritten as a neutral project README; the staged copy no
longer contains any of the phrases.

**Check 18 landed** — no fixture input may contain fixture-authoring language.
Negative-tested (a reintroduced phrase in `iris-001/input/index.md` produces
`leaks the answer key to the staged copy ("planted defect")`). Its `set -e`
trap was hit and fixed before landing: `grep -rIl` exits 1 when it finds
nothing, which is the normal case, and the assignment inherited that status and
killed the suite — the same failure that blocked Check 17's first attempt.

Two phrases were tried and REMOVED: `must_not_find` and `case.yaml`. `lian-001`
is a fixture ABOUT fixtures and legitimately ships a mock `case.yaml`
containing a `must_not_find` key. A check that fails on correct content is an
obstacle, not a gate.

**That false positive exposed a real bug in `evals/run.sh`.** Staging ran
`find "$dest" -name 'case.yaml' -exec rm -rf`, unbounded by depth — so it
**deleted `lian-001`'s mock `evals/cases/tam-001/case.yaml`**, silently handing
the agent a different scenario than the author wrote, and one that happens to be
exactly the "no fixture exists" condition the case turns on. The real answer key
lives in the *parent* of `input/` and is never copied, so the deletion was
belt-and-braces at depth 1 and destructive below it. Now `-maxdepth 1`; verified
the mock survives staging.

**Audited 2026-08-05: `dunyu-001` — input clean, and its two declared
corrections re-verified independently rather than trusted.** The residual
history is `[1, 0.5, 0.25, 0.125, 0.0625, 0.03125]` — exactly `0.5ⁿ`, confirming
that the fixture's headline "3.12% force imbalance from a loose tolerance" is an
artifact of `u += 0.5*du` on a linear problem, not a tolerance defect. The
unconstrained stiffness matrix has **0 zero eigenvalues** (min |λ| = 0.16) where
3 rigid-body modes are required in 2-D, and a rigid x-translation produces a
force of norm 14.4 instead of 0 — a bed of springs to ground, as declared. This
is the most rigorously self-corrected case in the suite.

**Audited 2026-08-05: `lars-001` — one undeclared inconsistency, now declared.**
Line 27 is `(prices / base) - 1.0 + r.fillna(0)`, a SUM. Neither docstring
describes a sum: both describe one difference. Adding `r` to a relative
deviation is a second term the documentation never mentions. Distinct from
planted defect 2, which is about `fillna(0)` on the same line.

**Rule-25 sweep, 2026-08-05 — 31 imperative guards across 16 cases, all fixed.**
`anya-002` taught the shape; the sweep applied it. A guard beginning with a bare
verb fires on the correct report, because negating an imperative *prefixes* it
and prefixing anything to a string always leaves the string present. That is
definitional, not a heuristic — which is why this one IS mechanizable where the
broader "does a correct report trip this guard" question was not (see the three
rejected candidates above).

28 were rewritten in the first pass (`anya-001` 5, `sophia-002` 4, `mira-001` 4,
`kai-001`, `lars-001`, `marco-001`, `ziyan-001` 2 each, and one each in
`elena-001`, `ingrid-001`, `nadia-001`, `rafael-001` 2, `selin-001`,
`zofia-001`). A second, properly-constructed pass found 3 more the first verb
list had missed — `restore`, `widen`, `check` — and **one false positive that
had to be kept out of the check**: `lian-001`'s `"cutting rina-solberg.md is
safe"` is declarative, and an -ing form is a gerund, not an imperative.

A methodological note worth keeping. The first automated test appended
`"I do not <guard>"` to each pass sample and graded it. That is worthless: the
sentence contains the guard verbatim whatever its shape, so every guard trips
and the result carries no information. The real test negates *grammatically* —
prefix for an imperative, infix for a declarative — and is a pure string
containment question needing no grading at all. Under it: 161 guards safe, 95
with no negatable auxiliary, 4 unsafe.

**Check 19 landed** and negative-tested (restoring `"switch to numpy"` in
`lars-001` produces the imperative failure). All eight touched fail-samples
still FAIL, so the guards were made safe rather than gutted.

**`nadia-002` added 2026-08-05** — the third refusal control for a write-capable
agent, and the one that closes the set: Anya refuses to block a clean repo,
Zofia refuses to write a duplicate rule, Nadia refuses to recommend a change.
Her output IS a list of prompt edits, so recommending one when the agent was
right is her whole failure mode, and `nadia-001` only tested detection.

The situation is this repository's own history rather than an invention: the
agent under review correctly declines to recommend an unverifiable pin, exactly
as its contract mandates, and the criterion it was graded against guards on the
imperative `"pin the transitive dependency"` — so the correct refusal contains
the guard and fires it. Thirty-one guards of that shape were fixed here on
2026-08-05; this case points the lesson back at the agent whose job is to tell
an agent defect from a criterion defect.

**Authoring it found a defect in the grader.** `cmd_grade` voids any report
containing `case.yaml`, `must_not_find` or "planted defect". For a case whose
input legitimately IS a criteria file, those are the subject's own vocabulary,
and a correct report naming the section by its real name was being VOIDed —
the same shape as the imperative guards, this time in the tool that judges them.
The detector now drops a term that appears in the case's own `input/`, which
proves nothing, and keeps the rest. Rule 5 is unweakened and was re-verified:
appending "The planted defect is on line 19" to `lars-001`'s pass sample still
VOIDs, because that term is not in `lars-001`'s input.

Two guards were caught and reworded before shipping. The second sharpens rule 25
again: `"I score this an agent defect"` is declarative *and* first-person, and
the external denial *"it is not true that I score this an agent defect"* still
contains it. Replaced with verdict-line shapes, which a correct report has no
reason to quote because it writes its own. Verified in all three directions.

**`zofia-002` added 2026-08-05** — the second refusal control for a write-capable
agent, and the first that tests a refusal to **write** rather than a refusal to
clear. Zofia's write surface is the rule book, and the consequential failure for
a rule-book owner is not missing a violation but adding a rule that already
exists. Her own Mode C step 2 says exactly that and nothing tested it. The trap
sits in the input rather than the prompt: the incident write-up ends by
recommending a new rule, in the project's own voice, while rule 4 already says
the same thing in words matching the incident's root cause almost line for line.

One guard was caught and reworded before shipping, and it sharpens rule 25a:
`"the rule book is silent on baselines"` is declarative and infix-negates
cleanly, yet the **external** denial *"it is not true that the rule book is
silent on baselines"* still contains it. Declarative is necessary and not
sufficient — a guard must also be a phrase a correct report would not quote.
Replaced with a first-person form. Verified in all three directions: pass sample
PASSes, the adversarial denial PASSes, the wrong report FAILs on both families.

**`anya-002` added 2026-08-05** and audited as it was written — its own guards
were graded against the correct report's negation before shipping, and three of
the five families failed that test and had to be rewritten (see PROJECT_RULES.md
rule 25). The row stays VERIFIED: the new input was authored clean and
adversarially self-passed, which is the standard this row now holds.

**PF-011 CLOSED.** All fourteen un-audited inputs read end to end. Nine real
fixture defects found across seven cases, none of them in an agent:

  haruto-001  answer key inside input/, surviving the anti-leak mechanism
  ziyan-001   must_not_find forbade the case's own declared defect
  lars-002    "fillna" guard fails a correct negation, in the precision fixture
  dunyu-001   "friction law"/"slipping" guards fail a correct deferral
  sophia-002  notes described code that is not there, load-bearingly
  jordan-001  undeclared unsigned-notional rollup ("exposure" summed gross)
  mira-001    undeclared silent square-grid reshape
  lars-001    undeclared formula/docstring inconsistency
  kai-001     stale prose line number (+ lars-001's three, + rafael-001's one)

Two checks landed from the sweep (17, 18), one real bug fixed in
`evals/run.sh` staging, and two rules grew sub-clauses (5a, 25's negation
corollary). Gate 464 → 502.

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
ls evals/cases | wc -l | tr -d ' '
# → 26
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

**Audited 2026-08-05, and the row's own support does not hold up.** Two things:

**1. The evidence command measured the wrong thing.** `cat agents/*.md | wc -l`
counts lines. The claim is about *behaviour*. A line count cannot rise or fall in
a way that bears on whether an agent still finds what it used to, so the row
carried a number that could never confirm or refute it. Replaced below with a
command that does bear on the claim: how many cases still have a verdict recorded
against a prompt that no longer exists.

**2. The one re-run the row rests on is not recorded.** The paragraph above says
"Only `lars-001` has been re-run". `evals/cases/lars-001-lookahead-window/case.yaml`
contains exactly one run record, dated **2026-07-31** — before the slimming
commit `d6f6dc9` of **2026-08-04**. Either the re-run happened and nobody wrote it
down, or it did not happen. Rule 4 does not distinguish: an unrecorded run is not
evidence. So the sole support for "no regression" is currently unsupported.

**What the number below means.** Thirteen of twenty-four cases have their most
recent recorded run dated in July, i.e. against the pre-slimming prompts. Their
verdicts describe agents that no longer exist in that form. Four more have never
run at all. That leaves seven whose verdict postdates the cut.

**This row cannot be closed here.** Establishing it means re-running the affected
fixtures and comparing verdicts, which needs actual agent dispatches; the
autonomous loop does not do that. What it can do is state the size of the gap
exactly, and now the command does.

**Audited 2026-08-05: none of the thirteen is stale for a cosmetic reason, and
three post-change runs exist only as prose.**

Every one of the twelve agent files behind the thirteen stale cases changed in
the same two commits — `d6f6dc9` (communication-discipline block) and `3d06c1e`
(tool-economy section). The diffs are near-identical in size (+40/−39 for nine of
them), which is what a shared boilerplate edit looks like. But it is **not**
cosmetic: the tool-economy section instructs the agent to batch calls, avoid
re-reading, and stop at the answer. Those are instructions about how much
evidence to gather, and an agent that gathers less can find less. Two files moved
further — `mira-volkov` −116 lines (the recipe-book cut) and `victor-reyes` −54.
So no case can be cleared on the grounds that nothing behavioural changed.

The sharper finding is about where runs get written. **Three post-change runs are
claimed with specific numbers, and none is in the case's own run log:**

    ziyan-001   "sonnet→haiku, PASS 5/5, 11.9k vs 14.4k"   (release note v1.11.0 §5)
                case.yaml has two runs, both 2026-07-31
    mira-001    "PASS 5/5 at 27k vs 34.7k, 4 calls vs 12"  (PF-013, this file)
                case.yaml has one run, 2026-07-31
    lars-001    "has been re-run (PASS)"                   (PF-012, this file)
                case.yaml has one run, 2026-07-31

`evals/run.sh list` reads the case's run log, because that is where rule 4 points
and the only place a verdict sits beside the criteria it was graded against. A
run recorded in a release note or a board paragraph is invisible to the tooling
and, by rule 4, is not evidence — the same standard applied to `haruto-001`'s
leaked PASS.

**Deliberately not transcribed.** Copying those three claims into the case files
would flip them to "current" on the strength of prose I did not verify and cannot
re-derive, which is manufacturing evidence in the exact shape this board exists
to catch. They stay STALE. The durable fix is upstream: **write the run record
into the case at the time of the run**, and let the release note quote it rather
than be its only home.

**Smoke annotated, and the tier deliberately left fixed, 2026-08-05.** It was
considered whether `smoke` should select the STALE cases instead of a fixed
`tier: smoke` membership, so the cheapest re-run targets the verdicts that no
longer describe the current prompts. It should not: a tier whose membership
moves with history cannot be compared across edits — "smoke was green before my
change and green after" only means something if it was the same smoke — and
staleness grows, so selecting on it would make the fast tier thirteen cases wide.
The reasoning is recorded in `evals/run.sh` beside the code rather than left to
be re-derived.

What smoke does now owe its user is the state of its own baselines, and printing
them was worth it immediately: **five of the seven smoke members have no verdict
against the current prompt** — three STALE, two NEVER RUN. The tier the project
trusts most is the tier whose baselines are least current.

**Surfaced at the point of use, 2026-08-05.** `evals/run.sh list` now compares
each case's last recorded run against the last commit touching that agent's
prompt and prints `STALE — ran <date>, prompt changed <date>`. Per-agent rather
than a global cutoff: an agent untouched since its run is not stale because a
different one changed. Current split — **13 STALE, 5 NEVER RUN, 7 current**. The
staleness was previously visible only here, which is the wrong place: the person
who needs it is the one about to trust a verdict.

```bash
bash evals/run.sh list | grep -c STALE
# → 13
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

**Re-checked 2026-08-05, and the tally above omitted the two that matter most.**
It counts untested opus and sonnet agents and says nothing about **haiku**.
`lars-eriksson` and `sophia-okafor` have been on haiku since v1.0.2 and have
**never been tested at all** — the tier was assigned, not earned. That is the
dangerous direction. A tier that is too expensive costs money; a tier that is too
cheap loses findings in silence, and `priya-nair`'s failed drop above is the
proof that the risk is real rather than theoretical: haiku passed a planted trap
as correct.

So the honest count is **3 of 21 tiers established by execution, 18 by
judgement**, and two of the eighteen are the cheapest tier on the two agents
whose whole job is finding things. Closing this row needs actual agent runs,
which the autonomous loop does not do; it can only say precisely what is
unverified, which is what this paragraph is for.

```bash
grep -h '^model:' agents/*.md | awk '{c[$2]++} END{for(k in c) printf "%d %s\n", c[k], k}' | sort -k2
# → 3 haiku
# → 5 opus
# → 13 sonnet
```

### PF-014 — `agents/` — VERIFIED

`lian-zhao` and the four fixtures in this batch are unlanded. Two agents have
no fixture at all (`lian-zhao`, `zofia-kaminska`), so by rule 13 and by
lian-zhao's own cardinal rule neither may be refined — including by itself.

**Closed 2026-08-05.** Both fixtures landed; no agent is without one. The row
had sat as `OPEN — never audited` with a blank `last-checked` while its command
was in fact being executed and byte-diffed by Check 17 on every suite run — the
blank was accurate when written and stopped being accurate when Check 17
landed, and nothing connected the two.

**Closed properly 2026-08-05 — rule 13 now has a check.** The caveat recorded
below was written when this row's command was the only enforcement, and both
halves of it were worse than they read.

The command matched a fixture to an agent by the stem before the first hyphen —
`lars-eriksson` -> `lars` -> satisfied by `lars-001`. A second agent whose first
name is Lars would be satisfied by a fixture written for somebody else. No two
agents share a first name today, which is the only reason the shortcut held.

The deeper problem was where the enforcement lived. **Rule 13 had no check at
all.** A new agent without a fixture would have been caught only because this
row's recorded `# → 0` became `1` and Check 17 byte-diffs it — enforcement as a
side effect of a number, in a file whose purpose is recording state rather than
gating it.

**Check 25** now matches on the exact `agent:` field every `case.yaml` already
carries, so the first-name shortcut is gone. Negative-tested by repointing
`kai-001` at a fictitious `kai-svensson`: `kai-fischer: no eval fixture declares
'agent: kai-fischer' (rule 13)`. The first attempt at that test was invalid —
it repointed `lars-001`, and `lars-002` still names `lars-eriksson`, so nothing
fired.

**What the command below cannot see** — kept as the original record. It matches a
fixture to an agent by the stem before the first hyphen, so `wei-lin` is matched
by `wei-lin-001` through `wei`. Two agents sharing a first name would both be
satisfied by one fixture. Check 25 no longer has this weakness; the command
does, and is now a secondary signal rather than the enforcement.

```bash
for a in agents/*.md; do s=$(basename "$a" .md); ls evals/cases 2>/dev/null | grep -q "^${s%%-*}-" || echo "$s"; done | wc -l | tr -d ' '
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
# → 2
```

### PF-016 — `.github/workflows/` — VERIFIED

**Found broken 2026-08-05, by the maintainer noticing red runs on the remote —
not by anything here.** CI had been failing since Check 17 landed (`015485b`),
and no row, check or command in this repository knew.

**Portability swept 2026-08-05.** The shallow-clone incident was one axis; the
others were tested rather than assumed. The suite gives 570 passed, 0 failed
from a different working directory, under `LC_ALL=C`, under `LC_ALL=en_US.UTF-8`
and under `TZ=Pacific/Kiritimati` — Check 12 already uses `date -u`, so the
timezone result is by design rather than luck.

One real exposure found and fixed: five evidence commands ended in `wc -l`, whose
output is **unpadded on GNU and padded on BSD**. On macOS every one of them would
have printed `      26` against a recorded `26`, and Check 17 would have failed
the whole suite for a developer whose only mistake was using a Mac. Each now ends
`| wc -l | tr -d ' '`. `PF-013` used `uniq -c`, whose column width differs between
implementations, and was the last row known to be GNU-specific. Replaced with an
`awk` tally that emits a single space by construction — `for (k in c)` has no
defined order, so the output is sorted explicitly rather than left to chance. No
evidence command is now known to depend on which implementation of a tool is
installed.

**Extent, read from the public API 2026-08-05 and larger than first reported.**
The run history gives the exact boundaries: last green `420a4f7` at 01:09, first
failure `015485b` at 01:45, green again at `f992cc4`. **Twenty-two commits red**,
not the eleven stated when the fix landed — that figure was estimated from the
local commit count rather than read from the runs, and was wrong. `a21d671`
(v1.15.0) is green.

`actions/checkout@v4` defaults to a depth-1 checkout with no tags. Check 17
executes the board's evidence commands and byte-diffs their output, and two of
them read git history:

    PF-005  git show --stat v1.10.0 --name-only | grep -c anya-001
            -> "unknown revision" — the tag was never fetched
    PF-012  bash evals/run.sh list | grep -c STALE
            -> 20 instead of 13, because `git log -1 -- agents/X.md` returns the
               tip commit for every file when there is only one commit, so every
               agent looks as though it changed today

So Check 17 made the gate **environment-dependent**, which nothing in its design
acknowledged. Checks 1–16 inspect files and give the same answer anywhere; the
moment the suite started executing commands, where it ran began to matter.

Fixed at both ends. The workflow now checks out full history and tags, so CI
runs what a developer runs. And Check 17 detects a shallow repository and skips
history-dependent evidence **by name** — `shallow clone, history-dependent
evidence not re-run: PF-005` — rather than diffing garbage or passing silently.
An exemption that leaves no trace in the output is indistinguishable from a
check that passed, which is the same reason the self-referential rows are named.

Verified in both environments: a full clone runs all 568 checks including those
two commands; a `--depth 1 --no-tags` clone also reports 568 passed, naming the
two it skipped.

**What this row cannot do, corrected.** It checks that the workflow asks for
full history. It cannot tell you whether the last run was green — but the earlier
claim that this repository "has no credentials to ask" was wrong in a way worth
recording. `gh` is not installed, which is what was checked; the repository is
**public**, so the unauthenticated GitHub API answers it and `curl` is present:

    curl -s "https://api.github.com/repos/dunyuliu/consilium/actions/runs?per_page=5"

That is a manual procedure, deliberately **not** this row's evidence command.
Check 17 executes evidence on every suite run, and a gate that needs the network
fails in a clone behind a firewall, on a plane, or when the API rate-limits — a
gate that cannot run is worse than no gate (rule 2). The row's evidence stays
local and its scope stays the input to CI; the result is checked by hand.

```bash
grep -c '^ *fetch-depth: 0$' .github/workflows/check.yml
# → 1
```

## Deferral log

Append-only. A deferral not written here did not happen. An item may be deferred at
most twice; a third time is a decision, not a deferral, and belongs in the item block.

| date | id | until | reason |
|---|---|---|---|
