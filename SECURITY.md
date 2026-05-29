# Security Policy

worklog is a Claude Code skill — Markdown instructions, no executable code, no server, no
network surface. It tells the agent to read and append entries in a project's `.worklog/`
directory and, on graduation, to write rules into `AGENTS.md`, `.claude/rules/`, or a skill.
There is no daemon, no build step, and nothing runs unless you invoke `/worklog`.

## Reporting

Report concerns privately through GitHub repository security advisories rather than public
issues.

## What it touches

- **Writes** `.worklog/WORKLOG.md` and `.worklog/INDEX.md` at the project root, and — only
  when an entry meets the graduation criteria — appends a rule to `AGENTS.md`,
  `.claude/rules/<topic>.md`, or a skill in the same repo.
- **Reads** the current session and those same files to decide what to log.
- **Commits nothing on its own.** All writes land in your working tree; you review and commit
  them via git. Graduation writes are surfaced in the run summary so you can revert.

## Out of scope

- Network operations of any kind. The skill performs none.
- Sandboxing the agent. The skill constrains what *it* writes (the files above); it does not
  constrain what the calling agent does elsewhere.
- Access control or encryption. `.worklog/` is plain text by design — readable in any editor
  and committed to the repo so every agent and teammate sees the same history.

## Prior incarnation

This project was previously "Priors," a local MCP server + CLI with a `.priors/` store. That
implementation (and its larger threat surface) is preserved at git tag
`legacy/priors-v1.1.0-rc.2` and is not part of the current contract.
