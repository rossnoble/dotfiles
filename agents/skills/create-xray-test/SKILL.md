---
name: create-xray-test
description: Create X-Ray testing steps for MX QA team
---

## What I do

- Generate reproducable testing steps for humans to follow when testing a feature
- Save the summary to the nearest `.agent-docs` directory (typically at the project root)
- Name the file with format: `YYYY-MM-DD-{TICKET_ID}-testing-steps.md`

## File naming

- Prefix: Current date in `YYYY-MM-DD` format
- Suffix: Kebab-case description of the conversation topic
- Extension: `.md`
- Look for the Jira ticket ID in the branch name: `XXX-1234`
- Example: `2026-02-19-EAM-1234-user-authentication-testing-steps.md`

## Where to save

1. Look for an existing `.agent-docs` directory starting from the current working directory
2. Walk up the directory tree until you find one or reach the git root
3. If no `.agent-docs` directory exists, create one at the project root
4. Save the summary file there

## Output format

Based on gathered context, generate test steps with:

| Field               | Description                                                                                                                                                                      |
| ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Action**          | Test phase, inputs, configuration, or user interactions. Use numbered steps (1, 2, 3) to detail multi-step actions, and sub-steps (a., b., c.) when it helps organize logically. |
| **Data**            | Always leave empty (empty string "")                                                                                                                                             |
| **Expected Result** | What should be true after this phase (may include multiple verifications)                                                                                                        |

**Guidelines:**

- **Favor coarser, phase-based steps** over micro-actions (3-5 steps typical, not 10+)
- Group related actions into logical phases: setup, main action, verification
- For multi-step actions within a single test step, use numbered format in Action field:
  - Main steps: `1. First action\n2. Second action\n3. Third action`
  - Sub-steps when helpful: `1. Main step\n  a. Sub-step\n  b. Sub-step`
- Results can be compound: "User is logged in AND settings page displays"
- Include preconditions/setup as step 1
- Cover happy path; edge cases can be separate tests or noted in description

**Example - Login flow (coarse, preferred):**

| #   | Action                             | Data | Expected Result                                    |
| --- | ---------------------------------- | ---- | -------------------------------------------------- |
| 1   | Navigate to login and authenticate |      | User is logged in and redirected to dashboard      |
| 2   | Verify dashboard state             |      | Dashboard displays user's name and default widgets |

**Example - Feature flag test (coarse):**

| #   | Action                                                               | Data | Expected Result                                             |
| --- | -------------------------------------------------------------------- | ---- | ----------------------------------------------------------- |
| 1   | Setup: Enable `my-feature-flag` feature flag and navigate to feature |      | Flag enabled, feature UI is accessible                      |
| 2   | Perform main user flow                                               |      | Expected behavior occurs, data is saved/displayed correctly |
| 3   | Verify side effects                                                  |      | Related components updated, no errors in console            |

**Example - Test with detailed numbered steps and sub-steps:**

| #   | Action                                                                                                     | Data | Expected Result                                |
| --- | ---------------------------------------------------------------------------------------------------------- | ---- | ---------------------------------------------- |
| 1   | Setup test environment<br>1. Enable feature flag `new-ui`<br>2. Clear browser cache<br>3. Navigate to app  |      | Environment ready, app loads with flag enabled |
| 2   | Complete login flow<br>1. Click login button<br> a. Enter username<br> b. Enter password<br>2. Submit form |      | User authenticated and redirected to dashboard |
| 3   | Verify new UI displays correctly                                                                           |      | New components visible, no console errors      |

## When to use me

Use this skill when:

- The user asks to generate testing steps
