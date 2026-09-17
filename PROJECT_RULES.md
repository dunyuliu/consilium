# PROJECT_RULES.md — consilium

Binding constraints for this repository. Not a how-to; the README is the
how-to. When a rule and the README disagree, this file wins and the README
gets fixed.

**consilium is a prompt library**, not an application: `agents/*.md` and
`commands/*.md` are the product, `tests/check.sh` is the gate,
`evals/cases/` is the regression suite, and `install.sh` is the delivery
mechanism (symlinks into `~/.claude/`). Every rule below names one of those
artifacts by path. A rule that cannot name a path is not a rule here.

**Canonical filename**: this file, `PROJECT_RULES.md`, at the repo root, is
the rule book. `agents/haruto-nakamura.md` and `commands/release.md` already
cite it by that name. There is no second rule book.

## Rule 0 — Always eat what you cook

**Every discipline this repo sells, it applies to itself first.** consilium
ships agents that audit, gate, test, and enforce. Any of those pointed at
someone else's project and never at this one is a claim, not a practice.

Numbered 0 because it is not one rule among the others — it is the reason the
others get checked. Numbering starts at 1 below and never shifts (see rule 6).

**And the order matters: the discipline goes in the agent first, this repo's
gate second.** consilium is built for other people's projects; applying it here
is the first test of a discipline, never the delivery of it. A lesson that
lands only in `tests/check.sh` has been learned by one repo — the one that
needed it least, because it already knew. The same lesson in an `agents/*.md`
prompt or in `zofia-kaminska`'s starter set travels to every project the team
is pointed at. So when a session finds something: write it where it ships, then
prove it here. A check with no prompt behind it is a fix that reached nobody.

**Concretely**: before shipping a discipline, run it here. Before claiming a
gate works, watch it fail. Before recommending a fixture, run the ones we
have. Before telling a user their docs have drifted, check ours.

**Incidents — all four found on 2026-07-31, all four only by turning consilium
on consilium:**

- `haruto-nakamura` and `commands/release.md` audited against
  `PROJECT_RULES.md`. The file did not exist. Two agents had been enforcing a
  rule book the repo never had.
- `wei-lin` seeded `project_rules.md` while `haruto-nakamura` audited
  `PROJECT_RULES.md`. On a case-sensitive filesystem each wrote a file the
  other could not find. Nobody noticed because nobody ran them together here.
- Five eval fixtures existed across three releases and **none had ever been
  executed**. Running them found four defects in the fixtures themselves —
  including a `line_range` that would have failed a correct answer, and a
  `must_not_find` that punished an agent for stating what it had refrained
  from doing.
- `tests/check.sh` Check 9 was written to verify fixture ranges against
  *report* keywords. It failed on the first case it touched, because
  `evals/README.md` — this repo's own documentation — says explicitly not to
  plant report keywords in fixture input. The check was rewritten around an
  explicit `anchor:` field. It was wrong for a reason already written down
  here.

**How to apply**: when adding or changing an agent, a check, or a rule, ask
what it would find if aimed at this repo — then aim it. If the answer is
"nothing, we're fine", that is the least trustworthy answer available and the
strongest reason to run it.

---

## Index

Read this list first; jump to a rule only when it is load-bearing.

| # | Rule | Tier |
|---|---|---|
| 0 | **Always eat what you cook** — apply every discipline here first | judgment |
| 1 | Minimal changes; no new files; the root is a whitelist | judgment; root table mechanical — Check 31 |
| 2 | No silent fallbacks or swallowed errors | judgment |
| 3 | `bash tests/check.sh` is the gate; green before merge | mechanical — the pre-push hook, not a check |
| 4 | Only fresh runs are evidence | judgment |
| 5 | One definition of "pass" — `check.sh` exit 0, `evals/README.md` criteria | mechanical — Checks 15, 16, 24 |
| 5a | The answer key is never inside `input/` | mechanical — Check 18 |
| 5b | The answer key is never LINKED into `input/` | mechanical — Check 23 |
| 6 | *(dropped — see "Dropped starter rules")* | — |
| 7 | `evals/cases/*/input/` is read-only fixture data | mechanical — Check 26 |
| 8 | Never delete evidence: release notes archive, never vanish | mechanical — Check 28 |
| 9 | Run the cheap check locally before pushing | mechanical — the pre-push hook, not a check |
| 10 | Every agent-behaviour bug gets an eval fixture before the fix ships | judgment |
| 11 | Docs move with the prompt, in the same change | judgment |
| 12 | A new agent lands with README roster, model table, and Layout entry | mechanical — Checks 6, 7 |
| 13 | A new agent lands with at least one `evals/cases/` fixture | mechanical — Check 25 |
| 14 | One installer, one canonical path | mechanical (in part) — Check 29 |
| 15 | A release is a note plus a matching tag, both pushed | mechanical — Check 27 |
| 15a | Nothing red is ever pushed, and the tag is pushed last | judgment — the pre-push hook enforces the local half; see the rule |
| 15b | Every release records its gate, row by row; the gate refuses what it can decide | mechanical — `tests/release_gate.sh`, held to the schema by Check 33 |
| 16 | Agent frontmatter is a contract, not a preamble | mechanical — Check 1 |
| 17 | Cross-references between agents must resolve | mechanical — Checks 5, 8 |
| 18 | One writer per repo — never run two mutating workflows at once | mechanical in name only — the pre-commit hook exists only where install.sh ran; nothing in the repo checks it |
| 18a | Acquire only for the write step; verify unlocked, before and after | norm — `tests/lock.sh status` reports hold *age* mechanically; whether the hold was write-only is not checkable after the fact |
| 18b | Never dispatch a writer while the gate is red; track and push local commits in the same action that turns it green | norm — nothing checks a dispatch decision after the fact; `bash tests/check.sh`'s exit code is the mechanical signal it says to consult |
| 19 | One owner per write surface | mechanical — Check 10 (agents only; human-owned surfaces are declared in the rule) |
| 20 | Every writer declares isolation first; merge is judged by someone else | mechanical — Check 11 |
| 21 | Standing claims are re-checked on a schedule and cite a command | mechanical — Checks 12, 34 |
| 21a | Board `# →` lines are literal command stdout, and the command is re-run | mechanical — Check 17 |
| 21b | No board evidence command reaches the network | mechanical — Check 21 |
| 25b | Every case tier is a tier the tooling consumes | mechanical — Check 22 |
| 25c | Silence must not satisfy a case | mechanical — Check 24 |
| 25d | A verdict records the prompt SHA it was graded against; a contested case needs more than one sample | mechanical in part — SHA/count derivable by tooling; "is this case contested" is judgment |
| 13a | An agent's fixture must name it exactly | mechanical — Check 25 |
| 22 | Every agent declares communication discipline | mechanical — Check 13 |
| 24 | Never audit a moving target; brief with ranges, not whole files | judgment |
| 25 | A fixture proves its criteria are executable, and absorbs every miss | mechanical — Checks 15, 16 |
| 25a | must_not_find guards are declarative, never imperative | mechanical — Check 19 |
| 23 | Every agent declares tool economy; dispatchers declare dispatch cost | mechanical — Check 14 |
| 23a | The dispatch-cost warning tracks the Agent tool exactly | mechanical — Check 20 |
| 26 | Before removing, weakening, or replacing a signal, measure what it currently catches | mechanical in part — a check could require a before/after count in the commit message; whether the count was measured against the real corpus is judgment |

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

