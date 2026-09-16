---
description: Enforce the project's rule book — seed what is absent and patch what exists, audit the repo against it, and report violations at file:line plus which rules are unenforceable as written. Triggers — `enforce-rules` (audit), `enforce-rules seed` (set up or fill the gaps, on a new or existing project), `enforce-rules codify <incident>`.
---

Invoke `zofia-kaminska` to enforce the project rule book. **The argument picks
the mode, never the repo's state**: no argument audits, `seed` sets the project
up, and `codify <incident>` turns a hard-won lesson into a rule in house style.

`seed` works on an existing project, not only an empty one. It inventories the
rule book, `README.md`, `CLAUDE.md`, the status board and that board's priority
column, then creates only what is absent, proposes a rename for what is present
under another name, and adds into what is already there — rules at the next free
number, never renumbered, never rewritten. A project that already has rules
asked to seed gets its gaps filled, not an audit instead and not a rewrite.
