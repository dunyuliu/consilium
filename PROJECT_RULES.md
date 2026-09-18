# PROJECT_RULES.md — consilium

Binding constraints for this repository. Not a how-to; the README is the
how-to. When a rule and the README disagree, this file wins and the README
gets fixed.

**consilium is a prompt library**, not an application: `agents/*.md` and
`commands/*.md` are the product, `tests/check.sh` is the gate, `evals/cases/`
is the regression suite, and `install.sh` is the delivery mechanism (symlinks
into `~/.claude/`). Every rule below names one of those artifacts by path. A
rule that cannot name a path is not a rule here.

**Canonical filename**: this file, `PROJECT_RULES.md`, at the repo root, is
the rule book. `agents/haruto-nakamura.md` and `commands/release.md` cite it
by that name. There is no second rule book.

## Rule 0 — Always eat what you cook

**Every discipline this repo sells, it applies to itself first.** An agent, a
check or a rule pointed at someone else's project and never at this one is a
claim, not a practice. Numbered 0 because it is the reason the others get
checked; numbering starts at 1 below and never shifts (see rule 6).

**The discipline goes in the agent first, this repo's gate second.** A lesson
landing only in `tests/check.sh` has been learned by one repo; the same lesson
in an `agents/*.md` prompt or in `zofia-kaminska`'s starter set travels to
every project the team is pointed at. Write it where it ships, then prove it
here. A check with no prompt behind it is a fix that reached nobody.

**How to apply**: before shipping a discipline, run it here; before claiming a
gate works, watch it fail; before telling a user their docs have drifted, check
ours. "Nothing, we're fine" is the least trustworthy answer available and the
strongest reason to run it anyway.

---

## Index

Read this list first; jump to a rule only when it is load-bearing.

| # | Rule | Tier |
|---|---|---|
| 0 | **Always eat what you cook** — apply every discipline here first | judgment |
| 1 | Minimal changes; no new files; the root is a whitelist | judgment; root table mechanical — Check 31 |
| 2 | No silent fallbacks or swallowed errors | judgment |
| 3 | `bash tests/check.sh` is the gate; green before merge | norm locally — no `pre-push` hook enforces it; CI (`.github/workflows/check.yml`) checks after the push, not before |
| 4 | Only fresh runs are evidence | judgment |
| 5 | One definition of "pass" — `check.sh` exit 0, `evals/README.md` criteria | mechanical — Checks 15, 16, 24 |
| 5a | The answer key is never inside `input/` | mechanical — Check 18 |
| 5b | The answer key is never LINKED into `input/` | mechanical — Check 23 |
| 6 | *(dropped — see "Dropped starter rules")* | — |
| 7 | `evals/cases/*/input/` is read-only fixture data | mechanical — Check 26 |
| 8 | Never delete evidence: release notes archive, never vanish | mechanical — Check 28 |
| 8a | A note for a tag that never legitimately existed may be removed — narrowly | norm — human confirms off-repo facts; paperwork checkable, once built |
| 9 | Run the cheap check locally before pushing | norm — no `pre-push` hook exists; nothing local enforces it |
| 9a | *(retired 2026-09-18 — see rule body)* | — |
| 10 | Every agent-behaviour bug gets an eval fixture before the fix ships | judgment |
| 11 | Docs move with the prompt, in the same change | judgment |
| 12 | A new agent lands with README roster, model table, and Layout entry | mechanical — Checks 6, 7 |
| 13 | *(retired 2026-09-17 — see rule body)* | — |
| 14 | One installer, one canonical path | mechanical (in part) — Check 29 |
| 15 | A release is a note plus a matching tag, both pushed | mechanical — Check 27 |
| 15a | Nothing red is ever pushed, and the tag is pushed last | judgment — no local mechanism enforces it; see the rule |
| 15b | Five rows the gate decides; seven obligations the release engineer owes | mechanical for the five — `tests/release_gate.sh`, held to the schema by Check 33; the seven are norm |
| 16 | Agent frontmatter is a contract, not a preamble | mechanical — Check 1 |
| 17 | Cross-references between agents must resolve | mechanical — Checks 5, 8 |
| 18 | One writer per repo — never run two mutating workflows at once | norm — no `pre-commit` hook exists; `tests/lock.sh` is a label, not an enforced mechanism |
| 18a | Acquire only for the write step; verify unlocked, before and after | norm — `tests/lock.sh status` reports hold *age* mechanically; whether the hold was write-only is not checkable after the fact |
| 18b | Never dispatch a writer while the gate is red; track and push local commits in the same action that turns it green | norm — nothing checks a dispatch decision after the fact; `bash tests/check.sh`'s exit code is the mechanical signal it says to consult |
| 19 | One owner per write surface | mechanical — Check 10 (agents only; human-owned surfaces are declared in the rule) |
| 20 | Every writer declares isolation first; merge is judged by someone else | mechanical — Check 11 |
| 21 | Standing claims are re-checked on a schedule and cite a command | mechanical — Checks 12, 34 |
| 21a | The board cites a command; it does not paste and byte-diff the command's output | norm — Check 17 retired 2026-09-17 |
| 21b | No board evidence command reaches the network | norm — Check 21 retired 2026-09-17 in `1faaa1f`; nothing reads evidence commands for network reach today |
| 25b | Every case tier is a tier the tooling consumes | mechanical — Check 22 |
| 25c | Silence must not satisfy a case | mechanical — Check 24 |
| 25d | A verdict records the prompt SHA it was graded against; a contested case needs more than one sample | mechanical in part — SHA/count derivable by tooling; "is this case contested" is judgment |
| 25e | Two dispatches agreeing against the criterion is a criterion defect, not the contested shape | judgment |
| 13a | *(retired with rule 13 — its check was the same one)* | — |
| 22 | Every agent declares communication discipline | mechanical — Check 13 |
| 24 | Never audit a moving target; brief with ranges, not whole files | judgment |
| 25 | A fixture proves its criteria are executable, and absorbs every miss | mechanical — Checks 15, 16 |
| 25a | must_not_find guards are declarative, never imperative | mechanical — Check 19 |
| 23 | Every agent declares tool economy; dispatchers declare dispatch cost | mechanical — Check 14 |
| 23a | The dispatch-cost warning tracks the Agent tool exactly | mechanical — Check 20 |
| 26 | Before removing, weakening, or replacing a signal, measure what it currently catches | mechanical in part — a check could require a before/after count in the commit message; whether the count was measured against the real corpus is judgment |
| 27 | A restriction does not survive a dispatch hop — restate it in every sub-brief | norm — no mechanism logs dispatch briefs today |
| 28 | A gate that blocks a correct action is a P1 defect in the machinery, not a reason to wait | norm — the override for two of three incidents already exists and is named; the third is open as PF-033 |

