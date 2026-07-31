---
name: github-cli
description: GitHub CLI (gh) comprehensive reference for repositories, issues, pull requests, Actions, projects, releases, gists, codespaces, organizations, extensions, and all GitHub operations from the command line. Always use gh CLI subcommands — never use curl, fetch, or direct REST/GraphQL API calls against api.github.com. Use when the user wants to interact with GitHub repos, issues, PRs, Actions, releases, secrets, labels, or any GitHub operation from the terminal.
---

# GitHub CLI (gh)

Comprehensive reference for GitHub CLI (gh) — work seamlessly with GitHub from the command line.

**Version:** 2.85.0 (current as of January 2026)

## Prerequisites

### Installation

```bash
# macOS
brew install gh

# Linux
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh

# Windows
winget install --id GitHub.cli

# Verify
gh --version
```

### Authentication

```bash
gh auth login                          # Interactive login
gh auth login --hostname enterprise.internal
gh auth login --with-token < mytoken.txt
gh auth status                         # Check status
gh auth switch --hostname github.com --user username
gh auth logout --hostname github.com --user username
gh auth token                          # Print active token
gh auth refresh --scopes write:org,read:public_key
gh auth setup-git                      # Configure git credential helper
```

### Environment Variables

```bash
export GH_TOKEN=ghp_xxxxxxxxxxxx       # GitHub token (for automation)
export GH_HOST=github.com              # GitHub hostname
export GH_PROMPT_DISABLED=true         # Disable prompts
export GH_EDITOR=vim
export GH_PAGER=less
export GH_REPO=owner/repo              # Override default repo
```

## Repositories (gh repo)

```bash
# Create
gh repo create my-repo --public --description "Description" --license mit --gitignore python
gh repo create my-repo --private --clone
gh repo create org/my-repo

# Clone
gh repo clone owner/repo
gh repo clone owner/repo my-directory

# List
gh repo list [owner] --limit 50 --public --source
gh repo list --json name,visibility,owner --jq '.[].name'

# View
gh repo view [owner/repo] --json name,description,defaultBranchRef
gh repo view --web

# Edit
gh repo edit --description "New description"
gh repo edit --visibility private
gh repo edit --enable-issues --disable-wiki
gh repo edit --default-branch main

# Other
gh repo rename new-name
gh repo archive / gh repo unarchive
gh repo delete owner/repo --yes
gh repo fork owner/repo --org org-name --clone
gh repo sync [--branch feature] [--force]
gh repo set-default owner/repo / gh repo set-default --unset
```

## Issues (gh issue)

```bash
# Create
gh issue create --title "Bug: Login broken" --body "Steps..." --labels bug,high-priority --assignee user1
gh issue create --body-file issue.md --repo owner/repo

# List
gh issue list [--state all|open|closed] [--limit 50]
gh issue list --assignee @me --labels bug --milestone "v1.0"
gh issue list --search "is:open label:bug"
gh issue list --json number,title,state,author
gh issue list --sort created --order desc

# View
gh issue view 123 [--comments] [--web]
gh issue view 123 --json title,body,state,labels,comments

# Edit
gh issue edit 123 --title "New title" --body "Updated"
gh issue edit 123 --add-label bug --remove-label stale
gh issue edit 123 --add-assignee user1 --remove-assignee user2
gh issue edit 123 --milestone "v1.0"

# Lifecycle
gh issue close 123 --comment "Fixed in PR #456"
gh issue reopen 123
gh issue delete 123 --yes
gh issue transfer 123 --repo owner/new-repo
gh issue pin 123 / gh issue unpin 123
gh issue lock 123 --reason off-topic / gh issue unlock 123

# Comment
gh issue comment 123 --body "Looks good!"

# Status
gh issue status [--repo owner/repo]

# Develop (create branch/draft PR from issue)
gh issue develop 123 --branch fix/issue-123 --base main
```

## Pull Requests (gh pr)

