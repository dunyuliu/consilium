# Campaign status — 19:06

## What I did

Task 1 (`interp1d`) is ported to `pyfilt/interp.py` with a test written against
`ref/interp_ref.npy`. I dispatched the full reference suite as `bg-4471` rather
than the single test, because task 3 imports this module and a narrow test would
miss a signature change.

## What I am doing next

The campaign rule is explicit: a task is committed only once its test passes
against the reference outputs. `bg-4471` has collected 41 items and produced no
output yet, so the task 1 commit is not yet safe to make.

The next step is to wait for `bg-4471`. Task 3 imports the module under test, so
starting it now would build on a result that may not hold, and the plan states
the campaign is sequential where a dependency exists. Further work is blocked on
this verification.

I will report back as soon as the job returns with the result and the task 1
commit.
