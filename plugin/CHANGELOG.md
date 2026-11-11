# Changelog

All notable changes to the `gvt-wiki` plugin are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and follows [semantic versioning](https://semver.org/).

## [Unreleased]

### Added

- The `maintain-wiki` skill, with the verbs `ingest`, `query` and `lint`. Invoke it as `/gvt-wiki:maintain-wiki`. It reads the `wiki` block of the consuming repo's `.gvt-agent.json` (`wiki.wikiDir`, `wiki.rawDir`).
- The `wiki-librarian` agent. It is read-only and runs the `query` verb.
- The `wiki-editor` agent. It writes the pages, the index entry and the log entries for one `ingest` run. Its tools are Read, Write, Edit, Grep and Glob. It has no Bash tool and never stages or commits.
- A PreToolUse hook that blocks state-changing git commands (stash, reset, checkout, switch, restore, clean, merge, rebase, cherry-pick, revert, pull and am) for subagents whose type starts with `gvt-wiki:`. Other callers pass through.
- `wiki-lint` (`skills/maintain-wiki/scripts/wiki-lint.mjs`), a mechanical checker that uses Node built-ins only and always exits 0.

### Migration

This is the first release of `gvt-wiki`; there is no earlier version here.

- The wiki practice moved here from the gvt-dev plugin's `maintain-wiki` skill and `wiki-librarian` agent. The namespace changes from `gvt-dev` to `gvt-wiki`. Invocations change to `/gvt-wiki:maintain-wiki`. The `wiki` block in `.gvt-agent.json` is unchanged. The marker line at the top of `<wikiDir>/schema.md` names the new namespace; edit it in a consuming repo. See [`MIGRATION.md`](https://github.com/GenvidTechnologies/claude-code-plugin-gvt-wiki/blob/main/MIGRATION.md).
- `ingest` dispatches `wiki-editor` to write. `wiki-editor` never stages or commits. `/gvt-wiki:maintain-wiki ingest` leaves the changed files uncommitted for the caller.
- The plugin does not depend on the gvt-dev plugin, and the gvt-dev plugin does not depend on it.