**One audience, one job, one home.** These four documents drift into each
other the moment a fact lives in two of them. Usage belongs in `README.md`
and is cited elsewhere, never copied; a convention for working on this repo
belongs in `CLAUDE.md`; a dated open issue belongs in `PATHWAY_FORWARD.md`
and nowhere else. A fact in two files is a fact that will be wrong in one of
them, and you will not find out which.

**Rationale**: this repo's product is prose. Prose sprawls silently — a
second file that half-covers the same ground is not caught by any compiler.

**Incident (2026-09-16)**: `CLAUDE.md` is on the root whitelist
`zofia-kaminska` hands every project she seeds — `agents/zofia-kaminska.md`
invariant 1, "day one owes `README.md`, `CLAUDE.md`, `PATHWAY_FORWARD.md` and
this rule book" — and had never existed here, on any branch. Nothing could
have caught it: her audit mode deliberately checks only the layout a
project's own book states, this book stated a different one, and no check
read the root at all. Rule 0, found by asking what her own rule would say
about this repo.

**How to apply**: before creating a file at the root, name the existing file
it should have gone into and say why it could not.

## 2. No silent fallbacks, swallowed errors, or placeholder prompts

Scripts fail loudly. `tests/check.sh` and `install.sh` both run under
`set -euo pipefail`; keep it that way. No `|| true` that hides a failed
check, no default substituted for a missing agent file, no TODO stub shipped
inside an `agents/*.md` prompt as if it were finished guidance.

**Rationale**: a gate that passes when it cannot run is worse than no gate.

**How to apply**: if a check cannot run, it fails. `find ... -delete` on
broken symlinks is deliberate cleanup and is fine; suppressing a non-zero
exit from a verification step is not.

## 3. `bash tests/check.sh` is the gate — pass it before anything merges

The gate is exactly:

```bash
bash tests/check.sh    # pass criterion: exit code 0, "0 failed" in summary
```

It runs on every push and pull request via `.github/workflows/check.yml`
against `origin` (`https://github.com/dunyuliu/consilium.git`). Nothing
merges to `main` over a red gate. Never merge intending to fix the failure
in a follow-up commit.

**Rationale**: the seven structural invariants — frontmatter validity,
command→agent resolution, README/disk sync, agent-mentioned-in-README,
stale-backtick-reference detection, model-table/frontmatter agreement, and
roster+Layout completeness — are the only automated protection this repo has.
If they are allowed to be red, it has none.

**How to apply**: run it locally (it takes under a second), then push.

## 4. Only fresh runs are evidence

Any inherited conclusion — from a prior session, from the README, from an
agent's own report, from this file — is a hypothesis until a fresh run
reproduces it. Be most skeptical of "already fixed" and "that check covers
it"; both end investigation early. When citing a check result, say whether
you ran it or read it.

This covers a figure handed to you in your own dispatch brief, by the agent
that dispatched you, same as any other agent's report — the dispatcher is not
exempt from being wrong, and re-deriving its number is the same discipline as
re-deriving anyone else's (rule 26's incident: the pasted split was wrong
twice, and re-counting it against the real corpus is what caught it).

**Incident (2026-07-31)**: the README claimed eval coverage of three cases
(`lars-001`, `sophia-001`, `iris-001`); `ls evals/cases` showed four. The
claim had been true once and was never re-run.

**How to apply**: quote the command and its output, not the README's
description of it.

Rule 21 makes the standing half of this mechanical: a claim that was fresh once
decays, and `PATHWAY_FORWARD.md` records when each was last re-derived.

## 5. One definition of "pass" — never invent a second

There are exactly two pass criteria in this repo:

- **Structural**: `bash tests/check.sh` exits 0. Not "the failures look
  cosmetic."
- **Eval**: the criterion in `evals/README.md` — every `expected` entry
  matches AND no `must_not_find` entry matches. Partial credit is explicitly
  out of scope for v1.

A well-reasoned alternative reading of an agent's output is not a pass.

**How to apply**: if you want a different criterion, change
`evals/README.md` or `tests/check.sh` in the same PR — do not report against
an uncommitted standard.

**Partly mechanical (2026-07-31)**: `bash evals/run.sh grade <case> <report>`
applies the `evals/README.md` criterion — every `expected` matched, no
`must_not_find` matched — identically every time, and voids a run whose report
references the answer key. `bash evals/run.sh stage <case>` copies `input/` to
an isolated directory outside the repo first, which is what actually closes
leakage. Agent invocation stays manual: it needs API access, cannot run in
free CI, and a gate that cannot run is worse than no gate.

Grading is necessary, not sufficient — it cannot see precision. See
`evals/README.md` for the proposed `declared_defects:` mechanism and why the
grader refuses to certify rather than pretending to judge.

**A run that read the answer key does not have a verdict at all.** `case.yaml`
and the case `README.md` normally sit one directory above `input/` and contain
the expected findings — but see rule 5a: that "normally" was doing more work
than anyone checked. Scope every invocation to `input/`, then check the agent's
own file-reference list before scoring. Void the run if it touched either —
leakage does not make the output look wrong, which is why it must be checked
rather than noticed. Incident: the first `haruto-001` run, 2026-07-31.

## 5a. The answer key is never inside `input/`

Tier: mechanical (Check 18). No file under `evals/cases/*/input/` may contain
fixture-authoring language — a phrase an author writes *about* a fixture,
addressed at a reader.

`evals/run.sh stage` isolates `input/` **from** the answer key. It copies
`input/` verbatim, by definition, so it cannot help when the key is *in* it.

*Incident (found 2026-08-05)*: `haruto-001` — the fixture whose 2026-07-31 leak
is the reason staging exists — shipped an `input/README.md` reading
*"`release_notes_v0.2.0.md` is **deliberately absent** … This is the planted
defect the agent is supposed to surface."* Its second run is recorded as
*"scoped to `input/`, PASS"*. Scoping to `input/` was the fix; the key was in
`input/`. Rule 5 voids that run.

Sharper: `evals/run.sh grade` voids any report containing "planted defect", so
an agent that faithfully quoted this fixture's own input would have been voided
for reading what it was given.

**What Check 18 does not do.** It matches a fixed phrase list. A leak written in
the project's own voice — a comment saying "this tolerance is deliberately too
loose" — reads as ordinary code and passes. The check is named narrowly on
purpose so it is not mistaken for the broader guarantee, which stays a review
responsibility.

## 6. *(dropped)*

Number retained so rule citations elsewhere never shift. See "Dropped
starter rules" at the bottom.

## 7. `evals/cases/*/input/` is read-only fixture data

Fixture inputs are the planted defects. Nothing writes through them — not an
agent under test, not a debugging run, not "just this once." An agent
invoked on a case reads `input/` and reports; it never edits it. Fixtures
containing intentionally broken code (`lars-001-lookahead-window/input/compute_returns.py`)
and intentionally stale docs (`sophia-001-config-drift/`,
`iris-001-defers-all/`) must stay broken.

**Rationale**: a fixture "fixed" by a helpful agent silently converts a
failing regression test into a passing one.

**How to apply**: `git status` inside `evals/` must be clean after any eval
run. If it is not, `git checkout -- evals/` and rerun with a read-only agent.

