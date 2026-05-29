---
description: Regenerate .worklog/INDEX.md (tag → dates) from .worklog/WORKLOG.md and run a retroactive graduation sweep.
argument-hint: (no arguments)
---

Regenerate the INDEX from the canonical `.worklog/WORKLOG.md` and sweep stable entries for promotion. Read the worklog `SKILL.md` for context — `skills/worklog/SKILL.md` in this plugin, or `~/.claude/skills/worklog/SKILL.md` if installed as a personal skill.

Note: there is no `LEARNINGS.md`. Per-session Claude corrections live in auto memory (`~/.claude/projects/<project>/memory/`). WORKLOG.md is the single project-shared history; durable rules graduate to AGENTS.md, `.claude/rules/<topic>.md`, or a skill.

## Steps

1. **Locate `.worklog/`.** `git rev-parse --show-toplevel` if available, else `pwd`. Stop if `WORKLOG.md` doesn't exist.

2. **Parse `WORKLOG.md`.** Each entry starts with `#### H:MMam/pm | \`type\` | headline`. Extract:
   - date (from the `### D MMM YYYY` section header above it)
   - type (`decision` | `failure` | `learning` | `correction` | `change`)
   - headline
   - tags (from the `tags:` line directly under the heading)
   - whether the entry already carries a `promoted` tag

3. **Retroactive graduation sweep.** For each non-`promoted` entry, apply the graduation criteria from SKILL.md (stable 30+ days, referenced 3+ times, phrased as a permanent project fact, etc.). For each candidate:
   - Pick the destination: `AGENTS.md` § Hard nos for universal rules; `.claude/rules/<topic>.md` for path-scoped rules (create the file if no existing one matches the rule's scope); a skill for multi-step procedures.
   - Rewrite the entry as a positive declarative rule (per the phrasing-flip table in SKILL.md).
   - Append the rule to the destination file.
   - Add the `promoted` tag to the entry in `WORKLOG.md`.
   Apply directly. Do not ask the user to rank or pick.

4. **Tag pruning.** Any tag with count 1 that doesn't fit a clear future category gets folded into a parent (e.g. `next-15` + `next-16` + `upgrade` → `next`). Apply merges directly in WORKLOG.md.

5. **Rewrite `INDEX.md`.** Build a tag → list-of-dates map across all entries. For each tag, emit:

   ```
   - **tag** (count) — YYYY-MM-DD (×n if multiple), YYYY-MM-DD, ...
   ```

   Order: most-frequent tag first; ties broken by most-recent use.

   Header:
   ```
   ## Worklog Index

   Tag → entry dates. Regenerate with /worklog-index.

   Use this as the tag vocabulary: prefer existing tags when writing new entries.

   ---

   ```

6. **Report** to the user: how many entries scanned, how many promoted (with destination paths), how many tag merges applied, how many distinct tags in the new INDEX.

## Notes

- Promotion is a destructive-ish edit (writes to AGENTS.md / `.claude/rules/` / skills). The user can revert via git. Do not ask for confirmation per the SKILL's no-prompts discipline.
- If `WORKLOG.md` has malformed entries (missing tags, missing type), report them rather than silently skipping.
- Do not invent claims when rewriting an entry into a rule. If the WORKLOG entry is too thin to carry a clean rule, leave it un-promoted and surface it as needs-more-context.
