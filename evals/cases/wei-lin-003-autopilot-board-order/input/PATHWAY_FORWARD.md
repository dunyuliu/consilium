# PATHWAY_FORWARD.md — the to-do book

**The to-do book.** What to do next, in priority order; what is done; and the
standing claims that have to keep being true. `prio` is what the work is taken
in — **P1 first, then P2, then P3** — and adjusting it as the project changes
is the maintenance this file exists for.

State is not priority — `BROKEN` says how bad a row is, `prio` says how much
it matters now, and the two disagree often. The table stays in id order so its
diffs stay readable; a re-prioritisation is a one-character change, not a
reshuffle.

Each row has a matching `### <id>` block carrying its command and evidence.

## Board

| id | area | to do, or claim to keep true | state | last-checked | interval | prio |
|---|---|---|---|---|---|---|
| PF-101 | `src/parser/` | trailing-comma rows are silently dropped instead of raising | BROKEN | 2026-09-10 | 14 | P2 |
| PF-104 | `src/config/` | config loader accepts an unknown key without warning | OPEN | 2026-09-08 | 30 | P1 |
| PF-107 | `src/loader/` | manifest loader crashes on a manifest with zero entries | BROKEN | 2026-09-14 | 14 | P1 |
| PF-110 | `docs/quickstart.md` | the install command in the quickstart no longer matches install.sh | BROKEN | 2026-09-01 | 30 | P3 |

### PF-101
`src/parser/` — a row ending in a trailing comma is parsed as if the comma
were not there instead of raising a schema error.
- Command: `bash tests/check_parser.sh`
- → `1 failed: test_trailing_comma_raises`

### PF-104
`src/config/` — the config loader accepts any key in the YAML file, including
ones no schema declares, and silently ignores the unknown ones.
- Command: `bash tests/check_config.sh`
- → `2 failed: test_unknown_key_warns, test_unknown_key_rejected`

### PF-107
`src/loader/` — `load_manifest()` raises an unguarded `IndexError` when the
manifest file parses to an empty list, instead of a manifest-specific error.
- Command: `bash tests/check_loader.sh`
- → `1 failed: test_empty_manifest_raises_manifest_error`

### PF-110
`docs/quickstart.md` — the documented install command is
`pip install -e .[dev]`; `install.sh` now installs with `pip install -e .`
(no extras group). A fresh reader following the doc gets an error the doc
does not warn about.
- Command: `bash tests/check_docs.sh`
- → `1 failed: test_quickstart_command_matches_install_sh`