**Incident (2026-07-31)**: the first eval run in this repo's history left a
`__pycache__/` directory inside `mira-001`'s `input/` — the agent imported
the fixture module to measure it, which is legitimate and read-only in
intent, but Python writes bytecode as a side effect. `.gitignore` now covers
`__pycache__/` and compiled objects. Note the rule's real scope: *no
meaningful change to fixture content*, not "no byte ever written". Editing a
planted defect is the violation; an interpreter's cache is noise to ignore.

## 8. Never delete evidence — release notes archive, they do not vanish

`release_notes_v*.md` are the project's only history outside git. On a new
release, previous notes **move** from the repo root to `docs/`
(`docs/release_notes_v1.0.0.md`, `docs/release_notes_v1.0.1.md`) — never
deleted, never rewritten. Eval outputs and audit reports for a non-passing
run are kept, not cleaned up.

**How to apply**: `git mv`, never `rm`, for any `release_notes_v*.md`.

## 9. Run the cheap check locally before you push

`bash tests/check.sh` is sub-second. Running it before `git push` costs
nothing; discovering it red in CI costs a round trip and a red badge on
`main`. Same for `install.sh`: run it after adding or renaming an agent, and
confirm the count it prints matches `ls agents/*.md | wc -l`.

**How to apply**: local green → push. Not push → check CI.

**Now mechanical (2026-07-31)**: `install.sh` wires a `pre-push` hook that
runs `tests/check.sh` and aborts the push on failure. The rule was previously
unenforceable — nothing recorded whether the gate ran before a given push, so
after the fact it was indistinguishable from "CI happened to be green".
Deliberate bypass is `git push --no-verify`, and a release that used it says
so in its release note.

## 10. Every agent-behaviour bug gets an eval fixture before the fix ships

When an agent misbehaves in a real deployment — wrong scope, missed finding,
advisory creep — the fix to `agents/<name>.md` lands with a fixture under
`evals/cases/` that reproduces the failure mode on the smallest realistic
input. This is already the established pattern:
`evals/cases/iris-001-defers-all/` exists precisely because
`iris-vermeulen` deferred everything in a real run.

**Rationale**: a prompt edit with no fixture is a vibes-based diff — the
README's own words.

**How to apply**: fixture first, or in the same commit. A prompt fix without
one is a debt that lands before the next version tag.

## 11. Docs move with the prompt, in the same change

`README.md` is the living doc. Any change to an agent's name, scope, model,
routing, or command wrapper updates the README in the same commit — the
roster table, the routing table, the model table, the Layout tree, and the
headline specialist count, whichever are affected. Never as a follow-up.

**Incident (2026-07-31)**: README:8 read "Sixteen specialists" while
`agents/` held nineteen. Three agents landed without their headline count.

**How to apply**: `grep -n <agent-name> README.md` before you call an agent
change done, and re-read the count in the opening paragraph.

---

## Project-specific rules

These encode practices consilium already follows (README "Hiring",
`agents/haruto-nakamura.md` release workflow, `tests/check.sh`). They are
codifications of existing agreements, not new policy — except where marked
**Proposed**, which are recommendations awaiting the maintainer's decision.

## 12. A new agent lands with its README roster, model table, and Layout entry

`agents/<name>.md` is not done until `README.md` contains: a roster-table
row, a model-table row under the correct model, and a Layout-tree line. A
new command additionally needs a row in the commands table.

**Mechanical (2026-07-31)**: `tests/check.sh` **Check 6** asserts every agent
appears exactly once in the README model table, under the model its own
frontmatter declares, and that no table row names a non-existent agent.
**Check 7** covers the other two artifacts: a roster-table row whose first
cell is the backticked agent name, and a Layout-tree line naming its file.
Check 3 and Check 4 already cover the commands table and *any* mention. All
three of rule 12's artifacts are now gated.

**Incident**: Check 4 passes on a mention alone, so an agent could be absent
from the model table with the gate green — and twice in one session it was
(`zofia-kaminska`, then `dunyu-liu`), along with a stale "Three engineers"
line that had drifted to seven. Check 6 was negative-tested against both a
missing row and a wrong model before landing.

Checks 6 and 7 were each negative-tested before landing — a missing row, a
wrong model, a dropped roster line, and a dropped Layout line all fail as
intended. A check that has never failed is not known to be a gate.

## 13. A new agent lands with at least one eval fixture

README "Hiring" step 5, verbatim: *"Plant at least one regression fixture
under `evals/cases/` covering their core competency, so prompt changes can
be measured."* This is a rule, not an aspiration.

**Rationale**: without it, the coverage gap grows monotonically and is only
discovered by counting.

**How to apply**: `ls evals/cases/ | grep <agent-first-name>` before
declaring a hire complete. Coverage debt for agents that predate this rule
is tracked as an open finding, not silently forgiven.

## 14. One installer, one canonical path

The repo ships exactly one install script, and the README, the Layout tree,
and any post-merge hook all name the same path. Two installers with
divergent behaviour is a fork of the delivery mechanism.

**Rationale**: the two current scripts differ in real behaviour — one
installs a git post-merge hook, the other supports `--force` and refuses to
clobber foreign symlinks. A user following the README gets neither the hook
nor the safety, depending on which they run.

**How to apply**: pick one, delete the other, update every reference in the
same commit (rule 11).

## 15. A release is a note plus a matching tag, both pushed

Per `agents/haruto-nakamura.md` Phase 3–4: the release commit is
`release: v<A.B.C> — <summary>`, tagged `v<A.B.C>` matching the release-note
version exactly, over a clean tree and a green `tests/check.sh`, then pushed
with the tag. A release note with no tag is not a release; a tag with no
note is not either.

**How to apply**: `git tag --list 'v*'` must contain a tag for every
`release_notes_v*.md` across the root and `docs/`. Cut a release when the
unreleased commit count makes the last note misleading — do not let the
gap grow indefinitely.

## 15a. Nothing red is ever pushed, and the tag is pushed last

Create the tag **locally, before any push**, so the local gate sees it: Check
27 reads `refs/tags/<version>` in the working clone, and the pre-push hook is
what enforces green-before-anything-leaves-the-machine. Then push in two
commands — the commit, then the tag. Never `--tags`, never `--follow-tags`: a
tag must not ride along on a push that could be rejected.

**The one failure CI is allowed to show between those two pushes** is Check 27
naming the note being released, and nothing else. CI reads only tags that are
already on the remote, so that single assertion *cannot* be green until the tag
push lands — it is the expected intermediate state, not a defect. Any other red
assertion means the release does not exist yet: delete the local tag, fix,
re-verify, re-cut. The tag has not been pushed at that point, so nothing needs
unpublishing.

**After the tag push, CI must be green on the released commit.** A red run
*then* is a real failure and is answered with a follow-up fix commit — never an
unpublish, never a force-push, never deleting a tag from the remote (rule 8).

"Flake" is not a conclusion. Re-run a job only for a named infrastructure
cause, at most once, and treat the second failure as real. If CI cannot be read
at all, say so and record it: a release that assumes a gate it could not see is
rule 2's silent fallback wearing a version number.

**Rationale**: the local hook proves one machine, one platform, one checkout —
often a shallow one, where checks that read history or tags skip themselves.
CI sees the rest, and only after a push. Both gates are real; only one of them
can run before the push exists.

