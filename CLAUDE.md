# CLAUDE.md

This repo is the source of the `worklog` skill, not a project that uses it, so there
is no `.worklog/` here to read. It is deliberately Markdown-only. The behavior lives
in `skills/worklog/SKILL.md`, the `.worklog/` format other agents follow is in
`CONVENTION.md`, and `.claude-plugin/` plus `hooks/` make it installable. There is no
code to build or run.

Mental model: agents append to `.worklog/LOG.md` (append-only history), and the skill
regenerates `.worklog/BRIEF.md` (a short dated orientation surface) as a projection of
that log. The rest is specified in SKILL.md and CONVENTION.md; do not restate it here.

## Don't re-grow it

Keep it Markdown-only. Do not add a server, a store schema, ID resolvers, a CLI, or a
build step. The heavy version of this idea was built and collapsed under its own
weight, and a disciplined SKILL.md does the job. If a change needs TypeScript, it
belongs in a different project.

The `.worklog/` log is project memory: distilled decisions, failures, and gotchas. It
is not an agent-session or execution log. Resumability, forking, replay, and
raw-transcript capture belong to the agent runtime (Claude Code transcripts, Omnara),
not here. Essays arguing "the log is the agent" are about that other log.

## Editing the skill

`SKILL.md` is the product, so treat it like code. The `description` frontmatter is the
trigger; the body is a standing cost that loads on every invocation, so keep it tight.
Skills do not re-read mid-session, so re-invoke after editing to test.
