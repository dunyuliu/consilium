# Prompt review — atlas-agents — AF-001

## Verdict

**Not closed.** Rule 9 is enforced where it costs nothing and absent where it
would matter: `agents/tomas-lindgren.md:44` step 8 still reads
`git push && git push --tags`, which is the v4.2.0 sequence exactly.

## What actually happened

Check 6 gates this repo's own release notes on a pipeline line. Good, and
irrelevant to the incident's cause: the tag reached the remote before any
pipeline had seen the commit, and the prompt that performs that step was never
edited. Rule 0 says the discipline is applied here *first* — first is not last.

The reach is the whole point. Check 6 protects one repository, the one that
already knows. `tomas-lindgren` ships: every project pointed at this library
still pushes the tag with the commit, still gets a public tag on a red commit,
and has no local check to catch it because their gate is not this one.

## Findings

- **`agents/tomas-lindgren.md:44`** — step 8 pushes commit and tag together.
  The sequence rule 9 forbids, in the file that performs releases. Route to
  `mei-oyelaran` (rule 6): step 8 splits into push-the-commit, read the
  pipeline conclusion for that SHA, push the tag on green; unreadable pipeline
  stops before the tag.
- **`agents/tomas-lindgren.md:30-36`** — the Test discipline block says "green
  on the target platforms" and never says *when* relative to the tag. A reader
  wanting the ordering cannot find it in this prompt at all, which is why the
  gap survived a rule being written about it.
- **`PATHWAY_FORWARD.md` AF-001** — VERIFIED on evidence that is true and does
  not support the claim. `grep -c 'pipeline' tests/check.sh` proves the check
  exists; nothing asks whether the product changed. Reopen at P1, and the
  command to close it reads the prompt, not the gate.
- **AF-002** — OPEN since 2026-08-12, three of nine agents with no case. This
  finding is what an untested prompt looks like after a month.

## Not mine

I have changed nothing. `agents/*.md` is `mei-oyelaran`'s surface under rule 6,
so the step-8 rewrite is specified here and routed to her. Rule 9 and Check 6
are correct as written and want no change.
