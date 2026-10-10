# Lessons ledger

Every lesson another project filed in `inbox/`, and what happened to it. The
inbox itself is local and emptied by triage; this file is the record. Projects
appear only as aliases (P01…); the alias map stays local, never in this repo.

Triage appends one row per lesson. **landed** names the commit; **dismissed**
says why in a few words; **deferred** means one project reported it and it did
not earn a line under the size budget. A deferred row is re-triaged when a
second project reports the same thing. Keep rows to one line; the detail is in
the commit.

| date | project | lesson | agent | outcome |
|---|---|---|---|---|
| 09-24 | P01 | never park a turn on an untracked background job | wei-lin | landed f1e7fa8 |
| 09-24 | P01 | parent SendMessage is not injection | wei-lin | landed f1e7fa8 |
| 09-24 | P01 | cap BLAS/OpenMP threads on shared nodes | wei-lin | landed f1e7fa8 |
| 09-24 | P01 | diagnosis is a hypothesis until independently reproduced | wei-lin | dismissed: covered, gate axis 3 |
| 09-24 | P01 | training target and reported metric name one ground truth | lars, victor | deferred |
| 09-24 | P01 | rollout step-0 input equals training input | project agent | dismissed: project-local agent |
| 09-24 | P01 | /audit writes AUDIT.md to the root | /audit | landed f1e7fa8 |
| 09-24 | P01 | per-landing tag skipped version line and note | /autopilot | landed f1e7fa8 (tags per milestone only) |
| 09-24 | P02 | inspect input field before blaming a threshold | lars | landed f1e7fa8 |
| 09-24 | P02 | anomaly the brief explains is acknowledged, not a finding | victor | landed f1e7fa8 |
| 09-24 | P02 | brief typo vs agreeing code is informational | victor | landed f1e7fa8 |
| 09-24 | P02 | AUDIT.md written into a parent workspace | /audit | landed f1e7fa8 |
| 09-24 | P02 | lead with "no reachable defects" on a clean audit | lars | landed f1e7fa8 |
| 09-24 | P03 | metric target needs an oracle row before freezing | zofia | landed f1e7fa8 |
| 09-24 | P03 | board read from the rule book; relayed instruction | /autopilot, wei-lin | landed f1e7fa8 |
| 09-24 | P03 | pgrep -f busy-check matched its own waiter | wei-lin | deferred |
| 09-24 | P04 | destructive-incident norm ships a mechanical proxy | zofia | landed f1e7fa8 |
| 09-24 | P04 | starter 6 covers every result cited outside the repo | zofia | landed f1e7fa8 |
| 09-24 | P04 | board records partial resolution in its own column | zofia | landed f1e7fa8 |
| 09-24 | P04 | relative-diff denominator floored at physical scale | mira | landed f1e7fa8 |
| 09-24 | P05 | dispatch only real workload | wei-lin | landed d207420 |
| 09-24 | P05 | /autopilot ceremony per milestone, not per landing | /autopilot | landed f1e7fa8 |
| 09-24 | P05 | poll the CI run list, not one SHA | wei-lin | landed d207420 |
| 09-24 | P05 | returning branches are stale; rebase, serial PRs | wei-lin | landed d207420 |
| 09-24 | P05 | gate every backend and variant touched | wei-lin | landed d207420 |
| 09-24 | P05 | freed scarce resource goes to the item needing it | wei-lin | landed d207420 |
| 09-24 | P05 | mechanism claim needs a control experiment | wei-lin | landed d207420 |
| 09-24 | P05 | cap concurrency, commit WIP at checkpoints | wei-lin | landed d207420 |
| 09-24 | P05 | name both sides of a brief-vs-rule conflict | wei-lin | landed d207420 |
| 09-24 | P05 | release preflight: Release before tag push | haruto | dismissed: conflicts with haruto step 12a |
| 09-24 | P05 | pre-tag gate reads every workflow for the SHA | haruto | landed f1e7fa8, corrected 09a28ed |
| 09-24 | P05 | guard per-job CI wall time | haruto | deferred |
| 09-24 | P05 | classify audit findings by threat model | victor | landed f1e7fa8 |
| 09-24 | P05 | grep the board before opening a row; compress closed rows | zofia | landed f1e7fa8 |
| 09-24 | P05 | branch off origin, not the local ref | zofia | dismissed: covered, rebase onto current main |
| 09-24 | P05 | CI checks only what the local gate cannot | wei-lin | deferred |
| 09-24 | P05 | docs never quote a derived count | zofia | landed 0730dcf |
| 09-24 | P05 | report token spend; stop dispatching near the limit | wei-lin | landed 0730dcf |
| 09-24 | P05 | a guard's failure path lives in the code under test | lars | dismissed: project-specific |
| 09-24 | P05 | board commands must be able to change colour | zofia | landed 09a28ed |
| 09-24 | P05 | stamp compiled binaries with a source hash | haruto | deferred |
| 09-24 | P05 | tee wrapper keeps draining after a write error | all | dismissed: project code |
| 09-24 | P05 | tag-triggered workflows read after the tag push | haruto | landed 09a28ed |
| 09-24 | P05 | gate every output a consumer reads | iris | landed c8b1c4d |
| 09-24 | P05 | per-case conventions, never one global constant | lars | landed c8b1c4d |
| 09-24 | P05 | every written file carries data | iris | landed c8b1c4d |
| 09-24 | P05 | tolerance gate must fail on NaN | iris | landed 3b75087 |
| 09-24 | P05 | salvage a dead agent's worktree diff | wei-lin | dismissed: covered, close-milestone step |
| 09-24 | P05 | serialize HDF5 opens in threaded harnesses | all | deferred |
| 09-24 | P06 | audit the first diff; self-verify small fixes | wei-lin | landed f1e7fa8 |
| 09-24 | P06 | recipe block states a fresh-shell acceptance test | victor | landed f1e7fa8 |
| 09-24 | P06 | cleanup re-runs its KEEP test on the staged set | wei-lin | deferred |
| 09-24 | P06 | parent message is the owner's channel | wei-lin | landed f1e7fa8 |
| 09-24 | P06 | at most one or two specialists at once | /autopilot | landed f1e7fa8 |
| 09-24 | P06 | do unblocked work before idling on a gate | wei-lin | landed f1e7fa8 |
| 09-24 | P06 | version bump rides in the feature PR | wei-lin | landed f1e7fa8 |
| 09-24 | P06 | specialist runs the fast suite before handing back | haruto | dismissed: covered, gate axis 3 |
| 09-24 | P06 | scaling sweep asserts time falls with ranks | wei-lin | deferred |
| 09-24 | P06 | audit citing a gate states its cost | victor | landed f1e7fa8 |
| 09-24 | P06 | /autopilot reads the project's merge policy | /autopilot | landed f1e7fa8 |
| 09-24 | P06 | session logs in the gitignored scratch area | wei-lin | dismissed: project convention |
| 09-24 | P06 | open the PR first; gates run alongside | wei-lin | landed a7bae87 |
| 09-24 | P06 | recycle the conductor at each milestone | /autopilot | landed a7bae87 |
| 09-24 | P06 | board edits inline, not dispatched to zofia | wei-lin | open: conflicts with rule 19, maintainer's call |
| 09-24 | P06 | no MPI runtime daemon survives a kill | wei-lin | landed a7bae87 |
| 09-24 | P06 | iterative-solver timing from full-cycle runs | wei-lin | deferred |
| 09-24 | P07 | grep the reference for sibling definitions | mira | landed f1e7fa8 |
| 09-24 | P07 | reference defects get an upstream issue or deferral | mira | landed f1e7fa8 |
| 09-24 | P07 | record reference SHA per ported file | mira | landed f1e7fa8 |
| 09-24 | P07 | release body mangled into mojibake | haruto | landed f1e7fa8 |
| 09-24 | P07 | estimate and log dispatch token cost | wei-lin | landed 0730dcf |
| 09-24 | P07 | dunyu-liu used for abstract prose | dunyu-liu | dismissed: description already scoped to numerics |
| 09-24 | P07 | HTTP 200 does not prove a link is live | ziyan | deferred |
| 09-24 | P08 | subagent notices may never reach the conductor | wei-lin | landed f1e7fa8 |
| 09-24 | P08 | local gate when there is no remote or CI | /autopilot | landed f1e7fa8 |
| 09-24 | P08 | per-milestone checklist with NOT RUN | wei-lin | landed f1e7fa8 |
| 09-24 | P08 | apply a violated criterion to the oracle first | victor | landed f1e7fa8 |
| 09-24 | P08 | direction claims verified by a before/after run | lars | landed f1e7fa8 |
| 09-24 | P08 | the gate is the last command before commit | wei-lin | landed f1e7fa8 |
| 09-24 | P08 | "20 passed, 3 skipped" is not green | wei-lin | dismissed: covered, gate axis 1 |
| 09-24 | P08 | never rm -rf in a worktree | wei-lin | landed f1e7fa8 |
| 09-24 | P08 | chain filtering is not the constrained posterior | dunyu-liu | deferred |
| 09-24 | P08 | stop after a 403 or CAPTCHA | all | deferred |
| 09-24 | P08 | commit after each fix item passes | wei-lin | landed d207420 |
| 09-24 | P09 | undefined-name check; run changed entry points | lars | landed f1e7fa8 |
| 09-24 | P09 | ask about missing CI before the audit | haruto | landed f1e7fa8 |
| 09-24 | P09 | ask the version question up front | haruto | landed f1e7fa8 |
| 09-24 | P09 | brief carries state, never the agent's rules | /autopilot | landed d66d9a2 |
| 09-24 | P10 | fan-out exhausts the shared rate limit | /autopilot | landed f1e7fa8 |
| 09-24 | P10 | convergence order per consecutive triple | dunyu-liu | deferred |
| 09-24 | P10 | shared setting gets one check per implementation | zofia | landed f1e7fa8 |
| 09-24 | P10 | never modify the main checkout's tree | wei-lin | landed f1e7fa8 |
| 09-24 | P10 | untracked files are invisible in worktrees | wei-lin | landed f1e7fa8 |
| 09-24 | P10 | reap every worktree | wei-lin | dismissed: covered, close-milestone step |
| 09-24 | P10 | timeout on each specialist dispatch | haruto, wei-lin | deferred |
| 09-24 | P10 | /loop keeps firing after its campaign ends | /loop | dismissed: Claude Code, not consilium |
| 09-24 | P10 | watchdog compares against frozen literals | /autopilot | dismissed: not consilium's text |
| 09-24 | P10 | commit messages via a file, quoted heredocs | all | deferred |
| 09-24 | P05 | invoking session writes nothing while wei-lin runs | /autopilot | landed (this PR) |
| 09-24 | P05 | mission notes never committed at the root | wei-lin, zofia | landed (this PR) |
| 09-24 | P05 | tolerance from measured spread incl. CI, absolute floor | iris | landed (this PR) |
| 09-24 | P05 | one oracle independent of self-reference | iris | landed (this PR) |
| 09-24 | P05 | threshold = next power of ten above margin x worst | iris | landed (this PR) |
| 09-24 | P05 | pre-written constraints re-checked, not relayed | /autopilot | landed (this PR); P10 watchdog row now covered |
| 09-24 | P05 | verify by filtering the full record, not a tail | /autopilot | landed (this PR) |
| 09-24 | P05 | board guard asserts column count | zofia | landed (this PR) |
| 09-24 | P06 | a tag is not a Release; --latest and gh release view | haruto | landed (this PR) |
| 09-24 | P06 | seeded book states the unattended grant and release sequence | zofia | landed (this PR) |
| 09-25 | P06 | count live agents, refuse a third; lower tier for mechanical; timing runs exclusive | wei-lin | landed (this PR) |
| 09-25 | P06 | git worktree remove deletes ignored run output; check --ignored first | wei-lin | landed (this PR) |
| 09-25 | P06 | worktrees under the gitignored scratch dir | wei-lin | dismissed: rule book sets location; stale line covered by loop rule 2 |
| 09-28 | P05 | evidence names a clean committed SHA: commit, then measure | mira, zofia | landed (this PR) |
| 09-28 | P05 | read the metric definition before asserting a mechanism | wei-lin | landed (this PR), in place |
| 09-29 | P06 | never merge past a hold marker; never freeze a first reference with external validation | wei-lin | landed (this PR) |
| 09-29 | P01 | rollout input built unlike training is a correctness finding | victor | landed (this PR) |
| 09-29 | P01 | compare running normalizer stats against ground truth | lars | deferred |
| 09-29 | P01 | leaf agent briefed to dispatch audits it cannot | /autopilot | deferred |
| 09-29 | P01 | never park on a background process (third time) | wei-lin | landed (this PR) |
| 09-29 | P01 | shared launcher has every flag live configs use | haruto | deferred |
| 09-29 | P03 | "dispatched" needs a live PID and a growing log | wei-lin | landed (this PR) |
| 09-29 | P03 | a stop or kill is terminal; roster of child PIDs | wei-lin | landed (this PR) |
| 09-29 | P03 | flock the model dir at launch | all | deferred |
| 09-29 | P03 | recycle the conductor only on a cheap trigger | /autopilot | landed (this PR) |
| 09-29 | P03 | OMP/MKL threads exported in launch templates | wei-lin | dismissed: covered, thread caps |
| 09-29 | P03 | no signal swallowed as rc=0; check the final step | lars | deferred |
| 09-29 | P03 | discover artifacts by glob, not a schedule | all | deferred |
| 09-29 | P03 | never overwrite untracked reference artifacts | all | deferred |
| 09-29 | P03 | measure the incumbent before co-locating on a GPU | wei-lin | deferred |
| 09-29 | P03 | ratio-to-truth metrics scored two-sided | all | deferred |
| 09-29 | P11 | Critical rests on recomputation, not a doc table | victor | landed (this PR) |
| 09-29 | P11 | state both formulas; "different estimator" before "wrong" | victor | landed (this PR) |
| 09-29 | P11 | each design parameter cites its source or "our choice" | victor | landed (this PR) |
| 09-29 | P11 | no final report while own background children run | victor | deferred |
| 09-29 | P11 | portability nits in research scripts are Low | victor | landed (this PR) |
| 09-29 | P11 | release bumped minor unilaterally | haruto | dismissed: covered, step 0 |
| 09-29 | P05 | never undo a mutation with git checkout -- | iris | landed (this PR) |
| 09-29 | P05 | a test pins only a measured value | haruto | deferred |
| 09-29 | P05 | reordering a data-moving step before refusal gates | haruto | deferred |
| 09-29 | P05 | "board clear" means every row closed or blocked | wei-lin | landed (this PR) |
| 09-29 | P05 | CI wait: absence of pending is not completion | wei-lin | landed (this PR) |
| 09-29 | P05 | derive the bump from the changelog | haruto | dismissed: covered, step 0 |
| 09-29 | P12 | stranger clone under env -i; env scripts own their interpreter | /autopilot | landed (this PR) |
| 09-29 | P12 | PR carries code and tests; NOTES never committed | wei-lin | landed (this PR) |
| 09-29 | P12 | framework determinism before fitting a tolerance | iris | landed (this PR) |
| 09-29 | P12 | identify a process's owner before claiming contention | wei-lin | landed (this PR) |
| 09-29 | P12 | content-hash every anchor before building a gate | iris | deferred |
| 09-29 | P12 | no duplicate dispatch; never write under read-only dirs | wei-lin | deferred |
| 09-29 | P12 | commit WIP before a wait; heartbeat installed at launch | wei-lin, /autopilot | landed (this PR) |
| 09-29 | P13 | no CI: stop before pushing | haruto | dismissed: covered, step 0 |
| 09-29 | P13 | check the root-file rule before writing release notes | haruto | deferred |
| 09-29 | P07 | reap worktrees on landing; git cherry for squash merges | wei-lin | landed (this PR) |
| 09-29 | P14 | a perf number carries its repeat count and range | zofia | landed (this PR) |
| 09-29 | P14 | fixed release-note schema | haruto | deferred |
| 09-29 | P14 | backfilled Release says so and is never Latest | haruto | landed (this PR) |
| 09-29 | P14 | check a scaling direction against numeric pairs | victor | landed (this PR) |
| 09-29 | P14 | router settles mechanically checkable disagreements | victor | landed (this PR) |
| 09-29 | P14 | WRONG against a source cites the line read | victor | landed (this PR) |
| 09-29 | P14 | no VERSION or tags: the release is the commit | haruto | landed (this PR) |
| 09-29 | P08 | never end a turn while a child is alive | wei-lin | landed (this PR) |
| 09-29 | P08 | live roster of children; untracked outputs outside worktrees | wei-lin | landed (this PR) |
| 09-29 | P08 | /audit report for a non-code artifact goes to its project | /audit, victor | landed (this PR) |
| 09-29 | P08 | a FAIL quotes the rule and shows the measurement | sophia | landed (this PR) |
| 09-29 | P08 | resolve DOIs yourself; never send the user's email out | ziyan | landed (this PR) |
| 09-29 | P08 | parity runs write to a scratch copy | kai | landed (this PR) |
| 09-29 | P09 | push finished work before any long wait | wei-lin | landed (this PR) |
| 09-29 | P09 | copy out board-cited evidence before reaping | wei-lin | landed (this PR) |
| 09-29 | P09 | rule book names one board, the one /autopilot reads | zofia, /autopilot | dismissed: covered, one-board rule |
| 09-29 | P09 | quote a process's ps line, never infer it | wei-lin | landed (this PR) |
| 09-29 | P15 | grant from the rule book; state the target branch first | wei-lin | landed (this PR) |
| 09-29 | P15 | record owned worktrees; commit WIP at step boundaries | wei-lin | landed (this PR) |
| 09-29 | P15 | a config value is a claim, not evidence | victor | landed (this PR) |
| 09-30 | P16 | validate a deps manifest by running tests in a clean env; canaries call the API | iris | landed (this PR) |
| 09-30 | P16 | same-code output is a regression anchor, not an independent oracle | iris | landed (this PR) |
| 09-30 | P16 | population claims state n per stratum and a CI; re-derive summary counts | dunyu-liu | landed (this PR) (also lands P10's deferred convergence-triple row) |
| 09-30 | P16 | write the notes file in the first 10 minutes | dunyu-liu | deferred |
| 09-30 | P16 | code-fact verdict and effect verdict; untraced effect is CAN'T TELL | lars | landed (this PR) |
| 09-30 | P16 | never signal or renice a process not on the roster | wei-lin | landed (this PR) |
| 09-30 | P16 | no content-free interim completions | wei-lin | dismissed: covered, rule 1 (622f8ea) |
| 09-30 | P16 | silent rule book: ask about merge authority at minute 0 | /autopilot | landed (this PR) |
| 09-30 | P16 | rules hold invariants; changing state goes on the board | zofia | landed (this PR) |
| 09-30 | P16 | gate a merge on --exit-status &&, never after ; | wei-lin | landed (this PR) |
| 09-30 | P05 | evidence keyed to the tree hash; no re-sweep of an identical tree | haruto | landed (this PR) |
| 09-30 | P05 | re-read CI state on every wake; never trust a background poller | haruto | landed (this PR) |
| 09-30 | P05 | checkpoint before long gates; one long-gate agent at a time | wei-lin | landed (this PR) |
| 09-30 | P16 | long runs write per-case results and skip finished cases on restart | wei-lin | landed (this PR) |
| 09-30 | P16 | after a 429 resets, refill free slots; deferrals name an unblock event | wei-lin | landed (this PR) (corrects 0730dcf's "stop dispatching") |
| 09-30 | P16 | never leave artefacts untracked in the default checkout | wei-lin | dismissed: covered, never touch the main checkout |
| 09-30 | P16 | invoker relays specialist numbers as unaudited until audited | /autopilot | landed (this PR) |
| 09-30 | P16 | writes outside the repo need the owner's OK for that write | /autopilot | landed (this PR) |
| 09-30 | P16 | behavioural claims in release docs name their test | haruto | landed (this PR) |
| 09-30 | P16 | pkill -f killed its own shell | all | dismissed: covered, wei-lin kill lesson |
| 09-30 | P05 | every wait is one blocking call; never re-wake to poll (15M vs 58k tokens) | haruto, wei-lin, dunyu-liu | landed (this PR) |
| 09-30 | P05 | wait on the PID captured at launch, never pgrep -f | haruto, wei-lin | landed (this PR) (also lands P03's deferred pgrep row) |
| 09-30 | P05 | a release script drives mechanical steps; the agent does judgment and failures | haruto | landed (this PR) |
| 09-30 | P05 | one long gate at a time; checkpoint line before each wait | haruto | landed (this PR) |
| 09-30 | P05 | one agent per job; never resume a finished agent (it keeps its old prompt) | wei-lin, /autopilot, /release | landed (this PR) |
| 09-30 | P05 | conductor cycle-time duty: one sweep per content key, fix rounds BLOCKER/MAJOR only | wei-lin | landed (this PR) (design review before build, CI cancel after force-push: deferred) |
| 09-30 | P05 | throughput is measured: rows/hour and rows left by blocker class | wei-lin | landed (this PR) |
| 09-30 | P05 | one cost-record schema emitted by every agent | all | dismissed: superseded by the SubagentStop hook in lesson 7 |
| 09-30 | P05 | consilium reads only the sanitized cost export; no-leak rule for published material | consilium | open: maintainer's call on project names already in the ledger |
| 09-30 | P05 | builders run touched tests locally; CI runs the full tier | haruto | landed (this PR) |
| 09-30 | P05 | victor audits single-surface diffs himself; docs-only changes are not audited | victor | landed (this PR) |
| 09-30 | P05 | victor fixes easy findings directly | victor | dismissed: covered by builder self-verify (f1e7fa8); an auditor fixing its own findings breaks rule 20 |
| 09-30 | P05 | science sweep re-runs only when a declared science-bearing path changed | zofia, haruto | landed (this PR) |
| 09-30 | P05 | touched tests include the cheap registration checks; no commits in the main checkout | haruto | landed (this PR) (main-checkout half already covered) |
| 09-30 | P05 | a red CI on the default branch or a tag goes to the head of the queue | wei-lin | landed (this PR) |
| 09-30 | P05 | owner rule: nothing tagged until every check the tag triggers has passed on that SHA | zofia, haruto | landed (this PR) (supersedes 09a28ed's read-after-push) |
| 09-30 | P05 | tag and Release created in one step (gh release create --target); never a separate tag push | haruto, zofia, rule 15a | landed (this PR); owner-directed |
| 09-30 | P05 | batch small related non-physics changes into one PR; physics gets its own | wei-lin | landed (this PR); owner-directed |
| 09-30 | P05 | during a red-release repair only the repair merges | wei-lin | landed (this PR) |
| 09-30 | P05 | an owner's "X before Y" is a hard ordering, checked off by name | wei-lin | landed (this PR) |
| 09-30 | P05 | a rule forbidding an action ships with its refusing check, or is labelled a norm | zofia | landed (this PR) |
| 09-30 | P05 | tag only a SHA with its own green CI and image gate; no "equivalent SHA" proof | haruto | landed (this PR) (tree-hash carry-forward narrowed to the science sweep) |
| 09-30 | P05 | a commit adding evidence or data a test reads is not docs-only | haruto | landed (this PR) |
| 09-30 | P05 | after every landing, fold small ready non-physics rows into the next PR | wei-lin | landed (this PR); owner-approved |
| 09-30 | P05 | audit only a diff that changes gate or physics logic | victor, wei-lin | landed (this PR); owner rule |
| 09-30 | P12 | board updates still go through a PR with green CI; "reviewed it myself" is no gate | wei-lin | landed (this PR) |
| 09-30 | P03 | all work lives inside the project root; never sibling worktrees | zofia, wei-lin | landed (this PR) (promotes P06's 09-25 dismissed row: second project) |
| 09-30 | P16 | stranger clone of the SHA runs before the tag | /autopilot | landed (this PR) |
| 09-30 | P16 | phase table: estimate vs actual, owner's timezone | wei-lin | landed (this PR) |
| 09-30 | P16 | environment is part of the content key; say up front when it changes | wei-lin | landed (this PR) |
| 10-01 | P05 | kill one PID from the job's own record after ps confirms it; never a computed list | wei-lin | landed (this PR) |
| 10-01 | P05 | a sweep runs from its own detached worktree so edits cannot race it | wei-lin | landed (this PR) |
| 10-01 | P16 | phase-table actuals come from recorded timestamps, never recall | wei-lin | landed (this PR) |
| 10-01 | P16 | the invoking session forwards specialist completion notices to the conductor at once | /autopilot | landed (this PR); polling half covered by wei-lin rule 1 |
| 10-01 | P12 | owner exception to 1b: a new agent of mean length may raise the ceiling once | rule 1b | landed (this PR); ceiling 5576 -> 5768 |
| 10-01 | P12 | new agent shu-han, research-proposal author | shu-han | landed (this PR); fixture shu-han-001 required by lian-zhao, built by iris-vermeulen |
| 10-01 | P12 | elena-hartmann: critique plus elevation, significance first | elena-hartmann | landed (this PR); 171 -> 137 lines |
| 10-01 | P05 | every wait carries a deadline; a sweep runner times out a hung cell | wei-lin, haruto, iris | landed (this PR) |
| 10-01 | P05 | verify a brief's claim with the pre-tag checker before merging the release PR; check-read files stay out of paths-ignore | haruto | landed (this PR) |
| 10-01 | P16 | convert every timestamp with TZ=<owner tz>; no end time later than the send time | wei-lin | landed (this PR); the prose rule from 584e270 had not held |
| 10-01 | P17 | reference lookups for an unpublished proposal are DOI/ID-only; no free-text queries with PI or tool names | shu-han | landed (this PR) |
| 10-01 | P18 | Mode B always diffs the tracked root against the whitelist; missing CLAUDE.md flagged | zofia | landed (this PR) (proposed, not a violation, where the book has no layout) |
| 10-01 | P18 | a follow-up message gets its delta applied and reported, not a re-run | zofia | landed (this PR) |
| 10-01 | P18 | whitelist covers dotfiles, VERSION and reference/oracle trees | zofia | landed (this PR) |
| 10-02 | P05 | when the conductor's run ends, the invoker lists its branches, worktrees and open P1 rows; any unowned one gets a fresh conductor or an owner report that turn | /autopilot | landed (this PR) |
| 10-02 | P09 | a conductor cannot message a running specialist; follow-ups wait for its report; `fork` clones the conductor | wei-lin | landed (this PR) |
| 10-02 | P09 | a result matching an earlier one to 3+ sig figs is flagged with the check that rules out a wrong-file read | wei-lin | landed (this PR) |
| 10-02 | P17 | literature review covers prior art for every "first"/"only" claim, local folders first | shu-han | landed (this PR) (root cause was the dispatch brief) |
| 10-02 | P17 | the report names any workflow step skipped and what blocked it | shu-han | landed (this PR) |
| 10-02 | P17 | `/propose` command: workflow order is the contract; no drafting before checklist and literature review | /propose | landed (this PR), paid by cuts |
| 10-02 | P18 | never commit, rebase or reset a live child's worktree; never drop a deliverable the owner asked for | wei-lin | landed (this PR) (mechanism unidentified) |
| 10-02 | P16 | after each returning mission, check the main checkout for strays and diff one against the child's branch before removing it | wei-lin | landed (this PR) |
| 10-02 | P18 | conductor gets SendMessage + TaskStop: steer a live child by message, stop by TaskStop, never by killing its PIDs; `Agent(to:…)` spawns a new agent | wei-lin | landed (this PR); supersedes the PR #63 "wait for its report" line |
| 10-02 | P18 | mission commits carry an `Agent: <name>` trailer so a rewrite is attributable | wei-lin | landed (this PR) |
| 10-02 | P18 | kill-by-PID + worktree takeover as the steering fallback | wei-lin | dismissed: PR #63 forbids touching a live child's tree; TaskStop replaces it |
| 10-02 | P16 | no tag until the release log holds `clone: PASS <sha>`; the clone builds its own env under `env -i` | haruto, wei-lin | landed (this PR); root cause: haruto's prompt ran the clone after publication |
| 10-02 | P05 | long jobs re-read their context every tool round (one job: 231 calls, 62.5M tokens, nothing committed for 50 min); wait in blocking calls, commit before the wait | mira, iris, kai | landed (this PR) |
| 10-02 | P05 | a waiting subagent ends its turn and is woken by the run's exit | — | dismissed: a subagent that ends its turn is finished; a blocking call gets the same saving |
| 10-02 | P05 | auditors cost about 1/100 of implementers per job | — | noted: the review step is not the cost centre |
| 10-02 | P16 | a specialist treated its conductor's mid-task messages as untrusted and finished a superseded brief (~57 min, 122k tokens) | wei-lin | landed (this PR): the brief says her messages amend it, never widen permissions |
| 10-02 | P05 | consilium ships a usage kit (SubagentStop hook, exporter, leak gate) and requires it | — | deferred to the owner: a user-level settings hook is the owner's call; consilium retired its hooks 09-17 |
| 10-02 | P05 | triage aggregates the anonymous usage export per agent and flags outliers | triage | accepted, no repo change; p90 doubling is the trigger, cache_read share >95% rejected (normal for 15 of 24 agents) |
| 10-02 | P09 | the conductor's own heavy launches get the thread cap too, and an owner's resource order outranks a project rule against caps | wei-lin | landed (this PR) |
| 10-02 | P09 | zofia flags project rules that forbid thread caps | zofia | dismissed: one incident; the precedence clause in wei-lin covers it |
| 10-02 | self | the release PR is squash-merged; a merge commit is a new SHA and forces a second CI wait | haruto | landed (this PR) |
| 10-02 | self | a dispatcher's mid-run message amends haruto's brief and never widens permissions | /release | landed (this PR) |
| 10-02 | P18 | a child that dies on a session limit naming a reset time gets a wake-up armed for that time | /autopilot | landed (this PR) |
| 10-02 | P18 | "precision noise" is not a verdict after a bit-identical checkpoint; checkpoint down to the first differing operation | mira | landed (this PR) |
| 10-02 | P16 | a specialist that disagrees with a relayed owner decision says so in its report, never by acting | wei-lin | landed (this PR) |
| 10-02 | P16 | coordinator idle after a limit stop; schedule the wake-up at the reset time | /autopilot | landed (this PR) (same fix as P18) |
| 10-02 | P10 | batch open decisions into one pre-flight question with defaults; decisions go in the brief | /autopilot | landed (this PR) |
| 10-02 | P10 | mid-run relays refused as injection | wei-lin | covered: briefs say the dispatcher's messages amend them (PR #66) |
| 10-02 | P10 | a re-run of the same script is MEASURED; VERIFIED needs an independent oracle | wei-lin | landed (this PR) |
| 10-02 | P10 | rules audits check that each rule's named files, runs and commands still exist and are canonical | zofia | landed (this PR) |
| 10-02 | P15 | an UNVERIFIED mark names what would verify it | zofia | landed (this PR) |
| 10-02 | P15 | a plan compared against an existing run first gets the no-solve input-equivalence check | victor | landed (this PR) |
| 10-02 | P15 | zofia seed mode on an existing project: created nothing, re-verified as a delta | zofia | noted: positive, no change |
| 10-03 | P05 | owner decisions relayed mid-run get a verifiable channel: committed verbatim to the board, the relay cites the commit; the conductor objects in her report, never re-litigates | /autopilot, wei-lin | landed (this PR) |
| 10-03 | P12 | mid-mission amendments ignored by a specialist; a shape change is a stop and a fresh brief, small steers cite a board commit | wei-lin | landed (this PR) |
| 10-03 | P12 | a way for agents to authenticate the sender of a message | tooling | deferred: a harness feature; the board-commit citation is the workaround |
| 10-03 | P13 | every verb in the owner's budget (clean up, refactor, release) is committed scope; only narrowing needs the owner | /autopilot | landed (this PR) |
| 10-03 | P13 | zofia declined her dispatcher's mid-task scope additions | /enforce-rules | landed (this PR): a message citing a board commit amends the brief |
| 10-03 | P10 | a conductor tagged without the milestone cycle, a session log or the gate on the tag's SHA; tag only through haruto's checklist | wei-lin | landed (this PR) |
| 10-03 | P12 | a conductor ends no turn with its own wait pending: cancel it or log "still owns <step>"; the invoker reads that before re-briefing | wei-lin, /autopilot | landed (this PR) |
| 10-03 | P12 | a long-job monitor needs a wall-time ceiling, not only an exit wait (92-min hang missed) | wei-lin | dismissed: covered, every wait carries a 2-3x deadline (rule 1) |
| 10-03 | P16 | under "clear the board", a checkpoint is not a stop; an ownership claim that blocks work is re-read from current files | wei-lin | landed (this PR) |
| 10-03 | P16 | a commit/PR instruction in the brief overrides kai's no-commit default; gate under the pinned interpreter | kai | landed (this PR) |
| 10-03 | P16 | a docstring cited evidence that does not exist; cite only what exists | kai | landed (this PR) |
| 10-03 | P16 | a turn that ends on a wait names the PID or agent that wakes it, or the work is hers now | wei-lin | landed (this PR) |
| 10-03 | P16 | one owner per PR; a correction goes to that owner (or stops it) first | wei-lin | landed (this PR) |
| 10-03 | P17 | NOT SUPPORTED only after every page was searched; list the pages read | ziyan | landed (this PR) |
| 10-03 | P17 | try local disk, then repository raw files, before publisher URLs; ask the PIs early | shu-han | landed (this PR) |
| 10-03 | self | usage log: 94% of subagent tokens are context re-reads; runs over 150 tool calls are 6% of runs but 58% of tokens; every agent checkpoints and stops at ~120 calls, and the conductor is recycled there | all agents, /autopilot | landed (this PR) |
| 10-03 | self | usage by project: a conductor briefed as a generic agent ran 243 calls without her cap; one conductor ran 8 h with no commit; conductors overshot the cap by up to 60% | /autopilot, wei-lin | landed (this PR) |
| 10-03 | P16 | a stale injected copy of the instruction file put rows "out of scope"; "exhausted" names each open row's blocker | wei-lin | dismissed: covered, loop rule 1 (10-03 row: re-read from current files; every open row named with its unblock event) |
| 10-03 | P16 | board and log commits went straight to the default branch; they take the PR path code takes | wei-lin | landed (this PR) |
| 10-03 | P16 | a write-capable specialist dispatched without worktree isolation, a day after logging the same lesson | wei-lin | dismissed: covered three times (Isolation, Phase 1, Hand-offs); a compliance miss no prompt line fixes |
| 10-03 | P18 | a multi-day gate of independent cases ran as a serial loop on a mostly idle many-core host; pool it from nproc, load and memory, ETA on the board | wei-lin | landed (this PR) |
| 10-04 | P16 | the greenfield-research specialist was dispatched for re-runs, re-analysis and a bug fix; match task class to the description | dunyu-liu, wei-lin | landed (this PR): description names what it is not for |
| 10-04 | P16 | the costliest specialist was dispatched without the owner's OK; route to the cheapest match, owner OK per dispatch | dunyu-liu, wei-lin | landed (this PR); per-dispatch cost line dismissed: tool calls already capped |
| 10-04 | P16 | a parity verifier held one of two production acceptance checks and three audits re-derived arithmetic under it; enumerate every check on the production path, audit the rule set against the source | mira-volkov, priya-nair, lars-eriksson | landed (this PR) |
| 10-04 | P16 | merged when the only completed CI run had failed (the other was cancelled) and reported green; quote run id and conclusion, strip machine-local paths | wei-lin | landed (this PR) |
| 10-04 | P16 | merge discipline lived only as written rules; propose host-side protection to the owner as a day-one decision, no bypass actors | zofia-kaminska | landed (this PR): sharpens starter invariant 13 |
| 10-04 | P19 | a doc compression delivered 4%, then met its target partly by widening the wrap; measure at the file's wrap width, restructure before calling prose load-bearing | kai-fischer | landed (this PR) |
| 10-04 | P19 | a release reported every gate passed when no CI existed; an absent CI is a finding, never a pass; CI proposed on day one | haruto-nakamura, zofia-kaminska | landed (this PR): host protection itself landed 10-04 |
| 10-04 | P19 | a check defined but never registered in the runner never ran; the test command must run every check, seed a meta-check | zofia-kaminska | landed (this PR) |
| 10-04 | P05 | 84 stale remote branches after two weeks of conductor runs; the end report lists every branch pushed, deleted once landed or abandoned, else a board row | wei-lin | landed (this PR) |
| 10-04 | P05 | release adds a post-publish stale-branch sweep | haruto-nakamura | dismissed: the conductor that pushed them owns them, and /autopilot lists each branch at run end |
| 10-04 | P05 | protect the default branch and release tags host-side, no bypass | zofia-kaminska | dismissed: covered, starter invariant 13 (landed 10-04) |
| 10-04 | P05 | every commit takes the PR path with a fast lane: docs/board-only PRs run light checks and auto-merge, never queue behind code; a direct-push policy is flagged once | wei-lin, zofia-kaminska, /autopilot | landed (this PR); PR path itself landed 10-04 |
| 10-04 | P16 | an audit passed a claim measured on the wrong population (a filter over all-missing rows); restate as metric on population answering question | priya-nair, lars-eriksson | landed (this PR) |
| 10-04 | P16 | scope change drip-fed to a live specialist again; read the reference template first; a stop the conductor cannot reach goes to its invoker | wei-lin | landed (this PR): recurrence of the 10-03 row, fixture-eligible under rule 10, deferred to the owner |
| 10-05 | P12 | unpublished work went onto the board and log of a public repo; check visibility before the first push, ask once which work lines are private | wei-lin, zofia-kaminska | landed (this PR) |
| 10-05 | P18 | a specialist's "confirmed after the fix" went on the board from a run that predated the fix and wrote 0 bytes; a board number names its result file, mtime and code SHA, and a report's paths are listed before being called gone | wei-lin | landed (this PR): sharpens "a row closes on a command that ran" |
| 10-05 | P16 | one exploratory solver run hung 8 h past the ~30 min threshold; timeout set at launch, repeated-warning tripwire | wei-lin | landed (this PR): recurrence of the 10-01 P05 row and the ~30 min kill rule, fixture-eligible under rule 10, deferred to the owner |
| 10-05 | P15 | an owner-decision relay commit swept the conductor's uncommitted board edits; stage only the relay's hunk | /autopilot | landed (this PR) |
| 10-05 | P15 | seed saw a merge-gate heading and missed that no rule says when a PR is required; judge a rule present by what it requires, name the substitute where host protection is unavailable | zofia-kaminska | landed (this PR): sharpens starter invariant 13 (10-04) |
| 10-05 | P16 | the conductor ended an open budget on an owner hold read from a superseded note and a self-set time-box; a hold or time-box not quoted from current files is no unblock event | wei-lin | landed (this PR): sharpens loop rule 1; recurrence of the 10-03 P13 and P16 stop rows, fixture-eligible under rule 10, deferred to the owner |
| 10-06 | P05 | two benchmarks reported landed on self-consistency alone; until an independent oracle at matched resolution passes (an archived one first) the row is "gated, not validated" | wei-lin | landed (this PR): recurrence of the 09-30 P16 and 10-02 P10 oracle rows, fixture-eligible under rule 10, deferred to the owner |
| 10-06 | P05 | a physics PR merged without its required audit; the merge report cites the audit's link, none means no merge | wei-lin | landed (this PR): recurrence of the 09-30 P05 audit row, fixture-eligible under rule 10, deferred to the owner |
| 10-06 | P05 | the starter's validation step defines "independent" as another source at matched resolution | zofia-kaminska | dismissed: covered by iris's oracle definition and the conductor's closure rule (this PR); a starter line would duplicate |
| 10-06 | P16 | a probe reported every case converged because the driver raised nothing, while it logged each failed solve and wrote no output; the claim was relayed unchecked | wei-lin | landed (this PR): extends the 10-05 result-file line to any relayed success; recurrence of the 10-05 P18 row, fixture-eligible under rule 10, deferred to the owner |
| 10-06 | P17 | a reference check tallied 13 claims verified while its table covered 8; an issues-only table hides an absent ID, so one row per assigned ID and the tally counts IDs marked | ziyan-chen | landed (this PR) |
| 10-06 | P16 | a closing report summarised board rows as done while five still read open at the final SHA; quote each row's State cell as read there | wei-lin | landed (this PR): end-report item 4 |
| 10-06 | P16 | the same report called every merge gate-green when one merge SHA's required check was cancelled and another still ran | wei-lin | dismissed: covered, Phase 2 merge report quotes run id and conclusion (10-04 P16 row); recurrence, fixture-eligible under rule 10, deferred to the owner |
| 10-07 | P05 | a two-dot diff read a sibling's new files as "deleted" and four PRs were rebased and re-verified for a false revert hazard; judge staleness by three-dot or a trial squash, rebase only on a real conflict or when CI must test the combined tree, no oracle re-run when the PR's diff is unchanged | wei-lin | landed (this PR): sharpens gate axis 4 and Phase 2 |
| 10-07 | P05 | a dispatched agent's worktree was force-removed because its PR had merged, while the agent still ran; reap only after its completion notice or a liveness check | wei-lin | landed (this PR): sharpens the reaping step; recurrence of the 10-02 P18 live-child-worktree row, fixture-eligible under rule 10, deferred to the owner |
| 10-07 | P18 | a widened gate reused an older scaffold whose reference was a third-party build, not the oracle the narrower gate used, and batched every DIVERGED to pool end; diff the oracle path before launch, report each DIVERGED on arrival | wei-lin | landed (this PR): extends the pool line |
| 10-07 | P16 | a dispatched rules agent checked out, committed and stashed in the owner's main checkout; copy the never-touch line verbatim into every brief | wei-lin | landed (this PR): one clause on the existing Phase 1 line; recurrence of the 09-24 P10 and 09-30 P16 main-checkout rows, fixture-eligible under rule 10, deferred to the owner |
| 10-07 | P16 | the conductor ended on "another agent owns this merge, holding" with no live agent | wei-lin | dismissed: covered, loop rule 1 (an ownership claim not quoted from current files is no unblock event; a wait names the agent that wakes you, or the work is yours); recurrence of the 10-05 P16 stop row, fixture-eligible under rule 10, deferred to the owner |
| 10-07 | owner | anya-petrov owns a project's user docs as standing work: Diátaxis pages, README first, docs in the code's PR, executable README commands with shape checks after scripted edits, link check, changelog per bump, docs site actually publishes | anya-petrov | landed (this PR): source owner decision 2026-10-07 |
| 10-07 | P21 | a template audit built the root whitelist from the current tree and so found zero violations | zofia-kaminska | landed #101: the whitelist is built from the template, never the tree |
| 10-07 | P16 | same whitelist-from-tree audit, its "zero violations" relayed by the conductor unchecked | zofia-kaminska | landed #101; second project the same day, fixture-eligible under rule 10, deferred to the owner |
| 10-07 | P16 | investigation scripts, outputs and figures were committed into the docs tree as board-row evidence; keep docs lean, evidence is the command and its SHA | zofia-kaminska | landed (this PR): the Docs failure mode in invariant 1; a loop-side question to projects is the owner's, outside this repo |
| 10-07 | P16 | the invoking session relayed to an ended conductor, which resumed her alongside a fresh one | /autopilot | landed (this PR): relay only while she is live, else seed a fresh one |
| 10-07 | P20 | the conductor closed a P1 row as "premise false" from a column measuring the same quantity at another location | wei-lin | landed (this PR): a lifecycle change goes to zofia that turn, quoting the row's quantity beside the code line the output measures; fixture deferred to the owner |
| 10-07 | P20 | the conductor opened, closed and re-scoped rows herself, second run in a row | wei-lin | dismissed: covered by rule 19 and her board constraint, sharpened above; recurrence, fixture-eligible under rule 10, deferred to the owner |
| 10-07 | P20 | the command put merge policy to the owner pre-flight although the conductor carries a fallback | /autopilot, wei-lin | landed (this PR): where the rule book is silent the command's cycle is the policy, never asked; wei-lin's fallback names the same cycle |
| 10-07 | P20 | seeding left starter invariant 13 out and never listed it dropped; a tree-shaped whitelist declined the template | zofia-kaminska | landed (this PR): the seed report ends with all thirteen invariants landed or dropped, dropping 13 or 1's layout needs the owner; whitelist half landed #101 |
| 10-07 | P02 | the invoking session invented a narrower no-push policy and asked the owner to confirm it | /autopilot | landed (this PR): only the owner narrows scope |
| 10-07 | P02 | a declined decision was re-asked twice in prose | /autopilot | landed (this PR): a declined one is a BLOCKED(owner) row, never re-asked |
| 10-07 | P02 | the command's "where none is stated, ask pre-flight" clause contradicted its own dev cycle; missing CI read as a question | /autopilot | landed (this PR): same edit as the P20 row; missing CI is her first row |
| 10-07 | P15 | the conductor read the parent's kill of a finished run as a fault, deleted the run output, relaunched unapproved and codified a false cause | wei-lin | landed (this PR): an external kill sends her to the board and log for who stopped it; killed output moves aside, never deleted; relaunch already forbidden |
| 10-07 | P15 | the parent killed the run itself instead of stopping or messaging the live conductor | /autopilot | landed (this PR): a stop is relayed to her before the session acts on it |
| 10-07 | consilium | a release dispatched without a worktree branched in the shared checkout and left it off the default branch | haruto-nakamura | landed (this PR): cut in his own worktree, leave the caller's checkout as found, a halt included |
| 10-07 | P16 | on the first job after a docs-lean rule landed, the conductor wrote a run-measurement note into the dev docs, added it to the docs allowlist so the gate passed, and cited unaudited numbers in a source comment | wei-lin | landed (this PR): an allowlist line exempting its own file is a weakening under gate axis 1 and only the owner adds one; Phase 3 snapshot is command + SHA on the board, output in runs/, never a doc or comment; follows the 10-07 P16 docs-lean row |
| 10-07 | P13 | a conductor's background wait on `pgrep -f` matched its own shell, never ended, and was left running after she reported done | wei-lin | dismissed: covered, Lessons (wait on the PID from `$!`, never `pgrep -f`) and loop rule 1 (never end a turn with a wait of your own pending); third project after 09-24 P03 and 09-30 P05, fixture-eligible under rule 10, deferred to the owner |
| 10-07 | P20 | the final report said every branch was reaped while two merged local branches remained, one a removed worktree's | wei-lin | landed (this PR): a worktree is reaped with its branch; report item 3 lists every branch the run made, local or pushed, from `git branch -a` |
| 10-07 | P02 | the invoking session relayed owner decisions without committing them to the board; the conductor took six and silently dropped the seventh as impersonation | /autopilot, wei-lin | landed (this PR): a relay citing no board commit is answered with a request for it, never dropped; the session half covered by the 10-03 P05 commit-first relay line; recurrence of the 10-02 P10 relay-as-injection row, fixture-eligible under rule 10, deferred to the owner |
| 10-08 | P10 | conductors created three new md files (notes, a session log) although a board owner decision forbade new files | wei-lin | landed (this PR): the session log becomes a section in an existing log when such a decision stands; follows the 10-07 P16 docs-lean row |
| 10-08 | P02 | a 6 h run of four conductors merged 15 PRs and tagged nothing: no conductor declared a milestone while one surface stayed open | wei-lin | landed (this PR): a milestone is per surface; from ~80% of the budget an untagged surface at target takes the cycle first; with none, the report says `no milestone, because` |
| 10-08 | P20 | two conductor runs ended with seven PRs and no cycle or tag; the invoking session landed four PRs and reaped branches itself | wei-lin, /autopilot | landed (this PR): same edit, and the session sends a merged surface with no tag and no reason to a fresh conductor, never a landing of its own; second project the same day, fixture-eligible under rule 10, deferred to the owner |
| 10-08 | P02 | the release was tagged before the stranger clone ran; the clone then found a blocker and a second release followed | haruto-nakamura | landed (this PR): the post-tag gate's clone row only re-reads step 11's pre-tag clone; recurrence of the 09-30 P16 clone-before-tag row, fixture-eligible under rule 10, deferred to the owner |
| 10-08 | P19 | the report-only tidy found merged branches with `git branch --merged`, which misses squash merges | zofia-kaminska, wei-lin | landed (this PR): merged means PR merged or `git cherry` empty |
| 10-08 | self | usage REPEAT: a P10 conductor dispatched general-purpose for diagnoses and candidate fixes, 3 runs/24M, second window running | wei-lin | landed (this PR): those go to the domain specialist; only a fix located at file:line with no owning agent may go general-purpose, capped at 40 calls |
| 10-08 | self | usage REPEAT: a P10 conductor ran 123 calls, past the ~120 cap a second window running | wei-lin | landed (this PR): the checkpoint starts at ~100 so the stop lands by 120 |
| 10-08 | self | usage REPEAT: a P02 main session reached 332k context, second window running | /autopilot | landed (this PR): past ~200k the invoking session hands off a state brief for a fresh session |
| 10-08 | P09 | a layout migration run in a worktree reported three git-ignored folders as moved; they were lost, since ignored files ride no branch or merge | wei-lin | landed (this PR): move them in the main checkout after the merge and report from a listing there; the worktree half covered by the reaping step (`git status --ignored`) |
| 10-08 | consilium | the release gate's `tree` row failed any run from a linked worktree, though releases are cut in their own; its lock test missed a lock taken from one | iris-vermeulen | landed (this PR): run from a linked worktree, that worktree is the one allowed extra; the lock is read from the common git dir |
| 10-08 | consilium | the post-tag gate's `clone` row was described as re-reading the pre-tag clone; it makes its own fresh clone of the pushed tag | haruto-nakamura | landed (this PR): described as it runs; it never replaces step 11's pre-tag clone; corrects the 10-08 P02 row's wording |
| 10-08 | consilium | the root-layout audit compared against the starter template only, so a book's own adopted whitelist read as violations | zofia-kaminska | landed (this PR): the book's adopted layout, else the template, never the tree; refines #101 |
| 10-08 | consilium | the ignored-file lesson told the conductor to move files in the main checkout, which rule 20 item 1 forbids | wei-lin | landed (this PR): she hands the owner the exact moves as a BLOCKED(owner) row and verifies from a listing |
| 10-08 | consilium | eight more rule-10 recurrences marked fixture-eligible this release, zero fixtures landed | iris-vermeulen | deferred: fixtures or a proxy check are the owner's; whether to keep landing unfixtured is the human's |
| 10-08 | consilium | autonomous mode granted patch and minor tags while the escalation list still stopped on any default-branch tag | wei-lin | landed (this PR): escalate on a tag the grant does not cover |
| 10-08 | consilium | the milestone audit step read as victor covering "own rules followed", blurring into zofia's rules audit | wei-lin | landed (this PR): victor's pass is that the code does what it claims |
| 10-08 | consilium | the seeded gate check claimed to cover root, docs and tests layouts but inspected only the root | zofia-kaminska | landed (this PR): the check diffs root, `docs/` and `tests/` against their template rows |
| 10-08 | consilium | a splice attached "object in your report" to the missing-commit case instead of to acting on a cited one | wei-lin | landed (this PR): reattached to "then act" |
| 10-08 | consilium | the relay sentence could put a stop behind a board commit, against wei-lin's resource-safety-first order | /autopilot | landed (this PR): a stop goes to her at once, committed after |
| 10-08 | consilium | the ~80% milestone trigger had no meaning for an open-ended budget | wei-lin | landed (this PR): open-ended, it starts at the last queued item |
| 10-08 | consilium | the release isolation line called itself "temporal, not spatial" beside a worktree requirement | haruto-nakamura | landed (this PR): temporal as well as spatial |
| 10-08 | self | usage REPEAT: a P02 main session over 200k context, third window | /autopilot | dismissed: covered by #105 (handoff past ~200k), awaiting effect |
| 10-08 | self | usage REPEAT: a P10 run sent specialist work to general-purpose, 1 run/10M | wei-lin | dismissed: covered by #105 (diagnoses never to general-purpose), awaiting effect |
| 10-08 | self | usage REPEAT: a P06 main session over 200k context, no consilium agent dispatched | none | dismissed: no consilium prompt governs a session that ran none; report-back only |
| 10-09 | P12 | an owner quote relayed verbatim to a public board carried a privacy-listed term | /autopilot | landed (this PR): verbatim, or a marked paraphrase when the quote holds such a term |
| 10-09 | self | usage recurrence after #105: a P12 wei-lin run begun after it reached 161 calls, resumed turn after turn, each turn short | wei-lin, /autopilot | landed (this PR): calls summed over every resume; past ~100 a resumed turn starts nothing and asks for a fresh conductor, never resumed past it; fixture wei-001 |
| 10-09 | P21 | an audit ran model inference on CPU because GPUs showed load while two had most memory free; ~23x slower | victor-reyes | landed (this PR): place inference by free GPU memory (2x footprint), niced; CPU only when none, with the wall time stated |
| 10-09 | P12 | recurrence after #109: a privacy-listed term landed in a public repo through the conductor session-log PR, no grep run on its head | wei-lin | landed (this PR): the privacy grep runs on every PR head, fast lane and session logs included; fixture wei-002 |
| 10-09 | P12 | near the call cap a conductor pushed to main directly and merged a gate-logic PR without its audit | wei-lin | landed (this PR): cap pressure never skips a gate; unfinished gated work goes to the successor |
| 10-09 | self | usage: a P12 kai-fischer run at 127 calls/11M, past the ~120 stop its prompt already states; first flag | kai-fischer | noted: no edit, the inbox shows no cause; re-triage on a repeat |
| 10-09 | P20 | a docs-only conductor run squash-merged under a rule book fixing merge commits; the fast lane hard-coded `--squash` | wei-lin | landed (this PR): every merge passes the rule book's method, `--squash` only when it names none |
| 10-09 | P20 | the same runs called a docs-only landing a milestone and gave no milestone line | wei-lin | dismissed: covered, end-report item 2 and the per-surface milestone (10-08 P02/P20 rows); recurrence after them, fixture wei-003 |
| 10-09 | P03 | the report-only tidy listed a worktree as dead while two running jobs had it as their cwd | zofia-kaminska | landed (this PR): a worktree holding a live process's cwd is in use, never stale |
| 10-09 | P12 | a conductor went idle on "needs an owner call" though the row quoted the owner's approval, and marked checkable facts BLOCKED(owner) | wei-lin | landed (this PR): facts, engineering defaults and row-approved work are not escalations; grep the row before BLOCKED(owner) |
| 10-09 | P12 | the same run reached 208 calls past the ~100 cap | wei-lin | dismissed: covered by #109 (calls summed over resumes, fresh conductor past ~100) and fixture wei-001, awaiting effect |
| 10-09 | P16 | an auditor called the full suite green from the exit status of `pytest … \| tail` | lars-eriksson | landed (this PR): a green suite quotes the runner's summary line; no status read through a pipe |
