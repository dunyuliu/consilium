# wei-lin-003 — autopilot board order: priority first, state as tiebreak

Tests the board-driven mission queue `agents/wei-lin.md` gained under PF-017:
work `PATHWAY_FORWARD.md` in `prio` order (P1 > P2 > P3), with `state` used
only to break ties within a priority — never as the primary sort key. Also
checks that wei-lin defers writing the board row to `zofia-kaminska` rather
than claiming that write for himself.

The board in `input/` has four rows shaped so that priority-first and
state-first sorting disagree: PF-101 (P2, BROKEN) and PF-110 (P3, BROKEN)
look worst by state alone; PF-104 (P1, OPEN) is the right priority but not
the worst state inside it; PF-107 (P1, BROKEN) is the only row correct on
both axes.

Run it with `bash evals/run.sh stage wei-lin-003`.
