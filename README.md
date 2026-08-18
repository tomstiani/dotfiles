# Personal workflow configuration

This is the chezmoi source directory for the local macOS development setup.

## Herdr worktree workflow

Herdr is the workspace manager. Worktrunk owns Git worktrees, `herdr-plus` owns the development layout, and `tuicr` owns pull-request review.

### Pull requests from `gh-dash`

Run `gh dash` inside a Herdr repository workspace, select a PR, and use:

| Key | Action |
|---|---|
| `W` | Resolve the PR with Worktrunk, open/reuse its Herdr worktree, and focus the development layout |
| `R` | Resolve/reuse the PR worktree and run `tuicr pr <number>` in a review tab |

Both actions are idempotent. They reuse existing workspaces, tabs, and processes instead of creating duplicates. Fork PRs and repository paths containing spaces are supported.

### Create a regular worktree

From any Herdr repository workspace:

- `Ctrl+A`, then `Shift+G`: create/switch from the default branch
- `Ctrl+A`, then `Shift+C`: create/switch from the current branch
- `Ctrl+A`, then `Shift+D`: remove a worktree

Release `Ctrl+A` before pressing the second key.

New worktrees opened through the Worktrunk picker receive the same adaptive development layout as PR worktrees:

```text
landscape: editor | agent + shell
portrait:  editor / agent / shell
```

## Configuration map

| Source | Purpose |
|---|---|
| `dot_config/gh-dash/config.yml` | `W` and `R` PR actions |
| `dot_config/herdr/config.toml` | Herdr keybindings |
| `dot_config/herdr/plugins/config/cloudmanic.herdr-plus/worktrees/development.toml` | Development tab and panes |
| `dot_local/bin/executable_herdr-pr` | PR bridge |
| `dot_local/bin/executable_herdr-worktree-layout` | Portrait/landscape adjustment |
| `dot_local/private_share/herdr-pr/executable_self-check` | Contract-focused regression check |
| `dot_config/docs/herdr-worktree-workflows.md` | User guide |
| `dot_config/docs/herdr-gh-dash-prd.md` | Technical design and acceptance criteria |

## Validation

```sh
~/.local/share/herdr-pr/self-check
chezmoi diff
```

The self-check uses strict command doubles for edge cases. Real Herdr and Worktrunk integration should also be exercised after upgrading either tool.

## Applying changes

Edit files in this source directory, inspect the diff, then apply intentionally:

```sh
chezmoi diff
chezmoi apply
```

`README.md` is source-repository documentation and is ignored by chezmoi, so it will not create `~/README.md`.
