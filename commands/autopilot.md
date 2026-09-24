---
description: Work the status board unattended for a stated budget — wei-lin works the board the rule book names, lands each change through a gated merge, and at each milestone runs the strict cycle (zofia rules audit + victor technical audit, fix by surface owner, kai refactor, haruto release gated on green CI) before proving the result from a fresh clone. Triggers — `autopilot <budget>`, e.g. `autopilot 12h`.
---

Invoke `wei-lin` for the budget passed as argument (`12h`, `until the board is
green`, `3 milestones`); she states how she read it before spending any of it.
The brief carries only state she cannot find: running jobs, out-of-repo data,
untracked work, pending user decisions, results measured this session. Never
restate her rules — if one seems missing, file an inbox lesson instead.

**The queue is the status board the rule book names** — `PATHWAY_FORWARD.md`
by default — worked in `prio` order, state as the tiebreak. If this command and
the rule book disagree on which file, ask once rather than pick. She does not
write the board: she lands the work, re-runs the row's evidence command, and
hands Zofia the output (rule 19). A row closes on a command that ran.

**Per landing: a gated merge only.** Per **milestone** — a surface reaching its
target state — once each: session log, board pass, and the strict cycle in her
Phase 3a: audit (`zofia-kaminska` rules, `victor-reyes` code), fix by each
surface's owner, `kai-fischer` refactor scoped to the findings,
`haruto-nakamura` release with the tag gated on green CI for that exact SHA
(rule 15a). Then clone the pushed commit into an empty directory and follow the
README as a stranger; an error there blocks the release. With no remote, no CI,
or pushing forbidden, the gate is the full test tier on the exact SHA plus a
stranger clone of the local repo at the tag — say so in the first report.

**Unattended scope is the project's stated merge policy**, read from its rule
book; where none is stated, no default-branch merges. Never a major bump, a
package publish, or a force-updated tag. She stops and asks on those, on a
second CI failure at the same check, and on the rest of her escalation list.

**At most two specialists at once** — they share one rate limit — with WIP
committed before each dispatch, and the conductor recycled at each milestone: a
fresh `wei-lin` seeded from the board and session log, not ~900k tokens of
accumulated context. A slash command does not hold a session open:
the budget is spent through her heartbeat wake-ups, and an interrupted run
resumes from the last committed checkpoint and the board, never from memory.
No prompt makes a release error-free; the cycle buys only that an error a user
would have seen is refused before the tag.