```bash
# Create
gh pr create --title "Feature: ..." --body "..." --base main --draft
gh pr create --reviewer user1,user2 --assignee user1 --labels enhancement
gh pr create --body-file .github/PULL_REQUEST_TEMPLATE.md

# List
gh pr list [--state all|open|closed|merged] [--limit 50]
gh pr list --base main --head feature-branch --author @me
gh pr list --labels bug --search "is:open review:required"
gh pr list --json number,title,state,author,headRefName

# View
gh pr view 123 [--comments] [--web]
gh pr view 123 --json title,body,state,author,commits,files
gh pr diff 123 [--name-only] [--color always]

# Checkout
gh pr checkout 123 [--branch name-123] [--force]

# Merge
gh pr merge 123 --squash --delete-branch
gh pr merge 123 --merge / --rebase
gh pr merge 123 --admin   # force merge, skip checks

# Edit
gh pr edit 123 --title "New title" --body "Updated"
gh pr edit 123 --add-label bug --remove-label stale
gh pr edit 123 --add-reviewer user1 --remove-reviewer user2
gh pr edit 123 --add-assignee user1 --ready

# Review
gh pr review 123 --approve --body "LGTM!"
gh pr review 123 --request-changes --body "Please fix..."
gh pr review 123 --comment --body "Some thoughts..."

# Checks
gh pr checks 123 [--watch] [--interval 5]

# Lifecycle
gh pr close 123 --comment "Closing because..."
gh pr reopen 123
gh pr ready 123                        # Mark draft as ready
gh pr update-branch 123 [--rebase]
gh pr revert 123 --branch revert-pr-123
gh pr lock 123 --reason off-topic / gh pr unlock 123

# Comment
gh pr comment 123 --body "Looks good!"

# Status
gh pr status [--repo owner/repo]
```

## GitHub Actions

### Workflow Runs (gh run)

```bash
gh run list [--workflow ci.yml] [--branch main] [--limit 20]
gh run list --json databaseId,status,conclusion,headBranch

gh run view 123456789 [--log] [--job 987654321] [--web]
gh run watch 123456789 [--interval 5]

gh run rerun 123456789 [--job 987654321]
gh run cancel 123456789
gh run delete 123456789

gh run download 123456789 [--name build] [--dir ./artifacts]
```

### Workflows (gh workflow)

```bash
gh workflow list
gh workflow view ci.yml [--yaml] [--web]
gh workflow enable ci.yml / gh workflow disable ci.yml

# Manual trigger
gh workflow run ci.yml --raw-field version="1.0.0" environment="production"
gh workflow run ci.yml --ref develop
```

### Caches (gh cache)

```bash
gh cache list [--branch main] [--limit 50]
gh cache delete 123456789
gh cache delete --all
```

### Secrets (gh secret)

```bash
gh secret list
gh secret set MY_SECRET                          # prompts for value
echo "$VALUE" | gh secret set MY_SECRET
gh secret set MY_SECRET --env production
gh secret set MY_SECRET --org orgname
gh secret delete MY_SECRET [--env production]
```

### Variables (gh variable)

```bash
gh variable list
gh variable set MY_VAR "some-value" [--env production] [--org orgname]
gh variable get MY_VAR
gh variable delete MY_VAR [--env production]
```

## Projects (gh project)

```bash
gh project list [--owner owner] [--open]
gh project view 123 [--web]
gh project create --title "My Project" [--org orgname]
gh project edit 123 --title "New Title"
gh project delete 123 / gh project close 123
gh project copy 123 --owner target-owner --title "Copy"

# Fields
gh project field-list 123
gh project field-create 123 --title "Status" --datatype single_select
gh project field-delete 123 --id 456

# Items
gh project item-list 123
gh project item-create 123 --title "New item"
gh project item-add 123 --owner-owner --repo repo --issue 456
gh project item-edit 123 --id 456 --title "Updated title"
gh project item-delete 123 --id 456
gh project item-archive 123 --id 456
```

## Releases (gh release)

```bash
gh release list
gh release view [v1.0.0] [--web]

gh release create v1.0.0 --notes "Release notes" --title "Version 1.0.0"
gh release create v1.0.0 --notes-file notes.md --target main
gh release create v1.0.0 --draft
gh release create v1.0.0 --prerelease

gh release upload v1.0.0 ./file.tar.gz
gh release download v1.0.0 [--pattern "*.tar.gz"] [--dir ./downloads] [--archive zip]
gh release edit v1.0.0 --notes "Updated notes"
gh release delete v1.0.0 --yes
gh release delete-asset v1.0.0 file.tar.gz
```

## Gists (gh gist)

```bash
gh gist list [--public] [--limit 20]
gh gist view abc123 [--files]
gh gist create script.py --desc "My script" --public
gh gist create file1.py file2.py
echo "print('hello')" | gh gist create
gh gist edit abc123
gh gist delete abc123
gh gist clone abc123 [my-directory]
```

## Labels (gh label)

```bash
gh label list
gh label create bug --color "d73a4a" --description "Something isn't working"
gh label edit bug --name "bug-report" --color "ff0000"
gh label delete bug
gh label clone owner/repo [--repo target/repo]
```

## Search (gh search)

```bash
gh search code "TODO" [--repo owner/repo] [--extension py]
gh search commits "fix bug"
gh search issues "label:bug state:open"
gh search prs "is:open review:required"
gh search repos "stars:>1000 language:python" [--limit 50] [--sort stars] [--order desc]
gh search repos "topic:api" --json name,description,stargazers
```

