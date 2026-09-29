---
name: documentation-writing
description: Write or revise clear technical documentation, including tutorials, how-to guides, reference pages, explanations, READMEs, runbooks, and procedures. Use when creating, restructuring, or editing developer and operational documentation.
---

# Documentation Writing

Write for the reader's task. Prefer clear, consistent language over strict adherence to a style rule.

## Workflow

1. Identify the audience, their goal, assumed knowledge, and the facts they must know.
2. Read the relevant code, configuration, interfaces, and existing docs. Do not guess technical details.
3. Choose one primary document type:
   - **Tutorial** — teach through a complete, guided experience.
   - **How-to guide** — help an informed reader complete a specific task.
   - **Reference** — provide precise facts for lookup.
   - **Explanation** — build understanding of concepts, reasons, or trade-offs.
4. Put the reader's goal or key fact first. Add prerequisites before steps and details after the essential path.
5. Draft with the language rules below.
6. Verify commands, code examples, links, names, defaults, and expected results against the source.
7. Remove repetition, background that does not help the task, and promises about unimplemented behavior.

## Language rules

Apply these Simplified Technical English principles without claiming ASD-STE100 compliance:

- Use one term for one concept. Do not vary terms only for style.
- Use familiar words and define necessary domain terms at first use.
- Use active voice unless the actor is unknown or unimportant.
- Address the reader as "you" and use imperative verbs for instructions.
- Put one instruction in each numbered step and one topic in each paragraph.
- Keep procedural sentences near 20 words and descriptive sentences near 25 words when practical.
- Include subjects, verbs, and articles; do not shorten text into fragments that become ambiguous.
- Avoid unnecessary synonyms, jargon, idioms, nominalizations, and complex verb phrases.
- Use a vertical list when a sentence contains several conditions, options, or items.
- Put a warning or required condition before the action it governs.
- Preserve exact UI labels, API names, commands, and established project terminology.

## Structure by document type

### Tutorial

State what the reader will build, list minimal prerequisites, guide one reliable path, show observable results, and end with the completed outcome. Teach by doing; do not turn the tutorial into an exhaustive reference.

### How-to guide

Use a goal-oriented title. State prerequisites, give the shortest ordered procedure, show how to verify success, and add only likely troubleshooting. Explain reasons only when they affect a decision or prevent an error.

### Reference

Organize around the product's structure. Use consistent headings and compact tables or lists. Document syntax, parameters, defaults, constraints, outputs, errors, and one minimal example. Prefer completeness and scanability over narrative flow.

### Explanation

State the question or concept, provide context, explain how and why it works, and cover relevant trade-offs or alternatives. Link to procedures instead of embedding long step sequences.

## Final check

- The title and opening match the reader's goal.
- The document has one primary purpose and a clear path through it.
- Each step has one action and an observable result where useful.
- Terms, examples, and formatting are consistent.
- Headings and link text are descriptive and accessible.
- A reader can copy commands safely; placeholders and destructive actions are explicit.
- The content says no more than the reader needs for this purpose.

## Sources

- [ASD-STE100 basics](https://www.asd-europe.org/standards-specifications/simplified-technical-english/what-are-the-basics-of-simplified-technical-english/)
- [Simplified Technical English overview](https://en.wikipedia.org/wiki/Simplified_Technical_English)
- [Diátaxis documentation framework](https://diataxis.fr/)
- [Google developer documentation style guide](https://developers.google.com/style)
- [Microsoft Writing Style Guide](https://learn.microsoft.com/style-guide/)
