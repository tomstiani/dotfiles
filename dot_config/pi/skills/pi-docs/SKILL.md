---
name: pi-docs
description: Reference documentation for pi, the coding agent harness. Use when asked about pi itself, its SDK, extensions, themes, skills, TUI, keybindings, prompt templates, custom providers, models, or packages.
---

# Pi Documentation

Pi is a coding agent harness. The main documentation and related docs are located at:

- Main documentation: /Users/tom.stian.ingebretson/.nvm/versions/node/v22.19.0/lib/node_modules/@mariozechner/pi-coding-agent/README.md
- Additional docs: /Users/tom.stian.ingebretson/.nvm/versions/node/v22.19.0/lib/node_modules/@mariozechner/pi-coding-agent/docs
- Examples: /Users/tom.stian.ingebretson/.nvm/versions/node/v22.19.0/lib/node_modules/@mariozechner/pi-coding-agent/examples

## Topic Index

| Topic | File |
|-------|------|
| Extensions | `docs/extensions.md`, `examples/extensions/` |
| Themes | `docs/themes.md` |
| Skills | `docs/skills.md` |
| Prompt templates | `docs/prompt-templates.md` |
| TUI components | `docs/tui.md` |
| Keybindings | `docs/keybindings.md` |
| SDK integrations | `docs/sdk.md` |
| Custom providers | `docs/custom-provider.md` |
| Adding models | `docs/models.md` |
| Pi packages | `docs/packages.md` |

## Usage

When working on pi topics, read the relevant `.md` files completely and follow cross-references before implementing. Always read linked docs (e.g., `tui.md` for TUI API details).

## This Installation

**Agent dir:** `~/.config/pi/` (not the default `~/.pi/agent/`)

This is set via `PI_CODING_AGENT_DIR=/Users/tom.stian.ingebretson/.config/pi` in the shell. All user config, extensions, skills, sessions, and settings live under `~/.config/pi/`.

| Path | Purpose |
|------|---------|
| `~/.config/pi/extensions/` | Global extensions |
| `~/.config/pi/skills/` | Global skills |
| `~/.config/pi/settings.json` | Settings |
| `~/.config/pi/sessions/` | Sessions |

> **Always resolve the actual agent dir before writing files.** Check `PI_CODING_AGENT_DIR` first (`echo $PI_CODING_AGENT_DIR`), then fall back to `~/.pi/agent/` if unset.
