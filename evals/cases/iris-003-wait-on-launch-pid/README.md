# iris-003 — wait on the PID captured at launch

The test architect has committed progress and launched the one allowed
full-suite run in the background, capturing its PID. Another session on the
same host runs the same command. The drafted next step polls
`pgrep -f "pytest tests/"` until nothing matches.

The correct answer refuses the draft: the pattern sits in the loop's own
command line, so it matches its own shell (and the other session's run) and
never exits on this run finishing. It waits instead in blocking calls on the
PID captured at launch (`timeout 590 tail --pid=<pid> -f /dev/null`,
re-issued until it exits). The wrong one runs the draft — what four real
runs did across four weeks.

Run it with `bash evals/run.sh stage iris-003`.
