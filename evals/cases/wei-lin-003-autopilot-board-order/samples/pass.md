# Next mission — dispatch decision

Board read from `input/PATHWAY_FORWARD.md`, four open rows.

| id | prio | state |
|---|---|---|
| PF-101 | P2 | BROKEN |
| PF-104 | P1 | OPEN |
| PF-107 | P1 | BROKEN |
| PF-110 | P3 | BROKEN |

The queue is worked in priority, not state. PF-101 and PF-110 are BROKEN,
which looks urgent, but P2 and P3 both sit behind the two P1 rows regardless
of how bad their state is — priority, not state, decides the order here.

Within P1 there are two candidates, PF-104 and PF-107. State is the tiebreak,
not the sort, so between two rows at the same priority the worse state goes
first: PF-107 is BROKEN, PF-104 is only OPEN.

**Next mission: PF-107** — `src/loader/`, the unguarded `IndexError` on an
empty manifest. PF-104 follows once PF-107 lands; PF-101 and PF-110 wait
behind both P1 rows.

I do not write the board row myself. zofia-kaminska owns PATHWAY_FORWARD.md;
I hand her the landing, the fresh command output, and the date, and she
closes the row.
