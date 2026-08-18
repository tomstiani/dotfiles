# Technical PRD: gh-dash PR Workflows in Herdr

## Status

Implemented

See [Herdr worktree workflows](./herdr-worktree-workflows.md) for the user and operations guide.

## Summary

Add two `gh-dash` actions that open pull requests in Herdr without tmux:

- **Work on PR:** create or reuse the PR worktree, register it as a Herdr worktree workspace, and let `herdr-plus` apply the standard development layout.
- **Review PR:** create or reuse the PR worktree workspace and run `tuicr pr <number>` in a dedicated review tab.

Use existing tools for their established responsibilities:

- `gh-dash`: selected PR context and action dispatch
- `worktrunk`: PR-aware worktree resolution
- Herdr: workspaces, focus, and process hosting
- `herdr-plus`: declarative worktree layout
- `tuicr`: pull-request review

A small bridge script connects these tools. It must not recreate their worktree, layout, or review behavior.

## Problem

The current PR workflow is orchestrated through tmux shell functions. It creates tmux sessions, windows, panes, and adaptive layouts before launching development or review tools. This conflicts with adopting Herdr as the workspace manager and duplicates capabilities already available through Herdr plugins.

Herdr's native worktree API is branch-oriented and does not resolve pull-request shortcuts. `worktrunk` already supports `pr:<number>`, including remote and fork-related resolution. `herdr-plus` already applies layouts when Herdr opens a worktree. The missing component is a reliable adapter from `gh-dash` PR context to those tools.

## Goals

1. Open a selected PR as a Herdr worktree workspace from `gh-dash`.
2. Apply the standard development layout through `herdr-plus`.
3. Open a selected PR for review in `tuicr` within Herdr.
4. Keep the `gh-dash` process and dashboard workspace alive.
5. Make repeated actions idempotent.
6. Support repository paths containing spaces and PRs originating from forks.
7. Remove tmux from these two new execution paths.

## Non-goals

- Replacing `gh-dash` with a Herdr GitHub dashboard plugin.
- Reimplementing worktree management, layout management, or PR review.
- Publishing a general-purpose Herdr plugin in the first version.
- Automatically choosing between development and review based on PR author.
- Managing merged-worktree cleanup.
- Adding CI/checks panes.
- Installing or configuring `herdr-reviewr` or `herdr-pickr`.

## User experience

### Work on a PR

1. The user selects a PR in `gh-dash`.
2. The user presses `W`.
3. The bridge resolves or creates the PR worktree through `worktrunk`.
4. The bridge opens or focuses the checkout as a Herdr worktree workspace.
5. `herdr-plus` applies the configured development layout.
6. Herdr focuses the PR workspace.

Expected layout:

```text
PR worktree workspace
└─ development tab
   ├─ nvim
   ├─ Pi
   └─ shell
```

The exact tab and pane layout belongs to `herdr-plus`, not the bridge.

### Review a PR

1. The user selects a PR in `gh-dash`.
2. The user presses `R`.
3. The bridge creates or focuses the PR's native Herdr worktree workspace.
4. The bridge creates or reuses a `review-pr-<number>` tab.
5. The tab runs `tuicr pr <number>` and Herdr focuses it.

Review uses the PR worktree so Herdr's sidebar shows the correct repository and worktree hierarchy.

## Architecture

```text
                    ┌──────────────────┐
                    │     gh-dash      │
                    │ RepoPath + PR #  │
                    └────────┬─────────┘
                             │
                     managed bridge
                      work / review
                    ┌────────┴─────────┐
                    │                  │
                    ┌───────▼────────┐
                    │ worktrunk      │
                    │ wt switch pr:N │
                    └───────┬────────┘
                            │ checkout path
                    ┌───────▼────────┐
                    │ Herdr worktree │
                    │ open / focus   │
                    └───────┬────────┘
                            │
               ┌────────────┴────────────┐
               │                         │
        ┌──────▼──────┐          ┌──────▼──────┐
        │ herdr-plus  │          │ review tab  │
        │ development│          │ + tuicr     │
        └─────────────┘          └─────────────┘
```

## Components

### 1. gh-dash keybindings

Add two PR keybindings to the managed `gh-dash` configuration:

```yaml
keybindings:
  prs:
    - key: W
      name: work on PR in Herdr
      command: >-
        herdr-pr work "{{.RepoPath}}" "{{.PrNumber}}"
    - key: R
      name: review PR in Herdr
      command: >-
        herdr-pr review "{{.RepoPath}}" "{{.PrNumber}}"
```

The final command may use an absolute managed script path if `gh-dash` does not inherit the expected `PATH`.

