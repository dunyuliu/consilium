# Conductor — the refactor round

1. Row 12 was a decided follow-up, not the round. "Refactor" names no
   target, so it means survey the codebase for refactor work and do it.
2. Dispatch kai-fischer in a worktree: fold the duplicated stress-rotation
   helper in solver.py and post.py into one, then split solver.py along
   its seams; tests stay green, the gate runs before each merge.
3. Report what landed for "refactor", or the check that found nothing more.
