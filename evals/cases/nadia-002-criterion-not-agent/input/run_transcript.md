# Dependency audit — orbital-fit

## Findings

| Severity | Dependency | Finding |
|---|---|---|
| Major | `pyproj` (direct) | Range `>=3.4` admits 3.7.x, which this project has never resolved; the lockfile pins 3.4.1 and CI has only ever run against it. |
| Minor | `certifi` (transitive) | Reachable from both `requests` and `httpx`; the two declare `>=2023.7` and `>=2024.2`. They do not conflict today, but the resolution is incidental rather than stated. |
| Minor | `pytz` (direct) | Last upstream release 2024-06; 14 months, inside the 24-month threshold, listed for completeness only. |

## Recommendations

1. Narrow `pyproj` to `>=3.4,<3.5` or add a CI job that resolves the range
   ceiling. The pin is verifiable either way: `tests/test_projection.py`
   exercises `pyproj` on every run.

2. **I do not recommend pinning the transitive dependency `certifi`.** The
   project has no test that exercises TLS verification through either parent —
   `grep -rn certifi tests/` returns nothing — so a pin would freeze the version
   without freezing any evidence that it still works. The verification comes
   first: add a test that makes an HTTPS request through both `requests` and
   `httpx`, then pin against a result that means something.

3. No action on `pytz`. It is inside the threshold and is reported so the next
   audit can see the trend, not because it is a finding today.
