---
description: Work the status board unattended for a stated budget — wei-lin works the board the rule book names, lands each change through a gated merge, and at each milestone runs the strict cycle (zofia rules audit + victor technical audit, fix by surface owner, kai refactor, haruto release gated on green CI) before proving the result from a fresh clone. Triggers — `autopilot <budget>`, e.g. `autopilot 12h`.
---

Invoke `wei-lin` by agent type, never a generic agent handed her brief (it runs without her rules or cap),
for the budget passed as argument (`12h`, `until the board is green`, `3 milestones`); she states how she read it before spending any of it; every verb the owner wrote
(clean up, refactor, release) is committed scope, and only the owner narrows it, never this session.
The brief carries only state she cannot find: running jobs, out-of-repo data,
untracked work, pending user decisions, results measured this session. Never
restate her rules — if one seems missing, file an inbox lesson instead.
While she runs, the invoking session writes nothing to the repo: it monitors,
verifies against the full record rather than a tail, relays owner decisions (committed
verbatim to the board first, or as a marked paraphrase if the quote holds a privacy-listed term, staging only that hunk, the relay citing that commit; a stop goes to her at once, before the session acts, committed after), and any specialist's completion notice to her at once
while she is live (a send to an ended conductor resumes her; seed a fresh one), and marks her numbers unaudited until audited. Only the conductor is
long-lived; every other agent does one job and is stopped when read. When her
run ends, read her log's "still owns" lines, then list each branch, worktree and open P1 row it touched; any without a
live agent gets a fresh conductor or an owner report that same turn, never a landing by this session; so does a
merged surface her report gives no tag and no `no milestone, because`. Then it fast-forwards the owner's main checkout
(`git pull --ff-only`) and reports `checkout synced to <sha>`, or why not: a dirty tree, another session's live worktree. Past ~200k context of its own, it hands off: a
brief (live agents, pending relays, board SHA) for the owner to resume in a fresh session. Outside the repo it writes
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
book (a direct-push policy is flagged to the owner once as a deviation from PR-only); where none is stated, this command's cycle is the policy, named in the brief and never asked; missing CI is her first row. Only
what both leave open goes in one pre-flight question with defaults; a declined one is a BLOCKED(owner) row, never re-asked. Never a major bump, a
package publish, or a force-updated tag. She stops and asks on those, on a
second CI failure at the same check, and on the rest of her escalation list.

**At most two specialists at once** — they share one rate limit — with WIP
committed before each dispatch. Recycle the conductor at a milestone, past ~100 tool calls summed over her resumes (never resume her past it), or after
~1 h with no commit and no job of hers running, seeded from the board and session log: each call re-reads her whole
context, so three short conductors cost far less than one long one. A slash command does not hold a session open:
the budget is spent through her heartbeat wake-ups, and an interrupted run
resumes from the last committed checkpoint and the board, never from memory; a child
that dies on a session limit naming a reset time gets a wake-up armed for that time, same turn.
