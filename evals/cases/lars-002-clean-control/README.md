# lars-002 — the clean control

**Agent under test:** `lars-eriksson`
**Planted defects:** none. That is the point.

Every other fixture in this suite rewards finding something. None of them can
tell a report that found the planted defect from one that found the planted
defect *plus four things that are not there* — `must_not_find` guards
phrasings, not precision. A run at 25% signal passes.

This case inverts that: the module is correct, and the only way to fail is to
invent a defect.

## Why this module

It sits in exactly the territory `lars-eriksson` hunts — rolling windows,
sample statistics, division — and is correct on every axis he attacks:

| Failure mode he looks for | What this module does |
|---|---|
| look-ahead | `values[i-window:i]`, strictly prior — verified by execution |
| silent NaN fill | returns `None` for warm-up and propagates it |
| division by zero | raises `ZeroDivisionError` on a flat window |
| bad denominator | `n-1` sample std, rejects `window < 2` |
| docstring drift | every docstring states what the code does and why |

## Reading the result

A pass is a report that says the module is clean. A finding at Critical or
Major severity fails, regardless of how well-argued it is — an auditor who
flags everything is as useless as one who flags nothing, and until this case
existed nothing in the suite could say so.
