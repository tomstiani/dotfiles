---
name: tuicr
description: Use tuicr for terminal-native human code review. Launch working-tree or PR review panes, read persisted review comments, and feed anchored feedback back into pi.
---

# tuicr Review Workflow

Use this when the user wants a real review pass for your changes, says "let me review this", or asks to work from tuicr comments.

## User reviews agent changes

1. From the repo root, open tuicr:

```bash
tmux split-window -h -l 60% 'tuicr -w'
```

If not in tmux, tell the user to run `tuicr -w` in the repo.

2. Find the session slug:

```bash
tuicr review list --repo .
```

Prefer the single row with `"active": true`. If multiple sessions fit, ask which `slug` to use.

3. When the user says comments are ready, or after the pane exits, read comments:

```bash
tuicr review comments --repo . --session <slug>
```

The output is JSON. Treat each item as user feedback. Use `location`, `path`, `start_line`, `end_line`, `comment_type`, and `content` as the source of truth.

Severity convention:

- `issue`: fix first
- `suggestion`: implement if cheap, otherwise explain why not
- `note`: answer or acknowledge
- `praise`: no action

Before claiming done, rerun `tuicr review comments --repo . --session <slug>` in case the user added more comments while you worked.

## PR review

Open a PR in tuicr:

```bash
tmux new-window -c /path/to/repo 'tuicr pr <number>'
```

PR session slugs look like `gh:owner/repo/pr/<number>` and can be read without `--repo`:

```bash
tuicr review comments --session gh:owner/repo/pr/<number>
```

## Agent-authored comments

Do not add comments unless the user explicitly asks you to write findings into tuicr.

```bash
tuicr review add --repo . --session <slug> \
  --target-file src/main.rs \
  --line 42 \
  --side new \
  --type issue \
  --username "pi" \
  "Handle the empty case here."
```

Omit `--target-file` for a review-level comment. Add `--end-line` for a range comment. Use `--side old` for removed lines.
