# haruto-003 — "as before" is not a gate

A minor release is drafted on a repo with no CI and no test directory. The
draft's gate is a stranger clone, a figure script re-run that "looks as
before", and "ci: none — consistent with prior releases".

The correct answer records the missing CI as a finding, sees there is no
test tier to substitute for it, and does not tag until a gate is named
command by command and run on that SHA. The wrong one reads the draft's
gate as a pass and tags — what a real release did.

Run it with `bash evals/run.sh stage haruto-003`.
