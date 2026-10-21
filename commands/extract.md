---
description: Extraction-first autopilot — keep a data-extraction job running for the stated budget, with infrastructure work only beside it, never instead of it. Triggers — `extract <budget> [scope]`, e.g. `extract 10h`, `extract 8h Legs 166-210`, `extract DSDP01`.
---

Invoke `wei-lin` by agent type, with a brief whose **queue item 1 is a running extraction job**, started within her first 10 calls and kept running for the whole budget. Scope comes from the argument; with no scope, it is the board's next unprocessed reports. Fixes, merges and hygiene run beside that job, never in front of it. A branch that blocks extraction is fixed only as far as needed to unblock it.

**Before seeding:**
- Commit every owner directive verbatim to the board.
- Cite that commit's SHA in the brief. An uncited relay is refused.
- The brief carries only state she cannot find: running jobs, what was measured, and pending owner decisions.

**What extraction means:**
- Deterministic code first (the fastpath) over the whole scope, under `nice -n 19` with 4 CPUs free.
- Agents only for what code flags, at most 2 at once.
- Scanned or raster tables go to Claude tier-3 crop reads (k-of-5) immediately. An OCR tool is a second reader for agreement, never a prerequisite.
- New values go to staging. They are promoted only through the gate.
- Re-running already-processed reports and comparing them (matched, missing, new, coverage, time) counts as extraction work, and it comes first when the workflow has changed.

**Every tick, this session:**
- Read the per-report-hour throughput log.
- Treat an hour with zero new values as a stall: redirect her at once and file it in the consilium inbox.
- Mark her numbers unaudited until audited.
- Relay every specialist completion to her.
- Recycle her at about 100 calls, seeding the new conductor from the board.

**Each brief reports:** reports processed, values extracted (staged and released), coverage, and values per hour, against the last brief.
