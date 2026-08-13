---
name: fetch-linear-ticket
description: Fetch Linear ticket information from current branch and save to .agent-docs
---

## What I do

- Extract the Linear ticket ID from the current git branch name
- Fetch ticket details and recent comments using the `linear` MCP tools
- Save the information to a ticket-specific subdirectory: `.agent-docs/{TICKET-ID}/`
- Name the file with format: `YYYY-MM-DD-{kebab-case-summary}.md`

## How to extract the ticket ID

1. Get the current branch name:

   ```bash
   git branch --show-current
   ```

2. Extract the ticket ID using the pattern `[A-Z]+-[0-9]+` (e.g., `ENG-1234`, `LIN-567`)

3. Supported branch name formats:
   - `feature/AAA-1234-some-description`
   - `bugfix/AAA-1234-some-description`
   - `john/AAA-1234/some-description`
   - `hotfix/AAA-1234`
   - `AAA-1234-some-description`
   - `AAA-1234`
   - Any branch containing a ticket ID pattern

4. If no ticket ID is found, inform the user and ask them to provide it manually.

## How to fetch the ticket

Use the `linear` MCP tools to fetch ticket information. The Linear MCP server exposes tools for querying issues.

1. First, if uncertain of exact tool names, list available `linear_*` tools to discover the correct ones.

2. Use the appropriate tool (e.g., `linear_get_issue` or similar) to fetch the issue by its identifier. Request:
   - Title (summary)
   - State (status)
   - Priority
   - Assignee
   - Description

3. Use the comments tool (e.g., `linear_list_comments` or similar) to fetch recent comments on the issue. Limit to the 5 most recent comments.

If a tool is not available or returns an error, inform the user and suggest they verify the Linear MCP server is authenticated (`opencode mcp auth linear`).

## Output format

The saved markdown file should include:

```markdown
# {Issue Title}

**Ticket:** {TICKET-ID}
**State:** {state}
**Priority:** {priority}
**Assignee:** {assignee}

## Description

{issue description}

## Comments

### {commenter name} - {date}

{comment text}

...
```

## File naming and location

- **Directory:** `.agent-docs/{TICKET-ID}/` (e.g., `.agent-docs/ENG-1234/`)
- **Filename:** `YYYY-MM-DD-{kebab-case-summary}.md`
- Date format is populated with current date
- Convert the issue title to kebab-case (lowercase, spaces to hyphens, remove special characters)
- Truncate the summary portion to keep filenames reasonable (max ~50 chars for summary part)
- Example: `.agent-docs/ENG-1234/2024-03-15-add-user-authentication-flow.md`

## Where to save

1. Look for an existing `.agent-docs` directory starting from the current working directory
2. Walk up the directory tree until you find one or reach the git root
3. If no `.agent-docs` directory exists, create one at the project root
4. Inside `.agent-docs`, create a subdirectory named after the ticket ID (e.g., `ENG-1234/`) if it doesn't already exist
5. Save the ticket file inside that subdirectory

## After saving

After saving the ticket file, provide a brief summary to the user including:

- Ticket ID and title
- Current state
- Key points from the description (2-3 sentences max)
- Note any recent comments if relevant

This gives the user immediate context without needing to open the file.

## When to use me

Use this skill when:

- The user asks to fetch, save, or document the current Linear ticket
- The user wants context about the Linear issue they're working on
- The user says things like "get the linear ticket", "save the linear issue", "fetch linear ticket details"
