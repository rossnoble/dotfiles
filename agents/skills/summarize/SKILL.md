---
name: summarize
description: Summarize key points of the current session and save to the nearest .agent-docs directory
---

## What I do

- Analyze the current conversation to identify key points, decisions, and outcomes
- Generate a concise markdown summary with clear headings
- Save the summary to the nearest `.agent-docs` directory (typically at the project root)
- Name the file with format: `YYYY-MM-DD-name-of-conversation.md`

## Output format

The summary file should include:

1. **Title** - A descriptive title based on the conversation topic
2. **Date** - The current date
3. **Summary** - 2-3 sentence overview
4. **Key Points** - Bullet list of important items discussed
5. **Decisions Made** - Any decisions or conclusions reached
6. **Action Items** - Next steps or tasks identified (if any)
7. **Code Changes** - Brief description of any files modified (if applicable)

## File naming

- Prefix: Current date in `YYYY-MM-DD` format
- Suffix: Kebab-case description of the conversation topic
- Extension: `.md`
- Example: `2026-02-19-add-user-authentication.md`

## Where to save

1. Look for an existing `.agent-docs` directory starting from the current working directory
2. Walk up the directory tree until you find one or reach the git root
3. If no `.agent-docs` directory exists, create one at the project root
4. Save the summary file there

## When to use me

Use this skill when:
- The user asks to summarize or document the session
- A significant task or feature has been completed
- The user wants to preserve context for future reference
