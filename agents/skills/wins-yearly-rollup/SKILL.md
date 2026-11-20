---
name: "wins-yearly-rollup"
description: "Use when the user asks for a yearly wins summary or annual review or promotion material from their SecondBrain vault's Wins/ log, built from the quarterly files."
---

# Yearly wins rollup

Combine a year of wins into one narrative with the strongest evidence, for an annual review or promotion case.

## Before you start
1. Find the vault: the connected folder `SecondBrain` (on the user's Mac `~/Documents/SecondBrain`; in a session it is mounted at `$HOME/mnt/SecondBrain`). If it is not available, say so and stop.
2. Read `AGENTS.md` at the vault root for the rules and layout.
3. Settle the inputs. Ask one short question only if missing and it changes the result:
   - Year (default: the year that just ended, or the current year if the user says "so far").
   - Audience and emphasis (for example "promotion packet for the next level", "annual review"). Default: annual review.

## Steps
1. List `Wins/` for that year: `YYYY-Q1.md` to `YYYY-Q4.md` (raw logs) and any `YYYY-Qn-summary.md` (quarterly summaries). Note any missing quarters.
2. Read the quarterly summaries where they exist. For a quarter with no summary, read its raw log and summarize it the same way, but tell the user a quarterly rollup is missing and suggest running the quarterly skill first.
3. Pull raw log lines when you need a link or an exact figure for the strongest items.
4. Identify 4-7 themes across the year. Show how work grew over time (for example from contributor to owner, from a feature to a platform).
5. Pick the 8-12 strongest wins for the stated audience, ranked by impact, each with its link.
6. Write `Wins/YYYY-summary.md` with:
   - **Year in brief**: one paragraph.
   - **Themes**: for each, the story across quarters and the top evidence with links.
   - **Top wins**: the ranked list.
   - **Team and kudos**: short list with links.
   - **Gaps**: wins with no impact line and quarters with no summary or log.
7. If the summary file exists, ask before overwriting; otherwise write it.

## Rules
- Never invent an impact, number, title or scope. Use only what the logs, summaries and linked sources say. Missing details go under Gaps.
- Never edit raw logs or quarterly summaries.
- Write only inside `Wins/`. Do not run git; the user commits (see `AGENTS.md`).
- Finish by telling the user where the file is, the top themes, and what is missing.