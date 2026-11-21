---
okf_version: "0.2"
---

# Wiki Index

This wiki is the documentation of the `gvt-wiki` plugin repository. It lists
every page under `wiki/`, grouped under section headings, one line each. Each
entry's text is the linked page's frontmatter `description`. The page format
and the maintenance rules are in [the schema](schema.md). The change log is
[log.md](log.md).

## Process

* [Issue Triage Conventions](issue-triage.md) - Project conventions that /gvt-dev:triage-issues reads for this repository - types, priorities, labels, required fields, splitting, duplicates, dependencies and mutation recipes.

## Schema

* [Wiki Maintenance Schema](schema.md) - The maintenance rules for this wiki — page format, create-vs-update lifecycle, raw/ immutability, staleness policy and the verb contract.

## Repository files outside the wiki

These links leave the wiki bundle on purpose. The plugin's own documentation is
its components and the root files, so the index points to them. A reader that
gets only the `wiki/` bundle cannot follow them.

* [README.md](../README.md) - plugin overview, components and install.
* [MIGRATION.md](../MIGRATION.md) - what moved from the gvt-dev plugin, the copy base commit, and the steps for a consuming repository.
* [CLAUDE.md](../CLAUDE.md) - maintainer guide: layout, commands, test conventions, release entry point.
* [plugin/CHANGELOG.md](../plugin/CHANGELOG.md) - plugin changelog.
* [maintain-wiki skill](../plugin/skills/maintain-wiki/SKILL.md) - the `maintain-wiki` skill (`ingest`, `query`, `lint`), with its four templates and the `wiki-lint` script in `scripts/`.
* [wiki-librarian agent](../plugin/agents/wiki-librarian.md) - read-only agent for the `query` verb.
* [wiki-editor agent](../plugin/agents/wiki-editor.md) - write agent for the `ingest` verb; never stages or commits.
* [hooks.json](../plugin/hooks/hooks.json) - wiring of the git-state guard (`plugin/hooks/git-state-guard.mjs`).
