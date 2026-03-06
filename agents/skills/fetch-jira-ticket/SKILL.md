---
name: fetch-jira-ticket
description: Fetch Jira ticket information from current branch and save to .agent-docs
---

## What I do

- Extract the Jira ticket ID from the current git branch name
- Fetch ticket details and recent comments using the `jira` CLI
- Save the information to the nearest `.agent-docs` directory
- Name the file with format: `{TICKET-ID}-{kebab-case-summary}.md`

## How to extract the ticket ID

1. Get the current branch name:

   ```bash
   git branch --show-current
   ```

2. Extract the ticket ID using the pattern `[A-Z]+-[0-9]+` (e.g., `EAM-1234`, `PROJ-567`)

3. Supported branch name formats:
   - `feature/AAA-1234-some-description`
   - `bugfix/AAA-1234-some-description`
   - `janedoe/AAA-1234-some-description`
   - `hotfix/AAA-1234`
   - `AAA-1234-some-description`
   - `AAA-1234`
   - Any branch containing a ticket ID pattern

4. If no ticket ID is found, inform the user and ask them to provide it manually.

## How to fetch the ticket

Use the `jira` CLI to fetch ticket information:

```bash
jira issue view AAA-1234 --plain --comments 5
```

This returns:

- Summary (title)
- Status
- Priority
- Assignee
- Reporter
- Description
- Recent comments

## Output format

The saved markdown file should include:

```markdown
# {Ticket Summary}

**Ticket:** {TICKET-ID}
**Status:** {status}

## Description

{ticket description}

## Comments

### {commenter name} - {date}

{comment text}

...
```

## File naming

- Format: `YYYY-MM-DD-{TICKET-ID}-{kebab-case-summary}.md`
- Date format is populated with current date
- Convert the ticket summary to kebab-case (lowercase, spaces to hyphens, remove special characters)
- Truncate the summary portion to keep filenames reasonable (max ~50 chars for summary part)
- Example: `2026-01-01-EAM-1234-add-user-authentication-flow.md`

## Where to save

1. Look for an existing `.agent-docs` directory starting from the current working directory
2. Walk up the directory tree until you find one or reach the git root
3. If no `.agent-docs` directory exists, create one at the project root
4. Save the ticket file there

## After saving

After saving the ticket file, provide a brief summary to the user including:

- Ticket ID and title
- Current status
- Key points from the description (2-3 sentences max)
- Note any recent comments if relevant

This gives the user immediate context without needing to open the file.

## When to use me

Use this skill when:

- The user asks to fetch, save, or document the current Jira ticket
- The user wants context about the ticket they're working on
- The user says things like "get the ticket info", "save the jira ticket", "fetch ticket details"
