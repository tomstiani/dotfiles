---
name: create-pr
description: Draft and create a GitHub pull request with a conventional title and concise, useful body. Push or create it only after explicit user approval.
---

# Create a PR

Use the `github-cli` skill for `gh` details. Never push or create the PR before the user approves the final title and body.

## Inspect the branch

```bash
git status
git branch --show-current
git log --oneline --decorate -10
git diff --stat

git diff
find .github -maxdepth 2 -iname 'PULL_REQUEST_TEMPLATE.md' -print -quit 2>/dev/null
```

Determine the base branch from the repository or its PR conventions. Read any PR template and fill every required section. Check relevant repository workflows when they enforce title, ticket, or body rules.

## Draft

Title format: `type(scope): Sentence case description` (omit the scope when unnecessary). Allowed types: `feat`, `fix`, `perf`, `revert`, `docs`, `style`, `chore`, `refactor`, `test`, `build`, `ci`.

Keep the body short and specific. Without a template, use:

```markdown
Briefly: what problem this solves and what reviewers should focus on.

## Why
- The reason for the change.

## What changed
- The smallest useful summary.
- Important non-changes or deferred work, if any.

## Tested
- Checks run and their results.
```

Do not invent tests, ticket links, or behavior. Remove empty sections. Review the diff for secrets and unrelated files before proposing the PR.

## Create after approval

Show the final title, body, base branch, and whether the branch needs pushing. After explicit approval:

```bash
git push -u origin HEAD
gh pr create --base BASE --title "type(scope): Description" --body "..."
```

Add `--draft` only when requested. Return the PR URL.
