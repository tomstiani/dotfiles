---
name: pr-review
description: |
  Review a pull request authored by someone else. Covers context gathering, reading the diff,
  proposing a verdict, drafting comments, and submitting via gh CLI.
  Use when: the user wants to review someone else's PR, leave feedback, approve or request changes,
  or respond to existing review threads.
license: MIT
metadata:
  version: "1.0.0"
---

# PR Review

You help the user review a pull request they didn't author. The goal is to give clear, constructive, well-scoped feedback that respects the author and moves the PR forward.

Reference the shared [code-reviewer](../code-reviewer/SKILL.md) checklist for security, performance, correctness, maintainability, and testing rules.

All comments — inline and the main review body — must be passed through the [humanizer](../humanizer/SKILL.md) skill before being shown to the user or posted. Reviews should read like they were written by a thoughtful person, not generated. No bold headers, no rule-of-three bullet lists, no AI vocabulary, no sycophantic openers.

## Flow

### 1. **Gather context before touching any code**
Ask the user:
> "Any context I should know before I start — is this a junior contributor, a sensitive area, or do you just want a quick pass?"

Also ask:
> "Do you want me to flag all nits and suggestions, or only blocking issues?"

Wait for answers to both before proceeding.

### 2. **Fetch and understand the PR**
```bash
# View PR summary, description, and metadata
gh pr view <PR_NUMBER>

# Check out the branch locally to run and explore the code
gh pr checkout <PR_NUMBER>
```

### 3. **Read the PR description and existing discussion**
Before looking at any code:
- Understand *what* the PR is trying to do and *why*
- Check for linked issues, screenshots, or test instructions
- Note any areas the author flagged as uncertain
- Read existing review threads — check if other reviewers have already raised issues or if the author has replied

If there are existing threads, ask the user:
> "There are existing review comments on this PR — do you want to respond to any of them as part of your review?"

### 4. **Review the diff**
```bash
gh pr diff <PR_NUMBER>
# Or file-by-file after checkout:
git diff main...HEAD
```
Apply the Review Process from `code-reviewer` (Security → Performance → Correctness → Maintainability → Testing) at the depth the user asked for in step 1.

Focus on the blast radius — what does this change affect beyond the files touched?

### 5. **Propose a verdict**
Before drafting any comments, surface a recommended outcome and confirm with the user:
> "Based on the diff, I'd suggest **[approve / comment / request changes]** because [reason]. Does that match what you're thinking?"

Wait for confirmation before proceeding.

### 6. **Draft the main review comment**
Always ask the user to write an opener in their own words:
> "Write your opener for the main comment — a sentence or two in your own words."

Do not suggest edits, rephrase, or run it through the humanizer.

**If there are inline comments (step 7):** the main body is only the user's opener. Use it verbatim as `--body` in step 8.

**If there are no inline comments:** the AI-drafted content goes in the main body instead. Compose it as:

```
[user's opener]

---

> Written by AI, confirmed by Tomstiani

[AI-drafted body following: fact → numbered issues → recommendation → sources]
```

Confirm the full composed comment with the user before posting.

### 7. **Collect and preview inline comments**
Draft all inline comments and present them as a list for the user to confirm, edit, or drop before anything is posted:

```
Proposed comments:
1. [File: auth.ts, line 42] blocking: token is not validated before use
2. [File: auth.ts, line 67] nit: variable name `x` is unclear — consider `expiryTime`
3. [File: README.md, line 5] suggestion: update setup instructions to reflect new env var

Shall I post these, or would you like to edit/drop any?
```

Wait for confirmation. Only post once approved.

#### Comment structure

Each comment should follow this pattern:

1. **Fact first.** Open with the correct behaviour or the actual problem — stated as fact, not suspicion. No "I think" or "it seems like".
2. **Numbered issues.** If there are multiple problems with the same thing, number them. One sentence per issue, specific to line/variable/behaviour.
3. **Clear recommendation.** End with exactly what should change. One sentence, direct imperative.
4. **Sources (if relevant).** If you're citing specs, docs, or articles, add them as bare `Source:` lines at the end.

Every inline comment must open with this attribution blockquote:

```
> Written by AI, confirmed by Tomstiani
```

The main review body (step 6) is user-written and does not get this header.

Keep comments concise. Point to the exact line and say what the issue actually is. Prefix with `nit:`, `suggestion:`, or `blocking:` so the author knows what must change. Offer a concrete alternative — don't just flag and leave.

Before showing the draft to the user, run all comments through the [humanizer](../humanizer/SKILL.md) skill. They should sound like a person wrote them at a keyboard, not generated.

### 8. **Submit the review**
Use the main comment from step 6 as `--body`:
```bash
# Approve
gh pr review <PR_NUMBER> --approve --body "<main comment from step 6>"

# Request changes
gh pr review <PR_NUMBER> --request-changes --body "<main comment from step 6>"

# Comment only (neutral)
gh pr review <PR_NUMBER> --comment --body "<main comment from step 6>"
```

### 9. **Follow up**
- If you requested changes, re-review once the author pushes updates
- Resolve your own threads once addressed — don't leave the author guessing
- If the PR is outside your expertise, say so and suggest tagging someone more familiar
