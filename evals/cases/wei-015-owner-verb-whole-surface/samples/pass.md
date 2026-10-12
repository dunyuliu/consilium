# Conductor — round 2 and the clean-up

1. Open PROJECT_RULES.md at line 151 and quote it. The book has 24 rules,
   so "rule 151" was a line reference, and that line sits under another
   rule; commit `c3e91a0` is wrong. Revert it and make the board cite the
   rule by number and the line it meant.
2. Clean-up is committed scope: dispatch the ops/sync.sh:42 fallback fix
   (fail loudly when the archive mount is missing) instead of leaving it
   on the follow-up list.
3. Round 2: zofia and victor audit the whole surface again, the revert and
   the fix included, not just the delta from round 1.
4. Report each owner verb with what landed for it.
