# Herdr worktree workflows

This setup uses Worktrunk for Git worktrees, Herdr for workspace management, `herdr-plus` for pane layouts, and `tuicr` for pull-request review.

## Quick reference

| Action | Keys | Result |
|---|---|---|
| Work on the selected PR | `W` in `gh-dash` | Creates or reuses its worktree and opens the development tab |
| Review the selected PR | `R` in `gh-dash` | Creates or reuses its worktree and opens `tuicr` in a review tab |
| Switch/create from the default branch | `Ctrl+A`, then `Shift+G` in Herdr | Opens the Worktrunk picker |
| Switch/create from the current branch | `Ctrl+A`, then `Shift+C` in Herdr | Opens the Worktrunk picker using the current branch as the base |
| Remove a worktree | `Ctrl+A`, then `Shift+D` in Herdr | Opens the Worktrunk removal picker |

Herdr key sequences are sequential: release `Ctrl+A` before pressing the second key.

## PR workflow

Run `gh dash` inside the repository's root Herdr workspace. Select a pull request and use:

### `W`: develop

1. `herdr-pr` asks Worktrunk to resolve `pr:<number>`.
2. Worktrunk creates or reuses the checkout, including fork PR resolution.
3. Herdr opens or focuses the checkout as a native worktree workspace.
4. `herdr-plus` creates the `development` tab.
5. The adaptive layout helper selects a portrait or landscape arrangement.

The development tab contains:

- `editor`: `nvim .`
- `agent`: `pi`
- `shell`: an idle shell

### `R`: review

`R` resolves the same PR worktree, then creates or reuses a `review-pr-<number>` tab in that worktree workspace. The tab runs:

```sh
tuicr pr <number>
```

Keeping review inside the worktree workspace makes the branch and worktree hierarchy appear correctly in Herdr's sidebar. Repeated presses focus the existing tab and process rather than creating duplicates.

## Creating any worktree

From a Herdr repository workspace, press `Ctrl+A`, then `Shift+G`. Select an existing branch or enter a new branch name. Worktrunk creates the checkout and Herdr opens it as a native worktree workspace.

Use `Ctrl+A`, then `Shift+C` when the new branch should start from your current branch rather than the repository's default branch.

The same adaptive development layout applies whether the worktree came from `W`, `R`, or the Worktrunk picker.

## Adaptive layout

The layout helper reads Herdr's terminal area when the worktree opens.

Landscape:

```text
┌──────────────┬──────────────┐
│              │    agent     │
│    editor    ├──────────────┤
│              │    shell     │
└──────────────┴──────────────┘
```

Portrait:

```text
┌─────────────────────────────┐
│           editor            │
├─────────────────────────────┤
│           agent             │
├─────────────────────────────┤
│           shell             │
└─────────────────────────────┘
```

Terminal cells are taller than they are wide, so portrait detection uses the terminal area's aspect ratio rather than comparing rows and columns one-to-one. Running `W` again rechecks an existing workspace; newly opened Herdr worktrees adapt automatically.

## Behavior and safety

- Worktrees and workspaces are identified by canonical checkout paths.
- Actions are locked per repository and PR to prevent duplicate concurrent opens.
- Existing worktrees, tabs, and running `tuicr` processes are reused.
- A failed Herdr open preserves the Git worktree and reports its path.
- Errors appear as Herdr notifications while `gh-dash` remains running.
- Literal `~/` repository paths from `gh-dash` are expanded safely; shell evaluation is not used.
- Removing or closing a Herdr workspace does not automatically delete its Git worktree.

## Troubleshooting

### Nothing happens after pressing `W` or `R`

The action must inherit a Herdr session. Start `gh dash` inside a Herdr pane. Failures should appear as a bottom-right Herdr notification.

### The layout did not appear

Check the plugin event log:

```sh
herdr plugin log list --plugin cloudmanic.herdr-plus
```

Confirm the plugin is enabled:

```sh
herdr plugin list | grep cloudmanic.herdr-plus
```

### Verify the bridge

Run the managed self-check:

```sh
~/.local/share/herdr-pr/self-check
```

This checks argument validation, paths containing spaces, malformed CLI output, reuse behavior, review restart behavior, and portrait reorientation with strict command doubles. Real integration behavior should still be checked after Herdr or Worktrunk upgrades because their CLI schemas are external contracts.

## Managed files

| File | Purpose |
|---|---|
| `~/.config/gh-dash/config.yml` | `W` and `R` bindings |
| `~/.local/bin/herdr-pr` | PR workflow bridge |
| `~/.local/bin/herdr-worktree-layout` | Adaptive pane orientation |
| `~/.config/herdr/plugins/config/cloudmanic.herdr-plus/worktrees/development.toml` | Development tab definition |
| `~/.config/herdr/config.toml` | Worktrunk picker keybindings |
| `~/.local/share/herdr-pr/self-check` | Runnable regression check |

Portable sources are managed by chezmoi. Herdr session state, generated plugin files, and worktree checkouts are intentionally unmanaged.
