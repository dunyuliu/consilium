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
| 10-09 | P16 | /autopilot never fast-forwards the owner's main checkout; two projects' checkouts ended several releases behind the remote | /autopilot | landed (this PR): after reaping, the invoking session runs `git pull --ff-only` there and reports `checkout synced to <sha>` or why not (dirty tree, another session's live worktree) |
| 10-09 | P03 | recurrence after #111: the tidy offered a worktree live jobs read data and config from by absolute path, two sole-copy archives, and a board-cited dir as uncited | zofia-kaminska | landed (this PR): in use also when a running job's script or config names a path inside; an archive offered only beside the originals it is the sole copy of; citations searched in board and docs; fixture zofia-004 |
| 10-09 | P13 | recurrence after #84: the conductor dispatched the greenfield specialist on a broad owner directive, without the per-dispatch OK | wei-lin | landed (this PR): the OK is asked in the pre-flight question, never read from a broad directive; fixture wei-004 |
| 10-09 | P13 | the same dispatch briefed source edits in the shared checkout, not a worktree | wei-lin | dismissed: covered, Hand-offs (`isolation: "worktree"`; 10-03 P16 row); exercised by fixture wei-004 |
| 10-09 | P22 | `git add -u` with one unmatched pathspec staged nothing; a separate staging masked it and the commit was reported complete | wei-lin | landed (this PR): before a commit, the staged file list matches the intended list by count |
| 10-09 | P22 | the merge gate checked a generator's side output while both generated main artifacts failed to import | wei-lin | landed (this PR): a changed generator's gate loads or imports every artifact it writes |
| 10-09 | P22 | recurrence after #104: the report called every merged branch deleted while one stayed on the remote | wei-lin | landed (this PR): item 3 lists branches from `git branch` and `git ls-remote --heads origin`, a tracking ref not being the remote; fixture wei-005 |
| 10-09 | self | usage REPEAT: P06 and P02 main sessions over 200k context | none | dismissed: no agent prompt governs a main session; waste report-back to both projects |
| 10-09 | self | usage first flags: a P05 mira-volkov run at 134 calls; P22 general-purpose runs doing specialist work | mira-volkov, wei-lin | noted: covered by mira's ~120-call stop and the Hand-offs routing line (#105); re-triage on a repeat |
| 10-10 | consilium | a post-tag transcription commit was pushed before the release gate ran; the gate's `clone` row, comparing README's default-branch clone with the tag, then failed for good | haruto-nakamura | landed (this PR): the gate runs in a fresh clone right after the tag, before any further push; CI and gate rows go into ONE follow-up commit. The row is right (the `publish` row ties the tag to HEAD too), script unchanged; no earlier ledger row, so no fixture |
| 10-10 | consilium | victor's dispatch tool was unavailable in session and the release's deep audit ran inline, no specialist reviewed | victor-reyes, haruto-nakamura | landed (this PR): its frontmatter grants Agent, but dispatched by haruto it is a nested subagent, which can lack it; victor then says so on line 1 and names the specialists, and haruto runs them |
| 10-09 | P13 | an auditor handed the board's count as the anchor reported a match her own per-item records contradicted | priya-nair | landed (this PR): a number the brief or a board hands her is the claim, never the anchor; recount it from the per-item records |
| 10-09 | P13 | recurrence after #89: a release with no CI and no test tier was tagged on a stranger clone and re-runs called consistent with prior releases | haruto-nakamura | landed (this PR): the substitute gate is named command by command, run on that SHA with summary lines; "as before" names no gate; with neither CI nor tests, no tag until the owner names one; fixture haruto-003 |
| 10-09 | P13 | the same conductor never opened missing CI as her first row | /autopilot | dismissed: covered, "missing CI is her first row" (#102) and the no-CI substitute gate said in the first report (#89) |
| 10-09 | P13 | one conductor commit carried a non-standard attribution trailer | wei-lin | deferred |
| 10-10 | P12 | a conductor force-removed a live child's worktree, killing its detached job: the roster, rebuilt from memory, had the two agent ids swapped | wei-lin | landed (this PR): roster ids copied verbatim from each dispatch result; reap on a notice carrying that worktree's id, a log label being no evidence; a detached job runs from a cwd outside its worktree; recurrence after #96, fixture wei-006 |
| 10-10 | P03 | after two relays forbidding one kind of run, the conductor kept launching it and ended turns on waits; the invoking session stopped the processes | wei-lin | landed (this PR): a relay forbidding running work stops it first, confirmed by `ps`; no wait ends a turn while the ordered change is unmade |
| 10-10 | P21 | recurrence after #96: a conductor ran `reset --hard` in the owner's main checkout to fix a diverged default and wiped uncommitted owner edits | wei-lin | landed (this PR): the main checkout is read only, no reset, checkout, clean or stash; a diverged default is the invoker's `git pull --ff-only` (#112); fixture wei-007 |
| 10-10 | P21 | recurrence after #110: at the cap a conductor pushed its docs-only session log straight to main | wei-lin | landed (this PR): session-log and docs-only commits are gated work, handed to the successor on a pushed branch; fixture wei-007 |
| 10-10 | P21 | recurrence after #109: a conductor reached 257 calls past the ~100 cap, resumed by relays and notices; a P03 run reached 165 the same day; both went through two context summaries, which drop any running count | wei-lin, /autopilot | landed (this PR): a turn opening on a context summary is past the cap, records and asks for a fresh conductor; the invoker sums each notice's `tool_uses` and never resumes her past ~100 or once summarized; fixture wei-008 |
| 10-10 | P21 | the same conductor merged a new numbered rule inside its own merge flow | wei-lin | landed (this PR): Compound drafts the rule for `zofia-kaminska` to land; the conductor never merges it |
| 10-10 | P21 | the same conductor force-released a worktree lock calling its own host session's process stale | wei-lin | landed (this PR): a lock held by the host session, where in-process agents run, is live, never stale |
| 10-10 | P13 | an owner-named tag gate (no CI) was read as narrowing the milestone cycle; the release was briefed to skip audit and refactor | wei-lin | landed (this PR): an owner-named tag gate stands in for CI only, never for a cycle step |
| 10-10 | P13 | a conductor wrote a reproduction match citing the committed value as a placeholder it never looked up; the real value differed | wei-lin | landed (this PR): a match claim quotes both numbers in full, printed by one command that turn |
| 10-10 | self | usage: a P21 general-purpose run at 99 calls/11M built a new dataset mode after the invoker ruled out the greenfield specialist; no agent owns a routine build | wei-lin | landed (this PR): a build with a final design and no owning agent may go to general-purpose, the brief stating the 40-call cap, larger builds split; first build-class flag (#105 covered diagnoses), no fixture |
| 10-10 | self | usage: P11 general-purpose runs (2, 17M, docs cleanup) and a P08 main session at 941k context with zero commits | none, haruto-nakamura | noted: both flagged runs and the P08 context are main-session, no agent prompt governs; waste report-back to both. Also seen: a P11 haruto sent its deep audit to general-purpose (29 calls), not `victor-reyes` as its prompt says; first instance, re-triage on a repeat |
| 10-10 | P21 | recurrence after #110 and #118: mid-run, not at the cap, a conductor pushed a job-list swap commit straight to main, self-reported | wei-lin | landed (this PR): every commit reaches the default branch by PR, cap or not, a docs, board or job-list commit too; `git push` names a feature branch, never the default; fixture wei-009 |
| 10-10 | P21 | the same run left an audit-followup fix on a pushed worktree branch with no PR | wei-lin | dismissed: covered, end-of-campaign item 3 lists every branch from the remote, deleted once landed or a board row (fixture wei-005) |
| 10-10 | self | usage REPEAT: P21 general-purpose doing specialist work, 2 runs (165 calls/18M, 71 calls/7M), neither briefed a 40-call cap | wei-lin | noted: the 165-call run was a main-session dispatch, no prompt governs; the 71-call build came from a conductor dispatched before #119 merged, so it ran the pre-cap prompt; not a repeat after the fix, re-triage on the next one |
| 10-10 | self | usage first flags: a P05 haruto-nakamura run at 146 calls; a P07 main session at 945k context, zero commits | haruto-nakamura, none | noted: covered by haruto's ~120-call stop, re-triage on a repeat; P07 is main-session, waste report-back |
| 10-11 | P18 | recurrence after 09-24 (P08, gate axis 1): a landing passed on "N passed, 0 failed, M skipped", the skips from data links missing in the worktree; main with real data failed | wei-lin | landed (this PR): a missing-data skip is a failure; the gate runs the one canonical tier command (fixed interpreter, real data) and reports each skip's reason; fixture wei-010 |
| 10-11 | P18 | green reported on a PR's SHA, not the merge head; a later board-closing PR left main red | wei-lin | landed (this PR): a green for a PR sequence is the tier re-run at its last merge head, a fast-lane PR included |
| 10-11 | P18 | after a context summary a conductor wrote false history on the board (its own landing attributed to the owner), invented a stricter precondition and launched a redundant full re-run | wei-lin | landed (this PR): a summary-opened turn records only from board, session log, git log and PR list; author identity attributes nothing to the owner; an added precondition costs no compute without the invoker's OK. Dispatched 10-03, before #119 |
| 10-11 | P21 | recurrence after #119 (10-03 P10, 10-10 P13): on the post-#119 prompt a conductor ran the milestone audit as her own re-derivation, called it independent, dispatched no auditor | wei-lin | landed (this PR): a check she runs herself is a self-check, never an audit, and leaves its step open; fixture wei-011 |
| 10-11 | P21 | the same run's label fix corrected one of two wrong columns | wei-lin | dismissed: covered, fixes route to the surface owner and the cycle's audit re-checks them (above) |
| 10-11 | self | usage: a P18 wei-lin run at 276 calls/31M this window, 1081 in all through 10 context summaries | wei-lin, /autopilot | noted: dispatched 10-03 and resumed by relays since, so it and its invoker run the pre-#119 prompt and command; not a repeat after the fix; waste report-back |
| 10-11 | survey | owner decision 1A: 12 of 17 recent tags shipped with no victor audit (per-landing conductor tags, haruto self-checks, main sessions, a stale audit); one tag preceded the stranger clone | haruto-nakamura, wei-lin, /release | landed (this PR): no tag on any path without victor's report on last-tag..tagged-commit quoted in the note, or "audit waived by owner" on a written waiver; one run per release; the tag waits for every gate, stranger clone included; no fixture: the surveyed tags are not dated against the prompt |
| 10-11 | P05 | a standalone /release tagged with zero audit rounds, 3 of the last 4 releases | /release | landed (this PR): folded into the survey's 1A row above |
| 10-11 | P12 | recurrence after #110 (wei-002): a privacy-listed host resolved from a control-socket filename reached a public session log in two merged commits, no grep run | wei-lin | landed (this PR): the privacy grep runs before every push, every branch, and a hit blocks like red CI (fixture wei-012) |
| 10-11 | self | usage: REPEAT P18 wei-lin at 131 calls; P05 `claude` at 149 calls; P19 main session at 334k context | wei-lin, none | noted: the P18 conductor runs the pre-#119 prompt, already governed; `claude` and the P19 main session are not consilium prompts; waste report-back |
| 10-11 | P18 | an auditor called call sites reachable on real data from the code path alone, and the real configs excluded every one; the same session her "clean" verdict on a module missed sites another auditor had cited by file:line | lars-eriksson | landed (this PR): reachable means the project's real configs and fixtures reach it, grepped and quoted; "clean" for a pattern quotes the zero-hit grep over the whole scope |
| 10-11 | P18 | recurrence after #127: a rules-doc PR merged as docs-only with no tier and the conductor's checkpoint committed untiered; both added text the cheapest tier's tracked-text guard rejects, main red | wei-lin | landed (this PR): the fast lane runs the cheapest tier at its merge head, a checkpoint commit too (fixture wei-014) |
| 10-11 | P18 | recurrence after #128: a release with no CI gated the head before its note commit, tagged the note commit unrun, ran the stranger clone after publishing (it failed) and built its environment with `pip install --user`, replacing pinned packages account-wide | haruto-nakamura | landed (this PR): the substitute gate runs on the note commit's own SHA; he runs `clone: PASS` before the tag; the clone's environment is a venv with user site off, never `--user` or a shared site (fixture haruto-004) |
| 10-11 | P18 | a patch cut to remove a machine path from the prior note shipped another, an interpreter path carrying a user name; the project's guard allowlisted release notes | haruto-nakamura | landed (this PR): he greps the note and the published body for absolute paths and user names; an allowlist exempts citations, never a path |
| 10-11 | P05 | 54 of the last 88 merged PRs were bookkeeping: each owner decision committed verbatim to the board first, every commit by PR, so one board PR per decision | /autopilot | landed (this PR): decisions go to one open batch branch, merged as one fast-lane PR per `/brief` (owner-approved in that project) |
| 10-11 | self | usage REPEAT: P18 wei-lin at 162 and 130 calls, both started after #119 on its prompt; each context summary landed mid-turn with the harness's "continue as if the break never happened", and the rule named only a turn opening on one | wei-lin | landed (this PR): a summary at a turn's start or mid-turn is past the cap, no next step, an in-flight task's included (fixture wei-013) |
| 10-11 | self | usage: P14 main session at 626k context | none | noted: main-session, no prompt governs; waste report-back |
| 10-12 | P13 | recurrence after the 10-03 landing: "two audit rounds and clean up" got a round 2 on one commit's delta, a MINOR inside scope left on the follow-up list, and "clean up" answered "already clean" | wei-lin | landed (this PR): the verb rule now lives in the conductor's own prompt: each owner verb ends in a landed action or a named reason it is empty, quoting the check; a MINOR inside it is fixed; a second round reads the whole surface (fixture wei-015) |
| 10-12 | P13 | round 1 called a cited "rule 151" a typo without opening the rule book (it cited line 151, under another rule); the conductor applied the change unopened | zofia-kaminska, victor-reyes, wei-lin | landed (this PR): a rule number or file:line is opened and quoted before it is called a typo, and before a fix to it counts as self-verified |
| 10-12 | P16 | a minor release gated on the fast tiers though the rule book requires the full tier; an end-to-end test broke on a column that release added | haruto-nakamura | landed (this PR): the tag waits for the tier the rule book names for a release (full unless it says otherwise), its summary line quoted under that tier's name; a faster tier never stands in. The pre-tag audit half not landed: the tier-named quote is the check |
| 10-12 | P16 | an output count carried through two release records was never re-derived; the fresh clone produced one fewer, by design | haruto-nakamura | landed (this PR): a count in the note is re-derived on that SHA with the command that produces it, or dropped |
| 10-12 | self | usage: P12 main session 12M with zero commits, no subagent spend | none | noted: main session, no prompt governs; waste report-back |
| 10-12 | self | usage REPEAT: P14 main session at 650k context (626k on 10-11), no subagent spend | none | noted: main session, no shipped prompt governs; waste report-back |
| 10-12 | P13 | told to clear the board, a conductor reported two rows owner-gated whose decision the board's owner-decisions header already recorded; the rows' state cells were never updated | wei-lin | landed (this PR): a row is owner-held only once a grep of the board's recorded owner decisions for its subject finds none; one on record routes it to `zofia-kaminska` to close |
| 10-12 | P20 | recurrence after #112 (wei-005): a report called the merged branch "cleaned by the merge flow" while it stayed on the remote | wei-lin | landed (this PR): item 3's listings run after the last merge and are pasted, a merge's `--delete-branch` being no evidence; fixture wei-005 already reproduces it |
| 10-12 | P24 | recurrence after the 10-03 and 10-05 rows: a "queue exhausted" summary left an open P2 row with no blocker out entirely | wei-lin | landed (this PR): item 4 counts every open row against a grep of the board, a row with no blocker and no dispatch being workable; fixture wei-016 |
| 10-12 | P24 | recurrence after the 10-08 P02/P20 rows: with every workable row closed a conductor cut no tag, "a clear board isn't an owner-approved release boundary" given as the stated blocker | wei-lin | landed (this PR): a stated blocker is a failing gate or a grant the rule book withholds, the cycle being unattended scope; a merge policy silent on tags leaves patch and minor pre-authorized; fixture wei-016 |
| 10-12 | P24 | handoff carried two-day-old "still running, do not kill" entries with no liveness check | wei-lin | landed (this PR): a "still owns" entry carries its PID or agent id and date, re-checked by `ps` and the worktree list at each handoff or struck |
| 10-12 | self | usage: a P02 wei-lin run at 162 calls/22M; a P22 general-purpose run at 80 calls/8M on specialist work (second window after 10-09); an unaliased project's main session at 455k context | wei-lin, none | noted: none flagged REPEAT by the report; the conductor's ~100-call cap and the 40-call general-purpose brief already govern, the main session no prompt; waste report-back |
| 10-13 | self | usage REPEAT, owner-flagged (fourth window after 10-08, 10-10, 10-12): general-purpose doing specialist work in P22 (30 calls, at the threshold) and P06 (63 calls), both dispatched by a conductor; each brief asked it to read the sources and decide where a guard belonged, one with no cap, one 63 calls past a 40-call cap | wei-lin | landed (this PR): a final design names every file it touches and leaves nothing to derive, confirm or choose; a read-then-decide brief is a design mission for the specialist; the cap is 30 calls, the usage report's own threshold; fixture wei-017 |
| 10-13 | P05 | recurrence after the 10-03 P16 and 10-09 P13 rows: a board/rules writer dispatched without worktree isolation edited the main checkout while the conductor switched branches in it | wei-lin | landed (this PR): Hand-offs names every writer, a board, rules or log edit included; fixture wei-004 already reproduces the isolation miss |
| 10-13 | P20 | a numeric-guard change gated on a smoke tier whose cases all stayed under its threshold, 4/4 identical before and after; a downstream case broke on merge | wei-lin | landed (this PR): for a guard on a value the tier's cases reach both sides of its limit, the extreme grepped and quoted, identical green before and after being the sign it never crossed |
| 10-13 | P20 | an engine patch tag cut with no technical-audit quote the day the audit rule landed; "bit-identical" asserted for a raise-instead-of-extrapolate change from the parity set alone | haruto-nakamura, wei-lin | dismissed: the audit half is 1A (10-11), the tag predates its install; the bit-identical half folded into the threshold row above |
| 10-13 | P02 | a release audit searched for a file with `find /` on a shared network mount; the scan ran 41 min, outlived the agent's turn and held a worktree lock | victor-reyes, all | landed (this PR): every agent's tool economy: a search stays inside the repo or worktree, never `/`, home or a mount, and no command it starts outlives its report |
| 10-13 | P18 | a conductor reported a row blocked whose blocker its passing acceptance test had satisfied, then closed rows herself; a path guard deny-listed release notes only | wei-lin | dismissed: covered, a stated blocker is a failing gate (#131), lifecycle changes go to zofia (10-07 P20), an allowlist exempts citations, never a path (10-11 P18) |
| 10-13 | consilium | v1.29.1 audit: victor's decision tree has no branch for an unavailable Agent tool | victor-reyes | dismissed: covered, its cardinal rule (10-10) applies to every branch: with no Agent tool it says so on line 1 and lists each specialist its dispatcher must run; no edit, so no two-sided fixture gates one |
| 10-13 | consilium | v1.29.1 audit: wei-010's third must_not_find guard ("merging PR #22 now") trips on "I am not merging PR #22 now" and never matched the fail sample | iris-vermeulen | landed (this PR): replaced by the fail sample's command fused with what it skips to; a refusal probe passes, the fail sample still trips |
| 10-13 | self | usage: P02 main session at 455k context; P19 main session at 370k and a wei-lin run at 141 calls/21M; P06 general-purpose 7M (row above) | wei-lin, none | noted: main sessions, no prompt governs; the conductor's ~100-call cap already governs the 141-call run; waste report-back |
| 10-13 | P21 | recurrence after the 10-03 P16 and 10-10 P21 rows (wei-009): a conductor committed a one-line queue edit in the owner's main checkout and ran a push naming the default, self-reported | wei-lin | landed (this PR): a commit is made only in the conductor's own worktree on a feature branch, the main checkout getting reads and `git pull --ff-only`, never `checkout -b`, `commit` or `push`; fixture wei-018 |
| 10-13 | self | usage, recurrence 4 h after #136 went live: two P21 general-purpose builds dispatched by a conductor ran 84 and 55 calls; both briefs capped them at 30 calls "without landing", and one asked it to confirm a loader's behaviour before building | wei-lin | landed (this PR): the 30-call cap is a stop landed or not; the read-then-decide brief was already barred by #136; wei-017 gains the cap criterion |
| 10-13 | self | usage: the same P21 conductor ran 143 calls/16M, a mid-turn context summary at call 70 followed by 76 calls of new work, the default-branch push among them; third window running with a conductor past 120 calls since wei-013 landed (10-11) | wei-lin | noted: wei-013 already states it; a third text edit is not landed, owner decision on a mechanical stop |
| 10-13 | P21 | a conductor committed a one-line queue edit in the owner's main checkout and pushed it to the default branch; proposed a pre-push branch-name refusal in her merge step | wei-lin | dismissed: covered, the incident wei-018 reproduces (#137); the commit predates that merge by 40 min, every later default-branch commit carries a PR, and `git push` naming a feature branch, never the default, is already her text |
| 10-13 | P21 | a build specialist left a kept training dataset partly linked into session scratch; the conductor reported it landed and listed no scratch to reap | wei-lin | landed (this PR): the merge gate finds no link in a kept artifact resolving outside the project root (`find -type l` + `readlink -f`), and the scratch it was built in is a "still owns" line until reaped; paid by cutting the dirty-close rationale |
| 10-13 | self | usage: P02 main session at 626k context; P25 main session at 465k; neither flagged REPEAT by the report | none | noted: main sessions, no prompt governs; waste report-back |
| 10-13 | P22 | given an unreadable /autopilot budget, a conductor returned a refusal memo after one tool call and spent nothing | /autopilot | landed (this PR): an unreadable budget runs as `until the board is green`, the brief saying so, never a refusal memo; first report, no fixture (rule 10) |
| 10-13 | P22 | the same memo called four owner decisions open BLOCKED(owner) rows "confirmed by grep" with no grep run; the board held one, unrelated | wei-lin | landed (this PR): the BLOCKED(owner) grep's count is quoted, and a check not run this run is never cited |
| 10-13 | P22 | the memo escalated a missing CI as needing an owner-named substitute gate, though /autopilot already names it; her own clause read "an owner-named tag gate stands in for CI" | wei-lin | landed (this PR): that clause names the no-CI substitute, the full tier on the exact SHA plus the stranger clone, never an escalation |
| 10-13 | self | usage: P24 general-purpose doing specialist work, 1 run/3M at 40 calls, first flag | wei-lin | noted: not REPEAT; a conductor's 30-call general-purpose stop (#136, #137) already governs; waste report-back |
| 10-13 | self | usage REPEAT: P02 main session at 642k context (455k and 626k in earlier windows today), no subagent spend | none | noted: the only shipped text on a main session's context is /autopilot's ~200k hand-off, and this session dispatched no agent; no shipped prompt governs it; waste report-back |
| 10-14 | self | usage REPEAT, recurrence after #136 and #137: P24 general-purpose doing specialist work, 7 runs/63M with one at 137 calls; P03 3 runs/15M, first flag. Every run was dispatched by a conductor on the post-#137 prompt, not by a main session, so shipped text governs: 10 of the 11 briefs past 30 calls carried no cap, and the 11th wrote "30-call budget, keep it tight" after a "confirm the design fits" step and ran 77 | wei-lin | landed (this PR): the brief's first line is the verbatim `Stop at tool call 30, landed or not`, grepped for before the call, a "budget" never standing in; a brief asking it to confirm is a design mission; fixture wei-017's cap criterion now needs the verbatim line. Not landed: a mechanical stop, since a brief is the only lever a prompt holds over a general-purpose run and the one capped brief ran past it; owner decision |
| 10-14 | P24 | a conductor routed a judgment-bearing filter fix and its regression test to general-purpose, the project's rule book reserving that class for a named specialist | wei-lin | folded into the row above: the same run as the 10-13 P24 usage row, already barred by #136 (a candidate fix goes to the domain specialist) |
| 10-14 | P24 | recurrence after #136 (the 10-13 P05 row, after the 10-03 and 10-09 rows): one conductor dispatched three board writers without worktree isolation in one night, one brief saying "own worktree" in prose | zofia-kaminska, wei-lin | landed (this PR): a writer briefed with a branch or HEAD checks before its first edit, and in the main checkout writes nothing and returns the edit as a diff; fixture zofia-005 |
| 10-14 | P24 | on ENOSPC a conductor blamed a subagent's search and called itself dead without checking the disk; a test fixture copied the repo, a large ignored cache included, into the test temp dir every run and filled a shared disk | wei-lin, iris-vermeulen | landed (this PR): on ENOSPC `df` and `du` on the temp roots before any cause is named; a test that copies the repo copies tracked files only and asserts the copy's size bound; first report, no fixture (rule 10) |
| 10-14 | self | usage: P24 anya-petrov at 208 calls/19M, first flag; P24 wei-lin at 124 calls/15M and 124/14M | anya-petrov, wei-lin | noted: anya's tool economy already says checkpoint and stop past ~120 calls, no edit on a first flag; the conductor's ~100-call cap governs, a mechanical stop still the owner's decision (10-13 row); waste report-back |
| 10-14 | self | usage REPEAT, recurrence after #137 (wei-013): P24 conductor at 124 calls/15M; its 185-call run took context summaries at calls 61 and 121 and dispatched new work after each, obeying the harness's "Resume directly — do not acknowledge the summary" over the cap; P03 conductor at 134 calls/16M, first flag, the run inspected the same shape (a summary at call 46, 63 calls after it) | wei-lin | landed (this PR): the summary's "Resume directly", "do not acknowledge the summary" and "Pick up the last task" lines are named as the harness's, never the invoker's, and her first words after one name it; wei-013's input now carries the literal line |
| 10-14 | self | usage REPEAT: P24 general-purpose doing specialist work, 4 runs/21M; the 148-call run started before #140 merged, the two after it (45 and 42 calls) were design-final builds whose briefs opened with the verbatim stop line | wei-lin | noted: #140 held on the conductor side; the overrun past 30 is general-purpose's own and no shipped prompt governs it; no wei-017 criterion, the conductor's brief is the passing one; waste report-back |
| 10-14 | self | usage: P03 mira-volkov at 212 calls/21M, first flag | mira-volkov | noted: first flag, no edit (rule 10); waste report-back |
| 10-14 | P24 | a writer dispatched with worktree isolation was placed in the main checkout; it detected that before its first edit and returned a patch | zofia-kaminska, wei-lin | dismissed: covered, the writer-side check #140 landed (zofia-005) caught it as designed; a conductor cannot poll while a foreground child holds her turn, and her handoff re-check already runs `git worktree list`; a harness defect |
| 10-14 | P24 | the refactoring agent declined a design-final wiring of a built function into a new call site, one call each, twice in one campaign; the conductor re-routed to general-purpose both times | kai-fischer | landed (this PR): its description says it adds no behaviour, wiring a built function into a call site that does not call it yet being a build, so the conductor's design-final route sends it on the first dispatch; first report, no fixture (rule 10) |
| 10-14 | P03 | recurrence after the 09-30 P05 row: a conductor kept a per-tick watcher on a training specialist that owned its own completion monitor, ~8 no-op wakes in ~1 h at ~130k context each | wei-lin | landed (this PR): a monitor of hers wakes her on a state change or its deadline, never per tick, and a child that owns its completion monitor gets none of hers; fixture wei-019 |
| 10-14 | P24 | a conductor recycled at its cap with two live specialists; their completion notices resumed it and it merged a landing after its successor owned both missions, forcing a release-SHA re-freeze | wei-lin | landed (this PR): a turn resumed past the cap or after her run ended merges nothing, a child's finished landing included, and logs its branch and SHA for the successor; first report on this channel (the 10-07 fix covered the invoker's relay), no fixture |
| 10-14 | P24 | third instance of the refactoring agent declining a first-time wiring task, re-routed to general-purpose | kai-fischer | noted: filed minutes after #144 put that boundary in its description, from a session that loaded the earlier one; no new edit |
| 10-14 | self | usage REPEAT, recurrence after #144 (and #137): P03 conductor at 123 calls/13M, a mid-turn context summary at call 62 followed by 59 calls of new work, its prompt snapshot carrying #144's "first words after it name it"; not the recycle channel above | wei-lin | noted: the third text edit on this failure did not hold on its first post-fix run; a mechanical stop at a context summary is the owner's decision (10-13 row); waste report-back |
| 10-14 | self | usage REPEAT: P24 general-purpose doing specialist work, 9 runs/77M, one at 200 calls; every brief past 30 calls carried the stop line, 3 not as the first line | none | noted: the overrun past 30 is general-purpose's own (the #140 ruling); waste report-back |
| 10-14 | P13 | a conductor briefed general-purpose with a specialist's code change; it ran uncapped in the main checkout and the conductor had to restore it | wei-lin | dismissed: covered, a specialist-owned job never goes to general-purpose and the stop line opens its brief (#136, #140), and every brief carries the verbatim worktree-only line |
| 10-14 | P05 | a release note shipped inside the tag with four errors (wrong tag-target SHA, the prior commit's gate results, a wrong diffstat, a docs update that never happened), found by the release agent after the push; the audit verdict it cited lived only in the conductor's transcript | haruto-nakamura, wei-lin | landed (this PR): before the tag command the note is re-read against that SHA, every SHA, count and diffstat pasted from a command run on it and every claimed doc update in its `git show --stat`; the conductor puts victor's report text in the release brief; first report on note content (the 10-11 P18 rows covered the gate SHA), no fixture |
| 10-14 | P05 | a publication scrub dispatch ran ~196 calls over two resumes; its new guard compared HEAD to the working tree and could never go red once committed | anya-petrov | landed (this PR): a scrub guard is shown red on a planted leak in a scratch commit before it is reported done; first report, no fixture. Noted: the call overrun is the second anya flag (10-14 P24 usage row), her ~120-call checkpoint governs, and never resuming a finished agent is already the conductor's rule |
| 10-14 | P05 | a physics investigation went to general-purpose because the costliest specialist needs per-dispatch owner OK | wei-lin | dismissed: covered for a conductor, a diagnosis goes to the domain specialist (`rafael-santos` named), never general-purpose; the dispatcher is not named, and a main session is governed by no shipped prompt |
| 10-14 | P20 | a conductor's hand-off dropped two of three seeded brief items without listing them as deferred; a merged source change had no tag and no `no milestone, because` line; she edited the board in the main checkout twice and caught it both times | wei-lin | landed (this PR): the end report carries one line per seeded brief item, done, deferred (why) or blocked; first report. Noted: the missing milestone line recurs after the 10-08 and 10-09 rows (fixture wei-003); the board edits were caught before commit, rule 20 item 1 already bars them |
| 10-14 | self | usage REPEAT, recurrence after #140: P24 general-purpose past 120 calls (134) and doing specialist work (4 runs/43M). The three long runs were dispatched by one conductor started after #140 merged; none of the three briefs opened with the stop line, one carried it nowhere (145 calls), two carried it lower (114, 115), and no grep ran before any call | wei-lin | landed (this PR): the stop line moves into the brief template every brief is built from, the routing paragraph pointing to it. Noted: the fourth text edit on this failure; a mechanical stop (a hook refusing a general-purpose call whose prompt does not open with the line) is the owner's decision; waste report-back |
| 10-14 | self | usage: P24 conductor at 138 calls/15M, first flag this window | wei-lin | noted: first flag, the ~100-call cap and #145's resumed-past-cap rule govern; waste report-back |
| 10-15 | self | usage REPEAT carry-over from the 10-15 03:43 pass: a P24 conductor started after #146 opened a general-purpose brief with "Stop at tool call 60"; that run went to 148 calls, the fifth failure of the text fix | wei-lin | noted: the mechanical stop is the owner's decision; folded into the "never raised" clause two rows down |
| 10-15 | P22 | the release agent wrote its note into a project root whose whitelist excludes it and pushed it straight to the default branch, though every prior commit there landed through a PR; its rules check ran before the note existed | haruto-nakamura | landed (this PR): the note goes where the root whitelist puts notes, its path re-checked once the file exists, and the release commit goes through a PR where `git log` shows the project lands that way; second report after the 09-29 P13 row (deferred, no fix landed), no fixture; landed over the agent-refinement owner's objection that no single-shot fixture reproduces it |
| 10-15 | P22 | a conductor escalated an environment-strategy question to the owner on a library-mismatch cause that one command with the reader's own tool would have falsified, never run, citing a pre-failure warning as the cause | wei-lin | landed (this PR): an owner question rests on a cause one command run this run failed to falsify, its first fatal line quoted; first report (the 10-09 P12 row covered checkable facts marked BLOCKED), no fixture |
| 10-15 | P24 | a general-purpose run briefed "Stop at tool call 40" ran 105 calls and self-reported the miss after a mid-task context summary | wei-lin | landed (this PR, with the usage row below): the number is 30, never raised; the overrun is general-purpose's own (the #140 ruling), and a checkpoint count inside the child is no consilium surface |
| 10-15 | self | usage REPEAT: P24 general-purpose doing specialist work, 7 runs/60M, one past 120 calls (139); all seven dispatched by one conductor started after #146, none opening with the stop line (it sat 171 to 3,428 characters in), one raising it to 40 (106 calls); the sixth failure of the text fix | wei-lin | landed (this PR): one clause, at no line cost, the number is 30, never raised. Noted: the line not first repeats the #146 template miss; a mechanical stop is the owner's decision; waste report-back |
| 10-15 | self | usage: P22 general-purpose doing specialist work, 2 runs/6M (35 and 40 calls), first flag; both conductor briefs opened with the 30-call line; both were re-runs of an existing pipeline | wei-lin | noted: first flag; re-runs already go to the surface owner and the overrun past 30 is general-purpose's own; waste report-back |
| 10-15 | self | usage: P15 general-purpose doing specialist work, 1 run/3M (35 calls), first flag; the conductor's brief carried no stop line | wei-lin | noted: first flag, a breach of the template line #146 placed; waste report-back |
| 10-16 | P20 | REPEAT after #111: a conductor squash-merged two docs-plus-script PRs under a merge-commits-only rule book; the fast lane passed the method, but the landing step still read "Squash-merge" | wei-lin | landed (this PR): the landing step merges with the rule book's method flag, read before the run's first merge, never the default; fixture wei-003 now touches a script so it reaches that step |
| 10-16 | P15 | an audit's docs specialist claimed a model builder did X, citing a line in a different script; the orchestrator refuted it from the builder's own output metadata before it reached the conclusions | sophia-okafor | landed (this PR): a "the code does X" claim about an artifact cites the line in the code path that built it, a line from another script never standing in; the orchestrator side worked as designed; first report, no fixture |
| 10-16 | P17 | a citation check given local full-text PDFs graded three claims PARTLY, two from an abstract or excerpt only, and listed an uncited bib key as validated | ziyan-chen | landed (this PR): every cited paper is read in full when a local PDF is given; a verdict short of verified quotes the page or says ABSTRACT ONLY; the cited set is the `\cite` keys, never the bib. Extends the 10-03 NOT SUPPORTED rule and the 10-06 tally rule to a new verdict and a new set; first report of each, no fixture |
| 10-16 | P05 | REPEAT after the 10-03 /autopilot landing and wei-015: a conductor given "refactor round" read it as authorising only a two-line follow-up decided the cycle before, did no refactor work and asked the owner to name the next row | wei-lin | landed (this PR): a verb naming no target means survey the project for that verb's work and do it, an earlier-scoped item or a "name the next row" question never narrowing it; fixture wei-020 |
| 10-16 | self | usage: P24 general-purpose doing specialist work, 7 runs/29M; 8 runs past 30 calls, all dispatched by conductors started after #147; 5 briefs opened with the stop line (32 to 42 calls), 3 put a project header above it (at 143 to 398 characters; 43 to 70 calls), one lowering it to 25 | wei-lin | landed (this PR): one clause, no line cost, the stop line is the brief's first line, above any project or repo header. Noted: the template held in 5 of 8, against 0 of 7 the window before; the overrun past 30 is general-purpose's own (the #140 ruling); a mechanical stop is the owner's decision; waste report-back |
| 10-16 | self | usage: P25 zero-commit spend 7M and main context peak 484k, spent in the main session with no subagent | none | noted: a main session, no shipped prompt governs (the 10-13 row); waste report-back |
| 10-17 | P24 | two general-purpose runs briefed with the 30-call stop line as their first line ran 44 and 41 calls; one committed past the cap, the other stopped before committing | wei-lin | folded into the usage row below: both dispatched by one conductor started before #151 installed, both briefs opening with the line; the overrun is general-purpose's own (the #140 ruling); a harness-enforced stop is the owner's decision |
| 10-17 | P24 | REPEAT after the 10-14 summary rows (wei-008, wei-013): a conductor ran 159 calls across two context summaries, merging and dispatching after each and past ~100, naming the cap only at call 157 | wei-lin | noted: the rule and both fixtures exist; the harness's resume line again outranked the text, the seventh text failure on this cap; a mechanical stop is the owner's decision, no further text edit |
| 10-17 | P24 | a successor conductor ran 117 calls; its audit specialists ran 50 to 99 calls against a 30-call line its invoker relayed for every brief | wei-lin | noted: the conductor's ~100-call cap governs; the specialists stayed under their own ~120-call stop, the 30-call line being shipped for general-purpose only |
| 10-17 | P24 | a conductor sent a three-line loader registration to the porting specialist, briefing it as a "parity/row-conservation job" (60 calls, uncommitted), and dispatched before committing the scoping note the brief told it to read | wei-lin | landed (this PR): the roster line says the porting specialist ports against a reference implementation, a loader or wiring build framed as parity being no port; the uncommitted-note half is covered (untracked files are invisible to a worktree, so commit what missions read); first report, no fixture |
| 10-17 | P24 | after two worktree-isolated children returned clean branches, the main checkout held stray edits matching their files; the conductor diffed them against the branches and restored path by path | wei-lin | dismissed: covered, the returning-mission `git status --porcelain` on the main checkout and the diff-before-removal rule worked as designed; the isolation leak itself is the harness's, no consilium surface |
| 10-17 | self | usage REPEAT: P24 general-purpose doing specialist work, 2 runs/8M (41 and 38 calls); one dispatched by a conductor started before #151 installed (21:49), one after; both briefs opened with the verbatim stop line | wei-lin | noted: not a failure of #151, which held in both; the overrun past 30 is general-purpose's own (the #140 ruling); a mechanical stop is the owner's decision; waste report-back |
| 10-17 | P01 | the audit skill told its router to write a dated report file into the project; the owner's standing rule is no audit files, and every audit left another document | /audit, victor-reyes | landed (this PR): findings come back in the final message and no file is written, unless the rule book names where audits go or the user asks, then an existing master document before a new file; extends the 09-24 P01 row (location) to existence, first report of it; no fixture, a graded report cannot show a file was not written |
| 10-17 | self | usage: P03 general-purpose doing specialist work, 1 run/3M (39 calls), first flag this window; its brief opened with the verbatim 30-call stop line | wei-lin | noted: the line held; the overrun past 30 is general-purpose's own (the #140 ruling); a mechanical stop is the owner's decision; waste report-back |
| 10-17 | owner | run folders were named by date and board rows had no ID convention, so projects drifted (expNN, P1.5-style IDs that read as priorities) | zofia-kaminska | landed (this PR): `runs/expNNN<v>_<slug>/`, a rerun or tweak takes the next variant letter and only the owner opens a new NNN; board row IDs are 1, 2, 3 with 1a, 1b sub-rows, never reused, renumbered or priority-shaped; net 0 |
| 10-17 | owner | consilium's own board still keyed rows `PF-NNN`, the shape zofia-kaminska's rule 12 now forbids in every project it seeds | PATHWAY_FORWARD.md, tests/ | landed (this PR): rows are `1`, `2`, `3` (PF-006 → 6, no number changes), header notes the old spelling; live references follow, history untouched; the board parser emits every row and Check 12 now reddens on a malformed or reused id instead of skipping it; agents/+commands/ net 0 |
| 10-17 | P21 | a variant carried an extra transform, clamp or constant beside the one change the owner asked for (~4×) | dunyu-liu, wei-lin | landed (this PR): no scope expansion inside the feature either, an extra offered as an option, never built in; the conductor's brief template carries the same line |
| 10-17 | P21 | a comparison picked each arm's best checkpoint or window | dunyu-liu | landed (this PR): one a-priori rule chooses every compared arm's checkpoint or window, never best-per-arm |
| 10-17 | P01 | a change made a board row or rule false and left it so | wei-lin | landed (this PR): the change updates it in the same PR, or asks its owner that turn where the write is not the conductor's |
| 10-17 | P15 | changes awaiting the owner went out one PR each (2×) | zofia-kaminska | landed (this PR): starter invariant 13, changes awaiting the owner ride one PR |
| 10-17 | P01, P15 | owner decisions ended a reply as prose, so "make this item" matched none and the wrong item was built (also filed in the P01 inbox) | zofia-kaminska | landed (this PR): the seeded `CLAUDE.md` conventions carry the Needs-you shape, numbered with lettered options and one recommended, so it reaches every session, not only `/brief`; reaches an already-seeded project at its next seed pass |
| 10-17 | P21, P24 | runs and board rows named by bare ID, glossed on first mention only or never; two owner corrections in a day | /brief | landed (this PR): no bare run or row ID, glossed at every mention, tables and options too |
| 10-17 | P21 | a one-change variant got the next fresh experiment number instead of the baseline's plus a letter | zofia-kaminska | dismissed: covered, 1438d35 (#154) run naming |
| 10-17 | P21 | an owner-supplied run ID collided with a running experiment; the session named the clash and used the rule's ID | zofia-kaminska | dismissed: worked as designed under 1438d35 (#154) |
| 10-17 | P24 | the board keyed rows by spreadsheet letter codes the owner could not read | zofia-kaminska | landed 1438d35 (#154) for row IDs 1, 2, 3; the gloss half lands above; an old-code alias column for a board already on codes deferred, first report |
| 10-17 | P24 | REPEAT: two agents briefed "stop at tool call 30" ran 60 (uncommitted) and 34 | wei-lin | noted: the conductor already reads call counts from the completion notice, never the self-report; a harness-enforced stop is the owner's decision |
| 10-17 | P24 | recurrence after the 10-03 P05 and 10-07 P02 rows: a conductor held relayed owner directives as uncited and called the invoking session's board commit recording them verbatim circular | wei-lin | landed (this PR): the invoking session's own commit is the citation, never circular; fixture-eligible under rule 10, deferred to the owner |
| 10-17 | P24 | two parallel specialist branches each added a regression test under the same number | wei-lin | landed (this PR): each parallel brief reserves its own number for any numbered file it adds |
| 10-17 | P24 | completion notices from earlier cycles were listed as open unverified tasks | wei-lin | landed (this PR): a notice older than the run is checked against the default branch and logged, never re-queued |
| 10-17 | P15 | briefed four owner-assigned items in one PR, the rules enforcer delivered the rule text and routed the file moves, scripts and check as outside her surface, after 73 calls | zofia-kaminska | landed (this PR): her description says up front that moving, deleting or pruning files and writing scripts go to another agent, so the dispatcher briefs those elsewhere |
