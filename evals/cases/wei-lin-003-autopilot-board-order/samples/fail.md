# Next mission — dispatch decision

Three rows are BROKEN and one is OPEN. BROKEN is the worst state, so the
BROKEN rows go first. **Next mission: PF-101** — the parser is silently
dropping malformed rows, which is a correctness bug in the tightest scope,
so it's the most urgent thing on the board.

PF-107 and PF-110 are also BROKEN and queue up behind PF-101. PF-104 is only
OPEN, so it waits until every BROKEN row is cleared.

Once the fix for PF-101 lands, I'll update PATHWAY_FORWARD.md myself with
the new state and last-checked date so the board reflects the landing
immediately.
