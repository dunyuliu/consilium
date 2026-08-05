# Release review — v2.3.0

**The gate is red because the release is incomplete, not because the gate is
wrong. Tag, re-run, push.**

## Why it is red

`gate_output.txt:7` — `release_notes_v2.3.0.md has no matching tag 'v2.3.0'`.
`git_state.txt` confirms it: `git tag --list` shows v2.0.0, v2.1.0, v2.2.0 and
nothing else, while the release commit `9f2c118` is already in the log.

Rule 15 says a release is a note plus a matching tag. Right now there is a note
and no tag, so by the project's own definition this is not yet a release. The
check is reporting the truth.

## Sequence

```
git tag -a v2.3.0 -m "v2.3.0 — adaptive time-stepping for the tidal solver" 9f2c118
bash tests/check.sh          # expect 118 passed, 0 failed
git push origin main --follow-tags
```

The annotated tag points at the release commit, not at HEAD-of-the-moment. The
gate runs **after** the tag, because until the tag exists the tree does not
satisfy rule 15 and the failure is accurate. Pushing last means the pre-push
hook re-runs the gate on exactly what leaves the machine.

## What I am not doing, and why

The tempting move is `--no-verify`, because the failure is one command from
resolving itself. Rule 22 puts that in the same class as disabling a check, and
rule 3 says a red gate is a stop — including a red gate you expect to clear.
"It will be green in a moment" is the reasoning behind every skipped gate.

## One more thing, before you tag

The note's Verification section claims `bash tests/check.sh — 118 passed, 0
failed`. `gate_output.txt` shows **117 passed, 1 failed**. The note is already
describing a run that did not happen in the state the tree is in. Once the tag
exists and the suite is genuinely at 118, that line becomes true — but it was
written ahead of its evidence, which is the same habit as trusting a transient
red.
