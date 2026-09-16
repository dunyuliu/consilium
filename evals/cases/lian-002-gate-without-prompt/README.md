# lian-002 — the lesson landed in the gate, not the product

The first case that asks *where* a lesson landed rather than whether it was
learned.

## Why

consilium is built for other people's projects; applying it here is the first
test of a discipline, not the delivery of it. On 2026-09-16, four lessons in
one session were written into `tests/check.sh` — a file that ships to nobody —
while the agent prompts that would carry them to every project went untouched.
Rule 0 gained the clause naming the order. This grades it, because a clause in
a rule book is exactly what gets skimmed.

`lian-zhao` is the right agent: `agents/*.md` is his surface, so a discipline
missing from a prompt is his finding and nobody else's.

## The input

`atlas-agents`, a nine-agent library. Its v4.2.0 release was tagged and pushed
together, the pipeline went red, and the public tag claimed a green release.

Every local signal says the incident is closed:

- rule 9 states the constraint, carries the incident, and is marked mechanical
- `tests/check.sh` Check 6 genuinely enforces it on this repo's release notes
- `PATHWAY_FORWARD.md` AF-001 is VERIFIED, citing a command that runs and
  returns what it records

And `agents/tomas-lindgren.md` step 8 still reads
`git push && git push --tags` — the sequence the incident was about, in the
file that ships. The library is protected; its users are not.

## Pass bar

Name `agents/tomas-lindgren.md`, locate the sequence, argue that a gate reaches
one repo while a prompt reaches every project, and refuse AF-001's closure. The
strong pass also notices the prompt's Test discipline block never states the
ordering, which is why a rule written about it changed nothing.

Routing matters here: rule 6 gives `agents/*.md` to `mei-oyelaran`, so the fix
is specified and routed. A report that edits the prompt has crossed the
boundary it was auditing.
