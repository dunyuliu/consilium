---
description: Work the status board unattended for a stated budget — wei-lin prioritizes PATHWAY_FORWARD.md, lands its rows through gated merges, patch-tags each landing, and at each milestone runs the strict cycle (zofia rules audit + victor technical audit, fix by surface owner, kai refactor, haruto release gated on green CI) before proving the result from a fresh clone. Triggers — `autopilot <budget>`, e.g. `autopilot 12h`.
---

Invoke `wei-lin` to conduct an autopilot run for the budget passed as argument
(`12h`, `until the board is green`, `3 milestones` — she states how she read it
before spending any of it).

The queue is the project's status board, not a roadmap file: `PATHWAY_FORWARD.md`
where the rule book names it, worked in the board's own priority — `BROKEN`
before `OPEN` before a `VERIFIED` row gone overdue. Every row already carries
the command that decides whether it is done, which is what makes it a better
queue than a to-do list.

She does not write the board. Rows belong to `zofia-kaminska` (rule 19): Wei
lands the work, re-runs the row's own evidence command, and hands over the
literal output and the date for Zofia to write. A row closes on a command that
ran — never on a landing that looked right.

Per landing: gated merge from an isolated worktree, patch tag, session log.
Per **milestone** — a surface reaching its target state, not every landing —
the strict cycle in her Phase 3a, in order: audit (`zofia-kaminska` against the
rule book, `victor-reyes` against the code), fix routed to each surface's
owner, refactor by `kai-fischer` scoped to the findings, release by
`haruto-nakamura` with the tag gated on a green CI run for that exact SHA
(rule 15a). Then the gate no other agent runs: clone the pushed commit into an
empty directory, follow the README start to finish, run what it documents. An
error there blocks the release rather than earning a doc ticket.

**What it may do unattended**, and nothing beyond it: patch and minor tags on a
non-default branch. Not the default branch, not a major bump, not a publish,
not a force-update of an existing tag. It stops and asks on those, on a second
CI failure at the same check, and on the rest of her escalation list.

Two things this command cannot promise, so do not read them into it. A slash
command does not hold a session open for twelve hours — the budget is spent
through her heartbeat wake-ups, which need the session alive or an external
scheduler, and an interrupted run resumes from the board rather than from
memory. And no prompt makes a release error-free; what the cycle above buys is
that a release which would have shown an error to a user is refused before the
tag, by a gate that read the project as a stranger.
