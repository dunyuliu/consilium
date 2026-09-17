# Session log — 2026-09-16/17 — autopilot campaign (compressed)

**Compressed 2026-09-17 under the session-log end-of-life path.** This file was
2,765 lines. Every finding below whose lesson landed in a rule, a check, a
prompt or a board row is reduced to one line naming where it landed; the
reasoning that produced it is in the artifact, which is the thing that is read.

**Nothing is destroyed.** The full narrative is in git history at `9dcd1e8` —
`git show 9dcd1e8:docs/SESSION_LOG_2026-09-16_pf-003-first-real-dispatches.md`. A session log's job is to carry a lesson until the lesson
ships. Once it has, the log is a transcript, and a transcript belongs in
history rather than in the working tree.

**The mechanism, so this is a path and not a one-off.** A session log is
compressed when the release that carries its findings is cut. Each finding
becomes one line plus where it landed; findings that landed nowhere stay in
full, because those are still status rather than history. The compression
commit names the SHA holding the full text. Release notes are exempt — rule 8
governs those and is not in scope here.

## What this campaign produced, by artifact

- **Rules**: 8a, 9a, 15a, 15b, 18a, 18b, 25d, 25e, 26, 27 (index 27 -> 45 rows)
- **Checks**: 29 -> 35; Check 35 (tag has note AND Release) and its newest-tag grace
- **Prompts**: `wei-lin` (lock window, push-with-commit, remote-before-quoting,
  signal-removal gate, tree-check after interruption), `zofia-kaminska`
  (Mode C narrowness; :513 disambiguation), `iris-vermeulen` (measure before
  removing a signal), `lian-zhao` (fixture-ownership contradiction)
- **Board**: PF-003 closed after never narrowing; PF-009 closed after six weeks;
  PF-019/020/021/022/023/024/026/027 closed; PF-025/028/029/030/031 opened
- **Release**: v1.21.0, CI green on the tagged SHA, stranger-clone 1546/0

## Findings index

- Findings this session paid for
- Finding 5 — the gate reddens for the duration of any worktree-isolated dispatch
- Finding 6 — one weak criterion in a fixture landed this session, flagged not blocked
- Finding 7 — PF-003's detector now misreports the majority of what it counts
- Finding 8 — a subagent's closing claim about the lock was false
- Finding 9 — the board owner overrode her own row's instruction, and was right
- Finding 10 — `tests/lock.sh` does not work from a worktree, which explains finding 8
- Finding 11 — both test-tooling defects fixed, and re-verified independently
- Finding 12 — the three fixtures written today were dispatched the same day, and two of them grade badly
- Correction — I repeated an unverified mechanism for STALE, and it is wrong
- Finding 13 — STALE has a day-granularity blind spot, and it is live today
- Finding 14 — a criterion repair crossed the bar instead of moving it, and the gate caught it
- Finding 15 — the re-run scored WORSE, and the fixture is measuring the wrong thing
- Finding 16 — the interruption did not break the lock; the working pattern did
- Finding 17 — PR #19 merged a stale snapshot, because I pushed once and kept committing
- Finding 18 — what one missing push actually cost, counted
- Finding 19 — I cannot reliably tell my own prompt from the project's CLAUDE.md
- Finding 20 — the adjudicator's proposed fix, verified by execution, and my own near-miss
- Finding 21 — two agents disagreed on how to handle a split, and the synthesis is the useful answer
- Finding 22 — my brief contained a contradiction, and the agent obeyed the boundary rather than the instruction
- Finding 23 — "push in the same action that commits" and "nothing red is pushed" collide mid-chain
- Finding 24 — the `:513` disambiguation is verified by dispatch, not assumed
- Finding 25 — rule 25d's first real application, and it held
- Finding 26 — a correct-sounding design choice that discarded fourteen true positives
- Finding 27 — the hybrid landed, and the agent re-derived the measurement before trusting it
- Finding 28 — the near-miss is being written where it ships, not where it is merely recorded
- Finding 29 — three false negatives from over-narrow patterns, all mine, all in one day
- Finding 30 — the lesson shipped in three places, and the agent who landed it named what was still missing
- Finding 31 — rule 18b deadlocks, and I found it by obeying it
- Finding 32 — where the codify-caution goes, and why not a rule
- Finding 33 — the fixture built to teach rule 26 failed its own first real dispatch, on phrasing
- Finding 34 — rule 25d made prompt edits expensive, and a board row turned that into a gate failure
- Finding 35 — the fix was instance-level; the class survived, and I found it by finishing the test
- Finding 36 — the class fix holds, verified on an agent nobody mentioned
- Finding 37 — I nearly accused an agent of fabricating work, and the fault was my dirty index
- Finding 38 — the criterion repair held against text it had never seen
- Finding 39 — two independent runs converged on a remedy the criterion rejects
- Finding 40 — the adjudicator corrected me, and the correction was checkable
- Finding 41 — the repaired criterion grades the act, not the reasoning about it
- Finding 42 — the codify-caution is demonstrated, not asserted
- Finding 43 — the repaired criterion grades an act the fixture forbids, and I approved it
- Finding 44 — PF-009's audit found one drift, in my own prompt, and two agents appeared to disagree about it
- Finding 45 — the drift fix, and a bounded answer on mechanizing it
- Finding 46 — the stranger-clone gate passes, and the number a stranger sees is not the number we quote
- Finding 48 — the remote incident: read-only did not survive two hops, and I own it
- Finding 49 — `install.sh` is an unowned surface, found by trying to route a fix at it
- Finding 50 — the gate blocked its own repair, and the maintainer paid for it
- Finding 51 — rule 8 makes an accidental note permanent
- Decision recorded — local hook enforcement comes out, AFTER the release
- Correction to the hook decision — my recorded framing was wrong
- Finding 52 — a guard present for the compliant and absent for the non-compliant
- Finding 53 — the document that says what this project is for is the only one that can lie unnoticed
- Finding 54 — three deadlocks in one day is a property of the machinery, not bad luck
- Finding 55 — with the hooks gone, a staged deletion of this entire log nearly committed

## Still status, not history

These landed nowhere yet and are the live tail of the campaign:

- **PF-025** — `zofia-004`'s criterion 3 is unfixable by substring matching; a
  named limit, not a gap.
- **PF-028** — `install.sh` installs zero hooks from a linked worktree. Retired
  in effect by the hook removal; it describes the mechanism by which the control
  was inverted rather than a bug to repair.
- **PF-030/031** — the hook's ref-deletion bypass, and Check 28's paperwork
  enforcement for rule 8a.
- **Rules 9, 15a, 18's lock** rest on hooks that no longer exist and become
  obligations on the agent. The tree-check discipline belongs on that list and
  was not on it — see the finding on the staged deletion.
- **Trustworthiness is 30%** and that is the ceiling of a soft measure, not a
  backlog. Dispatching prose to a live agent and grading substrings cannot do
  better; the apparatus should be sized to that, which is what the leanness
  pass is for.
