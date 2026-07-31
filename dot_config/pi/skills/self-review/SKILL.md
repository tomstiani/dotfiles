---
name: self-review
description: |
  Review your own code before opening or requesting review on a PR.
  Catches issues early, writes a strong PR description, and sets reviewers up for success.
  Use when: the user wants to self-review, pre-flight their own PR, check their own diff,
  or prepare code before asking for review.
license: MIT
metadata:
  version: "1.0.0"
---

# Self-Review

You help the user audit their own code before opening a PR. The goal is to catch issues themselves first, write a clear description, and make the reviewer's job easy.

Reference the shared [code-reviewer](../code-reviewer/SKILL.md) checklist for security, performance, correctness, maintainability, and testing rules.

## Flow

### 1. **Review your diff cold**
Step away, then read it as a stranger would:
```bash
git diff main...HEAD
```
Ask yourself:
- Does this change do exactly what the ticket/issue asks — nothing more, nothing less?
- Are there any debug artifacts, commented-out code, or console logs left in?
- Would someone unfamiliar with the context understand what's happening?

### 2. **Run the shared checklist**
Apply the Review Process from `code-reviewer` in order:
**Security → Performance → Correctness → Maintainability → Testing**

Flag anything you find before moving on.

> **Generated files:** Unrelated changes to generated/codegen files (e.g. GraphQL types, schema dumps, mocks, lockfile churn from regeneration) are acceptable and do not block the PR. Note them so the author is aware, but don't treat them as scope violations or require reverting them.

### 3. **Write a clear PR description**
A good description reduces review time and back-and-forth. Cover:
- **What** changed and **why**
- Trade-offs or decisions you made consciously
- How to test or verify the change
- Screenshots or recordings for UI changes
- Anything you're uncertain about and want focused feedback on

### 4. **Anticipate reviewer questions**
Read through the diff one more time and ask: *what would I question if someone else wrote this?*
Add inline comments on your own PR to pre-empt those questions.

### 5. **Pre-flight checklist**
- [ ] Tests pass locally
- [ ] No unintended files staged (e.g. `.env`, secrets) — unrelated generated/codegen files are OK
- [ ] Branch is up to date with the base branch
- [ ] PR is scoped — not mixing unrelated changes (generated files excepted)
- [ ] PR description is filled out

Only open the PR once all boxes are checked.
