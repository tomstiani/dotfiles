---
name: skill-creator
description: Create or update Pi skills with concise instructions, progressive disclosure, and tested helper scripts. Use when adding or changing a skill.
---

# Skill Creator

Create small, task-focused Pi skills. The agent already knows general programming; add only domain knowledge, decisions, or repeatable procedures it cannot reliably reconstruct.

## Locations

- Global: `~/.config/pi/skills/<name>/`
- Project: `.pi/skills/<name>/`
- Shared agent skills: `~/.agents/skills/<name>/`

Each skill needs `SKILL.md` with YAML frontmatter:

```yaml
---
name: example-skill
description: What it does and when to use it.
---
```

Use lowercase hyphenated names matching the directory. Keep descriptions specific: include the task and concrete triggers.

## Structure

```text
skill-name/
├── SKILL.md             # required workflow and navigation
├── references/          # details loaded only when needed
├── scripts/             # deterministic, repeatable operations
└── assets/              # files used in generated output
```

Create only the directories the skill needs. Keep `SKILL.md` concise; move long examples, schemas, and variant-specific guidance into directly linked references. Avoid README, setup, changelog, and other auxiliary files.

## Workflow

1. Define the concrete tasks and phrases that should trigger the skill.
2. Write the smallest reliable workflow, including decision points and safety checks.
3. Add a script only when it avoids repeatedly rewriting deterministic code; test every new script.
4. Add references only for details that are genuinely loaded on demand; link them directly from `SKILL.md`.
5. Validate the skill:

```bash
~/.config/pi/skills/skill-creator/scripts/validate-skill.sh path/to/skill
```

6. Try it on a real task and remove anything that does not improve the result.

## Design rules

- Progressive disclosure: metadata → `SKILL.md` → references.
- Prefer a few strong examples over exhaustive prose.
- Use imperative instructions and explicit commands for fragile operations.
- Do not duplicate information between `SKILL.md` and references.
- Never add speculative flexibility or documentation for its own sake.
