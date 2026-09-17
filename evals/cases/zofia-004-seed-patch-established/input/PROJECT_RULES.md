# PROJECT_RULES.md

## 1. Station IDs are always five-digit, zero-padded strings

Every importer normalizes the raw station code to a five-digit zero-padded
string before it reaches any downstream function. No function may accept a
bare integer station ID.

**Rationale**: a bare int silently drops a leading zero and merges two
different stations that happen to share the trailing digits.

## 2. Timestamps are UTC, always

No importer writes a naive (timezone-unaware) timestamp. Every timestamp
column is explicitly UTC before it is written to parquet.

**Rationale**: a naive timestamp written from a machine in a non-UTC
timezone silently shifts every reading by that machine's offset.

## 3. `normalized/` is generated output, never hand-edited

Nothing writes into `normalized/` except the loader itself. A hand-edited
parquet file there is indistinguishable from one the loader produced.

**Rationale**: a hand-patched file breaks the guarantee that
`normalized/` is fully reproducible from `raw/`.

## 4. Every importer bug gets a regression fixture before the fix ships

The smallest raw CSV that reproduces the bug lands under `tests/fixtures/`
in the same change as the fix.

**Rationale**: without this, importer bugs recur silently on the next
malformed export.

## 5. `pytest tests/` must be green before a commit lands

**Rationale**: the CI pipeline is not built yet, so this is the only gate
there is.
