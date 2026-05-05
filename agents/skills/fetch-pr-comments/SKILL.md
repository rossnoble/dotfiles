---
name: fetch-pr-comments
description: Fetch PR review comments and CI bot comments, then prompt user to triage which issues to address. Use when reviewing PR feedback, checking CI failures, or preparing to address review comments.
---

# Fetch PR Comments

Fetch and triage comments on a GitHub Pull Request for the current branch.

## What I do

1. Identify the PR for the current branch
2. Fetch code review comments and bot comments (CI failures)
3. Present a categorized summary to the user
4. Prompt the user to select which issues to address
5. Create a todo list for the selected issues

## How to fetch the PR

1. Get the current branch name:
   ```bash
   git branch --show-current
   ```

2. Find the PR for this branch:
   ```bash
   gh pr view --json number,title,url,state
   ```

3. If no PR exists, inform the user and stop.

## How to fetch comments

Use the GitHub API via `gh`:

### Code review comments (on specific lines):
```bash
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments
```

### Bot/conversation comments (CI failures, etc.):
```bash
gh api repos/{owner}/{repo}/issues/{pr_number}/comments
```

Extract the owner/repo from:
```bash
gh repo view --json nameWithOwner --jq '.nameWithOwner'
```

## How to parse comments

### Code review comments
Extract from each comment:
- `user.login` - Who left the comment
- `path` - File path
- `line` or `original_line` - Line number
- `body` - Comment text

### Bot comments (CI failures)
Look for comments from known bots:
- `datadog-maintainx[bot]` - CI pipeline failures
- `github-actions[bot]` - Workflow failures
- `cursor[bot]` - Automated code review

Parse structured content from bot comments when possible (e.g., extract individual failures from datadog summaries).

## Output format

Print a categorized summary to the terminal:

```
## PR #12345 - [PR Title]

### CI Failures
1. [Linter] smart-hub.json: Usage of "'" as apostrophes is not allowed
2. [Build] CSS error: undefined custom property '--backgroundWhite'

### Code Review Comments
3. [High] SmartHubSkillCard.tsx:39 - Hardcoded placeholder "YYYY-MM-DD" shown to users
4. [Medium] smart-hub.json:115 - Typo: "always for approval" missing word "ask"
5. [Low] SmartHubSkillListContainer.module.css:8 - Deprecated --baseUnit token used

---
Which issues would you like to address? (e.g., "2, 4, 5" or "all" or "skip 1, 3")
```

## User interaction

After presenting the summary, ask the user which issues to address. Accept formats like:
- `2, 4, 5` - Address specific issues by number
- `all` - Address all issues
- `skip 1, 3` - Address all except specified
- `none` - Skip all, just informational

## After triage

For each issue the user wants to address:
1. Add it to the todo list with status `pending`
2. Include the file path, line number, and issue description
3. Begin working through the todos sequentially

## When to use me

- User asks to "check PR comments", "review PR feedback", "fetch PR comments"
- User asks to "check CI", "why is CI failing", "fix CI failures"
- User asks to "address review comments", "triage PR feedback"
- User wants to see what feedback exists on their current PR
