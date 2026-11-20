---
name: "code-review"
description: 'Reviews someone else''s open GitHub PR (by number, URL, or the current branch''s PR) as a reviewer: reads the diff and PR context, checks it against the repo standards for the files touched, validates each suspected issue, reports only high-signal findings ranked by severity, and gives a 1-5 merge confidence score with a short rationale. Report-only by default; posts inline PR comments only when asked. Use when you are asked to review a PR, want a second opinion on a PR before approving, need to triage a PR, or want to know how safe a PR is to merge. Trigger phrases: "review PR 1234", "review this PR", "pr review", "review pull request", "look over this PR for me", "is this PR safe to merge", "merge confidence", "/review-pr". Boundary: not for reviewing your own unpushed branch before opening a PR (that is self-review), not for fixing reviewer feedback (that is pr-review-autofix), and not for single-topic reviews of migrations or GraphQL schema (review-db-migrations, review-graphql-schema).'
allowed-tools: Task Read Glob Grep Bash(git:*) Bash(gh pr:*) Bash(gh repo:*) Bash(gh api:*)
metadata:
  author: Ross Noble
  version: '0.2.0'
---

# Review PR

Review a pull request the way a careful teammate would: understand the intent, check the code
against the repo's own standards, and report only what a human reviewer would want to act on.
End with a merge confidence score so the reader knows at a glance how safe the PR is to merge.
**Report-only unless the user asks to post comments.** Never approve, request changes, merge,
or push.

**Invocation:**

- `/code-review` — the open PR for the current branch
- `/code-review <number | url>` — a specific PR
- `/code-review <number | url> --comment` — also post validated findings as inline PR comments

## 1. Gather context

These must be known before reviewing:

- **PR metadata:** title, description, author, base/head refs, draft state, linked ticket.
  Resolve `owner/name` from the git remote once and reuse it.
- **Full diff and changed-file list.** Prefer `gh pr diff`; if `gh` is unavailable, use the
  GitHub MCP tools (`pull_request_read`).
- **Existing review threads and CI status**, so you don't repeat what reviewers already said
  and can tell which findings CI already catches.

Stop and say so if the PR is closed/merged, or the diff is empty. If the diff is very large
(hundreds of files or mostly generated code), tell the user and review the non-generated
files only; skip lockfiles, `*.gen.*`, snapshots, and translation output.

The PR's head may not be checked out. Read file contents at the head ref (`git show
<ref>:<path>` after fetching the branch by name) rather than the working tree, so surrounding
code is the code under review.

## 2. Discover standards

For each directory touched, read the nearest `AGENTS.md` (and `BUGBOT.md` if present) and walk
up to the root. Load the rule docs they link only when the diff touches that area (for
example `docs/rules/database-migration-standards.md` for migrations,
`docs/rules/graphql-schema-standards.md` for `.graphql`, `docs/rules/frontend-accessibility.md`
for UI). Consult `docs/references/resolve-scope.md` if scope discovery is unclear.

Do not flag anything a linter, formatter, or typecheck already enforces.

## 3. Review

Create a task list, then launch parallel subagents, each given the diff, PR description, and
the standards from step 2. Each looks at one dimension and returns candidate findings with
file, line, and a concrete failure scenario:

- **Correctness:** bugs, wrong edge-case handling, races, error paths, broken contracts with
  callers that are not in the diff. Read the callers.
- **Standards:** violations of the conventions discovered in step 2.
- **Architecture and risk:** layering/module-boundary breaks, backward-compatibility of
  schema, API, and migrations, missing feature-flag gating or kill switch for risky changes,
  security and data-exposure concerns.
- **Tests:** changed behavior with no test, tests that don't assert the behavior, flaky
  patterns.
- **Intent match:** whether the diff does what the PR description and ticket say, and
  anything in the diff the description doesn't mention.

## 4. Validate

Dispatch a fresh subagent per candidate finding to try to disprove it: re-read the code at
the head ref, check whether the case is reachable, and check whether an existing review thread
or CI result already covers it. Drop anything that is speculative, stylistic preference, or
unreachable. Keep a finding only if it can state the input or state that makes it wrong.

## 5. Score merge confidence

Give the PR a single score from 1 to 5 for how confident you are that merging it as-is is
safe. The score exists so a busy reader can decide how much attention the PR needs before
opening the details, so it must be earned by evidence: base it on the findings that survived
step 4 and on the risk factors below, not on gut feel or on how long the review took. A score
that moves with vibes teaches readers to ignore it.

| Score | Meaning | Typical evidence |
|-------|---------|------------------|
| 5 | Safe to merge | No blocker or should-fix findings; small or well-contained change; behavior is covered by tests; CI green |
| 4 | Likely safe | Only nits, or a minor should-fix the author can address in the same PR without re-review |
| 3 | Merge after fixes | One or more should-fix findings, or meaningful risk that tests or a flag would mitigate |
| 2 | Risky | A blocker, or several should-fix findings, or a risky change (migration, auth, shared API) without adequate tests or rollback path |
| 1 | Do not merge | A validated blocker with a concrete failure such as data loss, a security hole, a broken migration, or a break of existing callers |

Adjust within the table using these factors, because identical findings carry different risk
depending on the context around them:

- **Blast radius:** migrations, auth, billing, shared libraries, and public APIs raise the
  stakes; isolated UI copy or docs lower them.
- **Reversibility:** a feature flag, kill switch, or easy revert lowers risk; a one-way data
  change raises it.
- **Test coverage of the changed behavior:** untested risky logic should cost a point.
- **CI status:** failing or pending required checks cap the score at 3 until they resolve.
- **Review coverage:** if the "Not reviewed" list in step 6 includes risky areas you could not
  verify, cap the score at 4 and say why. Unverified code is not evidence of safety.
- **Intent match:** a diff that does more than the description says is a reason to lower the
  score.

Hard rules: any validated blocker caps the score at 2, and a draft PR is scored the same way
but noted as draft. If nothing survived validation and nothing risky went unreviewed, the
score is 5 — do not hold it back to look cautious.

Write a one-sentence rationale that names the one or two factors that decided the score, and,
when the score is below 5, a short "to raise it" note listing what would move it up (for
example "fix the unbounded retry in `worker.ts:88`", "add a test for the empty-input path").

## 6. Report

Output, in the terminal:

1. **Summary:** one short paragraph on what the PR does and your overall read.
2. **Merge confidence:** `N/5` — the one-sentence rationale from step 5, followed by the
   "to raise it" note when the score is below 5.
3. **Findings:** ranked most severe first, each with severity (blocker / should-fix /
   nit), `path:line`, what is wrong, the concrete scenario, and a suggested fix.
4. **Questions for the author:** things that need intent, not judgment.
5. **Not reviewed:** anything skipped (generated files, areas outside the diff you couldn't
   verify).

If nothing survives validation, say "No issues found", list what was checked, and still give
the merge confidence score. Do not pad.

The score is advisory. It never replaces a human approval, and you must not approve, request
changes, or merge based on it.

## 7. Post comments (only with `--comment` or an explicit request)

Show the exact comments you would post and get confirmation first; posting is visible to the
author and others. Post validated blocker and should-fix findings as inline comments on the
changed lines in a single pending review, and leave the review unsubmitted or as a plain
comment review — never approve or request changes. Put the merge confidence score and its
one-sentence rationale in the review's summary body, not in the inline comments, so the score
appears once per review. End each comment with:

```
---
_Generated by [Claude Code](https://claude.ai/code)_
```