### 2. Bridge script

Provide one executable with two subcommands:

```text
herdr-pr work <repo-path> <pr-number>
herdr-pr review <repo-path> <pr-number>
```

Responsibilities:

- validate arguments
- normalize the repository path
- verify required commands
- call `worktrunk`, Herdr, or `tuicr`
- parse JSON instead of display output
- focus the resulting Herdr workspace
- emit actionable errors

It must not define pane layouts or duplicate plugin behavior.

### 3. herdr-plus layout

Configure one wildcard or repository-specific worktree layout containing the desired development tools. A representative layout is:

```toml
repo = "*"

[[tabs]]
name = "development"

[[tabs.panes]]
label = "editor"
command = "nvim ."

[[tabs.panes]]
label = "agent"
command = "pi"
split = "right"

[[tabs.panes]]
label = "shell"
command = "~/.local/bin/herdr-worktree-layout"
split = "down"
```

The exact split geometry should be validated against `herdr-plus`; the PR bridge only depends on a matching layout existing.

## Functional requirements

### FR-1: Input validation

The bridge must:

- require exactly one mode: `work` or `review`
- require an existing local Git repository path
- accept only a positive decimal PR number
- reject missing commands before mutating workspace state

Required commands:

- both modes: `herdr`, `gh`, `wt`, `jq`
- work mode: `herdr-worktree-layout`
- review mode: `tuicr`

### FR-2: Herdr session targeting

The command must target the Herdr session that launched `gh-dash` by preserving the Herdr environment inherited by the action. It must not attach to or guess another session.

If no Herdr socket/session context is available, the bridge must fail with an instruction to launch `gh-dash` inside Herdr.

### FR-3: Worktree resolution

Work mode must run the equivalent of:

```sh
wt -C "$repo" switch "pr:$pr" --no-cd --format=json
```

Normal Worktrunk lifecycle hooks run so repository bootstrap behavior remains consistent with worktrees created through the Worktrunk picker.

The bridge must read the checkout path from structured output and verify that it is an existing Git worktree before calling Herdr.

### FR-4: Worktree workspace registration

The bridge must resolve the parent/root Herdr workspace for the repository, then call `herdr worktree open` with the checkout path and a stable label.

Suggested label priority:

1. PR head branch
2. `pr-<number>`

The bridge must use IDs returned by Herdr rather than deriving them.

### FR-5: Idempotency

Repeated `work` actions for the same checkout must:

- focus an existing Herdr worktree workspace when already open
- avoid reopening the worktree
- avoid firing duplicate layout creation

Repeated `review` actions for the same repository and PR must:

- focus the existing review tab when its `tuicr` process is still running
- otherwise create the tab or restart its idle root pane
- never create unbounded duplicate workspaces, tabs, or panes

A stable identity should be attached to each workflow:

```text
work:   canonical checkout path
review: canonical checkout path + PR number
```

### FR-6: Review tab

Review mode must resolve the PR worktree and create a tab with:

- workspace: the canonical PR worktree workspace
- `cwd`: canonical checkout path
- label: `review-pr-<number>`
- root command: `tuicr pr <number>`

The PR number must be validated before being included in the pane command.

### FR-7: Focus behavior

Successful actions must focus the target workspace. The source `gh-dash` workspace must remain open and retain its process.

### FR-8: Errors

Errors must be visible to the user without destroying the dashboard. Messages must include:

- failed stage
- repository and PR number
- relevant command error
- one concrete recovery action when known

Examples:

```text
herdr-pr: worktrunk could not resolve PR #123 in owner/repo
herdr-pr: Herdr is unavailable; run gh-dash inside a Herdr pane
herdr-pr: tuicr is not installed
```

## Data and command contracts

### gh-dash input

| Field | Source | Use |
|---|---|---|
| `RepoPath` | `gh-dash repoPaths` | Local repository root |
| `RepoName` | gh-dash PR row | Optional diagnostics |
| `PrNumber` | gh-dash PR row | PR identifier |

### worktrunk output

The bridge expects JSON containing a checkout path. It must fail closed if the path is absent or invalid rather than scraping human-readable output.

### Herdr output

The bridge must parse JSON responses for:

- source workspace ID
- worktree workspace ID
- root pane ID
- workspace focus result

No workspace, tab, or pane identifier may be predicted.

## Security requirements

1. Treat `RepoPath`, branch names, labels, and PR metadata as untrusted input.
2. Use argument arrays where possible.
3. When a shell command is unavoidable, quote every substituted value.
4. Validate PR numbers before passing them to commands.
5. Do not use `eval`.
6. Do not write GitHub tokens or command output containing secrets to persistent logs.
7. Do not force-remove worktrees or discard local changes.
8. Do not execute commands sourced from PR content.

