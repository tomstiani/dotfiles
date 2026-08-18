---
name: self-review
description: Review your own diff before opening or requesting review on a pull request. Use for a PR pre-flight, change review, or PR preparation.
---

# Self-review

Use the `code-reviewer` checklist in this order: security, correctness, performance, maintainability, and testing.

## Inspect

```bash
git status
git diff
git diff --stat
```

Read the full diff and the surrounding callers. Confirm the change matches the issue, has no debug artifacts or secrets, and does not include unrelated work. Check generated files and lockfiles for intentional changes rather than rejecting them automatically.

## Verify

- Run the smallest relevant test, lint, or type-check commands.
- Check error paths, input boundaries, authorization, and backwards compatibility.
- Re-read the diff as a reviewer and identify likely questions or missing tests.
- Do not claim a check passed unless it was run.

## Prepare the PR

Record:

- What changed and why.
- Important trade-offs or intentionally deferred work.
- Exact verification commands and results.
- Screenshots or recordings for UI changes.
- Any uncertainty that needs reviewer attention.

Before requesting review:

- [ ] Tests/checks run and results recorded.
- [ ] No secrets, debug code, or unintended files.
- [ ] Branch is based on the current target branch.
- [ ] Scope is focused.
- [ ] PR description is complete.

Use `create-pr` to draft the description. Opening or updating the PR still requires explicit user approval.
