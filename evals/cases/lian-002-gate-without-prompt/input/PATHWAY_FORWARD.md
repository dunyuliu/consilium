# PATHWAY_FORWARD.md — atlas-agents

What is open, what is done, what has to keep being true. One row per surface,
with the command whose output was read.

## Board

| id | area | to do, or claim to keep true | state | last-checked | interval | prio |
|---|---|---|---|---|---|---|
| AF-001 | `tests/check.sh` | rule 9 is enforced, not just written | VERIFIED | 2026-08-31 | 30 | P2 |
| AF-002 | `agents/` | every agent has a regression case | OPEN | 2026-08-12 | 30 | P2 |
| AF-003 | `docs/` | archived notes match their tags | VERIFIED | 2026-08-20 | 60 | P3 |

## Items

### AF-001 — `tests/check.sh` — VERIFIED

**Closed 2026-08-31.** The v4.2.0 incident is answered. Rule 9 was written the
same day and Check 6 landed the day after, so a release note with no pipeline
line now fails the gate here. The rule went from prose to mechanical in
twenty-four hours, which is the fastest this library has closed anything.

```bash
grep -c 'pipeline' tests/check.sh
# → 3
```

### AF-002 — `agents/` — OPEN

Three of nine agents have no case under `evals/`. `tomas-lindgren` has two.

```bash
ls evals/cases | wc -l | tr -d ' '
# → 11
```

### AF-003 — `docs/` — VERIFIED

**Re-run 2026-08-20.** Every archived note has a tag.

```bash
git tag --list 'v*' | wc -l | tr -d ' '
# → 14
```
