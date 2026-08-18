---
name: pi-docs
description: Reference documentation for pi, its SDK, extensions, themes, skills, TUI, keybindings, prompts, providers, models, and packages. Use when asked about pi itself.
---

# Pi documentation

Use the installed pi documentation, not memory. Find the package root first:

```bash
npm root -g
find "$(npm root -g)" -maxdepth 3 -type d -name 'pi-coding-agent' -print
```

Read the package `README.md` and the relevant file under `docs/`:

| Topic | Documentation |
|---|---|
| Extensions | `docs/extensions.md` |
| Themes | `docs/themes.md` |
| Skills | `docs/skills.md` |
| Prompt templates | `docs/prompt-templates.md` |
| TUI | `docs/tui.md` |
| Keybindings | `docs/keybindings.md` |
| SDK | `docs/sdk.md` |
| Providers/models | `docs/custom-provider.md`, `docs/models.md` |
| Packages | `docs/packages.md` |

Follow linked documentation when implementing an API; do not invent options or paths.

## Agent directory

Resolve the active directory before reading or writing configuration:

```bash
printf '%s\n' "${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
```

Typical locations are:

- `~/.config/pi/extensions/`
- `~/.config/pi/skills/`
- `~/.config/pi/settings.json`
- `~/.config/pi/sessions/`
