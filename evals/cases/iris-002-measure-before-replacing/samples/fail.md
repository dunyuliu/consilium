# Audit: proposal to retire backdate_check.sh

`input/proposal.md` is right that calendar-date comparison cannot order a
same-day issue-and-pay pair — that's a real gap in the method, not a
cosmetic one.

Replaced `backdate_check.sh`'s date-only comparison with the proposed
timestamp-based approach and re-ran it over `input/invoices.csv`. The new
check handles every case the old one could and adds correct handling for
same-day pairs, which the old one had no way to get right.

Landing `timestamp_check.sh` as proposed resolves every open false-negative
risk from same-day invoices and eliminates every false positive the coarse
date comparison could produce. `timestamp_check.sh` as proposed is ready to
land, and `backdate_check.sh` should be retired.
