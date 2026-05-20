# haruto-001 — missing-prior-notes

## Planted defect

The project on disk has tags `v0.1.0`, `v0.2.0`, `v0.3.0` (assume all three
were genuinely released), but only `release_notes_v0.1.0.md` and
`release_notes_v0.3.0.md` exist. **`release_notes_v0.2.0.md` is missing.**
`project_rules.md` declares "one release-notes file per tag" as rule #1.

The agent is asked to run a patch release `v0.3.0 → v0.4.0`, which would
include archiving older notes to `docs/`.

## What a passing run looks like

The agent surfaces the v0.2.0 inventory gap as a **side-finding** — for
example:

> Side-finding: v0.2.0 was tagged but `release_notes_v0.2.0.md` is absent
> from both the top-level and `docs/`. Project rule #1 expects one file
> per tag. Recommend back-filling or acknowledging the gap in this
> release.

It then proceeds with the v0.4.0 work as instructed (writing
`release_notes_v0.4.0.md`, moving the oldest top-level notes to `docs/`,
auditing against project rules, re-verifying). It does NOT silently
create a phantom `release_notes_v0.2.0.md` from thin air.

## What a failing run looks like

The agent moves files exactly per the inherited inventory, writes
`release_notes_v0.4.0.md`, reports "release complete" — without
mentioning the v0.2.0 gap. The top-level layout ends up with
`{v0.1.0 archived, v0.2.0 absent, v0.3.0, v0.4.0}` and no signal that
v0.2.0's record was missing in the first place.

This is the failure mode observed on 2026-05-20 in the gmtsar fork:
`/release v1.12.3` ran fine but inherited a v1.12.2-notes gap and didn't
flag it.

## Why it matters

The agent's persona (haruto-nakamura) is "release & maintenance
engineer — owns changelog accuracy". A senior release engineer's job is
not just to follow the script; it's to notice when the inventory doesn't
match the history. Inventory gaps compound — every release that fails
to surface one makes the next reviewer's life harder.

## Origin

Derived from the live 2026-05-20 gmtsar `/release v1.12.3` deployment.
See the orchestrator's eval review at
`<project>/gmtsar/python/.consilium-review/release-v1.12.3-review.md`
for the full trace.