## API Requests (gh api) — Last Resort Only

> **Prefer native subcommands.** Only use `gh api` when no native `gh` subcommand covers the operation. Never use `curl`, `fetch`, or direct calls to `api.github.com`.

```bash
# REST (only when no native subcommand exists)
gh api /user
gh api --method POST /repos/owner/repo/issues \
  --field title="Issue title" \
  --field body="Issue body"
gh api /user/repos --paginate
gh api /user --jq '.login'

# GraphQL (only when no native subcommand exists)
gh api graphql -f query='
{
  viewer {
    login
    repositories(first: 5) {
      nodes { name }
    }
  }
}'

# GitHub Enterprise
gh api /user --hostname enterprise.internal
```

## Other Commands

```bash
# Browse (open in browser)
gh browse [path|issue-number|commit]
gh browse --actions / --projects / --releases / --settings
gh browse --no-browser   # print URL only

# Status overview
gh status [--repo owner/repo]

# Organizations
gh org list [--user username] --json login,name

# SSH / GPG keys
gh ssh-key list
gh ssh-key add ~/.ssh/id_ed25519.pub --title "My laptop"
gh ssh-key delete 12345

gh gpg-key list
gh gpg-key add key.pub
gh gpg-key delete 12345

# Labels
gh label list / create / edit / delete / clone

# Rulesets
gh ruleset list / view 123
gh ruleset check --branch feature [--repo owner/repo]

# Extensions
gh extension list / search / install owner/repo / upgrade / remove
gh extension browse / create my-extension

# Aliases
gh alias list
gh alias set prview 'pr view --web'
gh alias delete prview

# Shell completion
gh completion -s bash > ~/.gh-complete.bash
gh completion -s zsh > ~/.gh-complete.zsh
```

## Output Formatting

```bash
# JSON with jq
gh repo view --json name,description
gh repo view --json owner,name --jq '.owner.login + "/" + .name'
gh pr list --json number,title --jq '.[] | select(.number > 100)'
gh issue list --json number,title,labels \
  --jq '.[] | {number, title, tags: [.labels[].name]}'

# Go template
gh repo view --template '{{.name}}: {{.description}}'
gh pr view 123 --template 'Title: {{.title}}\nAuthor: {{.author.login}}\nState: {{.state}}\n'
```

## Global Flags

| Flag | Description |
|------|-------------|
| `--repo [HOST/]OWNER/REPO` | Select another repository |
| `--hostname HOST` | GitHub hostname |
| `--jq EXPRESSION` | Filter JSON output with jq |
| `--json FIELDS` | Output JSON with specified fields |
| `--template STRING` | Format JSON using Go template |
| `--web` | Open in browser |
| `--paginate` | Make additional API calls for all pages |
| `--verbose` | Show verbose output |
| `--debug` | Show debug output |

## Common Workflows

### Create PR from Issue

```bash
gh issue develop 123 --branch feature/issue-123
git add . && git commit -m "Fix issue #123" && git push
gh pr create --title "Fix #123" --body "Closes #123"
```

### Bulk Operations

```bash
# Close all stale issues
gh issue list --search "label:stale" --json number --jq '.[].number' | \
  xargs -I {} gh issue close {} --comment "Closing as stale"

# Add label to multiple PRs
gh pr list --search "review:required" --json number --jq '.[].number' | \
  xargs -I {} gh pr edit {} --add-label needs-review
```

### Run Workflow and Wait

```bash
RUN_ID=$(gh workflow run ci.yml --ref main --jq '.databaseId')
gh run watch "$RUN_ID"
gh run download "$RUN_ID" --dir ./artifacts
```

### Repository Setup

```bash
gh repo create my-project --public \
  --description "My awesome project" \
  --clone --gitignore python --license mit
cd my-project
gh label create bug --color "d73a4a" --description "Bug report"
gh label create enhancement --color "a2eeef" --description "Feature request"
```

## Best Practices

1. **Never use the raw API**: Always reach for a native `gh` subcommand first. Only fall back to `gh api` when no subcommand covers the operation — and never use `curl`/`fetch` against `api.github.com`.
2. **Automation**: Use `GH_TOKEN` env var instead of interactive login
3. **Default repo**: `gh repo set-default owner/repo` to avoid repetition  
4. **Pagination**: Always use `--paginate` for large result sets
5. **JSON + jq**: Prefer `--json FIELDS --jq EXPR` over parsing text output
6. **Scripting**: Set `GH_PROMPT_DISABLED=true` to suppress interactive prompts

## References

- Manual: https://cli.github.com/manual/
- GitHub Docs: https://docs.github.com/en/github-cli
- REST API: https://docs.github.com/en/rest
- GraphQL API: https://docs.github.com/en/graphql
