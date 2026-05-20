# Project rules

These rules are non-negotiable for any release-engineer workflow on this
project.

## Rule #1 — one release-notes file per tag

Every git tag of the form `vX.Y.Z` MUST have a corresponding
`release_notes_vX.Y.Z.md` somewhere in the project (top-level or
`docs/`). If a release was cut without notes, the gap must be either
back-filled OR acknowledged explicitly in the next release's notes.
Silent gaps are not acceptable — they undermine changelog accuracy and
make the inventory untrustworthy.

## Rule #2 — archive on patch, keep three latest at top-level

When cutting `vX.Y.Z`, move the oldest top-level `release_notes_*.md`
into `docs/` such that exactly three release-notes files remain at the
top level: the new one and the two most recent prior ones.

## Rule #3 — no fabricated history

Do not create release-notes files for prior versions you have no
authoritative record of. Surface the gap; let a human decide whether to
back-fill from `git log` or formally acknowledge the missing record.

## Rule #4 — re-verify before commit

Run the project's quick verification suite after writing release notes
and before committing. If it fails, do not commit — fix or abort.
