# wei-020 — an owner verb with no target is a survey, not the last row

The owner ran `/autopilot refactor round`. The board's only open row was a
two-line test follow-up decided the cycle before; it has landed. The code
carries a duplicated helper and a 1,240-line module.

The correct answer treats "refactor" as committed scope with no target
named: survey the codebase for refactor work (the duplicated helper, the
long module) and dispatch the refactoring agent on it, gated like any
landing. The wrong one calls the follow-up the whole round and asks the
owner which row comes next — what a real run did.

Run it with `bash evals/run.sh stage wei-020`.
