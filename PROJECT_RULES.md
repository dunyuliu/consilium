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
| 1 | Minimal changes; no new files until necessary | judgment |
| 2 | No silent fallbacks or swallowed errors | judgment |
| 3 | `bash tests/check.sh` is the gate; green before merge | mechanical |
| 4 | Only fresh runs are evidence | judgment |
| 5 | One definition of "pass" — `check.sh` exit 0, `evals/README.md` criteria | mechanical |
| 6 | *(dropped — see "Dropped starter rules")* | — |
| 7 | `evals/cases/*/input/` is read-only fixture data | mechanical |
| 8 | Never delete evidence: release notes archive, never vanish | mechanical |
| 9 | Run the cheap check locally before pushing | mechanical |
| 10 | Every agent-behaviour bug gets an eval fixture before the fix ships | judgment |
| 11 | Docs move with the prompt, in the same change | judgment |
| 12 | A new agent lands with README roster, model table, and Layout entry | mechanical |
| 13 | A new agent lands with at least one `evals/cases/` fixture | mechanical |
| 14 | One installer, one canonical path | mechanical |
| 15 | A release is a note plus a matching tag, both pushed | mechanical |
| 16 | Agent frontmatter is a contract, not a preamble | mechanical |
| 17 | Cross-references between agents must resolve | mechanical |
| 18 | One writer per repo — never run two mutating workflows at once | mechanical |
| 19 | One owner per write surface | mechanical |
| 20 | Every writer declares isolation first; merge is judged by someone else | mechanical |
| 21 | Standing claims are re-checked on a schedule and cite a command | mechanical |
| 22 | Every agent declares communication discipline | mechanical |

---

## 1. Make the smallest change; do not add files until you must

Prefer the smallest edit that solves the problem. Fold new content into the
file it belongs to — a new top-level file needs an explicit ask. Never
refactor unrelated agents in the same change. The repo root stays curated:
`README.md`, `LICENSE`, `install.sh`, `PROJECT_RULES.md`, and exactly one
`release_notes_v*.md`, and `PATHWAY_FORWARD.md`. Nothing else.

**Rationale**: this repo's product is prose. Prose sprawls silently — a
second file that half-covers the same ground is not caught by any compiler.

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
and the case `README.md` sit one directory above `input/` and contain the
expected findings. Scope every invocation to `input/`, then check the agent's
own file-reference list before scoring. Void the run if it touched either —
leakage does not make the output look wrong, which is why it must be checked
rather than noticed. Incident: the first `haruto-001` run, 2026-07-31.

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

## 16. Agent frontmatter is a contract, not a preamble

Every `agents/*.md` carries `name`, `description`, `tools`, `model`;
`name` equals the filename stem; `model` is one of `{opus, sonnet, haiku}`.
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

**Tier 1**: enforced by `tests/check.sh` Checks 2 and 5.

Check 5 skips command stems and a short allowlist of hyphenated technical
terms (`NON_AGENT_TERMS` in the script). Before that narrowing it blocked
twice on correct prose — a gate that cries wolf trains the reader to work
around it. Every allowlist entry is a hole, so keep the list short.

**Gap**: agent-to-agent references *inside* `agents/*.md` bodies are not
checked. A rename breaks them silently.

**Proposed Tier-1 upgrade**: extend Check 5's backtick scan to `agents/*.md`
and `commands/*.md` bodies, not just `README.md`.

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
| campaign session log, merge decisions | `wei-lin` |
| `.consilium-review/` in a deployed project | `nadia-hadid` |
| `PATHWAY_FORWARD.md` (the inspection log) | `zofia-kaminska` |

Everyone not listed is read-only. An agent with `Edit` or `Write` in its
frontmatter and no surface here is an unscoped writer — Check 10 fails on it.

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