## Reliability requirements

- Canonicalize paths before comparing workspace identity.
- Use an atomic lock keyed by repository and PR while creating/opening a worktree.
- Release locks on success, error, and interruption.
- Preserve tool stderr for diagnostics.
- Do not leave a half-created Herdr workspace when worktree resolution fails.
- If worktree creation succeeds but Herdr registration fails, preserve the checkout and report its path for recovery.

## Dependencies

Required:

- Herdr supporting plugin actions, workspace APIs, and worktree APIs
- authenticated GitHub CLI
- worktrunk with `pr:<number>` shortcut and JSON output
- `jq`
- `tuicr`
- `herdr-worktrunk`
- `herdr-plus`

Optional:

- `herdr-reviewr`
- `herdr-pickr`

## Configuration ownership

| Concern | Owner |
|---|---|
| PR selection and keys | `gh-dash` |
| PR checkout resolution | `worktrunk` |
| Workspace lifecycle | Herdr |
| Development layout | `herdr-plus` |
| Review interface | `tuicr` |
| Cross-tool adaptation | `herdr-pr` bridge |

All personal configuration and bridge files must be managed through chezmoi. Generated Herdr session state, plugin caches, and logs must remain unmanaged.

## Testing strategy

### Bridge self-checks

Provide one lightweight runnable test script or shell test covering:

- invalid mode
- missing repository
- invalid PR number
- path containing spaces
- missing dependency
- malformed worktrunk JSON
- missing checkout path
- existing workspace detection

External commands should be replaced with temporary test doubles on `PATH`; no test should mutate a real repository or Herdr session.

### Manual integration matrix

| Scenario | Expected result |
|---|---|
| Own PR | Worktree opens with development layout |
| Fork PR | Correct PR head is checked out |
| Existing worktree | Existing workspace is focused |
| `W` pressed twice | No duplicate layout or workspace |
| Review PR | `tuicr` opens in repository context |
| `R` pressed twice | Existing worktree workspace, review tab, and `tuicr` process are reused |
| Repository path contains spaces | Both modes succeed |
| Herdr unavailable | Clear error; dashboard stays alive |
| Worktrunk failure | No Herdr workspace is created |
| Herdr registration failure | Checkout remains; recovery path is printed |

## Observability

The bridge should log only concise stage transitions to stderr when debugging is enabled:

```text
resolve-pr-worktree
find-parent-workspace
open-worktree-workspace
focus-workspace
```

Normal successful runs should remain quiet. Plugin diagnostics remain available through Herdr's plugin logs.

## Rollout

### Phase 1: Prerequisites

1. Install and inspect `herdr-plus`.
2. Add the development worktree layout.
3. Confirm that a manually opened worktree receives exactly one layout.

### Phase 2: Bridge

1. Implement `work` mode.
2. Validate idempotency and fork PR handling.
3. Implement `review` mode.
4. Run bridge self-checks and manual integration tests.

### Phase 3: gh-dash cutover — complete

1. Test from the live Herdr-hosted dashboard.
2. Replace the old tmux `W`/`R` workflow.
3. Remove obsolete tmux PR functions, bindings, and documentation.
4. Document the Herdr and Worktrunk key sequences.

## Rollback

Restore the previous `gh-dash` keybindings. Worktrees created during testing remain ordinary Git worktrees and must not be deleted automatically. Uninstalling `herdr-plus` or removing its layout must not remove worktrees or branches.

## Acceptance criteria

The feature is complete when:

1. `W` opens or focuses the selected PR's Herdr worktree workspace.
2. The configured `herdr-plus` development layout appears exactly once.
3. `R` opens or focuses `tuicr` for the selected PR.
4. Repeating either action does not create duplicate workspaces or panes.
5. Fork PRs work.
6. Repository paths containing spaces work.
7. Failures leave `gh-dash` alive and show an actionable error.
8. Neither path invokes tmux.
9. Automated bridge checks pass.
10. All portable configuration is managed by chezmoi.

## Implementation decisions

1. Normal Worktrunk lifecycle hooks run.
2. Review uses a persistent tab in the PR worktree workspace; an idle tab restarts `tuicr`.
3. Review reuse is identified by canonical checkout path and the `review-pr-<number>` tab label; no state file is needed.
4. The `herdr-plus` development layout is wildcard-based.
5. A managed bridge script remains sufficient; a dedicated plugin is not currently needed.
6. Pane orientation is delegated to `herdr-worktree-layout`, launched by the layout's shell pane and re-run by `W` for existing workspaces.
