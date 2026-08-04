# parse_board.awk — extract inspection-log rows from PATHWAY_FORWARD.md.
#
# Usage: awk -f parse_board.awk -v section=board|items|defer PATHWAY_FORWARD.md
#
# board -> id|area|state|last|interval        (one per table row)
# items -> id|state|has_cmd|has_result        (one per '### <id>' block)
# defer -> id|until                           (one per deferral-log row)
#
# Deliberately narrow, like evals/parse_case.awk: it understands exactly the
# shape PATHWAY_FORWARD.md documents. A general markdown parser would accept
# shapes the format does not define, which is how a checker starts silently
# scoring things the contract never promised.
#
# Commands are read from the ``` bash fences in the item blocks, never from the
# table: a markdown cell cannot hold a `|` without truncating at the first pipe,
# and a truncated command still looks like evidence.

function emit_item() {
    if (cur != "") print cur "|" cur_state "|" has_cmd "|" has_result
    cur = ""; cur_state = ""; has_cmd = 0; has_result = 0; infence = 0
}

# --- board table: | PF-001 | `area` | claim | STATE | date | interval |
section == "board" && /^\| *PF-[0-9]+ *\|/ {
    n = split($0, f, "|")
    id = f[2]; area = f[3]; state = f[5]; last = f[6]; iv = f[7]
    gsub(/^ +| +$/, "", id);    gsub(/^ +| +$/, "", area)
    gsub(/^ +| +$/, "", state); gsub(/^ +| +$/, "", last)
    gsub(/^ +| +$/, "", iv);    gsub(/`/, "", area)
    print id "|" area "|" state "|" last "|" iv
    next
}

# --- item blocks: ### PF-001 — `area` — STATE
section == "items" && /^### PF-[0-9]+/ {
    emit_item()
    line = $0
    match(line, /PF-[0-9]+/); cur = substr(line, RSTART, RLENGTH)
    # state is the last em-dash-separated field, minus any trailing qualifier
    n = split(line, parts, / — /)
    cur_state = parts[n]
    gsub(/^ +| +$/, "", cur_state)
    if (cur_state ~ /never audited/) cur_state = parts[n-1]
    gsub(/^ +| +$/, "", cur_state)
    next
}
section == "items" && /^```bash/ { infence = 1; next }
section == "items" && /^```/     { infence = 0; next }
section == "items" && infence {
    if ($0 ~ /^# → *[^ ]/) { has_result = 1 }
    else if ($0 !~ /^#/ && $0 !~ /^ *$/) { has_cmd = 1 }
    next
}

# --- deferral log: | 2026-08-04 | PF-003 | 2026-09-03 | reason |
section == "defer" && /^\| *20[0-9][0-9]-/ {
    n = split($0, f, "|")
    id = f[3]; until_d = f[4]
    gsub(/^ +| +$/, "", id); gsub(/^ +| +$/, "", until_d)
    print id "|" until_d
    next
}

END { if (section == "items") emit_item() }
