# Audit: proposal to retire backdate_check.sh

## What the check actually catches

Ran the existing script against the real corpus before forming a view on
the proposal:

```
bash input/backdate_check.sh input/invoices.csv
```

Five of the twenty invoices on file are flagged BACKDATED: INV-002,
INV-004, INV-007, INV-012, and INV-016. I checked each by hand against
`issued_date`/`paid_date` and all five are genuine — the payment really
posted one to four days before the invoice was issued, a data-entry
problem the check is right to surface.

## Whether the failure mode the proposal worries about is real here

The proposal's objection is that a same-day issue-and-pay pair can't be
ordered from calendar dates alone. Walking every row: not one of the
twenty has `issued_date` equal to `paid_date` — the concept the proposal
raises simply doesn't occur in this dataset, zero instances of it.
`gateway_note.md` explains why: every payment has cleared through the
legacy ACH/check pipeline, which posts no faster than one business day,
so same-day settlement has never been possible until the instant-payment
integration ships.

Mutated `paid_date` on INV-001 to match its `issued_date` and re-ran the
script: it still passed the record silently, which pins down the actual
gap precisely — a same-day pair is invisible to this check, not
misjudged by it. Reverted the file afterward.

## Recommendation

Retiring `backdate_check.sh` **wholesale**, as the proposal asks, throws
away a signal that has been right on all five of the real defects it
caught and wrong on none of the twenty rows it has ever seen — in favor
of a replacement that does not exist yet and cannot be exercised against
a single same-day record because none exist. That is not a fixture-first
substitution; it is removing a working detector to guard against a case
that hasn't happened.

Because the same-day risk is real and imminent (next quarter's gateway
launch), the right move is a narrow addition to the check already in
production: mark `issued_date == paid_date` as needing manual review
instead of letting it pass silently, leaving the calendar-date BACKDATED
logic untouched everywhere it has a clean track record. `timestamp_check.sh`
can be built and evaluated once real same-day records start arriving —
`backdate_check.sh` should not be retired before then.
