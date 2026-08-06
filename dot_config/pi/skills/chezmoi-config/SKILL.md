---
name: chezmoi-config
description: Use when editing dotfiles, config files, shell/editor/terminal/tool settings, files under ~/.config, or adding new local developer workflows/systems. Check whether the change should be managed by chezmoi before editing destination files.
---

# Chezmoi Config

When touching personal config, dotfiles, or developer workflow files:

1. Check whether the target is managed:
   ```bash
   chezmoi source-path <path>
   ```
2. If managed, edit the returned chezmoi source path, not the destination.
3. If adding a new config/workflow file under `$HOME`, ask: should this be portable dotfiles state?
   - Yes: create/edit it through chezmoi source, then `chezmoi apply --dry-run --verbose <path>`.
   - No: leave it local-only and do not add it.
4. Use `chezmoi diff` before applying; only run real `chezmoi apply` when intended.

Default: portable config belongs in chezmoi; caches, secrets, sessions, auth, generated state, and machine-local temp files do not.
