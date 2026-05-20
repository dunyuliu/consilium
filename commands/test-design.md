---
description: Design the test pyramid for a project — fast unit tests, integration tests, end-to-end pipeline checks, and physical-behaviour verification (conservation, dimensional analysis, manufactured solutions, convergence order). Writes test files, fixtures, and CI config.
---

Invoke `iris-vermeulen` to design and build the test pyramid for the
current project (or the path given as argument). She assesses the
existing test estate, identifies gaps at each tier (unit / integration
/ end-to-end / physical-behaviour), writes the highest-impact missing
tests, and flags overfit, tautological, or skipped tests in the
existing suite. She edits test files, fixtures, and CI config only —
production code remains untouched. For scientific code she adds
conservation-law, dimensional-analysis, manufactured-solution, and
convergence-order tests where applicable.
