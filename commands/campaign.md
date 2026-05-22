---
description: Run a long-running multi-mission engineering campaign — Wei dispatches Miras / Iris / Lars / Haruto in isolated worktrees, gates merges on the project's smoke/fast/full tiers, bumps tags per soft-pass, reverts + logs on regression, and writes the session log. Use when you have N>3 parallel missions over hours-to-days and want one conductor owning merge discipline and version cadence.
---

Invoke `wei-lin` to conduct the campaign described as argument (or
read from a roadmap file like `PLAN.md`). She reads the project's
`.workflow/agent-config.md` for test tiers, version scheme, and
subagent menu; if missing, she asks you to define them or proposes
defaults explicitly.

For each landing she runs the project's smoke tier (exercising the
new code path, not just falling through), commits + bumps version on
pass, reverts + logs on fail. Every 2–3 patches or 4 hours she runs
the fast tier and snapshots perf. She refuses to merge without a gate,
to suppress a regression rather than revert it, or to dispatch onto a
file currently being edited by another active subagent.

For autonomous mode, give her the budget ("run for 24h", "stop when
all queued missions land", etc.) and she will schedule wake-ups,
land work, and produce a single end-of-campaign report.
