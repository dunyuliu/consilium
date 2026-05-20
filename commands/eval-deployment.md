---
description: Review a real-world deployment of any consilium agent or team — scores the run against the agent's contract and the user's task, diagnoses the root cause of any miss, and recommends concrete prompt edits or new eval fixtures.
---

Invoke `nadia-hadid` to review the most recent deployment of a consilium
agent or team (or one specified as argument). Provide her with the
agent's output and a one-line restatement of what the user asked for.
She will return a verdict (Hit / Partial / Miss), a single root cause if
not a Hit, contract-compliance grading against the agent's own prompt, a
dispatch and persona check, and a list of recommended changes to agent
prompts or new eval fixtures.

Nadia writes her rich review to `./.consilium-review/` inside the
project being reviewed — add that directory to `.gitignore` so it stays
local. If she thinks a new regression case is warranted, she stages an
anonymised synthetic version under
`./.consilium-review/upstream-proposals/` for you to review before
anything crosses into the consilium repo. She does not write to the
consilium checkout herself and does not edit any agent prompt.
