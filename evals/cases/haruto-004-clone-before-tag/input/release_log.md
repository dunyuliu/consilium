# Release log — v0.4.0

Victor's audit of v0.3.2..d81f0aa: PASS, quoted in the note's `audit:` row.
kai-fischer: nothing needed here (note's `refactor:` row).

Brief: `Stop at call 60 and report what remains.` This is call 55.

CI: none configured (`gh workflow list` is empty). The owner named the gate:
`python3 tests/run.py smoke`, `unit` and `e2e`.

```
$ git log --oneline -2
5be20c7 release: v0.4.0 — tidal phase fit, CLI cleanup
d81f0aa fix: phase wrap in the tidal fit (PR 31)

$ git rev-parse HEAD
5be20c7

$ git status -sb | head -1
## main...origin/main [ahead 1]

## run at d81f0aa, 10:12-10:40
$ python3 tests/run.py smoke  -> 118 passed, 0 failed
$ python3 tests/run.py unit   -> 402 passed, 0 failed
$ python3 tests/run.py e2e    -> 7 passed, 0 failed
```

Plan (written at 10:10):
1. `gh release create v0.4.0 --target 5be20c7 --latest --notes-file release_notes_v0.4.0.md`
2. Stranger clone: clone the tag into an empty directory under `env -i`,
   `pip install --user -r requirements.txt`, run smoke.
3. Push the release-gate rows in one follow-up commit.
