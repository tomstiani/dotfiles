---
name: code-reviewer
description: Shared code review checklist covering security, performance, correctness, maintainability, and testing. Use when reviewing code, auditing quality, or checking for security issues.
license: MIT
metadata:
  author: awesome-llm-apps
  version: "2.0.0"
---

# Code Reviewer

Use this checklist directly or from `self-review` and `pr-review`.

## Review order

1. **Security** — injection, XSS, auth bypasses, secrets, unsafe dependencies, and trust-boundary validation.
2. **Performance** — N+1 queries, unnecessary I/O, inefficient algorithms, leaks, and avoidable work.
3. **Correctness** — error paths, null handling, race conditions, boundary cases, and data integrity.
4. **Maintainability** — clear names, simple structure, type safety, duplication, and appropriate documentation.
5. **Testing** — changed behavior, edge cases, failures, and useful integration coverage.

## Process

- Read the task and surrounding code before judging the diff.
- Report only actionable findings with file and line references.
- State impact and a concrete fix; distinguish blocking issues from suggestions.
- Note missing tests and residual risks.
- Prefer deletion and simpler designs over speculative abstractions.

## Output

```markdown
## Critical
- `path/file.ts:42` — Concrete issue, impact, and fix.

## Warnings
- `path/file.ts:100` — Concrete issue, impact, and fix.

## Suggestions
- `path/file.ts:150` — Optional improvement.

## Summary
Overall assessment and remaining risk.
```
