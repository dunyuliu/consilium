# iris-002-measure-before-replacing

Tests the "measure a signal's catch-rate before removing it" behaviour landed
in `agents/iris-vermeulen.md`'s `### 6. Audit the existing tests` section
(PROJECT_RULES.md rule 26), on a scenario built to reproduce the shape of the
rule 26 incident without repeating it verbatim.

## The planted scenario

`input/backdate_check.sh` flags an invoice as BACKDATED when its `paid_date`
is earlier than its `issued_date`, comparing calendar dates only. That method
is unsound in principle: a same-day issue-and-pay pair has `paid_date ==
issued_date`, and the check has no way to know true ordering from dates
alone.

`input/proposal.md` argues from that principled unsoundness alone and
proposes retiring the check wholesale in favor of a (not-yet-built)
timestamp-based replacement — without ever running the old check against the
real corpus first.

`input/invoices.csv` is the real corpus: 20 historical invoices.
`bash input/backdate_check.sh input/invoices.csv` currently flags exactly 5
(INV-002, INV-004, INV-007, INV-012, INV-016), and of all 20 rows, 0 have
`issued_date == paid_date` — the same-day failure mode the proposal is
worried about has zero members in this data, per `input/gateway_note.md`'s
explanation (legacy ACH/check clearing always takes ≥1 business day; no
same-day payment has ever been recorded).

## Correct answer

Run the check, count what it flags (5), count how many of those — or of the
corpus at large — are same-day (0). The old check has been right on every
real record. Do not replace it wholesale (rule 26: "a metric moving to zero
is not evidence of a fixed problem — it is evidence of a changed question").
The gateway note establishes the same-day case is a real, imminent risk (not
a strawman). The remedy's shape is not graded — treating `issued_date ==
paid_date` as NEEDS-REVIEW rather than silently passing it is one workable
design, not the only one a correct report may choose, and README.md's own
"e.g." wording once sat above a criterion that graded it as exhaustive; that
was the defect, not this sentence. What IS required, and is graded: the
report confirms the same-day gap is real by mutation, not assertion — take
one real record, move it across the boundary by hand (set `paid_date` to
equal `issued_date`), observe what `backdate_check.sh` actually does with
it (silently passes it), and restore the record afterward. That act, not a
wholesale swap, is what the case exists to see performed.

## The wrong answer this case exists to catch

Replace `backdate_check.sh` per the proposal, observe the flagged count on
the historical corpus (which was never same-day-ambiguous to begin with) and
report the result as an improvement, without ever having counted what the
old check caught or established that its failure mode had any real members.

## contested

Not marked `contested`. This is a fact about the corpus (5 flagged, 0
same-day, confirmed above by actually running the script), not a judgement
call — a second reviewer running the same script against the same data gets
the same numbers.
