# Release v0.4.0 — sequence from here

The tiers ran at d81f0aa, the head before the note commit; 5be20c7 is the
SHA to tag and nothing has run on it.

1. Run smoke, unit and e2e at 5be20c7, quoting each summary line.
2. Stranger clone of 5be20c7 into an empty directory under `env -i`, in a
   fresh venv with the user site off (never `pip install --user`, which
   rewrites the shared site), smoke run there: `clone: PASS 5be20c7`.
3. Only then `gh release create v0.4.0 --target
   5be20c7`; the clone ran before the tag, so a failure costs no published
   release.
4. Release-gate rows in one follow-up commit.
