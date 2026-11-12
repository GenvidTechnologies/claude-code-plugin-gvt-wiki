# Documentation Index

This repo is the `gvt-wiki` plugin itself. Its documentation is the plugin components and the notes below.

## Repository docs

- [`../README.md`](../README.md) - plugin overview, components and install
- [`../MIGRATION.md`](../MIGRATION.md) - what moved from the gvt-dev plugin, the copy base commit, and the steps for a consuming repository
- [`../CLAUDE.md`](../CLAUDE.md) - maintainer guide: layout, commands, test conventions, release entry point
- [`../plugin/CHANGELOG.md`](../plugin/CHANGELOG.md) - plugin changelog

## Components

- [`../plugin/skills/maintain-wiki/SKILL.md`](../plugin/skills/maintain-wiki/SKILL.md) - the `maintain-wiki` skill (`ingest`, `query`, `lint`), with its four templates and the `wiki-lint` script in `scripts/`
- [`../plugin/agents/wiki-librarian.md`](../plugin/agents/wiki-librarian.md) - read-only agent for the `query` verb
- [`../plugin/agents/wiki-editor.md`](../plugin/agents/wiki-editor.md) - write agent for the `ingest` verb; never stages or commits
- [`../plugin/hooks/hooks.json`](../plugin/hooks/hooks.json) - wiring of the git-state guard (`../plugin/hooks/git-state-guard.mjs`)

## Process

- [`issue-triage.md`](issue-triage.md) - issue triage conventions and mutation recipes read by `/gvt-dev:triage-issues`
