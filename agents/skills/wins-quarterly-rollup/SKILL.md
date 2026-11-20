---
name: "wins-quarterly-rollup"
description: "Use when the user asks for a quarterly wins summary or review prep from their SecondBrain vault's Wins/ log, such as a quarter recap, 1:1 prep or promo evidence."
---

# Quarterly wins rollup

Turn one quarter of the raw wins log into a ranked, themed summary the user can paste into a review, 1:1 or promotion write-up.

## Before you start
1. Find the vault: the connected folder `SecondBrain` (on the user's Mac `~/Documents/SecondBrain`; in a session it is mounted at `$HOME/mnt/SecondBrain`). If it is not available, say so and stop.
2. Read `AGENTS.md` at the vault root for the rules and layout.
3. Settle the inputs. Ask one short question only if missing and it changes the result:
   - Quarter (default: the quarter that just ended, or the current one if the user says "so far").
   - Audience and emphasis (for example "promo packet", "my manager", "emphasize platform work"). Default: manager review.

## Steps
1. Read `Wins/YYYY-Qn.md`. Each line is `- YYYY-MM-DD | type | what | impact | link`. Types: shipped, team win, kudos, unblock, decision.
2. Optionally read the quarter's `Weekly/` notes for context on themes. Do not re-query connectors unless the user asks; the log is the source of truth.
3. Group the wins into 3-6 themes (by project or kind of impact, not by date). Name each theme in plain words.
4. Rank themes and wins by impact for the stated audience. Lead with the biggest.
5. Write `Wins/YYYY-Qn-summary.md` with:
   - **Headline**: 2-3 sentences on the quarter.
   - **Themes**: for each, 2-5 bullets, each with the impact and a link from the log.
   - **Kudos and team wins**: short list with links.
   - **Gaps**: wins with no impact line, so the user can fill them in while the memory is fresh. List them as date, what, link.
   - **By the numbers**: counts by type (only counts that come from the log).
6. If the summary file exists, ask before overwriting; otherwise write it.

## Rules
- Never invent an impact, number or beneficiary. Use only what is in the log or the linked sources. If it is missing, put it under Gaps.
- Never edit `Wins/YYYY-Qn.md` (the raw log).
- Write only inside `Wins/`. Do not run git; the user commits (see `AGENTS.md`).
- Keep the summary scannable in a couple of minutes.
- Finish by telling the user where the file is, the top 3 themes, and how many Gaps need their input.