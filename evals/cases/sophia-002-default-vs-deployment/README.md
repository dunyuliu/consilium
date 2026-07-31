# sophia-002 — default vs. deployment, both directions

**Agent under test:** `sophia-okafor`
**Difficulty:** medium — two real findings sit one keystroke away from a
third, false one.

## Why this case exists

`sophia-okafor` previously reported, at High severity, that a config file
setting values different from the documented README defaults was "spec
drift". It isn't — that's what a config file is for. Her prompt was
tightened to require a cited code-side fallback (a `cfg.get(key, ...)`
lookup or signature default) before any default-mismatch finding.

The risk of that fix is overcorrection: swinging from "flags every
configured value" to "never flags a code-side default disagreement, or
stops noticing dead config keys". This case plants one instance of each
side so a single run proves the fix cuts both ways.

## Planted situations

1. **True positive — conflicting defaults (must find).**
   `input/README.md:12` documents `max_retries` defaulting to `3`.
   `input/worker.py:22` reads it as `cfg.get("max_retries", 5)` — the
   code's own fallback is `5`. Two defaults exist, in writing, and they
   disagree. `input/config.yaml:1` happens to set `max_retries: 3` for
   this deployment, so the bug never fires at runtime — irrelevant to
   whether it's a documented-vs-code-default drift. Sophia's fix requires
   her to cite the fallback before flagging this; she must still flag it,
   because the fallback is citable and wrong.

2. **True positive — dead config key (must find).**
   `input/README.md:15` and `input/config.yaml:4` both document/set
   `enable_dead_letter`. `input/worker.py` never reads the key — `grep -n
   enable_dead_letter input/worker.py` returns nothing. Unconditional
   finding: no fallback rule applies to a key the code never consults at
   all.

3. **Negative — deployment doing its job (must NOT find).**
   `input/worker.py:20-21` reads `cfg["queue_name"]` and
   `cfg["batch_size"]` via bare subscript — no `.get`, no signature
   default, nothing to cite as a code-side default anywhere in the file.
   `input/config.yaml` sets both away from the README's documented
   defaults (`"default"` &rarr; `"priority"`, `50` &rarr; `200`). That is
   the deployment configuring the service, not drift, and Sophia must not
   report it as a default mismatch.

## Pass criteria

See `case.yaml`. Exactly two findings: the `max_retries` fallback
conflict and the dead `enable_dead_letter` key. A report naming
`queue_name` or `batch_size` as a wrong/mismatched default fails
`must_not_find`.