**Incident (2026-09-16), and this rule caused it.** The first version of 15a
read "push the commit alone, wait for CI green on that SHA, then tag." That is
unsatisfiable here, and `agents/haruto-nakamura.md` had said so since
2026-08-05 — its ordering caveat names the deadlock between "do not tag until
green" and a gate that requires every note to have a tag. 15a was written
directly above that caveat and overrode it without noticing. Cutting v1.21.0
found it the only way it could be found: by running the sequence. CI came back
`failure` on 1 of 1319 assertions — Check 27, the missing tag — and every route
out was blocked. Leave the note untagged and Check 27 stays red on `main`; tag
it and the rule forbade it; revert the note and Check 28 fires, because a
release note that once existed may not vanish (rule 8). The release engineer
refused to break the hard rule, correctly, and stopped. **A rule that cannot be
obeyed does not get obeyed loosely — it gets obeyed until the work stops.**

**How to apply**: tag locally, push commit, push tag, then require green. No
offline check can read a network conclusion, so the note records the run
(schema item 9) — including the pre-tag run and its single permitted failure.
Judgment until a check asserts that field on every root note.

## 15b. Every release records its gate, row by row, and the gate refuses what it can decide

Ten rows, named in `agents/haruto-nakamura.md`'s note schema and parsed by
`tests/release_gate.sh`: audit, correctness, conciseness, fixes, docs,
refactor, tree, ci, publish, rules. No tag is pushed until that script exits 0.

Three it decides itself (tree, ci, publish) because they are readable. The
other seven it cannot: no program judges whether an audit was thorough or a
refactor left the system leaner. What is decidable is whether the pass happened
and produced a verdict, so each owes one line in the note and a blank line
fails the gate. **Quality stays a reader's judgement; the absence of the work
stops being invisible** — do not read it as a guarantee the seven were done
well. The script's header carries the mechanism; this rule carries the
obligation.

The gate is `iris-vermeulen`'s surface (rule 19), not the release engineer's:
a gate owned by the agent it judges is not a gate, for the same reason rule 20
has the merge judged by someone other than the author.

**Rationale**: ten release duties had accumulated in prompt prose and three
were checked by anything. A step described only in prose is satisfied by an
agent believing it did the step, and nothing downstream can tell.

**Incident (2026-09-16)**: asked what the release covers, the honest answer was
six of ten — no conciseness pass, no refactor step outside the autopilot, no
published GitHub release, and the rule book audited by whoever was cutting the
release rather than by the agent that owns it. All four had been "in the
workflow" for releases.

**How to apply**: `bash tests/release_gate.sh <note>` before the tag, every
time. Check 33 holds the script's row list and the documented schema together,
so a row cannot be quietly dropped from one side.

## 16. Agent frontmatter is a contract, not a preamble

Every `agents/*.md` carries `name`, `description`, `tools`, `model`;
`name` equals the filename stem; `model` is one of `{opus, fable, sonnet, haiku}`.
The `description` field is load-bearing — `victor-reyes` and
`elena-hartmann` route on it, so a vague description silently breaks
routing.

**Tier 1**: enforced today by `tests/check.sh` Check 1 (structure only —
description *quality* stays judgment).

## 17. Cross-references between agents must resolve

An agent that routes work to another agent names it by its exact stem
(`lars-eriksson`, not "the code auditor"). Every `Invoke \`agent\`` line in
`commands/*.md` and every backtick agent-shaped reference in `README.md`
must resolve to a file in `agents/`.

**Tier 1**: enforced by `tests/check.sh` Checks 2, 5, and 8.

Check 5 skips command stems and a short allowlist of hyphenated technical
terms (`NON_AGENT_TERMS` in the script). Before that narrowing it blocked
twice on correct prose — a gate that cries wolf trains the reader to work
around it. Every allowlist entry is a hole, so keep the list short.

**Gap closed (2026-08-04)**: agent-to-agent references *inside* `agents/*.md`
and `commands/*.md` bodies used to go unchecked, so a rename could break every
routing line silently. Check 8 now scans both, with the same skip rules as
Check 5.

## 25. A fixture proves its criteria are executable, and the suite absorbs every miss

**Two halves. The first is mechanical.**

Every case ships `samples/pass.md` and `samples/fail.md`. Check 15 grades both
and verifies the verdicts: the pass sample must PASS, the fail sample must
FAIL. A criterion that rejects a report written to satisfy it is not a
criterion, it is a typo with authority.

*Incident (2026-08-04)*: the grader shipped with `printf '%s'` where it needed
`printf '%s\n'`, silently dropping the **last keyword of every `any_of` list**
for its entire life. Every grade recorded before that date ran with its final
term ignored. A pass sample would have caught it on day one. Check 15's own
first run then found `ziyan-001` using `"wrong year"` as both an expected
keyword and a `must_not_find` guard — criteria that contradicted each other,
invisible until something executed them.

**The second half is the point of the suite.**

The suite is a living record of what has actually gone wrong, not a planned
matrix of what might. **Every real miss becomes a case.** `sophia-002` exists
because Sophia flagged configured values as drift; `lars-002` exists because
nothing measured hallucination; `haruto-001` came from a deployment miss.

Corollaries, each paid for:

- **A run's record lives in the case, at the time of the run.** A verdict
  written only into a release note or a board paragraph is invisible to
  `evals/run.sh list`, which reads the case's run log because that is where
  rule 4 points and the only place a verdict sits beside the criteria it was
  graded against. Three post-change runs were found on 2026-08-05 claimed with
  specific token counts in prose and absent from their cases (`ziyan-001`,
  `mira-001`, `lars-001`); all three cases still read STALE, and correctly so.
  They were **not** transcribed — copying a claim you did not verify into the
  place the tooling trusts is manufacturing evidence, whatever its source.
- **Silence must not satisfy a case (Check 24).** Every `must_not_find` guard
  passes trivially on an empty report — a report that says nothing cannot contain
  a forbidden phrase. So a case is only as strong as its *positive* criteria, and
  a weak one is passed by doing no work. `lars-002` — the single fixture whose
  purpose is measuring whether an agent invents defects — listed the bare word
  `"correct"` among its expected terms, and a report consisting of that one word
  scored 3 criteria, 0 failed (2026-08-05). Check 24 grades an empty file against
  every case and requires a non-PASS. It cannot tell you a *weak* report fails —
  "how much work does this show" is not mechanizable, and `lars-002` was found by
  hand, not by the check.
- **A fixture is never finished.** When a run finds something real the case
  did not declare, declare it — do not delete it to keep the case tidy. An
  undeclared true defect makes a thorough audit score worse than a shallow one.
- **When the agent and the fixture disagree, the fixture is the more likely
  defendant.** On 2026-08-04 that happened twelve times, across six authors.
  A failing case is a hypothesis about who erred, not a verdict on the agent.
- **Fix the criterion where the criterion is wrong, and never the reverse.**
  Weakening a case to make an agent pass destroys the only instrument that can
  tell you whether the next prompt edit helped. Loosening a `must_not_find`
  guard leaves earlier verdicts valid; tightening any criterion invalidates
  every recorded run that was graded before it.
