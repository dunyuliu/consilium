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

## Index

Read this list first; jump to a rule only when it is load-bearing.

| # | Rule | Tier |
|---|---|---|
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

---

## 1. Make the smallest change; do not add files until you must

Prefer the smallest edit that solves the problem. Fold new content into the
file it belongs to — a new top-level file needs an explicit ask. Never
refactor unrelated agents in the same change. The repo root stays curated:
`README.md`, `LICENSE`, `install.sh`, `PROJECT_RULES.md`, and exactly one
`release_notes_v*.md`. Nothing else.

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

**Rationale**: the five structural invariants — frontmatter validity,
command→agent resolution, README/disk sync, agent-mentioned-in-README, and
stale-backtick-reference detection — are the only automated protection this
repo has. If they are allowed to be red, it has none.

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
Check 3 and Check 4 already cover the commands table and *any* mention.

**Incident**: Check 4 passes on a mention alone, so an agent could be absent
from the model table with the gate green — and twice in one session it was
(`zofia-kaminska`, then `dunyu-liu`), along with a stale "Three engineers"
line that had drifted to seven. Check 6 was negative-tested against both a
missing row and a wrong model before landing.

**Still not mechanical**: the roster-table row and the Layout-tree line. An
agent in the model table but missing from its team roster still passes.

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

**Gap**: agent-to-agent references *inside* `agents/*.md` bodies are not
checked. A rename breaks them silently.

**Proposed Tier-1 upgrade**: extend Check 5's backtick scan to `agents/*.md`
and `commands/*.md` bodies, not just `README.md`.

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
