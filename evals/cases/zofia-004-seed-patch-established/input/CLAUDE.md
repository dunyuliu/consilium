# CLAUDE.md

## Build and test

```bash
pip install -e .
pytest tests/
```

## Conventions

- Station IDs are always five-digit strings, zero-padded (`"00304"`, not
  `304`). Every importer function assumes this.
- `normalized/` is generated output — never commit it, never hand-edit a
  parquet file in it.
- Timestamps are stored as UTC; no importer may write a naive timestamp.