- **Guards are declarative, never imperative.** Negating an imperative
  *prefixes* it — "do not rotate the token" contains "rotate the token" — so an
  imperative guard fires on the correct report. Negating a declarative *infixes*
  the negation — "must **not** be rotated" does not contain "must be rotated".
  Write `X must be rotated`, never `rotate X`. The containment is definitional,
  not a heuristic — prefixing anything to a string always leaves the string
  present — which is why this is **mechanically checked (Check 19)** where the
  broader question of whether a guard survives its negation is not checkable at
  all. Found 2026-08-05 while authoring `anya-002`, whose first draft had three
  imperative guard families; the sweep that followed found 31 more across 16 of
  the other cases.
- **Declarative is necessary, not sufficient — guard on what a wrong report
  RECOMMENDS or CONCLUDES, not on what it CLAIMS about the subject.** Infixing
  a negation is safe (`must not be rotated`), but a claim can also be denied
  *externally*: "it is not true that the rule book is silent on baselines"
  contains "the rule book is silent on baselines" whole. Every string can be
  externally denied, so no phrasing rule closes this — what closes it is
  choosing a phrase a correct report would not **quote**. A recommendation is
  rarely quoted; a claim about the subject is quoted whenever the task is to
  evaluate that claim. Found 2026-08-05 in `zofia-002`, whose task is precisely
  "does a rule already cover this", making the false claim the natural thing to
  restate. Not mechanizable, and Check 19 does not attempt it.

  **First person is not enough either, and the reliable shape is a verdict
  line.** `nadia-002` shipped `"I score this an agent defect"` — declarative,
  first-person, and still tripped by *"it is not true that I score this an agent
  defect"*. What survives is a phrase the correct report has no reason to write
  at all: `"verdict: agent defect"`, `"verdict: the run missed"`. A report
  states its own verdict; it does not quote the opposite one to reject it. Three
  layers, each paid for by a fixture: **imperative → declarative → verdict
  line.**
- **Before shipping a guard, write the correct report's negation and grade
  it** — both forms, infixed and external. A `must_not_find` entry must be a phrase only a *wrong* answer
  produces. A bare noun never is, because the right answer's denial contains
  it. Four instances, all found on 2026-08-04 and all demonstrated by
  execution rather than argued: `ziyan-001` guarded `"Williams"` while
  declaring a Williams defect, so no correct report could pass;
  `lars-002` guarded `"fillna"` in the one fixture built to measure precision,
  whose own notes describe the absence in that word; `dunyu-001` guarded
  `"friction law"` and `"slipping"` when its right answer is a deferral that
  must name the work being deferred. This is **not mechanizable** — three
  candidate checks were built and measured across all 23 cases, and each
  either missed known instances or failed correct content (see PF-011). The
  test is one command, so run it.

**Mechanically linted (Check 16)**: an `expected` term may not also be a
`must_not_find` guard, and an `any_of` entry may not be sentence-length. Six of
the twelve defects were one of those two shapes. The word cap is deliberately
loose — it flags clauses, not technical phrases.

**How to apply**: author the case, write both samples, run it once yourself,
record the outcome. When a real deployment misses, ask what case would have
caught it and add that case before fixing the prompt.

## 25d. Every verdict records the prompt SHA it was graded against; a contested case needs more than one sample

A `Run (...)` line records `<date>, <agent>, prompt <short-SHA>` — the
short commit SHA of the exact `agents/<agent>.md` (or `commands/*.md`) content
at dispatch time, not the repo's tip. Sample count is never a separate field
that can be forgotten: it is the number of `Run (...)` lines that name the
same SHA, so a reader (or `evals/run.sh`) derives it by counting rather than
trusting a maintained tally.

A case whose right answer is a judgement call, not a planted defect with one
correct finding, is marked `contested: true` in its own `case.yaml` with a
one-line reason. A contested case may not be reported closed, or cited on the
board as settled, on a single sample at the current SHA — it needs a second
dispatch at that same SHA agreeing with the first. A disagreement is reported
as a split (both verdicts, both criteria that diverged), never resolved by a
third tie-breaking run picked to prefer one side. What legitimises an
additional sample is *when* it was committed to, not its count: a sample
count fixed before dispatch is a measurement, while one commissioned only
after a split is seen is chosen because the first result was inconvenient,
and the two are indistinguishable in the record afterward.

A case with no `contested` marking is assumed uncontested: one sample at the
current SHA is sufficient, exactly as before this rule. Marking a case
contested is authorial judgement, made when the case is written or when a
second dispatch is found to disagree with the first — not a retroactive
audit obligation on the twenty-odd cases already in the suite.

**Rationale**: `evals/run.sh`'s STALE check compares calendar dates, so a
same-day prompt edit and dispatch are unordered and a verdict can silently
outlive the prompt it was produced against (PF-024). Separately, a fixture
whose pass bar is itself a judgement call was being graded, and reported on
the board, from one dispatch — indistinguishable from a settled measurement
(PF-025). Both gaps are closed by the same field: recording which prompt
version a verdict was produced against makes it both stale-detectable and
countable, so one schema change serves two rules rather than two.

**Incident (2026-09-16)**: `zofia-004-seed-patch-established` was dispatched
twice against the same prompt on the same day and returned opposite
judgements on its "add a rule at the next free number" criterion — one run
proposed a new rule, the other refused, calling the refusal the better-reasoned
reading of "enhance, never revamp" when no gap required a new rule. Both are
defensible; the fixture's criteria accept only the first (PF-025). Nothing in
`case.yaml`, `evals/run.sh list`, or the board said this verdict rested on one
draw rather than a settled answer, and PF-003's tally of PASS/FAIL counts
across the suite inherited the same blind spot for every case, not just this
one.

**How to apply**: when recording a run, name the prompt file's SHA at dispatch
time (`git log -1 --format=%h -- agents/<agent>.md`). When authoring a case
whose pass bar is a judgement call rather than a fact, set `contested: true`
and say why in one line. When a board row cites a contested case, quote the
sample count next to the verdict, not just the verdict.

**Tier**: mechanical in part. `evals/run.sh` can derive and print the same-SHA
sample count and can refuse to report a `contested: true` case as closed on
count 1 — both are string/count operations. Deciding whether a case *should*
be marked contested is judgement, the same limit rule 18a states for its own
mechanism.

## 24. Never audit a moving target, and brief with ranges not whole files

Three orchestration rules, all paid for on 2026-08-04. Roughly 20% of that
day's ~1M subagent tokens produced nothing durable, and every instance was an
orchestration error — not an agent failing at its job.

**1. Never dispatch an auditor while another agent is writing its subject.**
The lock (rule 18) guards commits, not reads. An auditor pointed at a
directory being written reports on a state that no longer exists by the time
you read the report.

*Incident*: `zofia-kaminska` was dispatched to audit the repo while
`iris-vermeulen` was still authoring `evals/cases/lian-001-*`. Two of her seven
findings — a missing `case.yaml` and a crash in `evals/run.sh` caused by it —
were artifacts of the half-written directory. 90k tokens, and the two wrong
findings were indistinguishable in tone from the five right ones.

**2. A fixture is not runnable until its author's adversarial pass is
recorded.** Shipping an unverified fixture means paying for every run that
rediscovers its defects.

*Incident*: `lars-002` was written and dispatched without its own adversarial
pass. Run 1 found real NaN propagation. The fix for that introduced an
absolute `_STD_FLOOR` that rejects legitimate small-scale data; run 2 found
that. Two runs, ~46k tokens, both spent proving the fixture author wrong. The
rule requiring this pass was written the previous day, by the same author who
skipped it.

