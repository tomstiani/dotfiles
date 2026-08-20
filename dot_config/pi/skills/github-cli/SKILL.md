---
name: github-cli
description: Use GitHub through the gh CLI for repositories, issues, pull requests, stacked pull requests, Actions, releases, projects, and searches. Never call api.github.com with curl, fetch, or a custom HTTP client.
---

# GitHub CLI

Use `gh`. When a flag is uncertain, run `gh GROUP COMMAND --help` instead of guessing.

## Safety

- Read-only commands can run normally.
- Before creating, commenting, reviewing, merging, closing, deleting, or changing anything, show the command and get explicit user approval.
- Never expose tokens. Check auth with `gh auth status`; use `GH_TOKEN` for automation.
- Use `--repo OWNER/REPO` outside the target repository.

## Auth and repositories

```bash
gh auth status
gh auth login
gh repo view [OWNER/REPO]
gh repo clone OWNER/REPO [DIRECTORY]
gh repo list OWNER --limit 50
```

For GitHub Enterprise, use `--hostname HOST` or `GH_HOST`.

## Issues

```bash
gh issue list --state open --limit 50
gh issue view NUMBER --comments
gh issue create --title "..." --body-file issue.md
gh issue edit NUMBER --title "..."
gh issue comment NUMBER --body "..."
gh issue close NUMBER
```

## Pull requests

```bash
gh pr status
gh pr list --state open
gh pr view NUMBER --comments
gh pr diff NUMBER
gh pr checkout NUMBER
gh pr checks NUMBER
gh pr create --title "type(scope): Description" --body-file body.md
gh pr review NUMBER --approve --body "..."
gh pr review NUMBER --request-changes --body "..."
gh pr merge NUMBER --squash --delete-branch
```

Use `gh pr create --draft` for draft PRs. Review and merge are mutating actions and always require approval.

## Stacked pull requests

GitHub's stacked PR feature is in public preview and requires branches in the same repository.

```bash
gh extension install github/gh-stack
gh stack init FIRST-BRANCH
# Commit the first layer, then add and commit each next layer.
gh stack add NEXT-BRANCH
gh stack view
gh stack submit
gh stack sync
gh stack switch
gh stack merge
```

`gh stack submit`, `sync`, and `merge` mutate GitHub state; show the command and get explicit approval first. Use `gh stack COMMAND --help` for restructuring, rebasing, linking existing PRs, or other less common operations.

## Actions

```bash
gh run list --limit 20
gh run view RUN_ID --log
gh run watch RUN_ID
gh run rerun RUN_ID
gh run cancel RUN_ID
gh run download RUN_ID --dir ./artifacts
gh workflow list
gh workflow run WORKFLOW --ref BRANCH
```

## Other common groups

```bash
gh release list
gh release view TAG
gh release create TAG --notes-file notes.md
gh project list --open
gh project view NUMBER
gh search repos QUERY --limit 50
gh search issues QUERY
gh search prs QUERY
```

For less common groups, inspect help first: `gh secret --help`, `gh variable --help`, `gh label --help`, `gh gist --help`, `gh org --help`, or `gh extension --help`.

## Structured output

Prefer `--json` and `--jq` in scripts instead of parsing display output:

```bash
gh repo view --json name,description --jq '.name'
gh pr list --json number,title,state --jq '.[] | [.number, .title, .state] | @tsv'
```

## API fallback

Use `gh api` only when no native subcommand exists. Keep requests inside `gh`; never call `api.github.com` directly.

```bash
gh api /user --jq '.login'
gh api /user/repos --paginate
```
