# zofia-001 — rule-book discovery by content, not filename

**Agent under test:** `zofia-kaminska`
**Difficulty:** medium — three rule-book-shaped files, only one is real.

## Why this case exists

Zofia's Step 0 is supposed to find the rule book by reading content, not by
matching the canonical filename. A synthetic project that only ever has one
plausible rule file never exercises that step. This fixture plants three
candidates at once: the real rules live in a file that doesn't look like a
rule book by name; the canonically-named file is a hollow stub; and a third
file is named like a rule book but is a plain how-to.

## Planted situations

1. **True positive — real rule, real violation (must find).**
   `input/CLAUDE.md:7-10` states migrations MUST go through
   `scripts/migrate.sh` and forbids calling `alembic upgrade head` directly.
   `input/deploy.sh:7` does exactly the forbidden thing. `input/
   scripts/migrate.sh` exists and does the mandated locking/audit work, and
   nothing calls it — the wrapper isn't missing, it's bypassed.

2. **True positive — degenerate stub at the canonical name (must find, and
   must not be mistaken for authoritative).**
   `input/PROJECT_RULES.md` is one line: `# Project Rules`. Nothing else.
   Under ~20 lines, no body, no rules. A run that treats this file as
   sufficient, or concludes from it that the project has no real rules,
   fails — the real rules are one directory listing away, in `CLAUDE.md`.

3. **Control — rule-book-shaped name, how-to content (must NOT be reported
   as a rule book or a violation source).**
   `input/docs/RULES.md` is titled "# Rules" but is a model-training
   quickstart: `pip install`, `python train.py --epochs 50 --lr 0.001`,
   `python evaluate.py`, `python export.py`. No MUST/never/required
   language anywhere, and the domain (ML training) is deliberately
   unrelated to the deploy/migration rule so its steps can't be misread as
   a conflicting policy. Zofia's contract says to note it's not a rule book
   and keep looking, not to cite it as one.

## Pass criteria

See `case.yaml`. Both true positives found (the `alembic`/`scripts/
migrate.sh` violation, and the `PROJECT_RULES.md` stub correctly named as
non-authoritative). Neither the stub nor `docs/RULES.md` reported as the
project's actual rule book.

## Adversarial self-audit

- `CLAUDE.md` carries two more rules (`make deploy` / no direct
  `docker push`; every `src/`-touching PR needs a test under `tests/`).
  Neither is violated by this fixture — `deploy.sh` does call `make
  deploy`, and there is no `src/` or `tests/` directory at all, so the
  testing rule is vacuous here rather than broken. Declared so a future
  reader doesn't mistake either for an undeclared defect.
- None of the words the `must_not_find` guards key on ("stub",
  "authoritative", "how-to", "binding") appear anywhere in `input/`, so a
  correct finding is genuine classification, not an echo of planted
  vocabulary.
- `scripts/migrate.sh` is real and correct — its presence is what makes the
  `deploy.sh` violation a live bypass rather than a missing-wrapper problem.
