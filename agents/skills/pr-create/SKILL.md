---
name: pr-create
description: Open a pull request with the `gh` CLI using the repo's PR template, filled in from the branch diff
---

## What I do

- Push the current branch if it has no upstream
- Locate the repo's pull request template
- Read the branch diff against the base branch and write the summary into the template
- Open the PR with `gh pr create` and return the URL

## Workflow

1. Determine the base branch and confirm there is something to PR:

   ```sh
   gh repo view --json defaultBranchRef -q .defaultBranchRef.name
   git rev-parse --abbrev-ref HEAD
   ```

   Use the default branch as the base unless the user names a different one.

2. Push the branch if needed:

   ```sh
   git push -u origin HEAD
   ```

3. Find the template. Check in order and use the first match:
   - `.github/pull_request_template.md` (any casing)
   - `.github/PULL_REQUEST_TEMPLATE/*.md` (ask which one if there are several)
   - `pull_request_template.md` or `docs/pull_request_template.md`

   If no template exists, fall back to the `Summary` / `Specific changes` format from the `pr-summary` skill.

4. Read the diff:

   ```sh
   git log --oneline <base>..HEAD
   git diff <base>...HEAD
   ```

   For large diffs, start with `git diff --stat <base>...HEAD` and read the
   significant files individually.

5. Fill in the template:
   - Keep every heading, section order, and checklist from the template verbatim
   - Replace placeholder/instructional text with real content; delete HTML comments
   - Check the boxes you can verify from the diff, leave the rest unchecked
   - Leave sections you genuinely cannot determine (ticket links, screenshots,
     QA steps) as empty placeholders rather than inventing content
   - Write in present tense, reference concrete files, functions, and components

6. Write the filled body to a temp file and open the PR:

   ```sh
   gh pr create --base <base> --title "<title>" --body-file /tmp/pr-body.md --draft
   ```

   - Title: short, imperative, prefixed with the ticket key if the branch name has one
   - Create as a draft unless the user asks otherwise
   - Print the returned PR URL

## Notes

- If a PR already exists for the branch, update it with `gh pr edit --body-file` instead of creating a duplicate
- Never commit, amend, or push anything beyond the current branch's existing commits
- Do not add "Generated with" footers or co-author trailers

## When to use me

- When opening a pull request for the current branch
