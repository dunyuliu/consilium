# tideloader

Loads tide-gauge CSV exports into a normalized parquet store for downstream
analysis. Point it at a directory of raw exports and it validates, dedupes,
and writes one parquet file per station.

## Usage

```bash
python -m tideloader.run --input raw/ --output normalized/
```

## Known issues

- The CSV importer does not validate file encoding before parsing; a
  non-UTF-8 export currently fails with a raw `UnicodeDecodeError` instead of
  a clear message.
- Windows path handling is untested — every path in the code and in this
  README uses forward slashes, and nobody has run this on Windows.

## License

MIT
