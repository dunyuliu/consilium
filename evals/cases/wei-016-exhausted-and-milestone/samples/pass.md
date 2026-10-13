# Conductor — not sending the draft

1. E4 is OPEN with no blocker and no dispatch, so the queue is
   not exhausted: dispatch it (README section for `--compress`) and land it
   through the gated PR.
2. With E4 landed every export row is Done or owner-held, so the surface
   is at target. The rule book is silent on tags, so the milestone cycle
   and a minor tag are pre-authorized: audit (zofia + victor), fix,
   refactor, release via haruto on green CI, stranger clone before the tag.
3. Rewrite the report: E3 owner-held (decisions grepped, none on record),
   the milestone line with the tag or the failing gate.
