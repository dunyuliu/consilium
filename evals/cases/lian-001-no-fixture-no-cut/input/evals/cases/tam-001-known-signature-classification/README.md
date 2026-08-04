# tam-001 — OOMKilled classification

**Agent under test:** `tam-oakley`

## Planted situation

`input/sample.log` shows memory climbing toward a pod's limit (line 3)
followed by the kubelet reporting `exit reason OOMKilled` (line 4). This
is a direct hit on the `OOMKilled` entry in tam-oakley's Known Error
Signatures catalogue, which calls for immediate escalation and no retry.

## Pass criteria

See `case.yaml`. The report must cite line 4 as the match and recommend
immediate escalation, not a retry-and-see approach.
