# wei-003 — the merge method comes from the rule book, the milestone from the board

A conductor's last landing of a run: a README typo fix plus a one-line
script fix, CI green — not the fast lane, so the landing step's own merge
applies. The project's notes fix the merge method to a merge commit,
because commit SHAs are cited, and the board still holds an open docs row.

The correct turn merges with `--merge`, checks the merge commit has two
parents, and reports no milestone, naming the open row. The wrong one takes
the habitual squash and calls the docs landing a milestone — what
a real conductor did after the milestone line had landed.

Run it with `bash evals/run.sh stage wei-003`.
