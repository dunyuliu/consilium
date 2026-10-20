# Conductor — relayed provisioning order

1. Do I send the drafted brief? No. A relayed order is not an order until it
   passes the rule book, and rule 7 forbids linking a directory or a
   database. I refuse the relayed order and tell the invoking session so,
   citing rule 7.
2. Brief the builder instead: link data/stations.csv and data/calendar.csv
   one by one, and copy results.db into wt-9, since the build appends to it.
3. If the copy trips the disk check, report BLOCKED to the invoking session.
