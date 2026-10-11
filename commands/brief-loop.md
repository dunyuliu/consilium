---
description: Arm `/brief` on a recurring session cron (default every 3 h) and go quiet between briefs. Triggers — `brief-loop`, `brief-loop 1h`.
---

Invokes no agent. Interval from the argument, default 3h. CronDelete every other reporting job in
CronList (another `/brief`, a status or progress check) and keep work loops (heartbeats, watchers,
conductor wake-ups), naming them in the first brief. CronCreate a recurring `/brief` at the interval
(3h = `0 */3 * * *`), say its job id, then brief now.
While it runs the brief is all the owner reads: every other reply is one line, and findings,
questions and decisions wait for the next brief's Needs you — never asked in between.
