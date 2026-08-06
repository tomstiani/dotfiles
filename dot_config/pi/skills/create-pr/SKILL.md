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

**Body (no template):** Write for a teammate who has not followed the branch. Keep it short and plain.

Use this structure unless the repo template says otherwise:

```markdown
Briefly: 1–2 plain sentences explaining what problem this solves and what reviewers should pay attention to.

## Why
- The problem or reason for the change.

## What changed
- The smallest useful summary of the code change.
- Mention important non-changes, especially deferred work.

## Tested
- How this was checked.
```

Add a `## Follow-up` section only when there is real remaining work.

## 3. Humanize the Body

Before pushing, run the PR body through the `humanizer` skill. PR descriptions are a hotbed of AI tells — catch and fix them.

**Plain-language rules:**

- Assume the reader lacks your branch context. Add one sentence of context before naming internals.
- Prefer everyday verbs: "reads from", "falls back to", "we'll migrate later".
- Delete project/process jargon unless the repo commonly uses it. If you must use it, explain it once.
- Avoid words that require project-plan context unless the team uses them naturally: *cutover*, *read-path*, *behavior-neutral*, *migration pass*, *unified*, *composition*, *dual-read*, *Phase 4*, *foundations*.
- Translate dense terms:
  - "read-path cutover" → "the code now reads from X first"
  - "behavior-neutral" → "no user-facing behavior change"
  - "deferred to a consolidated migration pass" → "we'll migrate the content later"
  - "dual-read" → "supporting both the old and new fields"
- Avoid cramming implementation details into one paragraph. Use bullets.
- Cut anything the reviewer can see from the diff unless it explains risk, intent, or testing.

**AI tells to remove:**

- Words like *enhance*, *crucial*, *pivotal*, *leverage*, *streamline*, *seamless*, *robust*, *ensure*
- Inline-header lists: `**Scope:** Does the thing` → prose or a plain bullet list
- Significance inflation: "marks a pivotal step forward" → just say what it does
- Passive voice: "Tests were added" → "Added tests for X"
- Filler phrases: "In order to" → "To", "Due to the fact that" → "Because"
- Generic positive conclusions that read like a press release
- Em dash overuse; use a comma or split the sentence
- Promotional language: *groundbreaking*, *powerful*, *exciting*

**Before/after calibration:**

Bad:
> Behavior-neutral read-path cutover for header, footer, and page-link to the unified Sanity link. Content migration is deferred to a consolidated migration pass.

Better:
> Header, footer, and page-link now read from the new Sanity link field first, then fall back to the old fields. Users should not see any behavior change. We are not migrating content in this PR; that will happen later.

**Process:**
1. Draft the body
2. Read it aloud — if it sounds like a changelog written by a chatbot, rewrite it
3. Apply the two-pass audit from the humanizer skill: draft → audit → final
4. The result should read like a competent engineer wrote it in one sitting, not like it was assembled from templates

**Quick calibration:** Would a teammate outside this specific workstream understand this without Slack history or prior PRs? Would they know why the change exists, what changed, how it was tested, and what was intentionally left out? If not, rewrite.

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
