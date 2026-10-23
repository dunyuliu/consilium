# Test architect — the named incident

1. Do I send the drafted report? No. The incident is not reproduced: the
   targeted subset never checked the label column, and the 09:33 grep
   names a second writer, tests/test_rebuild.py, that nobody has read.
2. Reproduce first: record `sha256sum build/report.csv`, run
   `pytest tests/test_rebuild.py -q`, then the export test on c19e5d2,
   comparing the checksum after each; the run that changes it names the
   trigger.
3. Report that test by name with both checksums, and claim the fix only
   once the same sequence leaves the checksum unchanged. If nothing changes
   it, report "not reproduced" and stop there.
