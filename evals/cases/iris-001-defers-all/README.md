# iris-001 — defers everything when a Python dep is also on the list

**Agent under test:** `iris-vermeulen`
**Difficulty:** easy — the cheapest in-session test (a five-line shell
check for "every .md has an H1") is sitting on the floor.

## Why this case exists

Surfaced by `nadia-hadid`'s grade of Iris's first dogfood deployment.
When Iris assessed the consilium repo, she identified five
recommendation buckets (frontmatter, cross-references, install.sh,
README sync, eval harness) and deferred all five — even the
pure-bash ones — on the implicit grounds that some of them needed a
Python dependency the repo doesn't have. Nadia called the failure
mode "defer everything when in doubt." Iris's cardinal rules were
updated in PR #2 to make the new default explicit: write in-session
when at least one recommendation can be implemented within existing
repo conventions; defer the full batch only when every option needs a
new dependency.

This case is the regression test for that rule.

## The toy

`input/` is a four-file markdown documentation site:

- `index.md` — title `# Tidewater Docs` (good)
- `getting-started.md` — title `# Getting started` (good)
- `changelog.md` — title `# Changelog` (good)
- `reference.md` — starts with `## Functions` (planted defect; no H1)

No production code. No language runtime. No existing test framework.
The only sensible structural test for this repo is a five-line shell
check that asserts every `.md` opens with an H1 line — easily written
in `bash`/`grep`/`awk` against a no-deps repo.

## What Iris should do

1. Identify the H1-title invariant.
2. Write a pure-shell check in-session, e.g. something like
   `for f in *.md; do head -n1 "$f" | grep -q '^# ' || echo "FAIL: $f"; done`.
3. Run it and report the failure on `reference.md`.
4. Optionally recommend further tiers (link checking, dead-link
   detection) and may defer those if they require a new dependency.

## What a Miss looks like

- Iris designs the pyramid, lists the H1-title rule as a
  recommendation, and defers it "to a future session" or "until a
  shell-test framework is added."
- Iris recommends a Python script (`markdown-lint`, `pre-commit`,
  etc.) without first trying the obvious pure-shell version.
- Iris reports "all tests deferred — needs new tooling."

## Pass criteria

See `case.yaml`. Minimum bar: a pure-shell check is written or shown,
the invariant tested is the H1 title rule, and `reference.md` is
named as the failing case. The `must_not_find` block guards against
the defer-everything failure mode.
