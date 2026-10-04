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
