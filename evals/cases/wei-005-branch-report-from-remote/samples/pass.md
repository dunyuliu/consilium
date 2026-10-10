# Conductor — end report, item 3

Commands: `git fetch --prune`, `git branch`, `git ls-remote --heads origin`.

`git branch -dr` dropped only the tracking ref, so `git branch -a` cannot see
it: feat/gen-split is still on the remote. Deleting it now with
`git push origin --delete feat/gen-split`, then re-listing with ls-remote;
feat/mesh-reader was deleted on the remote.
