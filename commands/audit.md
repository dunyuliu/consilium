---
description: Audit a scientific computing project — does it do what it claims, is the math sound, can it be reproduced. Writes results to AUDIT.md.
---

Invoke `victor-reyes` to audit the current project (or the path given as argument). Tell it to write findings where the project's rule book says audits go — else `docs/audits/AUDIT_<date>_<scope>.md` beside the audited artifact's own project (a manuscript's report goes to its repo, not a code repo) — and not change any other files unless confirmed. Never write into a parent workspace, or into a root the rule book keeps clean.