**3. Brief with `sed -n` ranges, not whole file paths.** A whole-file read is
re-billed on every subsequent tool call of that agent's run. Naming the file is
not enough; name the lines.

*Incident*: the same Zofia dispatch was told to read `PROJECT_RULES.md` (590
lines), `tests/check.sh` (470), and the board — costing ~3.5k per call across
26 calls. A dispatch given exact narrow paths ran at 3.2k per call on a task
of similar shape.

**How to apply**: before dispatching, ask what else is writing to that path;
check the fixture's run record exists; and quote line ranges in the brief. The
cost of getting this wrong is not a bad answer — it is a confident answer about
a state that has changed.

## 22. Every agent declares communication discipline

Every `agents/*.md` carries a `## Communication discipline` section. Terse
output is a universal contract here, not a per-agent preference.

**Rationale**: the user's harness injects "BE CONCISE" ahead of every prompt.
An agent that pads defeats that at one remove — the orchestrator is concise and
the twenty reports it aggregates are not.

**Limit, stated rather than papered over**: Check 13 verifies the section is
present, not that the prose is good. A vacuous section passes. Presence is
what a gate can hold; brevity is what review is for.

## 21. Standing claims are re-checked on a schedule, and cite a command

`PATHWAY_FORWARD.md` is the present tense of this repository: every open issue,
known-broken thing, and standing claim, by surface, with the date it was last
audited, a re-check interval, and the command whose output was read. Release
notes are append-only history (rule 8) and go stale by design — they are not
the current view, and must not be used as one.

- **A claim marked VERIFIED cites a command that ran.** A claim with no command
  is not verified, it is remembered.
- **A blank `last-checked` means never audited, and stays blank.** It is not an
  unfilled field; it is the honest statement that nobody has checked this
  surface. Never backfill a date to make a row look complete.
- **Overdue is a failure; deferring is not.** An item may be postponed by
  writing one line in the deferral log with a reason. Letting it lapse silently
  may not. The gate reddens on an undecided item, never on a date alone.
- **Items are never deleted.** The board only grows (rule 8).
- **One board, and the others get folded into it.** No `TODO.md`, `STATUS.md`,
  `BACKLOG.md` or second copy anywhere in the tree — Check 34, with
  `evals/cases/**` and `docs/SESSION_LOG_*` exempt as fixture data and history.
  The portable half of this lives in `zofia-kaminska`'s invariant 12, which is
  what reaches other projects; Check 34 is this repo taking the first dose.
- **Every row carries a priority — P1, P2 or P3 — and the work is taken in
  that order.** Check 12 fails a row without one. The board is a queue, not an
  archive: it holds what is open, what is done and what is claimed, and `prio`
  is the column that says which to touch next. Re-prioritising as the project
  moves is the maintenance this file is for, not evidence it was written wrong.
  State is not priority: `BROKEN` says how bad a row is, `prio` says how much
  it matters now, and they disagree often. Priority stays a column rather than
  a row order so that a re-prioritisation is one character and its diff stays
  reviewable.

**Rationale**: rule 4 says only fresh runs are evidence, but it is applied at
the moment of writing and never again. Nothing obliged anyone to re-check, so
nothing did. This rule is the standing half of rule 4.

**Incident (2026-07-31, found 2026-08-04)**: the v1.7.0 release note stated that
rule 18 had become mechanical via `tests/lock.sh` and a versioned `pre-commit`
hook installed by `install.sh`. `git log --oneline -S 'PRECOMMIT' -- install.sh`
returns zero commits. The hook was never committed — it existed only in the
authoring machine's untracked `.git/hooks/`, so the enforcement worked there and
nowhere else, and every clone got the lock script with no gate. The *effect* had
been verified once; the *source being committed* never was, and for four days
nothing re-checked it. Two further record defects went unnoticed the same way:
the v1.10.0 tag carries six files its note does not mention, and four eval
fixtures shipped with undeclared defects in regions documented as clean.

**How to apply**: run the command in the item's block, paste what it actually
printed, set `last-checked` to today, append a dated note. `tests/check.sh`
Check 12 enforces the shape; only you can enforce that the command was really
run.

## 21a. The board's `# →` line is the command's literal stdout, and the command is re-run

Tier: mechanical (Check 17). Every fenced evidence command in
`PATHWAY_FORWARD.md` is executed on every suite run and its output byte-diffed
against the recorded `# →` lines. Narration belongs in the item's prose above
the fence, never on a `# →` line.

**Why it is not enough to cite a command.** Check 12 verifies a `VERIFIED` claim
*cites* a command. It cannot tell whether the recorded output still matches what
that command prints today, so a row can be date-bumped without being re-derived.
Four rows did exactly that on a day their `last-checked` already read today
(2026-08-04). When Check 17 first ran, **five of thirteen rows had drifted**,
including two whose recorded "literal stdout" was only the first line of a
multi-line output — the precondition for this rule had itself silently lapsed.

**One command per fence.** A fence carrying more than one command line fails.
Line-oriented parsing cannot reconstruct multi-line shell: joining `for ...; do`
fragments with `;` yields `do;`, a syntax error the check would then report as
drift. The first attempt at this rule did exactly that and was reverted.

**Exit status is ignored; only stdout is the contract.** The first attempt
blocked the entire suite, and the parser was not the cause: `tests/check.sh` runs
under `set -euo pipefail`, so the first evidence command to exit nonzero — a
`grep -c` that finds nothing is routine — killed the run before the Summary line.
Evidence commands run with errexit suspended. A gate that stops the suite when it
trips is worse than no gate (rule 2).

**Self-referential rows are named, not dropped.** A command that invokes
`bash tests/check.sh` would recurse; those rows print
`self-referential, not re-run: <id>` and are exempt. An exemption that leaves no
trace in the output is indistinguishable from a check that silently passed.

**What it still cannot fix**: a command whose true output is a derived tally from
a larger listing needs a second, narrower command whose raw output *is* the
number. This rule is upstream of the check, not a substitute for writing a
checkable command.

## 20. Every writer declares isolation first, and is evaluated at the merge

An agent with write access follows one lifecycle, and its prompt states the
containment half **before anything else it says**:

1. **Isolate.** Work in your own worktree, branch, or scratch directory.
   Never write to the repo root, the `main`/`master` checkout, or the master
   project folder. Never touch a file another live mission holds.
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
first `##` heading in the file. A containment rule buried at line 80, after
the agent has already read its mission, is advice; at the top it is a
precondition. `tests/check.sh` Check 11 enforces the position.

**Rationale**: the expensive failures in this repo were never bad analysis —
they were correct work written to the wrong place, or landed without an
independent check. Two agents in one tree, a scratch run writing through a
symlink into golden data, a release cut while another release was running.
Analysis errors cost a rerun; containment errors destroy work that was
already right.

**Incident (2026-07-31)**: an audit of all nine write-surface owners found
**two** declared isolation at all, both buried past line 70. Five — including
the refactorer, the test architect, and the release engineer — had no
containment statement anywhere in their prompt.

## 19. One owner per write surface

Every file class in a project has exactly one agent that may write it. Two
agents holding the same surface do not collide loudly — they diverge quietly,
and the divergence surfaces months later as two files that were supposed to
be one.

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

