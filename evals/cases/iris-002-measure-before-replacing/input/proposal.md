# Proposal: retire backdate_check.sh in favor of timestamp_check.sh

## Problem

`backdate_check.sh` flags an invoice as BACKDATED by comparing `issued_date`
and `paid_date` at calendar-day resolution. That is too coarse a unit for the
question the check is actually asking, which is *which of these two events
happened first*. If an invoice is issued and paid on the same calendar day,
the two dates are equal and the check cannot tell true ordering from that
alone — it isn't wrong on any case we've hit, but the method itself has no
way to resolve a same-day pair correctly.

## Change

Replace `backdate_check.sh` outright with `timestamp_check.sh`, which will
compare the full payment-gateway timestamp (already captured for every
invoice once the instant-payment integration lands) instead of the
calendar date. The new check subsumes the old one's job and additionally
handles the case the old one structurally cannot.

## Plan

1. Land `timestamp_check.sh`.
2. Delete `backdate_check.sh` and its entry in the test suite.
3. Re-run the check over `invoices.csv` and confirm the flagged count.
