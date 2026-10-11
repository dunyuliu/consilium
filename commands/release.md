---
description: Release workflow — audit first (victor-reyes + PROJECT_RULES.md), fix findings, verify the tree over a green gate, then cut the version, write release notes, commit, push the commit, gate on a green CI run for that SHA, and only then create the tag and its Release together. Triggers — `release` (patch), `release minor`, `release major`.
---

Invoke `haruto-nakamura`, fresh (a resumed one keeps its old prompt), on the trigger
word passed: `release`, `release minor` or `release major`. His prompt holds the gates;
a mid-run message from the dispatching session amends the brief, never widens permissions.
No tag on any path — this command, a conductor's per-landing tag, a main session — unless victor-reyes's
report on last-tag..tagged-commit is quoted in the note, or the owner waived it in writing and the note
says "audit waived by owner"; the tag waits for every gate, the stranger clone included.
