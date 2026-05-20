# sophia-001 — units drift across README, config, and code

**Agent under test:** `sophia-okafor`
**Difficulty:** medium — three sources disagree, and one config knob is
inert.

## Planted defects

1. **`output_units` config key is dead code (critical).** `config.yaml`
   sets `output_units: centimetres`. `ingest.py` never reads the key.
   Whoever wrote the config believes they can change units; they cannot.

2. **Output units lie in three places (critical).** The README says
   "cleaned output to `data/clean/`" in metres (the implied unit of the
   config schema's `output_units` default). The config sets centimetres.
   The code multiplies by 1000.0 and labels the column `height_mm`. Three
   sources, three unit stories.

## Why this is good test material

- It's the canonical kind of drift Sophia exists to catch: docs, config,
  and code each have a different version of "the truth".
- It contains a false trail (the `must_not_find` guard) that a sloppy
  reading would flag: the numeric values in `config.yaml` differ from the
  README's defaults. That isn't drift — defaults documented in the README
  are just defaults; the config can override them. A good auditor notices
  this is by design, and reserves the "drift" label for the unit mismatch.

## Pass criteria

See `case.yaml`. Sophia must mention the unit drift (millimetres / 1000)
and call out the `output_units` config key. She must NOT flag the numeric
threshold values as wrong defaults.
