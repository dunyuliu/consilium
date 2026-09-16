# zofia-004 — Mode A on an established project: patch, don't revamp

`zofia-003-seed-bare-project` exercises Mode A only on the ABSENT column of
its own invariant-1 table — a project with no README.md, no CLAUDE.md, no
rule book at all. This case exercises the other two columns: PROJECT_RULES.md
here already has five real rules, and README.md and CLAUDE.md are both
complete. The correct seed adds new rules at the next free number without
touching 1-5, leaves README.md and CLAUDE.md alone, and creates only the
genuinely absent status board — seeded from the "Known issues" section
README.md already carries, not from an empty template.

Run it with `bash evals/run.sh stage zofia-004`.
