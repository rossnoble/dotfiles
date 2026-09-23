---
name: implement
description: Take the current ticket from branch to draft PR — fetch the Linear ticket, implement the change, update and verify tests, add changelog entries, commit, and open a draft PR. Use when the user says "/implement", "implement this ticket", "implement the current ticket", or asks for the full ticket-to-PR workflow on the current branch. Not for planning, investigating a bug, or reviewing existing code.
---

## What I do

- Fetch the ticket named by the current branch, for background and acceptance criteria
- Implement the change the user asked for, grounded in the conventions of the code I'm touching
- Add or update tests, and prove they actually catch the thing they claim to
- Add changelog entries for every affected project
- Commit atomically in Conventional Commits format, push, and open a draft PR with a written description

## Inputs and precedence

The **change to make** comes from the user's prompt. The **ticket** supplies background and
acceptance criteria.

- If the prompt is vague, the ticket's AC is the spec.
- If the prompt and the AC disagree, stop and ask. Don't pick one silently.
- The AC is the definition of done: re-read it before opening the PR and confirm each criterion is met.

Run the whole chain in one pass. Stop only for genuine ambiguity — see **Guardrails**. Track the
phases with a todo list so progress is visible.

## Step 1: Ticket context

Run the `linear-fetch` skill to pull the ticket for the current branch and save it under
`.agent-docs/{TICKET-ID}/`.

- If the branch has no ticket key and the user didn't give one, ask. Never invent a key.
- Read the ticket's attachments and comments too — the reason a ticket exists is often in a linked
  Slack thread rather than the description.

## Step 2: Ground in the codebase

Before writing anything:

1. Find the code the ticket or prompt names. Search for the identifiers quoted in the ticket.
2. Read the nearest `AGENTS.md` to the files you're about to touch, and any rules doc it points at.
3. Look at how the surrounding code already solves this problem.

If a local convention conflicts with the requested change, **surface it** — state the conflict, say
which way you went, and why. Don't silently violate it, and don't silently abandon the ticket's AC
to satisfy it.

## Step 3: Implement

- The smallest change that satisfies the AC. No adjacent refactors, no speculative abstraction, no
  renaming things you happened to read.
- Match the patterns already in the file over your own preference.
- Comments only where a reader would otherwise ask "why" — not to restate what the code says.

## Step 4: Tests

- Add or update the tests that cover the new behavior.
- Run only the affected test files, not the full suite.
- **For bug fixes, prove the test isn't vacuous:** stash the source change, re-run, confirm the new
  test fails, then restore. Report both results. A test added alongside a fix that also passes
  without the fix is testing nothing. Skip this for pure feature work, where there's no prior
  behavior to revert to.
- Never weaken or delete an existing assertion to get green. If an existing test now fails, that's a
  finding — decide whether the test or the change is wrong, and say which.

## Step 5: Changelog

If the repo has a changelog mechanism, add an entry for every affected project. Skip this step
entirely in repos that don't.

In the maintainx monorepo, the `mx-changelogs-create-changelogs` skill drives `yarn changelog-add`:
discover projects, read each one's schema, pass `--prompt false`, and re-run with a `CI=true` prefix
if it fails on `AWS_PROVIDER_CONFIG_ERROR`.

**Ask on any required field context can't settle.** The tool's defaults encode the common case, not
yours — a bug fix to a feature still behind a flag is not `GA`, whatever the default says.
Descriptions are user-facing and specific: what changed for the user, not which function you edited.

## Step 6: Commit

Commit **atomically**, in [Conventional Commits](https://www.conventionalcommits.org) format.

**Atomic** means each commit is one self-contained logical change that stands on its own: the tree
builds and its tests pass at every commit, and nothing in the commit belongs to a different concern.
The test for it is whether the commit could be reverted by itself without breaking anything else.

- A change and the tests that cover it are **one** commit — a commit that leaves the suite red isn't
  atomic. Don't split "add the fix" from "add the test for the fix".
- Genuinely independent pieces get their own commits: a prerequisite refactor, a rename, a helper
  extraction, an unrelated fix you had to make to proceed.
- Order them so each one applies cleanly on the last — prerequisites first.
- With a single logical change, the changelog entry rides along with it. With several commits, the
  changelog describes the PR as a whole, so it goes last as its own `chore(changelog):` commit.

**Format:**

```
<type>(<scope>): <imperative summary>

<body: why this is needed and what the old behavior was>

Refs: TICKET-KEY
```

- `type` is one of `feat`, `fix`, `perf`, `refactor`, `test`, `docs`, `build`, `ci`, `chore`, `revert`.
  Pick it from what the commit does, not from the ticket's label.
- `scope` is optional — the module, package, or workspace the commit touches. Omit it rather than
  inventing one.
- Summary is imperative and lowercase, no trailing period, under ~72 chars.
- The body explains **why**; the diff already shows what. Skip it only when the summary is genuinely
  the whole story.
- Breaking changes: `!` after the type/scope **and** a `BREAKING CHANGE:` footer.
- The ticket key goes in a `Refs:` trailer, not the subject. The subject line belongs to
  Conventional Commits — see Step 7 for where the ticket key surfaces for reviewers.

Also:

- Stage the files you actually changed. Don't `git add -A` and hope `.gitignore` covers the rest.
- Let the hooks run. If `lint-staged` rewrites files, keep the result.
- If the repo enforces a different commit convention (commitlint config, or a documented format in
  `AGENTS.md`/`CONTRIBUTING.md`), that wins — follow it and say so.

## Step 7: Draft PR

- Push the branch, setting upstream if it has none.
- Title the PR the way the repo's merged history titles commits — in a squash-merge repo the PR
  title *is* the commit that lands, so match `git log --oneline` on the base branch. Where that's a
  ticket-prefixed summary (`[TICKET-KEY] Imperative summary`), use that; where the history is itself
  Conventional Commits, use the type-prefixed form instead.
- Use the repo's PR template if one exists (`.github/pull_request_template.md` or
  `PULL_REQUEST_TEMPLATE.md`): keep its headings and order, replace the instructional HTML comments
  with real content, and delete sections that genuinely don't apply.
- Write the body in the `pr-summary` skill's format — a `Summary` of high-level changes and a
  `Specific changes` checklist referencing concrete files and symbols — folded into the template's
  sections. Present tense. Link the ticket; don't make the ticket the whole description.
- Open it with `gh pr create --draft` and a `--body-file`, then print the URL.
- If a PR already exists for the branch, `gh pr edit --body-file` instead of creating a duplicate.

## Step 8: Report

Close with how you verified the change, not just that you did:

- The test commands you ran and their results
- The negative-verification result, when you did one
- Anything relevant you did **not** run, and why
- Any convention you knowingly bent, and any decision the user should sanity-check

## Guardrails

- **Ask, don't guess**, on: a missing or ambiguous ticket, an AC that conflicts with the prompt, a
  required changelog field you can't derive, or a repo convention that forbids the requested approach.
- Don't modify files unrelated to the change.
- Don't merge, don't mark the PR ready for review, don't force-push, don't amend someone else's commit.
- No "Generated with" footers or co-author trailers.

## When to use me

Use this skill when the user wants a ticket taken all the way to a PR:

- "/implement", "implement this ticket", "implement the current ticket"
- A described change plus "then add a changelog and open a draft PR"

Use something else when:

- The bug isn't understood yet → `investigate`
- The work is already written and needs critique → `self-review`
- Only the PR needs opening → `pr-create`
