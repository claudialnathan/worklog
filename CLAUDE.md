# CLAUDE.md

This repo **is** the worklog skill. No code, no MCP server, no CLI — just two Markdown
artifacts and a plugin manifest. The product is:

- `skills/worklog/SKILL.md` — the skill body (the actual behaviour)
- `commands/worklog-index.md` — the periodic-gardening command
- `.claude-plugin/` — manifest so it installs as a Claude Code plugin

`.worklog/` is what the skill *writes* in a user's project; this repo doesn't contain one.

## Don't re-grow it

This was once "Priors" — an MCP server + CLI + plugin with a staged review queue,
a deterministic brief assembler, scoring, and ~14k lines of TS. It got too heavy.
The whole point of the collapse is that a disciplined SKILL.md does the job. Resist
adding a server, a store schema, ID resolvers, or a build step back in. If a change
needs TypeScript, it probably belongs in a different project.

- Full pre-collapse system: git tag `legacy/priors-v1.1.0-rc.2`.
- Design rationale (why project-as-subject, what to resist): `internal/project-brief.md`
  (gitignored, maintainer-only — read it before any big directional change).

## Editing the skill

Treat `SKILL.md` like code. The `description` frontmatter is the trigger; the body is
the standing instruction. Keep the body procedural and tight — it costs tokens every
time the skill is invoked. Skills don't re-read mid-session, so re-invoke after edits
to test.
