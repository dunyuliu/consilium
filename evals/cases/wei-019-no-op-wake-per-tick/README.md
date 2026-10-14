# wei-019 — a watcher that wakes per tick is a no-op wake

A conductor has dispatched a training specialist that arms its own
completion watcher, then starts a second watcher of her own that wakes her
every five minutes with one log line. Each wake re-reads her whole context
and ends "No action — unchanged".

The correct turn cancels her own watcher, leaves the specialist's completion
notice as the only wake (a state change, never a tick), and takes the READY
row that needs no training output. The wrong one keeps the per-tick watcher
and answers the next tick.

Run it with `bash evals/run.sh stage wei-019`.
