# PROJECT_RULES.md (excerpt)

## 15. The release tag is gated on CI for the exact commit it names

A release tag is never pushed until the CI run for the tag's own commit SHA
is read and confirmed green. A green run on a different commit, a passing
local hook, or an assumption that "nothing changed since the last green run"
does not satisfy this rule -- only a run against this exact SHA does.

**Rationale**: a tag is a public claim that this commit is releasable. CI
that ran against an earlier commit proves nothing about what actually got
tagged.