---

## 1. Make the smallest change; do not add files until you must

Prefer the smallest edit that solves the problem. Fold new content into the
file it belongs to — a new top-level file needs an explicit ask. Never
refactor unrelated agents in the same change.

**The root is a whitelist, not a preference.** These names, no others.
`tests/check.sh` Check 31 parses this table, so it is the machine-readable
source of truth, not documentation of one.

| file | audience | job |
|---|---|---|
| `README.md` | users, human | what consilium is, who is on the team, how to install and invoke it. Concise and followable start to finish; not a design doc. |
| `CLAUDE.md` | Claude and the user | the working doc for *editing* this repo: the order a change goes in, what the gate does and does not cover, the traps. |
| `PATHWAY_FORWARD.md` | Claude and the user | the present tense — every surface, its state, the command that demonstrates it, the date it was last audited. |
| `PROJECT_RULES.md` | Claude and the user | this rule book. |
| `install.sh` | users | the one installer (rule 14) — the delivery mechanism, not a document. |
| `LICENSE` | — | — |
| `release_notes_v*.md` | — | the current release only; older ones archive to `docs/` (rule 8). |

Directories: `agents/` and `commands/` (the product), `tests/` (the gate),
`evals/` (fixtures), `docs/` (archive). Nothing else at root.

**One audience, one job, one home.** Usage belongs in `README.md` and is cited
elsewhere, never copied; a convention for working on this repo belongs in
`CLAUDE.md`; a dated open issue belongs in `PATHWAY_FORWARD.md` and nowhere
else. A fact in two files is a fact that will be wrong in one of them, and you
will not find out which.

**How to apply**: before creating a file at the root, name the existing file
it should have gone into and say why it could not.

## 2. No silent fallbacks, swallowed errors, or placeholder prompts

Scripts fail loudly. `tests/check.sh` and `install.sh` both run under
`set -euo pipefail`; keep it that way. No `|| true` that hides a failed check,
no default substituted for a missing agent file, no TODO stub shipped inside an
`agents/*.md` prompt as if it were finished guidance. A gate that passes when
it cannot run is worse than no gate.

**How to apply**: if a check cannot run, it fails. `find ... -delete` on broken
symlinks is deliberate cleanup and is fine; suppressing a non-zero exit from a
verification step is not.

## 3. `bash tests/check.sh` is the gate — pass it before anything merges

```bash
bash tests/check.sh    # pass criterion: exit code 0, "0 failed" in summary
```

It runs on every push and pull request via `.github/workflows/check.yml`
against `origin` (`https://github.com/dunyuliu/consilium.git`). Nothing merges
to `main` over a red gate, and never merge intending to fix the failure in a
follow-up commit: these structural assertions are the only automated protection
this repo has, so if they are allowed to be red it has none.

**How to apply**: run it locally (under a second), then push.

## 4. Only fresh runs are evidence

Any inherited conclusion — a prior session, the README, an agent's own report,
this file, a figure handed to you in your own dispatch brief — is a hypothesis
until a fresh run reproduces it. The dispatcher is not exempt from being wrong.
Be most skeptical of "already fixed" and "that check covers it"; both end
investigation early. When citing a check result, say whether you ran it or read
it, and quote the command and its output rather than the README's description
of it. Rule 21 makes the standing half mechanical: a claim that was fresh once
decays, and `PATHWAY_FORWARD.md` records when each was last re-derived.

## 5. One definition of "pass" — never invent a second

Exactly two pass criteria exist here:

- **Structural**: `bash tests/check.sh` exits 0. Not "the failures look
  cosmetic."
- **Eval**: the criterion in `evals/README.md` — every `expected` entry matches
  AND no `must_not_find` entry matches. Partial credit is out of scope for v1.

A well-reasoned alternative reading of an agent's output is not a pass. If you
want a different criterion, change `evals/README.md` or `tests/check.sh` in the
same PR — do not report against an uncommitted standard.

**Partly mechanical**: `bash evals/run.sh grade <case> <report>` applies the
criterion identically every time and voids a run whose report references the
answer key; `bash evals/run.sh stage <case>` copies `input/` outside the repo,
which is what actually closes leakage. Agent invocation stays manual. Grading
is necessary, not sufficient — it cannot see precision.

**A run that read the answer key has no verdict at all.** `case.yaml` and the
case `README.md` sit above `input/` and hold the expected findings. Scope every
invocation to `input/`, then check the agent's own file-reference list before
scoring, and void the run if it touched either — leakage does not make the
output look wrong, which is why it must be checked rather than noticed.

## 5a. The answer key is never inside `input/`

Tier: mechanical (Check 18). No file under `evals/cases/*/input/` may contain
fixture-authoring language — a phrase an author writes *about* a fixture,
addressed at a reader. `evals/run.sh stage` isolates `input/` **from** the
answer key; it copies `input/` verbatim, so it cannot help when the key is *in*
it, and a report that faithfully quotes such a leak is then voided by the
grader — the fixture punishes the correct answer.

**What Check 18 does not do**: it matches a fixed phrase list, so a leak in the
project's own voice — "this tolerance is deliberately too loose" — reads as
ordinary code and passes. Named narrowly so it is not mistaken for the broader
guarantee, which stays a review responsibility.

## 6. *(dropped)*

Number retained so rule citations elsewhere never shift. See "Dropped starter
rules" at the bottom.

## 7. `evals/cases/*/input/` is read-only fixture data

Fixture inputs are the planted defects. Nothing writes through them — not an
agent under test, not a debugging run, not "just this once." Fixtures holding
intentionally broken code (`lars-001-lookahead-window/input/compute_returns.py`)
and intentionally stale docs (`sophia-001-config-drift/`, `iris-001-defers-all/`)
must stay broken: a fixture "fixed" by a helpful agent silently converts a
failing regression test into a passing one. The scope is *no meaningful change
to fixture content*, not "no byte ever written" — an interpreter's
`__pycache__/` is noise, and `.gitignore` covers it.

