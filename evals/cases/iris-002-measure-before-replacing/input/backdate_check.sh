#!/usr/bin/env bash
# backdate_check.sh -- flags an invoice as BACKDATED if its recorded payment
# date is earlier than its issue date. Reads invoices.csv (header:
# id,issued_date,paid_date; dates are ISO YYYY-MM-DD, so lexicographic
# comparison is chronological comparison).
set -euo pipefail

csv="${1:-invoices.csv}"

tail -n +2 "$csv" | while IFS=, read -r id issued paid; do
    if [[ "$paid" < "$issued" ]]; then
        echo "BACKDATED  $id  issued=$issued  paid=$paid"
    fi
done
