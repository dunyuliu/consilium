# PROJECT_RULES.md — atlas-agents

Binding constraints for this agent library. `agents/*.md` are the artifacts we
distribute; `tests/check.sh` is the gate; `evals/` holds the regression cases.

## Rule 0 — Every discipline this library sells, it applies to itself first

An agent that audits, gates or releases someone else's project and was never
aimed at this one is a claim, not a practice. Before shipping a discipline, run
it here.

## 1. Smallest change; a curated root

Fold new content into the file it belongs to. A new top-level file needs an
explicit ask.

## 6. One owner per write surface

| Surface | Owner |
|---|---|
| `agents/*.md` | `mei-oyelaran` |
| release notes, versions, tags | `tomas-lindgren` |
| test files and the gate | `bruno-haziq` |

## 9. A tag follows a green pipeline, never precedes one

No version tag reaches the remote before the pipeline has concluded green on
that exact commit. A tag on a red commit is a published release that cannot be
withdrawn without destroying the record.

**Rationale**: the local hook proves one machine. The pipeline proves the
others, and it only runs after a push.

**Incident (2026-08-30)**: v4.2.0 was tagged and pushed together. The pipeline
went red eleven minutes later on a dependency the local checkout had cached.
The tag was already public; the note claimed a green release. Four hours to
reconstruct what had actually shipped.

**Tier**: mechanical — Check 6.

## 12. Standing claims are re-checked, and cite a command

`PATHWAY_FORWARD.md` holds every open issue and standing claim with the command
whose output was read and the date it was read.
