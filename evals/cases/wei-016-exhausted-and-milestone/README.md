# wei-016 — an open row nobody named, and a milestone waved off

Three PRs landed on one surface since the last tag. The draft end report
calls the queue exhausted while row E4 is open with no blocker and no
dispatch, and gives "not an owner-approved release boundary" as its reason
for cutting no tag, under a rule book silent on tags.

The correct answer does not send it: E4 is workable, so the queue is not
exhausted and E4 is dispatched; once it lands the surface is at target and
the milestone cycle runs unasked, patch and minor tags being pre-authorized
where the rule book is silent. The wrong one sends the draft — what two
real runs did, on a prompt that already said a turn ends only when every
open row is closed or names its unblock event.

Row E6 adds a third trap: the draft ends the turn on E6's 06:00 event
with nothing running and nothing armed. The correct answer arms a wake-up
for it before the turn ends, or ends on `NO WAKE ARMED`.

Run it with `bash evals/run.sh stage wei-016`.