Everyone not listed is read-only. An agent with `Edit` or `Write` in its
frontmatter and no surface here is an unscoped writer — Check 10 fails on it.

**`commands/*.md` is `lian-zhao`'s, not `wei-lin`'s.** Each command file is a
short trigger wrapper — argument parsing and mode selection for one `agents/*.md`
invocation, not a runtime artifact of any single agent's campaign. That a file
like `commands/autopilot.md` documents `wei-lin`'s own workflow doesn't make it
hers to hold, any more than `agents/wei-lin.md` itself is — both are prompt
content describing an agent, authored by the agent whose surface is prompts.
Splitting ownership by which agent a command happens to invoke would give every
command a different owner and leave nobody who can keep the trigger-to-mode
mapping consistent across the whole set; one writer for the whole directory,
same as `agents/*.md`, is what a directory-wide surface means (rule 19's own
header). Gap found 2026-09-16: a dispatched `lian-zhao` correctly refused to
edit `commands/autopilot.md` because this table had no row for `commands/*.md`
at all — a whole directory with no enforced owner, invisible to Check 10.

**Human-owned surfaces.** `README.md` and `CLAUDE.md` have no agent owner and
are not an oversight: they are maintained by hand. An agent proposes a change
to either and routes it — `zofia-kaminska` refuses to edit them while auditing,
`sophia-okafor` reports their drift without fixing it. Declared here because
Check 10 walks agents to surfaces and cannot see a surface with nobody on it;
`CLAUDE.md` sat outside the model entirely for the day it took to notice
(2026-09-16).

**Precedence when surfaces touch.** CI config is `iris-vermeulen`'s; a port
needing a CI change asks her rather than editing it. Production code is
`kai-fischer`'s to simplify and `dunyu-liu`'s to create — whoever holds the
mission holds the file for its duration, and the other one waits.

**Incident (2026-07-31)**: `wei-lin` seeded `project_rules.md` while
`haruto-nakamura` audited `PROJECT_RULES.md`. Two owners, two filenames, and
on a case-sensitive filesystem each wrote a file the other could not find.
The filename was fixed first; the ownership was the actual bug. `wei-lin` now
specifies rules and delegates the writing to `zofia-kaminska`.

**How to apply**: adding an agent with write tools means adding a row here.
If the row would duplicate an existing surface, the agent is the wrong shape
— split the surface or fold the agent in.

## 18. One writer per repo — never run two mutating workflows at once

A workflow that commits, tags, or edits files owns the repo for its duration.
Do not start a second one — by hand or by dispatching an agent — until the
first has reported.

Before concluding a background agent is finished, check the **right** signal:
its transcript mtime, or by messaging it. An empty to-do list is not evidence
that an agent stopped, and a long-running agent that fans out to subagents may
not notify for many minutes because notification waits on its children.

**Incident (2026-07-31)**: the v1.1.0 release was cut by hand while a
dispatched release agent was still running, because a to-do-list query was
misread as proof it had died. Both wrote tags to the same repo seconds apart.
The tags happened to be correct and were verified before the push, but nothing
made that outcome likely — two writers raced and the good result was luck.

**Now mechanical (2026-07-31)**: `tests/lock.sh` takes a named lock and the
`pre-commit` hook installed by `install.sh` refuses a commit from anyone else
while it is held.

```bash
export CONSILIUM_LOCK_OWNER=<who-you-are>
bash tests/lock.sh acquire "release v1.7.0"   # ... work ... 
bash tests/lock.sh release
```

Ownership is a **label, not a pid**. The first version stored `$$` and checked
liveness — and read as stale the instant it was taken, because `$$` is the pid
of the short-lived `lock.sh` shell itself. Agents run each command in a fresh
shell, so no pid outlives the work it protects. Found by running it.

A lock is never auto-cleared, however old: "probably stale" is precisely the
reasoning that caused the incident.

**How to apply**: one release at a time. If a workflow appears stuck, stop it
explicitly and confirm it stopped before taking over its work.

### 18a. Acquire only for the write step; verify unlocked, before and after

The lock is exclusive, and exclusivity is only worth what it costs the other
writers waiting on it. Reading files, re-running board commands, running
`bash tests/check.sh`, re-deriving evidence — none of that needs exclusivity,
and none of it belongs inside the held window. The held window is: acquire,
write the file, `git add`, `git commit`, release. Seconds, not minutes. Any
final verification — the gate, a re-run of the command you just closed a
board row with — happens *after* release, on the commit you just made, not
before it.

**Rationale**: rule 18 is correct that a lock must never auto-clear, however
stale it looks — that is what makes the lock meaningful. But a rule that
never auto-clears is only survivable if nothing holds it for long, and
"acquire, then do the slow part" turns every ordinary interruption of the
slow part into a repo-wide block. Shortening the window is the only lever
this rule has, because rule 18 correctly forbids the other one.

**Incident (2026-09-16)**: two session rate limits hit in one afternoon. The
first was routine. The second killed a dispatched agent mid-run while it held
the repo lock, scoped to `PATHWAY_FORWARD.md`, for 174 minutes — the entire
duration of a verification pass it had started *after* acquiring, not before.
Every other writer was blocked for that whole window. Recovery required a
human-equivalent decision under rule 18 (nothing may auto-clear the lock):
confirm the holder was actually gone, inspect its worktree for unlanded work
— it held 164 uncommitted lines, recovered rather than redone — then release
`--force` by name, and write down that it happened. The lock behaved exactly
as designed; the incident was that a multi-minute read-only pass ran inside
the held window at all.

**How to apply**:
1. Do all reading, re-running of evidence commands, and gate runs first,
   unlocked.
2. `bash tests/lock.sh acquire "<what>" <path-prefix>…` only once you are
   ready to write.
3. Write, `git add`, `git commit`, `bash tests/lock.sh release` — as one
   unbroken sequence, nothing else interleaved.
4. Any closing verification (the gate, a re-run of a board command you just
   recorded) happens after release.
5. Before force-releasing a lock whose holder appears dead: check that
   holder's worktree for unlanded work and recover it — do not re-do work
   that already exists uncommitted. A force-release is always an explicit,
   recorded act naming the holder and the reason; a silent one is
   indistinguishable from a lock that never worked.

