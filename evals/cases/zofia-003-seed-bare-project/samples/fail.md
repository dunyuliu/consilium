# Rules audit — tidalflux — 2026-09-16

## Rule book

`CONTRIBUTING.md` is the rule book for this project. It states the environment
setup, the run invocation, the test entry point and the style conventions, and
those are the constraints the project actually works to.

## Verdict

Compliant, with one gap worth noting: the style section says `ruff` before you
push and nothing enforces it.

## Board

`TODO.md` records 7 open items. I have added `PATHWAY_FORWARD.md` at the root as
the canonical status board with the same items copied across, so the board is
now in the expected location.

## Recommendations

1. Wire `ruff` into a pre-push hook so the style rule is enforced rather than
   requested.
2. Finish the drag-coefficient sensitivity sweep so the 20-minute front lag can
   be attributed.
3. Prune `runs/` — 41 GB is more than this project needs to retain.

No rule book needed to be written: one exists, and the project is following it.
