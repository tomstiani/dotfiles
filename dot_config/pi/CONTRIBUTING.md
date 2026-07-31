# Contributing to pi-extensions

We use [Otard95/pi-extensions](https://github.com/Otard95/pi-extensions) as a pi package.
The local clone lives at `~/.config/pi/git/github.com/Otard95/pi-extensions`.

## Setup

The upstream remote (`origin`) is read-only. A personal fork is used for pushing branches.
The fork remote is named `fork` and points at `tomstiani/pi-extensions`.

If the fork remote is missing (e.g. after a fresh clone):

```bash
git -C ~/.config/pi/git/github.com/Otard95/pi-extensions \
  remote add fork git@github.com:tomstiani/pi-extensions.git
```

If the fork itself doesn't exist yet:

```bash
gh repo fork Otard95/pi-extensions --clone=false
```

## Workflow

```bash
REPO=~/.config/pi/git/github.com/Otard95/pi-extensions

# 1. Start from a clean main
git -C $REPO checkout main
git -C $REPO pull origin main

# 2. Create a branch
git -C $REPO checkout -b feat/my-change

# 3. Make changes, commit
git -C $REPO add <files>
git -C $REPO commit -m "type(scope): Description"

# 4. Push to fork and open PR against upstream
git -C $REPO push -u fork feat/my-change
gh pr create \
  --repo Otard95/pi-extensions \
  --head tomstiani:feat/my-change \
  --base main \
  --title "type(scope): Description" \
  --body "..."
```

## After a PR is merged

```bash
REPO=~/.config/pi/git/github.com/Otard95/pi-extensions

# Sync fork's main with upstream
gh repo sync tomstiani/pi-extensions --source Otard95/pi-extensions

# Delete the merged branch locally and on the fork
git -C $REPO checkout main
git -C $REPO branch -d feat/my-change
git -C $REPO push fork --delete feat/my-change
```

Pi picks up the merged changes on the next `/reload` or restart — no changes to `settings.json` needed.

## Conventions

- Commit messages follow conventional commits: `type(scope): Description`
- PR title mirrors the commit message

