# Repo Workspace Cockpit

A repo-specific terminal workspace built from `tmux`, `gh dash`, `worktrunk`, `nvim`, `pi`, and `tuicr`.

## Mental model

```text
tmux session = repository
tmux window  = branch / worktree / PR task
tmux panes   = tools / systems
```

Example:

```text
frontend-monorepo
├─ current window
│  └─ gh dash
└─ feat_uniwind
   ├─ nvim or tuicr
   ├─ pi
   └─ shell
```

## Commands

### `rdash`

Open the repo dashboard.

- Finds the current git repo root.
- Uses the repo basename as the tmux session name.
- Inside tmux, renames the current window to `dashboard` and runs `gh dash` in the current pane/window.
- Outside tmux, creates/attaches the repo session and uses a `dashboard` window.
- Does not reset `gh dash` if it is already running in that pane.
- Leaves a shell open when `gh dash` exits.

### `rtask [name]`

Open a task-focused window for the current branch or a custom name.

- Window name defaults to current branch.
- Creates an adaptive task layout:
  - landscape/wide: `nvim` left, `pi` top-right, shell bottom-right
  - portrait/narrow: `pi` top, `nvim` middle, small shell bottom
- Panes stay open after their tool exits.

### `rpr <repo-path> <pr-number>`

Open a PR workspace from `gh dash`.

- Gets the PR head branch with `gh pr view`.
- Sanitizes branch names for tmux windows (`feat/foo` → `feat_foo`).
- Creates or switches to the branch window.
- Runs `worktrunk` inside the PR window, not the dashboard.
- Uses `wt switch --no-hooks pr:N --format json` to get the worktree path.
- Sets up the adaptive task layout in that worktree.
- Opens `nvim` for your own PRs.
- Opens `tuicr pr N` for PRs authored by someone else.

### `rtuicr`

Open a review pane in the current window.

- Landscape/wide: right-side split.
- Portrait/narrow: bottom split.

```text
tuicr -w
```

The pane stays open after `tuicr` exits.

## gh-dash integration

`~/.config/gh-dash/config.yml` adds this PR keybinding:

```yaml
- key: W
  name: open PR workspace
  command: zsh -ic 'rpr "{{.RepoPath}}" "{{.PrNumber}}"'
```

Press `W` on a selected PR to open its worktree/task window.

Existing bindings:

- `R`: review PR in `tuicr`
- `A`: checkout + `pi`
- `T`: checks in `gh enhance`

## Intended behavior

From `gh dash`:

1. Select a PR.
2. Press `W`.
3. Stay out of the dashboard path.
4. Create/switch a PR branch window.
5. Let `worktrunk` fetch/create/switch the worktree inside that window.
6. Open the standard panes once the worktree path is known.
7. Use `nvim` as the primary pane for your PRs, or `tuicr` for other authors' PRs.

## Design constraints

- Dashboard is repo-level and can run in whichever tmux window/pane invoked `rdash`.
- Work windows are branch/worktree-specific.
- Work windows adapt to tmux dimensions: wide screens split side-by-side, narrow screens stack vertically.
- All panes in a work window share the same cwd.
- Tool panes should fall back to a shell instead of closing.
- Avoid tmux `send-keys` for setup; start commands directly or respawn panes.
- Avoid worktrunk hooks for this flow; tmux owns orchestration.

## Future features

- Detect PR windows by PR number even after branch rename.
- Add a toggle to switch a PR primary pane between `nvim` and `tuicr`.
- Add a checks/logs pane for `gh enhance` or CI output.
- Add `worktrunk` cleanup command for merged PR worktrees.
- Add repo dashboard panes beyond `gh dash` when they become useful.
- Add status repair command for half-created tmux windows.

## Troubleshooting

### Dashboard gets renamed or blocked

`worktrunk` ran in the dashboard process. The intended path is `rpr`, which starts `wt` inside the PR window via `_rpr_setup`.

### Only nvim pane exists

Run `W` again on the PR. `rpr` repairs windows with fewer than 3 panes.

### nvim/Oil shows an empty directory

The nvim pane should be launched with the explicit worktree path:

```zsh
nvim "$root"
```

Kill and recreate the window if it was created before that fix.

### Tool exits close panes

Tool commands should use shell fallbacks:

```zsh
gh dash; exec $SHELL
nvim .; exec $SHELL
pi; exec $SHELL
tuicr -w; exec $SHELL
```
