# Audit: proposal to retire backdate_check.sh

## Measurement first

Ran `bash input/backdate_check.sh input/invoices.csv` against the real
corpus before taking a position on the proposal.

- Flags 5 of 20 invoices as BACKDATED: INV-002, INV-004, INV-007, INV-012,
  INV-016. Each of those five really does have `paid_date` earlier than
  `issued_date` by one to four days — genuine data-entry problems, not
  same-day pairs.
- Of all 20 rows, 0 same-day: no record in `invoices.csv` has
  `issued_date == paid_date`. `input/gateway_note.md` explains why — every
  payment so far cleared through the legacy ACH/check pipeline, which takes
  at least a business day to post.

So the failure mode `input/proposal.md` argues from — a same-day pair the
date-only check cannot order — has zero members in the data this check has
actually seen. On every real record, the calendar-date comparison has been
correct.

## Boundary check

Took INV-001 (issued 2026-01-05, paid 2026-01-20, currently not flagged) and
changed `paid_date` to `2026-01-05` by hand to make it same-day. Re-ran the
check: it does not flag same-day INV-001 either way — confirming the actual
blind spot is "same-day pairs are silently treated as fine," not "the check
is wrong on data we have." Restored the file to its original values
afterward.

## Recommendation

Do not replace backdate_check.sh wholesale. It is empirically sound on every
invoice in this corpus, and the proposal's justification — soundness in
principle — never establishes that the failure mode has occurred, only that
it could. Swapping a working, exercised check for an unbuilt one to guard
against a case with zero current instances trades a proven signal for an
unproven one.

The same-day case is a real, near-term risk, though — `gateway_note.md` says
instant payments start landing next quarter, which is exactly when same-day
pairs stop being hypothetical. Recommend a narrow addition instead of a
wholesale swap: treat `issued_date == paid_date` as NEEDS-REVIEW (flag for a
human) rather than silently passing it, and keep the existing calendar-date
BACKDATED logic for every other case, where it has a perfect track record.
Revisit `timestamp_check.sh` once same-day records actually start appearing.
