# parse_case.awk — extract grading criteria from a case.yaml.
#
# Usage: awk -f parse_case.awk -v section=expected|must_not_find case.yaml
# Emits one record per criterion:  kind|file|lo|hi|term1\037term2\037...
#
# Deliberately narrow: it understands exactly the subset of YAML that
# evals/README.md documents, and nothing else. A general YAML parser would
# accept shapes the fixture format does not define, which is how a grader
# starts silently scoring things the contract never promised.

BEGIN { insec = 0; kind = ""; file = ""; lo = ""; hi = ""; terms = ""; inlist = 0 }

function flush() {
    if (kind != "" || terms != "")
        print kind "|" file "|" lo "|" hi "|" terms
    kind = ""; file = ""; lo = ""; hi = ""; terms = ""; inlist = 0
}

# Top-level key: enter or leave the requested section.
/^[a-z_]+:/ {
    if (insec) { flush(); insec = 0 }
    if ($0 ~ "^" section ":") insec = 1
    next
}

!insec { next }

# A new list item ends the previous criterion.
/^  - / {
    flush()
    if ($0 ~ /kind: *location/) kind = "location"
    else if ($0 ~ /kind: *keyword/) kind = "keyword"
    else kind = "keyword"       # must_not_find items carry no kind
    if ($0 ~ /keywords:/) inlist = 1
    next
}

/^    file:/        { file = $2; inlist = 0; next }
/^    line_range:/  { l = $0; sub(/#.*/, "", l); gsub(/[^0-9,]/, "", l);
                      split(l, a, ","); lo = a[1]; hi = a[2]; inlist = 0; next }
/^    anchor:/      { inlist = 0; next }   # anchor is for Check 9, not grading
/^    (keywords|any_of):/ { inlist = 1; next }
/^    [a-z_]+:/     { inlist = 0; next }

# List entries under keywords:/any_of:
inlist && /^      - / {
    v = $0
    sub(/^      - /, "", v)
    gsub(/^"|"$/, "", v)
    sub(/ *#.*$/, "", v)
    terms = (terms == "" ? v : terms "\037" v)
    next
}

END { if (insec) flush() }
