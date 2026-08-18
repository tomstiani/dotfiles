---
name: clickup-cli
description: Use clickup-cli for ClickUp tasks, lists, spaces, comments, time tracking, and documents. Use when the user wants to inspect or manage ClickUp project data.
---

# ClickUp CLI

Requires `CLICKUP_API_TOKEN` and `CLICKUP_TEAM_ID`.

```bash
clickup-cli <command> [flags]
clickup-cli --help
clickup-cli <command> --help
```

## Safety

- Read-only commands can run normally.
- Before creating, editing, commenting, updating status, or otherwise mutating ClickUp data, show the command and get explicit user approval.
- Never print or expose `CLICKUP_API_TOKEN`.

## Task IDs

Internal IDs such as `869b827uy` work directly. Custom IDs such as `MA-25578` or `GQL-456` require `-c`/`--custom`.

```bash
clickup-cli task get MA-25578 -c
clickup-cli task get 869b827uy
```

## Tasks

```bash
# Inspect and search
clickup-cli task get TASK_ID [-c] [-s]
clickup-cli task search [QUERY] [-l LIST_ID] [-S SPACE_ID] [-a USER_ID] [-s STATUS]
clickup-cli task rels TASK_ID [-c]

# Mutate after approval
clickup-cli task update TASK_ID [-c] [-t TITLE] [-d DESCRIPTION] [-s STATUS]
clickup-cli task subtask PARENT_ID NAME [-c] [-d DESCRIPTION] [-l LIST_ID]
```

Descriptions accept Markdown. Assignee filters use numeric user IDs; `assignees[]=me` is not supported.

## Spaces and lists

```bash
clickup-cli space search [QUERY]
clickup-cli space structure SPACE_ID
clickup-cli list info LIST_ID
clickup-cli list tasks LIST_ID [-a] [-A USER_IDS]
```

Use `list info` to discover valid statuses before updating a task.

## Comments and time

```bash
clickup-cli comment get TASK_ID
clickup-cli time get [TASK_ID] [-t TEAM_ID]
```

## Documents

```bash
clickup-cli doc search [QUERY] [-n MAX] [--cursor CURSOR]
clickup-cli doc pages DOC_ID
clickup-cli doc read DOC_ID [PAGE_ID]
```

Use `doc pages` first when you need to read one page from a document.

## Typical inspection flow

```bash
clickup-cli space search "Engineering"
clickup-cli space structure SPACE_ID
clickup-cli list info LIST_ID
clickup-cli list tasks LIST_ID
clickup-cli task get MA-25578 -c -s
clickup-cli task rels MA-25578 -c
clickup-cli comment get INTERNAL_TASK_ID
```

For commands not listed here, inspect the CLI help instead of guessing flags.