**How to apply**: `git status` inside `evals/` must be clean after any eval
run; if it is not, `git checkout -- evals/` and rerun with a read-only agent.

## 8. Never delete evidence — release notes archive, they do not vanish

`release_notes_v*.md` are the project's only history outside git. On a new
release, previous notes **move** from the repo root to `docs/` — never deleted,
never rewritten. Eval outputs and audit reports for a non-passing run are kept,
not cleaned up.

**How to apply**: `git mv`, never `rm`, for any `release_notes_v*.md`.

## 8a. A note for a tag that never legitimately existed may be removed — narrowly

Rule 8 cannot tell "this documents a real release" from "this documents a tag
nobody with release authority ever created," and defaults to keeping both,
turning a fabricated note into permanent un-removable content.

A note may be deleted, by the human maintainer only, when **all** hold: (1) its
version's tag does not exist on the remote and never did, confirmed on the
platform of record, not merely `git tag --list` in one clone; (2) the note's
own release gate was never run by a human with release authority — it was
written by an agent acting outside its dispatched scope (rule 27's shape); (3)
the deletion is a `git rm` whose commit message names the tag, why it is
fabricated, and how (1) and (2) were confirmed.

**Named abuse case, so this stays narrow**: it is not license to delete an
unwelcome but real note by asserting after the fact that its tag "doesn't
count." If a tag was ever pushed by anyone with release authority, the
carve-out does not apply, whatever the note's quality.

**Tier**: norm — condition (1) needs the platform's release history, which
`tests/check.sh` cannot reach (rule 21b). A check could require the deletion
commit to cite the tag and both conditions, so Check 28 verifies the paperwork
exists without verifying the facts inside it. Not built; PF-031.

## 9. Run the cheap check locally before you push

`bash tests/check.sh` is sub-second. Running it before `git push` costs
nothing; discovering it red in CI costs a round trip and a red badge on `main`.
Same for `install.sh`: run it after adding or renaming an agent and confirm the
count it prints matches `ls agents/*.md | wc -l`.

**How to apply**: local green → push. Not push → check CI.

**Norm, not mechanical**: `install.sh` no longer wires a `pre-push` hook
(removed in `86f4b5d`) — nothing local stops a red push from leaving the
machine. `.github/workflows/check.yml` runs the same gate in CI, but only
after the push lands; a red run there is discovered, not prevented.

## 9a. *(retired 2026-09-18)*

Number kept; rule numbers never move (see Conventions).

**What it required**: a carve-out from the `pre-push` hook's full-gate run for
a push whose only effect is deleting a tag or branch — a push that cannot
introduce the failure the gate is red about, because it removes the exact
thing the gate was red on.

**Why it is gone**: the `pre-push` hook this rule carved an exception into no
longer exists (`install.sh`, `86f4b5d`) — nothing local runs the gate on push
at all, so nothing can wrongly block a ref-deletion push either. The proposed
hook special-case this rule described was never built and is now moot with it.

**What replaces it**: nothing. A ref-deletion push, like any other push, is
unguarded locally; `.github/workflows/check.yml` runs after it lands, same as
rule 9.

## 10. Every agent-behaviour bug gets an eval fixture before the fix ships

When an agent misbehaves in a real deployment — wrong scope, missed finding,
advisory creep — the fix to `agents/<name>.md` lands with a fixture under
`evals/cases/` reproducing the failure mode on the smallest realistic input. A
prompt edit with no fixture is a vibes-based diff.

**How to apply**: fixture first, or in the same commit. A prompt fix without
one is a debt that lands before the next version tag.

## 11. Docs move with the prompt, in the same change

`README.md` is the living doc. Any change to an agent's name, scope, model,
routing, or command wrapper updates the README in the same commit — the roster
table, the routing table, the model table, the Layout tree, and the headline
specialist count, whichever are affected. Never as a follow-up.

**How to apply**: `grep -n <agent-name> README.md` before you call an agent
change done, and re-read the count in the opening paragraph.

---

## Project-specific rules

These encode practices consilium already follows (README "Hiring",
`agents/haruto-nakamura.md` release workflow, `tests/check.sh`) — codifications
of existing agreements, not new policy, except where marked **Proposed**.

## 12. A new agent lands with its README roster, model table, and Layout entry

`agents/<name>.md` is not done until `README.md` contains a roster-table row, a
model-table row under the correct model, and a Layout-tree line. A new command
additionally needs a row in the commands table.

**Mechanical**: Check 6 asserts every agent appears exactly once in the model
table under the model its frontmatter declares and that no row names a
non-existent agent; Check 7 covers the roster row (first cell the backticked
name) and the Layout line; Checks 3 and 4 cover the commands table and *any*
mention. Both were negative-tested — a check that has never failed is not
known to be a gate.

## 13. *(retired 2026-09-17)*

Number kept; rule numbers never move (see Conventions).

**What it required**: every new agent lands with at least one `evals/cases/`
fixture naming it, enforced by `tests/check.sh` Check 25.

**Why it is gone**: it mandated fixture count by agent headcount, not by
evidence of what a fixture catches — 20 of 36 fixtures have never recorded a
FAIL, and that population is what the rule kept alive.

**What replaces it**: nothing. Whether an agent's coverage is worth having is a
judgment call made when a fixture is authored or reviewed, and rule 25 governs
that. **Check 25 retires with this rule** (`iris-vermeulen`'s surface), and
**13a with it**: exact naming becomes a convention, not a rule with no gate.

## 14. One installer, one canonical path

The repo ships exactly one install script, and the README, the Layout tree and
any post-merge hook all name the same path. Two installers with divergent
behaviour is a fork of the delivery mechanism: a user following the README gets
whichever set of hooks and safeties that one happens to carry.

**How to apply**: pick one, delete the other, update every reference in the
same commit (rule 11).

## 15. A release is a note plus a matching tag, both pushed

Per `agents/haruto-nakamura.md` Phase 3–4: the release commit is
`release: v<A.B.C> — <summary>`, tagged `v<A.B.C>` matching the release-note
version exactly, over a clean tree and a green `tests/check.sh`, then pushed
with the tag. A note with no tag is not a release; a tag with no note is not
either.

**How to apply**: `git tag --list 'v*'` must contain a tag for every
`release_notes_v*.md` across the root and `docs/`. Cut a release when the
unreleased commit count makes the last note misleading.

## 15a. Nothing red is ever pushed, and the tag is pushed last

Create the tag **locally, before any push**, so the local gate sees it: Check
27 reads `refs/tags/<version>` in the working clone. Running `bash
tests/check.sh` green before pushing is on the release engineer — no
`pre-push` hook enforces it locally (rule 9). Then push in two commands —
the commit, then the tag. Never `--tags`, never `--follow-tags`: a tag must not
ride along on a push that could be rejected.

**The one failure CI may show between those two pushes** is Check 27 naming the
note being released, and nothing else. CI reads only tags already on the
remote, so that assertion *cannot* be green until the tag push lands —
expected intermediate state, not a defect. Any other red assertion means the
release does not exist yet: delete the local tag, fix, re-verify, re-cut;
nothing needs unpublishing, because the tag was never pushed.

**After the tag push, CI must be green on the released commit.** A red run
*then* is a real failure, answered with a follow-up fix commit — never an
unpublish, never a force-push, never deleting a tag from the remote (rule 8).
"Flake" is not a conclusion: re-run a job only for a named infrastructure
cause, at most once, and treat the second failure as real. If CI cannot be read
at all, say so and record it — a release that assumes a gate it could not see
is rule 2's silent fallback wearing a version number.

**Rationale**: a local run of `tests/check.sh` proves one machine and one
checkout, often a shallow one where checks reading history or tags skip
themselves; CI sees the rest, and only after a push. The reverse ordering ("push, wait for CI green,
then tag") is unsatisfiable here and deadlocks against Check 27 — **a rule that
cannot be obeyed does not get obeyed loosely; it gets obeyed until the work
stops.**

**How to apply**: tag locally, push commit, push tag, then require green. No
offline check reads a network conclusion, so the note records the run (schema
item 9), including the pre-tag run and its single permitted failure.

## 15b. Five rows the gate decides; seven obligations the release engineer owes

`tests/release_gate.sh` decides five rows — tree, ci, publish, release, clone —
each against reality: the working tree, CI, the tag and Release on the remote,
a stranger's clone of the tagged commit. No tag is pushed until it exits 0.

The other seven — audit, correctness, conciseness, fixes, docs, refactor, rules
— are obligations stated once in `agents/haruto-nakamura.md` and discharged in
the note for a human reading it later. Until 2026-09-17 they were rows that
passed on any `key:` line of twelve characters or more: the gate verified a
string, never the pass. **Ownership and review carry what no script can judge.**

The gate is `iris-vermeulen`'s surface (rule 19), not the release engineer's: a
gate owned by the agent it judges is not a gate, for the same reason rule 20
has the merge judged by someone other than the author.

**How to apply**: `bash tests/release_gate.sh <note>` before the tag, every
time. Check 33 holds the script's five rows and the documented schema together.

## 16. Agent frontmatter is a contract, not a preamble

Every `agents/*.md` carries `name`, `description`, `tools`, `model`; `name`
equals the filename stem; `model` is one of `{opus, fable, sonnet, haiku}`. The
`description` field is load-bearing — `victor-reyes` and `elena-hartmann` route
on it, so a vague description silently breaks routing.

**Tier 1**: Check 1 enforces structure only; description *quality* stays
judgment.

## 17. Cross-references between agents must resolve

An agent that routes work to another names it by its exact stem
(`lars-eriksson`, not "the code auditor"). Every `Invoke \`agent\`` line in
`commands/*.md`, every backtick agent-shaped reference in `README.md`, and
every agent-to-agent reference inside `agents/*.md` and `commands/*.md` bodies
must resolve to a file in `agents/`.

**Tier 1**: Checks 2, 5 and 8. Checks 5 and 8 skip command stems and a short
allowlist of hyphenated technical terms (`NON_AGENT_TERMS`). Every allowlist
entry is a hole, so keep the list short — but a gate that cries wolf on correct
prose trains the reader to work around it.

## 25. A fixture proves its criteria are executable, and the suite absorbs every miss

**Two halves. The first is mechanical.** Every case ships `samples/pass.md` and
`samples/fail.md`; Check 15 grades both and verifies the verdicts — pass sample
PASS, fail sample FAIL. A criterion that rejects a report written to satisfy it
is not a criterion, it is a typo with authority.

**The second half is the point of the suite.** It is a living record of what
has gone wrong, not a planned matrix of what might: **every real miss becomes a
case.** Corollaries, each paid for:

- **A run's record lives in the case, at the time of the run.** A verdict
  written only into a release note or a board paragraph is invisible to
  `evals/run.sh list`, which reads the case's run log — the only place a
  verdict sits beside the criteria it was graded against. Never transcribe such
  a claim afterward: copying a claim you did not verify into the place the
  tooling trusts is manufacturing evidence, whatever its source.
- **Silence must not satisfy a case (Check 24).** Every `must_not_find` guard
  passes trivially on an empty report, so a case is only as strong as its
  *positive* criteria and a weak one is passed by doing no work — the bare word
  `"correct"` once scored 3 criteria, 0 failed. Check 24 grades an empty file
  against every case and requires a non-PASS; it cannot tell you a *weak*
  report fails, because "how much work does this show" is not mechanizable.
- **A fixture is never finished.** When a run finds something real the case did
  not declare, declare it — do not delete it to keep the case tidy. An
  undeclared true defect makes a thorough audit score worse than a shallow one.
- **When the agent and the fixture disagree, the fixture is the more likely
  defendant.** A failing case is a hypothesis about who erred, not a verdict.
- **Fix the criterion where the criterion is wrong, and never the reverse.**
  Weakening a case to make an agent pass destroys the only instrument that can
  tell you whether the next prompt edit helped. Loosening a `must_not_find`
  guard leaves earlier verdicts valid; tightening any criterion invalidates
  every run graded before it.
- **Guards are declarative, never imperative.** Negating an imperative
  *prefixes* it — "do not rotate the token" contains "rotate the token" — so an
  imperative guard fires on the correct report; negating a declarative
  *infixes* it. Write `X must be rotated`, never `rotate X`. Definitional, not
  heuristic, which is why it is **mechanically checked (Check 19)** where
  whether a guard survives its negation is not checkable at all.
- **Declarative is necessary, not sufficient — guard on what a wrong report
  RECOMMENDS or CONCLUDES, not on what it CLAIMS about the subject.** Any claim
  can be denied *externally* ("it is not true that X") and so contains itself,
  which no phrasing rule closes; what closes it is a phrase a correct report
  would not **quote**. First person is not enough — *"it is not true that I
  score this an agent defect"* trips `"I score this an agent defect"`. What
  survives is a verdict line the correct report has no reason to write:
  `"verdict: agent defect"`. Three layers, each paid for by a fixture:
  **imperative → declarative → verdict line.** Check 19 does not attempt this
  half.
- **Before shipping a guard, write the correct report's negation and grade
  it**, both infixed and external. A `must_not_find` entry must be a phrase
  only a *wrong* answer produces; a bare noun never is, because the right
  answer's denial contains it — guarding `"Williams"` in a case declaring a
  Williams defect admits no correct report at all. **Not mechanizable**: three
  candidate checks were measured across all 23 cases and each either missed
  known instances or failed correct content (PF-011). The test is one command,
  so run it.

**Mechanically linted (Check 16)**: an `expected` term may not also be a
`must_not_find` guard, and an `any_of` entry may not be sentence-length. The
word cap is deliberately loose — it flags clauses, not technical phrases.

**How to apply**: author the case, write both samples, run it once yourself,
record the outcome. When a real deployment misses, ask what case would have
caught it and add that case before fixing the prompt.

## 25d. Every verdict records the prompt SHA it was graded against; a contested case needs more than one sample

A `Run (...)` line records `<date>, <agent>, prompt <short-SHA>` — the short
commit SHA of the exact `agents/<agent>.md` (or `commands/*.md`) content at
dispatch time, not the repo's tip. Sample count is never a separate field that
can be forgotten: it is the number of `Run (...)` lines naming the same SHA, so
a reader (or `evals/run.sh`) derives it by counting rather than trusting a tally.

A case whose right answer is a judgement call, not a planted defect with one
correct finding, is marked `contested: true` in its `case.yaml` with a one-line
reason. A contested case may not be reported closed, or cited on the board as
settled, on a single sample at the current SHA — it needs a second dispatch at
that same SHA agreeing with the first. A disagreement is reported as a split
(both verdicts, both diverging criteria), never resolved by a third
tie-breaking run picked to prefer one side. What legitimises an additional
sample is *when* it was committed to: a count fixed before dispatch is a
measurement, one commissioned after a split is seen was chosen because the
first result was inconvenient, and the record cannot tell them apart afterward.

A case with no `contested` marking is uncontested: one sample at the current
SHA suffices. Marking a case contested is authorial judgement, made when the
case is written or when a second dispatch disagrees with the first — not a
retroactive obligation on the cases already in the suite.

**Rationale**: `evals/run.sh`'s STALE check compares calendar dates, so a
same-day prompt edit and dispatch are unordered and a verdict can silently
outlive the prompt it was produced against (PF-024); separately, a fixture
whose pass bar is itself a judgement call was being graded from one dispatch,
indistinguishable from a settled measurement (PF-025). One field closes both.

**How to apply**: name the prompt file's SHA at dispatch time
(`git log -1 --format=%h -- agents/<agent>.md`); set `contested: true` with a
one-line reason when authoring a case whose pass bar is a judgement call; quote
the sample count beside the verdict when a board row cites a contested case.

**Tier**: mechanical in part — `evals/run.sh` can derive the same-SHA count and
refuse to report a `contested: true` case as closed on count 1. Deciding
whether a case *should* be contested is judgement, the same limit 18a states.

### 25e. Two dispatches agreeing against the criterion is a criterion defect, not the contested shape

25d's trigger for `contested: true` is *"a second dispatch is found to disagree
with the first."* A distinct shape is not that: **two dispatches agree with
each other, and both disagree with the criterion.** They route to opposite
remedies, and neither substitutes for the other:

- **Dispatches disagree with each other** → genuinely a judgement call the
  suite has not sampled enough to settle → `contested: true`, take another
  sample (rule 25d).
- **Dispatches agree, against the criterion** → the agreement is evidence the
  criterion is wrong → repair or split the criterion (rule 25's "fix the
  criterion where it is wrong, and never the reverse"), then re-grade the same
  reports against the repair.

Marking the second shape contested parks a defective criterion instead of
fixing it, and quietly lowers the bar on every factual criterion beside it.

**A criterion that grades an act has residue and is cheap to widen safely; a
criterion that grades an opinion must enumerate every acceptable answer and
cannot be widened without re-litigating each addition.** Every repair round so
far has been on an opinion-shaped criterion; the repair rebuilds it as ANDed
sub-criteria, each a fact about what happened rather than an opinion about what
should have happened.

**Tier**: judgment. Telling the shapes apart requires reading both dispatches
against the criterion text; nothing mechanizes beyond 25d's SHA/count tooling.

## 24. Never audit a moving target, and brief with ranges not whole files

Three orchestration rules. Each failure below is an orchestration error, not an
agent failing at its job, and each has cost a dispatch's full budget for
nothing durable.

**1. Never dispatch an auditor while another agent is writing its subject.**
The lock (rule 18) guards commits, not reads. An auditor pointed at a directory
being written reports on a state that no longer exists by the time you read the
report, and its wrong findings are indistinguishable in tone from its right
ones.

**2. A fixture is not runnable until its author's adversarial pass is
recorded.** Shipping an unverified fixture means paying for every run that
rediscovers its defects instead of testing the agent.

**3. Brief with `sed -n` ranges, not whole file paths.** A whole-file read is
re-billed on every subsequent tool call of that agent's run. Naming the file is
not enough; name the lines. Measured: ~3.5k per call on whole-file briefs
against 3.2k on narrow ones, over 26 calls.

**How to apply**: before dispatching, ask what else is writing to that path;
check the fixture's run record exists; quote line ranges. The cost of getting
this wrong is not a bad answer — it is a confident answer about a state that
has changed.

## 22. Every agent declares communication discipline

Every `agents/*.md` carries a `## Communication discipline` section. Terse
output is a universal contract here, not a per-agent preference: the user's
harness injects "BE CONCISE" ahead of every prompt, and an agent that pads
defeats that at one remove — the orchestrator is concise and the twenty reports
it aggregates are not.

**Limit, stated rather than papered over**: Check 13 verifies the section is
present, not that the prose is good. A vacuous section passes. Presence is what
a gate can hold; brevity is what review is for.

## 21. Standing claims are re-checked on a schedule, and cite a command

`PATHWAY_FORWARD.md` is the present tense of this repository: every open issue,
known-broken thing and standing claim, by surface, with the date it was last
audited, a re-check interval, and the command whose output was read. Release
notes are append-only history (rule 8) and go stale by design — they are not
the current view and must not be used as one. This rule is the standing half of
rule 4, which is otherwise applied at the moment of writing and never again.

- **A claim marked VERIFIED cites a command that ran.** A claim with no command
  is not verified, it is remembered.
- **A blank `last-checked` means never audited, and stays blank.** It is not an
  unfilled field; it is the honest statement that nobody has checked this
  surface. Never backfill a date to make a row look complete.
- **Overdue is a failure; deferring is not.** An item may be postponed by one
  line in the deferral log with a reason; letting it lapse silently may not.
  The gate reddens on an undecided item, never on a date alone.
- **Items are never deleted.** The board only grows (rule 8).
- **One board, and the others get folded into it.** No `TODO.md`, `STATUS.md`,
  `BACKLOG.md` or second copy anywhere in the tree — Check 34, with
  `evals/cases/**` and `docs/SESSION_LOG_*` exempt as fixture data and history.
  The portable half lives in `zofia-kaminska`'s invariant 12, which is what
  reaches other projects; Check 34 is this repo taking the first dose.
- **Every row carries a priority — P1, P2 or P3 — and work is taken in that
  order.** Check 12 fails a row without one. The board is a queue, not an
  archive. State is not priority: `BROKEN` says how bad a row is, `prio` says
  how much it matters now, and they disagree often. Priority stays a column so
  a re-prioritisation is one character with a reviewable diff.

**How to apply**: run the command in the item's block, set `last-checked` to
today, append a dated note. Check 12 enforces the shape; only you can enforce
that the command was really run.

## 21a. The board cites a command; it does not paste and byte-diff the command's output

Tier: norm. Every row's evidence block names one command whose output would
settle the claim. That is the requirement in full — a claim with no command is
not verified, it is remembered (rule 21). The command is read by whoever
re-checks the row on its interval; nothing re-executes and byte-diffs it on
every suite run, and no `# →` line is required. Rule 21's blank-date and
no-backfill discipline is unchanged, as is Check 12's requirement that
`VERIFIED` cites a command. Whether the command was actually run before a row
was dated is not mechanized, and should not be: it rests on the agent doing its
job.

**Write the command to assert what must remain true, not what happens to be
true.** A command naming a currently-true state — a defect present today, a
case settled at today's SHA, an exact fleet-wide count — goes red the moment
that state changes for a legitimate reason, and a legitimate transition is not
a regression; it also makes a row's colour depend on facts outside its own
claim, as a row pinning `bash tests/lock.sh status` → `free` did when another
writer correctly held the lock. The repair is always the same: replace "is the
defect still there" with "does the mechanism that would catch it still exist,"
and replace a pinned count with an inequality or a grep on the mechanism.

## 20. Every writer declares isolation first, and is evaluated at the merge

An agent with write access follows one lifecycle, and its prompt states the
containment half **before anything else it says**:

1. **Isolate.** Work in your own worktree, branch, or scratch directory. Never
   write to the repo root, the `main`/`master` checkout, or the master project
   folder. Never touch a file another live mission holds.
2. **Stay in your surface** (rule 19). Work adjacent to your mission that
   belongs to another owner is reported, not done.
3. **Finish.** Deliver a complete unit of work with its gate result. A
   half-landed change in a shared tree is worse than no change, because the
   next agent inherits it without knowing.
4. **Be evaluated.** Nothing merges on its author's say-so. The merge is a
   separate decision made by someone else — `wei-lin` inside a campaign,
   `haruto-nakamura` at a release boundary, the human otherwise — against a
   fresh gate run, not the author's report of one.

**Placement is the rule, not just the content.** The isolation section is the
first `##` heading in the file, and Check 11 enforces the position: a
containment rule buried at line 80, after the agent has read its mission, is
advice; at the top it is a precondition. The expensive failures here were never
bad analysis but correct work written to the wrong place — analysis errors cost
a rerun, containment errors destroy work that was already right.

## 19. One owner per write surface

Every file class in a project has exactly one agent that may write it. Two
agents holding the same surface do not collide loudly — they diverge quietly,
and the divergence surfaces months later as two files that were supposed to be
one.

**Ownership table** — `tests/check.sh` Check 10 parses this table, so it is
the machine-readable source of truth, not documentation of one.

| Surface | Owner |
|---|---|
| `PROJECT_RULES.md` (the rule book) | `zofia-kaminska` |
| test files, fixtures, CI config | `iris-vermeulen` |
| a language port + its parity tests | `mira-volkov` |
| existing production code (simplify) | `kai-fischer` |
| new production code (create) | `dunyu-liu` |
| release notes, version files, tags | `haruto-nakamura` |
| publication staging, citation files | `anya-petrov` |
| figure-generation scripts + their rendered images | `marta-silva` |
| campaign session log, merge decisions | `wei-lin` |
| `.consilium-review/` in a deployed project | `nadia-hadid` |
| `PATHWAY_FORWARD.md` (the inspection log) | `zofia-kaminska` |
| `agents/*.md` (the prompts themselves) | `lian-zhao` |
| `commands/*.md` (trigger wrappers invoking those prompts) | `lian-zhao` |
| `install.sh` (the installer, and the git hooks it wires) | `iris-vermeulen` |

Everyone not listed is read-only. An agent with `Edit` or `Write` in its
frontmatter and no surface here is an unscoped writer — Check 10 fails on it.

**Two boundaries worth stating, because each was found by trying to route work
at a directory with no row.** `commands/*.md` is `lian-zhao`'s: a command file
is a trigger wrapper for one `agents/*.md` invocation, and splitting ownership
by which agent a command invokes would leave nobody able to keep the
trigger-to-mode mapping consistent. `install.sh` is `iris-vermeulen`'s: its
load-bearing content is the `post-merge` hook that syncs the `~/.claude`
symlinks — `pre-commit` and `pre-push` were removed in `86f4b5d`, so rules 3,
9 and 18 have no local mechanism left, and `.github/workflows/check.yml`
(also hers) is what now runs the gate, after a push rather than before one —
gate infrastructure, the same class as `tests/lock.sh`, already hers — while
`install.sh`'s symlink half carries no prompt content and so is not
`lian-zhao`'s.

**Human-owned surfaces.** `README.md` and `CLAUDE.md` have no agent owner and
are not an oversight: they are maintained by hand. An agent proposes a change
and routes it — `zofia-kaminska` refuses to edit them while auditing,
`sophia-okafor` reports their drift without fixing it. Declared here because
Check 10 walks agents to surfaces and cannot see a surface with nobody on it.

**Precedence when surfaces touch.** CI config is `iris-vermeulen`'s; a port
needing a CI change asks her rather than editing it. Production code is
`kai-fischer`'s to simplify and `dunyu-liu`'s to create — whoever holds the
mission holds the file for its duration, and the other waits.

**How to apply**: adding an agent with write tools means adding a row here. If
the row would duplicate an existing surface, the agent is the wrong shape —
split the surface or fold the agent in.

**Carve-out: a single-owner landing is permitted when a change is mechanically
entailed and splitting it across owners would redden the gate in between.**
Same reasoning as rule 28: a boundary that forces a red window to stay
compliant is failing its purpose. Narrow on purpose — it excuses an amendment
that names its own consequence on another surface and nothing broader.

## 18. One writer per repo — never run two mutating workflows at once

A workflow that commits, tags, or edits files owns the repo for its duration.
Do not start a second one — by hand or by dispatching an agent — until the
first has reported. Two writers racing the same repo produce a correct result
only by luck.

Before concluding a background agent is finished, check the **right** signal:
its transcript mtime, or message it. An empty to-do list is not evidence that
an agent stopped, and a long-running agent that fans out to subagents may not
notify for many minutes because notification waits on its children.

**Norm, not mechanical**: `tests/lock.sh` takes a named lock, but `install.sh`
no longer wires a `pre-commit` hook to refuse a commit from anyone else while
it is held (removed in `86f4b5d`) — the lock is a label and a convention now,
not an enforced mechanism.

```bash
export CONSILIUM_LOCK_OWNER=<who-you-are>
bash tests/lock.sh acquire "release v1.7.0" <path-prefix>…   # ... work ...
bash tests/lock.sh release
```

Ownership is a **label, not a pid**: agents run each command in a fresh shell,
so no pid outlives the work it protects. A lock is never auto-cleared, however
old — "probably stale" is precisely the reasoning that caused the incident.

**The scope may not be the repo root, as a matter of discipline — nothing
enforces it now.** `acquire` takes path prefixes; with the `pre-commit` hook
gone, nothing refuses a commit staged outside them, so scoping to `.` or to no
prefix at all no longer turns off a guard — there is none — it only removes
the one signal a reviewer has of what the writer meant to touch. Name the
files you intend to write; widen by re-acquiring, never by scoping to root.

**How to apply**: one release at a time. If a workflow appears stuck, stop it
explicitly and confirm it stopped before taking over its work.

### 18a. Acquire only for the write step; verify unlocked, before and after

The lock is exclusive, and exclusivity is only worth what it costs the writers
waiting on it. Reading files, re-running board commands, running the gate,
re-deriving evidence — none of that needs exclusivity or belongs inside the
held window. The held window is: acquire, write, `git add`, `git commit`,
release. Seconds, not minutes. Rule 18 is right that a lock must never
auto-clear, but that is only survivable if nothing holds it for long:
"acquire, then do the slow part" turns every ordinary interruption into a
repo-wide block, and shortening the window is the only lever left.

**How to apply**:
1. Do all reading, evidence re-runs and gate runs first, unlocked.
2. `bash tests/lock.sh acquire "<what>" <path-prefix>…` only once ready to
   write.
3. Write, `git add`, `git commit`, `bash tests/lock.sh release` — one unbroken
   sequence, nothing interleaved.
4. Any closing verification happens after release.
5. Before force-releasing a lock whose holder appears dead: check that holder's
   worktree for unlanded work and recover it — do not re-do work that already
   exists uncommitted. A force-release is always an explicit, recorded act
   naming the holder and the reason; a silent one is indistinguishable from a
   lock that never worked.

**Tier**: norm. `tests/lock.sh status` prints hold age (`age_of()`) — that half
is mechanical. Whether the held time was spent writing or reading is not
determinable afterward: the lock file records only who holds it and since when,
and agents are prompted, not scripted, so there is no invocation boundary for a
check to sit between. What would make it checkable: a lock-history log, a line
per acquire and release, diffable against gate invocation timestamps.

### 18b. Never dispatch a writer while the gate is red; if commits sit local, track them and push in the same action that turns it green

A red gate means the pushed remote and the local branch disagree about what
passes. Dispatching a new writer during that window gives it a base missing
whatever made the gate red — every worktree it creates inherits the gap
silently, because branching does not check the gate. This is not rule 18's
concurrent-writer problem but a sequencing problem one level up, before any
lock is taken, and no lock protects against it: the new worktree never contends
for one, it just starts wrong.

**The nuance that keeps this from banning local commits**: the failure is never
"commits sat local" — a red gate legitimately keeps commits local until the fix
that turns it green lands. The failure is that nobody counts them while they
sit.

**How to apply**:
1. Before dispatching a writer to a fresh worktree, check the gate. Red → do
   not dispatch; fix or wait.
2. If commits are legitimately local, note how many and why (a session log
   entry, or the board row the fix belongs to) so the count is never only in
   one person's head.
3. Keep multi-owner chains short — each additional owner between one push and
   the next is another window in which a base can go stale unnoticed.
4. The commit that turns the gate green is the commit that gets pushed; do not
   defer the push to a separate later step.
5. **Carve-out: the bar is scoped to work unrelated to the red.** Dispatching
   the writer who clears it is required, not forbidden — they are the only one
   who can turn it green. The mitigation is "make sure that writer branches
   from the local branch carrying the unpushed commits, not the stale remote":
   every such brief names the branch and tells the agent to verify and
   fast-forward before doing anything else.

**Tier**: norm. Nothing here detects after the fact that a writer was
dispatched onto a red gate, because dispatch leaves no artifact (agents are
prompted, not scripted — the same limit 18a states). Mechanical and already
present: `bash tests/check.sh`'s exit code as the go/no-go signal, and
`git status` / `git log @{u}..` for the count step 2 asks be tracked.

## 23. Every agent declares tool economy; dispatchers declare dispatch cost

Every `agents/*.md` carries a `## Tool economy` section. A dispatch re-bills
the entire prior conversation on every tool call, so cost grows with the square
of tool calls, not with prompt size — measured here: under 7 calls ≈ 19k
tokens, over 10 ≈ 75k, against ~2k to read a file directly. An agent that
dispatches subagents states that multiplier explicitly; every agent states the
discipline of batching, reading once, and not re-confirming a finding it has.

**Tier 1**: Check 14 enforces presence of the section on every agent. **Limit,
stated rather than papered over**: it does not verify that a dispatch-capable
agent states the multiplier inside it — that half is judgment, not gated.

## 26. Before removing, weakening, or replacing a signal, measure what it currently catches

A check, metric, classifier or alarm about to be removed, weakened or replaced
is measured against the **real corpus** first — count what it currently flags,
not what the failure mode you are fixing predicts it flags. **A failure mode
having no members in the actual data means the signal is right on that data,
however unsound the method looks in principle.** Confirm a new boundary by
mutation, not argument: take one real record, move it across the boundary by
hand, watch it flip, restore it, confirm nothing else moved.

**A metric moving to zero is not evidence of a fixed problem — it is evidence
of a changed question.**

**Rationale**: rule 4 governs trusting an inherited conclusion, rule 25's
family governs designing a new criterion, and the negative-test convention
(rules 12, 25) governs *adding* an assertion. None govern *taking one away* — a
replacement reads as strictly better than what it replaces precisely because
nobody counted what the old signal caught before it was gone.

**How to apply**: before a commit that removes, weakens or replaces a check, a
grading criterion, a classifier or a board detector, run the old signal against
the real corpus and record the split (how many flags, on what basis each fired)
in the commit message or the entry the change lands beside. Then mutate one
real record across the new boundary and confirm the flip.

**Tier**: mechanical in part. A commit removing or changing a check in
`tests/check.sh` or `evals/run.sh` could be required to name a before/after
count in its message — cheap, and gameable, since nothing verifies the count
was measured rather than invented to match the diff. The count stays a norm;
only its *presence* is mechanizable, and is not yet built.

## 27. A restriction does not survive a dispatch hop — restate it in every sub-brief

An agent with routing authority given a constraint — read-only, no lock, no
worktree, no push — does not merely obey it itself: every sub-brief it writes
restates that constraint in full, in that sub-brief's own text. A constraint
carried only in the top-level dispatch is invisible to a second-hop agent,
which sees only the brief it was given. Authority to route work is authority to
lose a restriction that was written down once.

**How to apply**: copy every restriction from your own brief into each
sub-brief verbatim — never assume inheritance. A router that cannot list the
constraints its own mission carries has not read its brief closely enough to
redispatch it.

**Tier**: norm. A sub-brief leaves no artifact here — agents are prompted, not
scripted — so nothing can check after the fact whether a constraint was
restated. What would make it partly mechanical: logging dispatch briefs, so a
check could grep a sub-brief for the restrictions named in the brief that
spawned it. Nothing logs them today.

---

## 28. A gate that blocks a correct action is a P1 defect in the machinery, not a reason to wait

A gate is allowed two shapes: it refuses and stays refused because the thing it
guards is actually wrong, or it refuses and a corrective path exists in the
same breath — a named override, a narrower re-scope, a documented
force-procedure. A gate that goes terminal on a correct action — nothing but
"wait" or "work around it by hand outside the machinery" — has stopped being a
gate and become an obstacle indistinguishable from the failure it was built to
catch. The fix belongs in the machinery, filed and prioritized like any other
P1, never absorbed as the cost of having gates.

**Rationale**: rules 9a, 18a and 18b are each the same shape — a mechanism
doing exactly what it was built to do, on a correct action it had no way to
distinguish from an incorrect one. Each is scoped narrowly to the mechanism
that failed; this rule is the general form, so the next gate that goes terminal
has somewhere to land besides a fourth narrow carve-out.

**How to apply**: when a gate refuses a correct action, do not wait and do not
route around it by hand and call the incident closed. File it — a board row
naming the gate and the blocked action — and fix the gate: add the missing
override, narrow the refusal condition, or document the force-procedure in the
same file as the refusal. A gate fixed only in an incident write-up will do the
same thing to the next writer.

**Known corrective paths**, so a refusal is recognisable as non-terminal:
red-gate dispatch → 18b step 5; `tests/release_gate.sh`'s `row_skip` paths →
`--accept-skips`; `tests/lock.sh acquire` refusing a second holder → a
recorded force-release (18a). `pre-commit` and `pre-push` no longer exist
(`install.sh`, `86f4b5d`), so their refusals are no longer cases this list
needs to cover. `evals/run.sh` and CI gate nothing terminally. Check 35's
newest-tag grace has no override today — board row PF-033.

**Tier**: norm, since whether a blocked action was *correct* is a judgment
call. What would make the general rule checkable: grepping every hard-refusal
site (`exit 1` in a hook, a `row_fail` in `tests/release_gate.sh`) for a paired
override keyword (`--no-verify`, `--force`, `--accept-skips`, a named
force-procedure) in the same file — which catches a gate shipped with no escape
at all, though never whether the escape covers the case that needed it.

---

## Dropped starter rules

- **Rule 6 — "every performance number carries its provenance."** Dropped:
  consilium runs no benchmarks and ships no timing numbers. If the
  `evals/run.py` harness on the roadmap adds per-case latency and token-cost
  tracking, restore this rule as 6 rather than assigning a new number.

The remaining starter rules are retained, all adapted to name this repo's
actual artifacts.

---

## Conventions

- **Grow by sub-rule, not by renumber.** A refinement to rule 13 becomes 13a,
  never rule 18. Rule numbers get cited in commits and audit reports;
  renumbering breaks every citation. Dropped rules keep their number.
- **Every rule names a path or a command.** A rule that says "run the tests"
  without naming `bash tests/check.sh` is unenforceable and does not belong
  here.
- **Update the index** when adding a rule, including its tier.
