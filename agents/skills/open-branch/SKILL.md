---
name: "open-branch"
description: Opens a git branch named `rossnoble/{ticket}/{branch-title}` cut from the latest `origin/master`, pushes it, and opens a draft pull request with `gh`, in a cloud Claude Code session. Use when starting work on a Linear ticket, when asked to "open a branch", "start a branch", "open a draft PR", "create a branch for ABC-123", or when the current branch is not in that format.
allowed-tools: Bash, AskUserQuestion
metadata:
  author: rossnoble
  version: '0.2.0'
---

# Open a branch and a draft PR

Outcome: the working tree is on a new branch named `rossnoble/{ticket}/{branch-title}`, cut from the latest `origin/master`, pushed to origin, with a draft PR open against `master`. Finish by giving the user the PR URL.

## Name format

- `{ticket}`: the Linear issue key, uppercase, like `ABC-1234`. Take it from the user's message or the conversation. Never invent one; ask if missing.
- `{branch-title}`: a short kebab-case summary of the work. Lowercase, `a-z0-9-` only, no ticket key, at most ~50 chars. Derive it from the ticket title or task description.
- Example: `rossnoble/BF-8396/guard-auditing-backfill`

## Steps

1. Resolve `{ticket}` and `{branch-title}`; confirm only if either is ambiguous.
2. Fetch the base by name: `git fetch origin master` (this repo uses `master`, not `main`).
3. Create and switch: `git switch -c rossnoble/{ticket}/{branch-title} origin/master`. If the working tree has uncommitted changes, they carry over; mention that.
4. Verify with `git branch --show-current`.
5. Make sure the branch has something to open a PR from. GitHub rejects a PR whose branch has no commits ahead of `master`, so check `git rev-list --count origin/master..HEAD`. If it is `0`, create an empty commit: `git commit --allow-empty -m "{ticket}: start work on {branch-title}"`. Do not commit the user's uncommitted changes to fill this gap; they did not ask for that, so leave them in the working tree and say so.
6. Push with upstream tracking: `git push -u origin rossnoble/{ticket}/{branch-title}` (see "Cloud session constraints" first).
7. Open the draft PR (see "Draft PR" below), then print the PR URL.

## Draft PR

Run `gh pr list --head rossnoble/{ticket}/{branch-title} --json url --jq '.[0].url'` first. If a PR already exists for the branch, report its URL and stop; do not open a second one.

Otherwise create it with `gh pr create --draft --base master --head rossnoble/{ticket}/{branch-title} --title "{title}" --body-file <file>`.

- **Title**: `{ticket}: {Human readable title}`. Use the Linear ticket title when you have it, otherwise a short sentence case summary of the work.
- **Body**: if the repo has a pull request template (`.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE.md`), start from it so the reviewer sees the sections the team expects, and fill in only what you actually know. Otherwise write a two or three line summary of the intent. Always include a link to the Linear ticket when you know its URL. Write the body to a temp file and pass `--body-file`; that avoids shell quoting problems with backticks and newlines.
- Keep it a draft. Never mark it ready for review, request reviewers, or merge unless the user asks.

If `gh` fails (not authenticated, no permission, network error), report the exact error and stop. The branch is already pushed at that point, so the user can open the PR themselves. Do not try other routes such as raw API calls with tokens.

## Cloud session constraints

Cloud sessions may pin a development branch (for example `claude/...`) and forbid pushing to any other branch without permission. Creating the branch locally is always fine. If the session pins a branch or the push is refused, stop before pushing and ask the user to confirm pushing `rossnoble/...`; do not work around the restriction. If nothing restricts pushing, invoking this skill is the user's request to push and open the PR, so proceed without asking again.

## Exceptions

- Branch already exists locally or on origin: switch to it instead of recreating, and say so. Then continue from step 5, so it still gets pushed and gets a draft PR if it has none.
- Branch name already matches the format: skip creating the branch, and continue from step 5.
