---
name: investigate
description: Track down bugs by gathering context from tickets, branch names, and codebase
---

## What I do

- Extract the Jira ticket ID from the current git branch name
- Search for matching ticket documents in `.agent-docs` directory
- If no ticket document exists, run the `fetch-jira-ticket` skill to retrieve it
- Gather relevant context from the codebase
- Ask clarifying questions if anything is unclear
- Propose a fix with specific files to investigate

## Step 1: Extract the ticket ID

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

4. If no ticket ID is found in the branch, proceed using only conversation context (skip to Step 3)

## Step 2: Find existing documentation

1. Look for an existing `.agent-docs` directory starting from the current working directory
2. Walk up the directory tree until you find one or reach the git root
3. Search for any `.md` files containing the ticket ID in the filename (e.g., `*AAA-1234*.md`)
4. Read all matching documents to gather context

**If no ticket document exists:**

Run the `fetch-jira-ticket` skill to retrieve the ticket information before proceeding. This ensures you have full context about the bug being investigated.

## Step 3: Gather codebase context

Search the codebase to understand the bug:

1. **If files are mentioned** in the ticket docs or by the user:
   - Start by examining those specific files
   - Look for related code in the same directory or module

2. **If no files are mentioned:**
   - Search broadly for keywords from the bug description (error messages, feature names, etc.)
   - Identify relevant modules or components
   - Narrow down to specific files based on search results

3. **Look for:**
   - Recent changes to relevant files (`git log -p --since="2 weeks ago" -- <file>`)
   - Related tests that might indicate expected behavior
   - Similar patterns elsewhere in the codebase

## Step 4: Clarification

Before proposing a fix, ensure you have clarity on:

- Steps to reproduce the bug (if not documented)
- Expected vs actual behavior
- Any recent changes that might be related
- Environment or configuration details (if relevant)

**Ask the user** if any of these are unclear. Do not guess or assume - it's better to ask than to propose an incorrect fix.

## Step 5: Output format

Once you have gathered sufficient context, provide your analysis in the following format:

---

### Summary

A brief description of the bug based on gathered context. Include:
- What the bug is
- When/where it occurs
- Who is affected

### Hypothesis

Your theory about what is causing the issue and why. Be specific about:
- The root cause
- Why this behavior is occurring
- Any contributing factors

**If uncertain:** Explicitly state that you don't have enough information to form a confident hypothesis. Explain what additional information would help.

### Proposed Fix

Specific changes recommended to resolve the bug:
- Describe the approach
- Explain why this fix addresses the root cause
- Note any alternative approaches considered

**If uncertain:** State what further investigation is needed before proposing a fix.

### Action Items

- [ ] Step-by-step list of tasks to implement the fix
- [ ] Include any prerequisite steps
- [ ] Add testing and verification steps
- [ ] Note any follow-up tasks (documentation, monitoring, etc.)

### Files Affected

List each file that needs changes with a description:

- `path/to/file.ts:123` - Description of what needs to change
- `path/to/another-file.ts:45` - Description of what needs to change
- `path/to/test-file.spec.ts` - Tests to add or modify

---

## Important guidelines

- **One ticket only:** The branch ticket ID is the source of truth. The conversation may reference aspects of the bug but should not involve other tickets.
- **Be honest about uncertainty:** Never fabricate a hypothesis or fix when you lack sufficient information. Ask questions instead.
- **Reference specific code:** When discussing files, include line numbers where applicable using the format `file_path:line_number`.
- **Consider side effects:** When proposing fixes, think about what else might be affected.

## When to use me

Use this skill when:

- The user asks to investigate, debug, or track down a bug
- The user mentions an issue or error they need help understanding
- The user says things like "investigate this bug", "help me debug", "track down this issue", "figure out what's causing this"
- The user wants to understand why something isn't working as expected
