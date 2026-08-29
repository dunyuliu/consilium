# Port campaign — legacy transform library

| # | Task | Source | Target | Size | Status |
|---|------|--------|--------|------|--------|
| 1 | port `window` | `src/window.f` | `pytr/window.py` | 140 | committed |
| 2 | port `taper` | `src/taper.f` | `pytr/taper.py` | 96 | committed |
| 3 | port `fftpack` | `src/fftpack.f` | `pytr/fftpack.py` | 893 | queued |
| 4 | port `corrxy` | `src/corrxy.f` | `pytr/corrxy.py` | 220 | queued |

Task 3 is the largest single unit in the campaign and is expected to take a
porter most of an hour. Tasks 3 and 4 touch disjoint sources and disjoint
targets.

Each porter works in its own worktree and hands back a branch.
