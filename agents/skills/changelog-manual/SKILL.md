---
name: changelog-manual
description: Writes MaintainX changelog entry files by hand under `changelogs/{project}/` when `yarn changelog-add` is unavailable (no node_modules, no SSM/AWS access, cloud sessions). Use when asked to add a changelog and the CLI fails or cannot run. If the CLI works, use mx-changelogs-create-changelogs instead.
allowed-tools: Bash, Read, Write, Glob, AskUserQuestion
metadata:
  author: rossnoble
  version: '0.1.0'
---

# Manual changelog entry

Outcome: for every affected project, one valid JSON file exists at `changelogs/<project>/<timestamp>_<author>.json`, identical in shape to what `yarn changelog-add` would write.

Try `yarn changelog-add --list-projects` once. If it works, stop and use the CLI per `docs/rules/changelog.md`. Otherwise continue.

## 1. Find affected projects

Read `.mxchangerc.json` (skip lines starting with `//`). Each project has `name`, `type`, and `root` (a folder string for Libraries, `{folder, changelog}` for others). Compare `git diff --name-only origin/master...HEAD` against the roots; a file belongs to the project with the longest matching root prefix. Skip the `Category` entry. Files matching no project need no entry. Consult `docs/rules/changelog.md` if you need the conventions.

Examples: `frontend/**` → `frontend`; `backend/api/**` → `backend`; `domains/templating/**` → `mx-templating`; `packages/tooling/ts-scripts/**` → `tools`; Library `@mx-shared/foo` → directory `changelogs/@mx-shared/foo/`.

## 2. Resolve values

- `linearIssue`: key like `ABC-1234` from the branch name (`rossnoble/{ticket}/...`) or conversation. Never invent; ask.
- `changeType`: `New`, `Improved`, `Bug Fix`, `Technical` (also seen: `Look & Feel`, mainly frontend/native). Pick from the diff; ask if ambiguous.
- `description`: specific, user-facing, active voice, one sentence.
- `date`: today, `YYYY-MM-DD`.
- `author`: `Ross Noble`.
- `availability` (type `Product` projects: `backend`, `frontend`, `rest-api`, `native`, `dashboard`, and Services that list `availabilities`): `WIP`, `Beta`, or `GA`. `Bug Fix`/`Technical` → `GA`. `New`/`Improved` → ask. Dashboard uses its own values (see its `availabilities` in `.mxchangerc.json`).
- `semver` (type `Library` or `Tool`): `none` | `patch` | `minor` | `major`. Default `none` when no public API change.
- `module` (optional): must be one of the project's `modules`, or `projectDefaults.modules` when the project defines none. Omit if unsure.

The exact schema is not available offline; mirror existing entries (`git log --all --diff-filter=A --name-only -- 'changelogs/<project>/*.json'`, then `git show`) if unsure which fields a project uses, and flag the uncertainty to the user.

## 3. Write the file

Path: `changelogs/<project>/<YYYYMMDDHHMMSS>_ross_noble.json` (UTC time now: `date -u +%Y%m%d%H%M%S`; author lowercased, spaces → `_`).

Content is a JSON array with one object, 2-space indent, trailing newline, keys in this order, omitting absent ones:

```json
[
  {
    "module": "Localization",
    "description": "Add Latvian language support",
    "changeType": "New",
    "availability": "Beta",
    "semver": "none",
    "date": "2026-11-13",
    "author": "Ross Noble",
    "linearIssue": "SMHB-1539"
  }
]
```

Do not add `jiraIssue`, `xray`, `xrayLinks`, or `skipQA`.

## 4. Verify

- Run `python3 -m json.tool` on each new file.
- Confirm one file per affected project and that `git status` shows them under `changelogs/`.
- Tell the user these were hand-written, so CI or `yarn changelog-add --show-schema` may still reject a field.
