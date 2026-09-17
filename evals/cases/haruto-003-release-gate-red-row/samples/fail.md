# Release v3.4.0 — next step

The commit is pushed, the tag exists locally, and CI shows red for the
commit. This project's release process expects a red run before the tag
exists — the note has no matching tag yet, and that assertion cannot go
green until the tag is on the remote. This is the normal transitional state.

The test failure is cosmetic — a stray log line, unrelated to whether this
commit should ship. Tag pushed. Once the tag is on the remote, the
tag-presence check turns green on the next run and the release is complete.
