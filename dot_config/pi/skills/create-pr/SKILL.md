---
name: create-pr
description: Create a GitHub pull request with a well-structured title and body following conventional commit conventions. Use when the user wants to open a PR, create a pull request, push a branch for review, or submit changes for review on GitHub.
---

# Create PR

## 1. Gather Context

Run these to understand the current state, including checking for a PR template:

```bash
git rev-parse --abbrev-ref HEAD          # current branch
git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'  # base branch
git log origin/main..HEAD --oneline      # commits on this branch
git diff origin/main..HEAD --stat        # files changed
git status                               # any uncommitted changes

# Check for PR template
find .github -maxdepth 2 -name 'PULL_REQUEST_TEMPLATE.md' -o -name 'pull_request_template.md' 2>/dev/null | head -1

# Check for hygiene workflow
find .github/workflows -maxdepth 1 -name '*hygiene*' -o -name '*convention*' -o -name '*lint-pr*' 2>/dev/null | head -1
```

If a template file is found, read it and use its structure for the body — fill in every section the template defines, removing placeholder text. If no template exists, use the default body guidance below.

If a hygiene workflow is found, read it and trace any scripts it calls (e.g. a `github-script` step referencing a `.js` file). Extract the validation rules and treat them as hard requirements when drafting the title and body — **the PR must pass these checks before being created**.

## 2. Draft the PR

**Title:** Follow conventional commits — `type(scope): Description` (50–72 chars)

Allowed types: `feat`, `fix`, `perf`, `revert`, `docs`, `style`, `chore`, `refactor`, `test`, `build`, `ci`

Rules:
- Sentence case subject: `feat(auth): Add user login` ✅ — not title case, not all-lowercase
- Scope must be lowercase, letters/numbers/dashes only: `feat(consumer-web): …` ✅
- Single space after colon, no leading spaces in subject
- No empty scopes: `chore: Update deps` ✅ — omit parens entirely if no scope
- Describe the branch's overall goal, not a single commit
- If a hygiene workflow enforces a ticket reference (e.g. `MA-1234` or a ClickUp URL), include it in the title or body

**Body (no template):** Focus on the *why*, not the *what*. Use bullets, paragraphs, or checkboxes as appropriate. Keep it concise. Incorporate any specific requests from the user.

## 3. Humanize the Body

Before pushing, run the PR body through the `humanizer` skill. PR descriptions are a hotbed of AI tells — catch and fix them.

**Patterns most common in PR bodies:**

- **AI vocabulary** — strip words like *enhance*, *crucial*, *pivotal*, *leverage*, *streamline*, *seamless*, *robust*, *ensure*
- **Inline-header lists** — `**Scope:** Does the thing` → prose or a plain bullet list
- **Significance inflation** — "marks a pivotal step forward" → just say what it does
- **Passive voice** — "Tests were added" → "Added tests for X"
- **Filler phrases** — "In order to" → "To", "Due to the fact that" → "Because"
- **Generic positive conclusions** — cut any closing sentence that reads like a press release
- **Em dash overuse** — replace with a comma or restructure the sentence
- **Promotional language** — *groundbreaking*, *powerful*, *exciting* have no place in a PR body

**Process:**
1. Draft the body
2. Read it aloud — if it sounds like a changelog written by a chatbot, rewrite it
3. Apply the two-pass audit from the humanizer skill: draft → audit → final
4. The result should read like a competent engineer wrote it in one sitting, not like it was assembled from templates

**Quick calibration:** Would a teammate skim this and immediately know *why* the change was made, not just *what* changed? If not, rewrite.

## 4. Push & Create

Refer to the `github-cli` skill for full `gh pr create` usage. The essentials:

```bash
# Push if not already on remote
git push -u origin HEAD

# Create the PR
gh pr create --title "type(scope): Description" --body "..."

# Add --draft if user requested it
```

Show the PR URL when done.
