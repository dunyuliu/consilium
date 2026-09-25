# Lessons ledger

Every lesson another project filed in `inbox/`, and what happened to it. The
inbox itself is local and emptied by triage; this file is the record.

Triage appends one row per lesson. **landed** names the commit; **dismissed**
says why in a few words; **deferred** means one project reported it and it did
not earn a line under the size budget. A deferred row is re-triaged when a
second project reports the same thing. Keep rows to one line; the detail is in
the commit.

| date | project | lesson | agent | outcome |
|---|---|---|---|---|
| 09-24 | ai-dataset | verification agent triggered by the act of claiming | project agent | dismissed: project-local agent |
| 09-24 | ai-dataset | header mapper invoked before narrowing scope | project agent | dismissed: project-local agent |
| 09-24 | ai-dataset | re-check field never filled in the producing session | main agent | dismissed: covered, board blank-date rule |
| 09-24 | ai-dataset | audit a verdict document before committing it | main agent | dismissed: no consilium agent involved |
| 09-24 | cyclegns | never park a turn on an untracked background job | wei-lin | landed f1e7fa8 |
| 09-24 | cyclegns | parent SendMessage is not injection | wei-lin | landed f1e7fa8 |
| 09-24 | cyclegns | cap BLAS/OpenMP threads on shared nodes | wei-lin | landed f1e7fa8 |
| 09-24 | cyclegns | diagnosis is a hypothesis until independently reproduced | wei-lin | dismissed: covered, gate axis 3 |
| 09-24 | cyclegns | training target and reported metric name one ground truth | lars, victor | deferred |
| 09-24 | cyclegns | rollout step-0 input equals training input | project agent | dismissed: project-local agent |
| 09-24 | cyclegns | /audit writes AUDIT.md to the root | /audit | landed f1e7fa8 |
| 09-24 | cyclegns | per-landing tag skipped version line and note | /autopilot | landed f1e7fa8 (tags per milestone only) |
| 09-24 | dr4gm | inspect input field before blaming a threshold | lars | landed f1e7fa8 |
| 09-24 | dr4gm | anomaly the brief explains is acknowledged, not a finding | victor | landed f1e7fa8 |
| 09-24 | dr4gm | brief typo vs agreeing code is informational | victor | landed f1e7fa8 |
| 09-24 | dr4gm | AUDIT.md written into a parent workspace | /audit | landed f1e7fa8 |
| 09-24 | dr4gm | lead with "no reachable defects" on a clean audit | lars | landed f1e7fa8 |
| 09-24 | dynamo_gns | metric target needs an oracle row before freezing | zofia | landed f1e7fa8 |
| 09-24 | dynamo_gns | board read from the rule book; relayed instruction | /autopilot, wei-lin | landed f1e7fa8 |
| 09-24 | dynamo_gns | pgrep -f busy-check matched its own waiter | wei-lin | deferred |
| 09-24 | ecsvf | destructive-incident norm ships a mechanical proxy | zofia | landed f1e7fa8 |
| 09-24 | ecsvf | starter 6 covers every result cited outside the repo | zofia | landed f1e7fa8 |
| 09-24 | ecsvf | board records partial resolution in its own column | zofia | landed f1e7fa8 |
| 09-24 | ecsvf | relative-diff denominator floored at physical scale | mira | landed f1e7fa8 |
| 09-24 | eqdyna | dispatch only real workload | wei-lin | landed d207420 |
| 09-24 | eqdyna | /autopilot ceremony per milestone, not per landing | /autopilot | landed f1e7fa8 |
| 09-24 | eqdyna | poll the CI run list, not one SHA | wei-lin | landed d207420 |
| 09-24 | eqdyna | returning branches are stale; rebase, serial PRs | wei-lin | landed d207420 |
| 09-24 | eqdyna | gate every backend and variant touched | wei-lin | landed d207420 |
| 09-24 | eqdyna | freed scarce resource goes to the item needing it | wei-lin | landed d207420 |
| 09-24 | eqdyna | mechanism claim needs a control experiment | wei-lin | landed d207420 |
| 09-24 | eqdyna | cap concurrency, commit WIP at checkpoints | wei-lin | landed d207420 |
| 09-24 | eqdyna | name both sides of a brief-vs-rule conflict | wei-lin | landed d207420 |
| 09-24 | eqdyna | release preflight: Release before tag push | haruto | dismissed: conflicts with haruto step 12a |
| 09-24 | eqdyna | pre-tag gate reads every workflow for the SHA | haruto | landed f1e7fa8, corrected 09a28ed |
| 09-24 | eqdyna | guard per-job CI wall time | haruto | deferred |
| 09-24 | eqdyna | classify audit findings by threat model | victor | landed f1e7fa8 |
| 09-24 | eqdyna | grep the board before opening a row; compress closed rows | zofia | landed f1e7fa8 |
| 09-24 | eqdyna | branch off origin, not the local ref | zofia | dismissed: covered, rebase onto current main |
| 09-24 | eqdyna | CI checks only what the local gate cannot | wei-lin | deferred |
| 09-24 | eqdyna | docs never quote a derived count | zofia | landed 0730dcf |
| 09-24 | eqdyna | report token spend; stop dispatching near the limit | wei-lin | landed 0730dcf |
| 09-24 | eqdyna | a guard's failure path lives in the code under test | lars | dismissed: project-specific |
| 09-24 | eqdyna | board commands must be able to change colour | zofia | landed 09a28ed |
| 09-24 | eqdyna | stamp compiled binaries with a source hash | haruto | deferred |
| 09-24 | eqdyna | tee wrapper keeps draining after a write error | all | dismissed: project code |
| 09-24 | eqdyna | tag-triggered workflows read after the tag push | haruto | landed 09a28ed |
| 09-24 | eqdyna | gate every output a consumer reads | iris | landed c8b1c4d |
| 09-24 | eqdyna | per-case conventions, never one global constant | lars | landed c8b1c4d |
| 09-24 | eqdyna | every written file carries data | iris | landed c8b1c4d |
| 09-24 | eqdyna | tolerance gate must fail on NaN | iris | landed 3b75087 |
| 09-24 | eqdyna | salvage a dead agent's worktree diff | wei-lin | dismissed: covered, close-milestone step |
| 09-24 | eqdyna | serialize HDF5 opens in threaded harnesses | all | deferred |
| 09-24 | eqquasi | audit the first diff; self-verify small fixes | wei-lin | landed f1e7fa8 |
| 09-24 | eqquasi | recipe block states a fresh-shell acceptance test | victor | landed f1e7fa8 |
| 09-24 | eqquasi | cleanup re-runs its KEEP test on the staged set | wei-lin | deferred |
| 09-24 | eqquasi | parent message is the owner's channel | wei-lin | landed f1e7fa8 |
| 09-24 | eqquasi | at most one or two specialists at once | /autopilot | landed f1e7fa8 |
| 09-24 | eqquasi | do unblocked work before idling on a gate | wei-lin | landed f1e7fa8 |
| 09-24 | eqquasi | version bump rides in the feature PR | wei-lin | landed f1e7fa8 |
| 09-24 | eqquasi | specialist runs the fast suite before handing back | haruto | dismissed: covered, gate axis 3 |
| 09-24 | eqquasi | scaling sweep asserts time falls with ranks | wei-lin | deferred |
| 09-24 | eqquasi | audit citing a gate states its cost | victor | landed f1e7fa8 |
| 09-24 | eqquasi | /autopilot reads the project's merge policy | /autopilot | landed f1e7fa8 |
| 09-24 | eqquasi | session logs in the gitignored scratch area | wei-lin | dismissed: project convention |
| 09-24 | eqquasi | open the PR first; gates run alongside | wei-lin | landed a7bae87 |
| 09-24 | eqquasi | recycle the conductor at each milestone | /autopilot | landed a7bae87 |
| 09-24 | eqquasi | board edits inline, not dispatched to zofia | wei-lin | open: conflicts with rule 19, maintainer's call |
| 09-24 | eqquasi | no MPI runtime daemon survives a kill | wei-lin | landed a7bae87 |
| 09-24 | eqquasi | iterative-solver timing from full-cycle runs | wei-lin | deferred |
| 09-24 | gmtsar | grep the reference for sibling definitions | mira | landed f1e7fa8 |
| 09-24 | gmtsar | reference defects get an upstream issue or deferral | mira | landed f1e7fa8 |
| 09-24 | gmtsar | record reference SHA per ported file | mira | landed f1e7fa8 |
| 09-24 | gmtsar | release body mangled into mojibake | haruto | landed f1e7fa8 |
| 09-24 | gmtsar | estimate and log dispatch token cost | wei-lin | landed 0730dcf |
| 09-24 | gmtsar | dunyu-liu used for abstract prose | dunyu-liu | dismissed: description already scoped to numerics |
| 09-24 | gmtsar | HTTP 200 does not prove a link is live | ziyan | deferred |
| 09-24 | mercury | subagent notices may never reach the conductor | wei-lin | landed f1e7fa8 |
| 09-24 | mercury | local gate when there is no remote or CI | /autopilot | landed f1e7fa8 |
| 09-24 | mercury | per-milestone checklist with NOT RUN | wei-lin | landed f1e7fa8 |
| 09-24 | mercury | apply a violated criterion to the oracle first | victor | landed f1e7fa8 |
| 09-24 | mercury | direction claims verified by a before/after run | lars | landed f1e7fa8 |
| 09-24 | mercury | the gate is the last command before commit | wei-lin | landed f1e7fa8 |
| 09-24 | mercury | "20 passed, 3 skipped" is not green | wei-lin | dismissed: covered, gate axis 1 |
| 09-24 | mercury | never rm -rf in a worktree | wei-lin | landed f1e7fa8 |
| 09-24 | mercury | chain filtering is not the constrained posterior | dunyu-liu | deferred |
| 09-24 | mercury | stop after a 403 or CAPTCHA | all | deferred |
| 09-24 | mercury | commit after each fix item passes | wei-lin | landed d207420 |
| 09-24 | mfe-gf | undefined-name check; run changed entry points | lars | landed f1e7fa8 |
| 09-24 | mfe-gf | ask about missing CI before the audit | haruto | landed f1e7fa8 |
| 09-24 | mfe-gf | ask the version question up front | haruto | landed f1e7fa8 |
| 09-24 | mfe-gf | brief carries state, never the agent's rules | /autopilot | landed d66d9a2 |
| 09-24 | vegrav | fan-out exhausts the shared rate limit | /autopilot | landed f1e7fa8 |
| 09-24 | vegrav | convergence order per consecutive triple | dunyu-liu | deferred |
| 09-24 | vegrav | shared setting gets one check per implementation | zofia | landed f1e7fa8 |
| 09-24 | vegrav | never modify the main checkout's tree | wei-lin | landed f1e7fa8 |
| 09-24 | vegrav | untracked files are invisible in worktrees | wei-lin | landed f1e7fa8 |
| 09-24 | vegrav | reap every worktree | wei-lin | dismissed: covered, close-milestone step |
| 09-24 | vegrav | timeout on each specialist dispatch | haruto, wei-lin | deferred |
| 09-24 | vegrav | /loop keeps firing after its campaign ends | /loop | dismissed: Claude Code, not consilium |
| 09-24 | vegrav | watchdog compares against frozen literals | /autopilot | dismissed: not consilium's text |
| 09-24 | vegrav | commit messages via a file, quoted heredocs | all | deferred |
| 09-24 | eqdyna | invoking session writes nothing while wei-lin runs | /autopilot | landed (this PR) |
| 09-24 | eqdyna | mission notes never committed at the root | wei-lin, zofia | landed (this PR) |
| 09-24 | eqdyna | tolerance from measured spread incl. CI, absolute floor | iris | landed (this PR) |
| 09-24 | eqdyna | one oracle independent of self-reference | iris | landed (this PR) |
| 09-24 | eqdyna | threshold = next power of ten above margin x worst | iris | landed (this PR) |
| 09-24 | eqdyna | pre-written constraints re-checked, not relayed | /autopilot | landed (this PR); vegrav watchdog row now covered |
| 09-24 | eqdyna | verify by filtering the full record, not a tail | /autopilot | landed (this PR) |
| 09-24 | eqdyna | board guard asserts column count | zofia | landed (this PR) |
| 09-24 | eqquasi | a tag is not a Release; --latest and gh release view | haruto | landed (this PR) |
