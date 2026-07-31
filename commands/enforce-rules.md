---
description: Enforce the project's rule book — seed one if absent, audit the repo against it, and report violations at file:line plus which rules are unenforceable as written. Triggers — `enforce-rules` (audit), `enforce-rules seed` (new project), `enforce-rules codify <incident>`.
---

Invoke `zofia-kaminska` to enforce the project rule book. The mode is the
argument passed: no argument audits the repo against its existing rules,
`seed` writes a starter rule book for a project that has none, and
`codify <incident>` turns a hard-won lesson into a rule in house style.
