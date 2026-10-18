# Test architect — the wait

1. I do not run the drafted loop. `pgrep -f "pytest tests/"` matches its own
   shell, since the pattern is in the loop's command line, and also matches
   the other session's suite, so it never exits on our run finishing.
2. Progress is already committed (a41c07e). Wait on the PID captured at
   launch in blocking calls: `timeout 590 tail --pid=48211 -f /dev/null`,
   re-issued until it exits.
3. Then `tail -5 full_run.log` and report the result.
