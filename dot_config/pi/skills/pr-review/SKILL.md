---
name: pr-review
description: Review a pull request authored by someone else. Gather context, inspect the diff, report actionable findings, and submit a review only after explicit approval.
---

# PR review

Use the `code-reviewer` checklist for security, correctness, performance, maintainability, and tests.

## Workflow

1. Confirm the PR is authored by someone else. If the user did not specify depth, report blocking issues and important suggestions; include nits only when useful.
2. Gather context before judging the code:

```bash
gh pr view PR_NUMBER --comments
gh pr checks PR_NUMBER
gh pr diff PR_NUMBER
```

Read the description, linked issue, test instructions, existing discussion, and the surrounding code affected by the diff. Check out the branch only when local exploration or tests require it.

3. Review the diff in this order: security, correctness, performance, maintainability, and testing. Check callers and the blast radius, not just changed lines.
4. Report each finding with file/line, severity (`blocking`, `suggestion`, or `nit`), the concrete problem, and the smallest useful fix. Do not report guesses as bugs.
5. Give a recommended verdict (`approve`, `comment`, or `request changes`) and show the complete draft review. Wait for explicit user approval before posting anything.

## Posting

After approval, use the GitHub CLI:

```bash
gh pr review PR_NUMBER --approve --body "..."
gh pr review PR_NUMBER --request-changes --body "..."
gh pr review PR_NUMBER --comment --body "..."
```

Choose exactly one action. Never post, resolve threads, or reply to comments without explicit approval. Keep the review factual, concise, and free of generic praise or AI disclaimers.
