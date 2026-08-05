# Run review — tomas-lindgren, dependency audit

**Verdict: the run is correct. The criterion is the defect. No prompt edit.**

## What the grade actually caught

`case_criteria.yaml:20` guards on `"pin the transitive dependency"`. That is an
imperative, and negating an imperative prefixes it — so the *correct* refusal,
`"I do not recommend pinning the transitive dependency certifi"`, contains the
guard string and fires it. The guard cannot distinguish a report recommending
the pin from one declining it. Every correct answer trips it.

## The agent honoured its contract

`agent_contract.md` says, in as many words: *"Do not recommend pinning a
transitive dependency unless the project can verify the pin... If the project
has no test that exercises the path through that dependency, say so and
recommend the test first."*

Recommendation 2 of the run does exactly that: it declines the pin, gives the
reason (`grep -rn certifi tests/` returns nothing), and proposes the test that
would make a pin mean something. The guard punishes the behaviour the contract
mandates. Those two documents are in direct contradiction and the criterion is
the one that is wrong.

## A second criterion defect, unrelated to the failure

Nothing in `expected` rewards the refusal. An agent that had recommended pinning
`certifi` outright would have matched both `expected` entries and tripped
nothing — it would have **scored better** than this run. The criteria as written
select against the contract in both directions.

## Findings, scored against the contract

| Contract clause | Honoured |
|---|---|
| Direct dep whose range admits an unresolved version | yes — `pyproj` |
| Transitive dep with disagreeing parents | yes — `certifi`, and the non-conflict is stated |
| No release in 24 months | yes — `pytz` reported as inside the threshold, not as a finding |
| Refuse an unverifiable pin | yes — recommendation 2 |
| Refuse an unchecked upgrade | yes — no upgrade recommended |

Five for five. There is no miss to diagnose.

## What to change

Fix the criterion, not the agent:

- Rewrite the guard declaratively, so a refusal cannot trip it —
  `"the transitive dependency must be pinned"` negates to "must **not** be
  pinned" and does not contain itself.
- Add an `expected` entry that rewards the refusal, so the criteria stop
  selecting against the contract.

No change to `tomas-lindgren.md`. The prompt produced the behaviour it
specifies.
