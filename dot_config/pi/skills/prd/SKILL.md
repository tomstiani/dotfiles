---
name: prd
description: >
  Generate a Product Requirements Document (PRD) from session context. Produces
  a well-structured markdown file using the full feature set of
  markdown-preview.nvim: Mermaid diagrams (flowchart, sequence, gantt, journey),
  KaTeX math, task lists, emoji, tables, and a TOC. Use when the user asks to
  write a PRD, spec, product brief, or requirements document for a feature or
  product discussed in the session.
---

# PRD Skill

## Workflow

1. **Mine the session** — extract problem, personas, goals, constraints, and any technical details already discussed. Do not ask for information that can be inferred.
2. **Read the template** — load `assets/prd-template.md` as the structural skeleton.
3. **Fill every section** — replace all `{placeholders}` with real content. Leave no placeholder unfilled; omit sections that truly don't apply rather than leaving them empty.
4. **Write the file** — save to `{feature-name}-prd.md` in the current working directory (or wherever the user specifies).
5. **Confirm** — tell the user the file path and suggest `<leader>mp` to preview it.

## Markdown Feature Usage

Use these features purposefully — not decoratively:

| Feature | When to use |
|---------|------------|
| `[[toc]]` | Always — place after the header block |
| Mermaid `journey` | User flows with emotional stages |
| Mermaid `flowchart` | Decision trees, system flows |
| Mermaid `graph` | Architecture / component relationships |
| Mermaid `sequenceDiagram` | API / service interactions |
| Mermaid `gantt` | Milestones and timeline |
| KaTeX `$$...$$` | Metric formulas, conversion rates, scoring models |
| Task lists `- [ ]` | Requirements, open questions, action items |
| Tables | Personas, metrics, risks, API contracts |
| Emoji | Section headers only — one per `##` heading for scannability |
| Blockquotes `>` | Key constraints, guiding principles, status line |

## Writing Principles

- **Problem before solution** — never lead with features.
- **Specific over vague** — "reduce checkout drop-off by 15%" beats "improve conversion".
- **Explicit scope** — an *Out of Scope* section prevents scope creep.
- **Owned open questions** — every open question gets a named owner and due date.
- Tense: use present tense for requirements ("the system allows…"), future for milestones ("we will ship…").

## Template Location

`assets/prd-template.md` — read this file to get the full structure before writing the PRD.