**Tier**: a norm, not a mechanical check, and this is stated rather than
claimed otherwise. `tests/lock.sh status` already prints how long a lock has
been held (`age_of()`, rule 18's own mechanism) — that half is mechanical.
Whether the held time was spent writing or reading is not something a script
can determine after the fact, because the lock file records only who holds
it and since when, not what commands ran while it was held; and agents here
are prompted, not scripted, so there is no invocation boundary for a check to
sit between. What would make it checkable: a lock-history log (append a line
on every acquire and release, rather than overwriting one file) that a check
could diff against `bash tests/check.sh` invocation timestamps to flag a hold
that spans a slow command. Nothing in this repo does that today.

### 18b. Never dispatch a writer while the gate is red; if commits sit local, track them and push in the same action that turns it green

A red gate means the pushed remote and the local branch disagree about what
passes. Dispatching a new writer during that window gives it a base that is
missing whatever made the gate red in the first place — every worktree it
creates inherits the gap silently, because branching does not check the gate.

**Rationale**: this is not the concurrent-writer problem rule 18 already
covers (two mutating workflows racing the same lock). It is a sequencing
problem one level up, before any lock is even taken: the *conductor's* choice
of when to hand a fresh worktree to a writer at all. A green gate is the only
signal that local and remote currently agree; dispatching on a red one hands
out a stale base by construction, and no lock protects against that because
the new worktree never contends for one — it just starts wrong.

**Incident (2026-09-16)**: the same stale-base failure through two different
doors in one campaign. First, a branch was pushed, a PR opened, then six more
commits were cherry-picked locally and never pushed again; the maintainer
merged the snapshot the PR still pointed at, and two agents' work plus four
findings became unreachable objects — recovered only because someone noticed
the count didn't match. Second, the gate went red mid-chain, `pre-push`
correctly refused, commits sat local — and a dispatched agent branched from
the *remote* anyway and got a stale base; she detected the gap herself and
merged the missing branch by hand. `pre-push` was correct both times; the gap
is upstream of it, in the decision to dispatch during the window it exists to
guard.

**The nuance that makes this survivable rather than a ban on ever having
local, unpushed commits**: the second failure was never "commits sat local" —
a red gate legitimately keeps commits local until the fix that turns it green
lands. The failure was that nobody was counting them while they sat there.
What this rule requires is not "the gate must always be green" — sometimes it
isn't, and rule 15a already forbids pushing red — but that the local-ahead
count is tracked for as long as it's true, and that pushing happens in the
same action that turns the gate green, not as a later, separate step someone
might forget.

**How to apply**:
1. Before dispatching a writer to a fresh worktree, check the gate. Red →
   do not dispatch; fix or wait.
2. If commits are legitimately local because the gate is red mid-chain, note
   how many and why (a session log entry, or the board row the fix belongs
   to) so the count is never only in one person's head.
3. Keep multi-owner chains short — each additional owner between a push and
   the next is another window in which a base can go stale unnoticed.
4. The commit that turns the gate green is the commit that gets pushed. Do
   not defer the push to a later, separate step.

**Tier**: a norm, not a mechanical check — nothing in this repo can detect,
after the fact, that a writer was dispatched while the gate was red, because
dispatch itself leaves no artifact here to check (agents are prompted, not
scripted, same limit rule 18a states for lock-hold purpose). What is
mechanical, and already exists: `bash tests/check.sh`'s exit code as the
go/no-go signal this rule says to consult before dispatching, and
`git status`/`git log @{u}..` for the local-ahead count step 2 asks be
tracked.

## 23. Every agent declares tool economy; dispatchers declare dispatch cost

Every `agents/*.md` carries a `## Tool economy` section. A dispatch re-bills
the entire prior conversation on every tool call, so cost grows with the
square of tool calls, not with prompt size — measured here: under 7 calls ≈
19k tokens, over 10 ≈ 75k, against ~2k to read a file directly. An agent that
dispatches subagents states that multiplier explicitly; every agent states
the discipline of batching, reading once, and not re-confirming a finding it
already has.

**Rationale**: the user's harness already prepends "BE CONCISE" to every
prompt (rule 22). An orchestrator that does not know its own dispatch cost
burns 20k tokens confirming what a single 2k read would have settled.

**Tier 1**: enforced by `tests/check.sh` Check 14 — presence of the section
on every agent. **Limit, stated rather than papered over**: the check
verifies the section exists; it does not separately verify that an agent
capable of dispatching a subagent states the dispatch-cost multiplier inside
it — that half is judgment, not gated.

## 26. Before removing, weakening, or replacing a signal, measure what it currently catches

A check, a metric, a classifier, or an alarm that is about to be removed,
weakened, or replaced is measured against the **real corpus** first — count
what it currently flags, not what the failure mode you are fixing would
predict it flags. **A failure mode having no members in the actual data means
the signal is right on that data, however unsound the method looks in
principle.** Confirm a new boundary by mutation, not by argument: take one
real record, move it across the boundary by hand, watch it flip, restore it,
and confirm nothing else moved.

**A metric moving to zero is not evidence of a fixed problem — it is evidence
of a changed question.**

**Rationale**: rule 4 governs trusting an inherited conclusion; rule 25's
family governs designing a new criterion; the negative-test convention
(rule 12, 25) governs *adding* an assertion and proving it can fail. None of
them govern *taking one away* — replacing a signal reads as strictly better
than the thing it replaces precisely because nobody counted what the old
signal was catching before it was gone.

**Incident (2026-09-16)**: `evals/run.sh`'s STALE check compared a verdict's
calendar date to the prompt's last-commit date, which cannot order two events
on the same day (PF-024). Rule 25d replaced the date with the prompt's commit
SHA. Fifty existing `Run (...)` records carry no SHA, and backfilling one is
forbidden (rule 4) — so a SHA-less record needed a defined fallback, and the
choice was made on the *method's* soundness alone: same-day date comparison
is unsound in principle, so every SHA-less record was marked
provenance-unknown rather than falling back to the date. Measured against the
real corpus this was wrong. Of the 14 records the date comparison flagged
STALE before the change, **0 were same-day** — the exact case date comparison
cannot order — and all 14 were different-day, true positives, one gap of 6.5
weeks. The change took STALE 14 -> 0 and provenance-unknown 0 -> 34: fourteen
correct warnings replaced by thirty-four refusals to answer, and every summary
written afterward would have read it as an improvement, because the alarm
count went to zero. Caught by two things, both general: the true-positive rate
of the signal being removed was counted before it was removed, and the new
boundary was confirmed by flipping one real record's date to same-day, watching
it move STALE -> indeterminate, and restoring it.

**How to apply**: before a commit that removes, weakens, or replaces a
check, a grading criterion, a classifier, or a board detector, run the old
signal against the real corpus and record the split (how many flags, and on
what basis each fired) in the commit message or the rule/board entry the
change lands beside. Then mutate one real record across the new boundary and
confirm the flip, before trusting the new signal's silence.

**Tier**: mechanical in part. A commit that touches `tests/check.sh` or
`evals/run.sh` in a way that removes or changes a check/classifier could be
required to name a before/after count in its message — cheap, and gameable,
because nothing can verify the count was measured against the real corpus
rather than invented to match the diff, and rule 2 already warns that a check
worse than none is worse than nothing. What would make the substance
checkable: none of this repo's tooling can currently distinguish "I counted
the real corpus" from "I wrote a plausible number", so the count itself stays
a norm; only its *presence* in the commit message is mechanizable, and is not
yet built.

---

## Dropped starter rules

- **Rule 6 — "every performance number carries its provenance."** Dropped:
  consilium runs no benchmarks and ships no timing numbers. Nothing in the
  repo produces a performance claim to attach provenance to. If the
  `evals/run.py` harness on the roadmap adds per-case latency and token-cost
  tracking, restore this rule as 6 rather than assigning a new number.

The remaining starter rules are retained, all adapted to name this repo's
actual artifacts.

---

## Conventions

- **Grow by sub-rule, not by renumber.** A refinement to rule 13 becomes
  13a, never rule 18. Rule numbers get cited in commits and audit reports;
  renumbering breaks every citation. Dropped rules keep their number.
- **Every rule names a path or a command.** A rule that says "run the tests"
  without naming `bash tests/check.sh` is unenforceable and does not belong
  here.
- **Update the index** when adding a rule, including its tier.
