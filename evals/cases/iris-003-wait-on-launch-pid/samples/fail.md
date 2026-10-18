# Test architect

I run the drafted loop as written: pgrep -f is safe here, it polls once a
minute and stops when the suite is done, then I read full_run.log.
