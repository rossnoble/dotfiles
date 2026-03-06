---
name: pr-summary
description: Generate a brief overview of changes in the current branch for a pull request summary
---

## What I do

- Analyze the commits and changes in the current branch compared to the base branch
- Generate a concise summary suitable for pasting into a pull request description
- Output the summary directly (not saved to a file)

## Output

- Format should be broken into two sections: 1) "Summary" and 2) "Specific Changes"
- Summary: a list of desciptive high-level changes
- Specific changes: list of very specific changes referencing code
- Language is written in present tense

## Example

Below is a summary to follow as a guide

```
## Summary
- Fix search input focus behavior in the Blueprint Select Modal - previously the input would refocus every time a blueprint was clicked
- Add new empty state component for when no procedures exist in the library
- Fix form submit event propagation that was incorrectly bubbling up from the search input
- Migrate from deprecated components to pantry equivalents

## Specific changes
- [x] Migrate from deprecated `Loader` to `@mx-pantry/loader`
- [x] Migrate from legacy `Button` to `@mx-pantry/loader` via `Action` from core-components`
- [x] Add proper TypeScript types for grouped blueprint list
- [x] Disable search input when loading or when no blueprints exist
- [x] Add `ProceduresEmptyState` component with improved UX
- [x] Add withForm={false} to SearchInput to prevent submit events from propagating to parent forms
```

## When to use me

- When preparing to create a pull request
- When you need a quick summary of what changed in the current branch
