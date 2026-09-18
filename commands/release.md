---
description: Release workflow — audit first (victor-reyes + PROJECT_RULES.md), fix findings, verify the tree over a green gate, then cut the version, write release notes, commit, push the commit, gate on a green CI run for that SHA, and only then push the tag. Triggers — `release` (patch), `release minor`, `release major`.
---

Invoke `haruto-nakamura` to run the release workflow. The trigger word is the argument passed (`release`, `release minor`, or `release major`).

Two gates, one mechanism (rule 15a): the local suite is run by hand before
anything leaves the machine — nothing enforces it — and CI proves the rest, the
other platform, the clean checkout, the checks a shallow local clone skips. So the
commit is pushed alone, CI's conclusion for that exact SHA is read, and the tag
is pushed only on green. Where CI cannot be read at all, he stops before the
tag and says so rather than assuming it.
