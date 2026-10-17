---
description: Audit a scientific computing project — does it do what it claims, is the math sound, can it be reproduced. Returns findings inline; writes a file only where the rule book or the user says.
---

Invoke `victor-reyes` to audit the current project (or the path given as argument). Tell it to return findings in its final message and write no file, unless the project's rule book says where audits go or the user asks for one — then there, an existing master document before a new file, in the audited artifact's own project (a manuscript's report goes to its repo, not a code repo) — and not change any other files unless confirmed. Never write into a parent workspace, or into a root the rule book keeps clean.
