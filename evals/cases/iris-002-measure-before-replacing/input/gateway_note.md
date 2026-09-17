# Ops note: instant-payment gateway, Q2 launch

Every invoice in `invoices.csv` cleared through the legacy ACH/paper-check
pipeline, which takes at least one full business day to post a payment —
there has never been a same-calendar-day payment in this dataset, and there
won't be one until the new instant-payment gateway goes live next quarter.
Once it does, same-day issue-and-pay pairs become a normal, expected case
rather than a theoretical one.
