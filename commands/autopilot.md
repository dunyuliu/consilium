---
description: Work the status board unattended for a stated budget — wei-lin works the board the rule book names, lands each change through a gated merge, and at each milestone runs the strict cycle (zofia rules audit + victor technical audit, fix by surface owner, kai refactor, haruto release gated on green CI) before proving the result from a fresh clone. Triggers — `autopilot <budget>`, e.g. `autopilot 12h`.
---

Invoke `wei-lin` for the budget passed as argument (`12h`, `until the board is
green`, `3 milestones`); she states how she read it before spending any of it.
The brief carries only state she cannot find: running jobs, out-of-repo data,
untracked work, pending user decisions, results measured this session. Never
restate her rules — if one seems missing, file an inbox lesson instead.
While she runs, the invoking session writes nothing to the repo: it monitors,
verifies against the full record rather than a tail, relays owner decisions and
any specialist's completion notice to her at once, and marks her numbers unaudited until audited. Only the conductor is
long-lived; every other agent does one job and is stopped when read. Outside the repo it writes
nothing without the owner's OK for that write. A pre-written constraint is a claim to re-check, not an order.

**The queue is the status board the rule book names** — `PATHWAY_FORWARD.md`
by default — worked in `prio` order, state as the tiebreak. If this command and
the rule book disagree on which file, ask once rather than pick. She writes a
row's mechanical update (fresh command output, date); opening, closing and
re-scoping rows stay Zofia's (rule 19). A row closes on a command that ran.

**Per landing: a gated merge only.** Per **milestone** — a surface reaching its
target state — once each: session log, board pass, and the strict cycle in her
Phase 3a: audit (`zofia-kaminska` rules, `victor-reyes` code), fix by each
surface's owner, `kai-fischer` refactor scoped to the findings,
`haruto-nakamura` release, the tag gated on green CI for that exact SHA (rule
15a). Before the tag, clone that SHA into an empty directory and follow the
README as a stranger, under `env -i` so no shared venv is inherited; an error, or
an env-build script that doesn't create its own interpreter, blocks the release. With no remote, no CI,
or pushing forbidden, the gate is the full test tier on the exact SHA plus a
stranger clone of the local repo at the tag — say so in the first report.

**Unattended scope is the project's stated merge policy**, read from its rule
book; where none is stated, ask the owner once at the start, and until then
make no default-branch merges. Never a major bump, a
package publish, or a force-updated tag. She stops and asks on those, on a
second CI failure at the same check, and on the rest of her escalation list.

**At most two specialists at once** — they share one rate limit — with WIP
committed before each dispatch. Recycle the conductor at a milestone, seeded
from the board and session log, and only when a cheap trigger fired (a PID
exited, a new checkpoint or results line) — an idle recycle costs 100k+ tokens. A slash command does not hold a session open:
the budget is spent through her heartbeat wake-ups, and an interrupted run
resumes from the last committed checkpoint and the board, never from memory.
No prompt makes a release error-free; the cycle buys only that an error a user
would have seen is refused before the tag.
