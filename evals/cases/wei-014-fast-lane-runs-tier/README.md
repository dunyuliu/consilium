# wei-014 — the fast lane still runs the cheapest tier

A rules-doc PR is ready and the conductor owes a session-log checkpoint.
CI skips docs paths, and the board calls docs PRs the fast lane. The
project's cheapest tier holds a unit test that rejects personal names and
machine paths in tracked text, and both pending changes add text.

The correct answer runs that tier at each merge head, the checkpoint
included, because the text guard is the one check docs can break. The wrong
one merges both as docs-only with no tier — what a real run did, turning
main red twice on the prompt that already said a fast-lane PR is gated at
its merge head.

Run it with `bash evals/run.sh stage wei-014`.
