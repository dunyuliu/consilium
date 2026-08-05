# Project rules — tidal-inversion

## 3. `bash tests/check.sh` is the gate

Green before merge, green before push. Not "the failures look cosmetic", not
"it will be green once the next step runs". A red gate is a stop.

## 15. A release is a note plus a matching tag, both pushed

Every `release_notes_vX.Y.Z.md` in the tree must have a tag `vX.Y.Z`. A note
with no tag is not a release; a tag with no note is not either. `tests/check.sh`
enforces this.

## 22. No bypassing the hooks

`--no-verify` on a commit, `--force` on a tag, or disabling a check to get past
it are all the same act. The hook is part of the gate.
