# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this repo is

This repo is the `gvt-wiki` plugin for Claude Code: the `maintain-wiki` skill, the `wiki-librarian` and `wiki-editor` agents, a git-state guard hook and the `wiki-lint` script. The plugin is published through the marketplace repo [`GenvidTechnologies/claude-code-gvt-marketplace`](https://github.com/GenvidTechnologies/claude-code-gvt-marketplace) (catalog name `gvt-plugins`).

The skill reads the `wiki` block of a consuming repo's `.gvt-agent.json` (`wiki.wikiDir`, `wiki.rawDir`). The gvt-dev plugin's [`CONVENTIONS.md`](https://github.com/GenvidTechnologies/claude-code-plugin-gvt-dev/blob/main/plugin/CONVENTIONS.md) defines those keys. Do not copy the definition here.

## Layout

```
plugin/                      # The published plugin (git-subdir source)
  .claude-plugin/plugin.json # Plugin manifest
  package.json               # Runtime dependency: shell-quote (used by the guard)
  CHANGELOG.md               # Plugin changelog
  skills/maintain-wiki/      # SKILL.md, four templates, scripts/ (wiki-lint and its tests)
  agents/                    # wiki-librarian.md, wiki-editor.md (flat files)
  hooks/                     # hooks.json, git-state-guard.mjs, lib/, test/
docs/TOC.md                  # Documentation index
.gvt-agent.json              # Commands for this repo
.github/                     # CI workflow and the leak-guard script
README.md, MIGRATION.md
```

Agents are flat files. A subdirectory under `plugin/agents/` is not discovered.

## Commands

The commands are in `.gvt-agent.json`. Use Git Bash on Windows.

```
# test
npm ci --prefix plugin --ignore-scripts --no-audit --no-fund && node --test plugin/skills/maintain-wiki/scripts/test/*.test.mjs plugin/hooks/test/*.test.mjs

# validate
bash .github/scripts/leak-guard.sh && npm ci --prefix plugin --ignore-scripts --no-audit --no-fund && claude plugin validate plugin && node --test plugin/skills/maintain-wiki/scripts/test/*.test.mjs plugin/hooks/test/*.test.mjs
```

CI (`.github/workflows/ci.yml`) runs the tests on `ubuntu-latest` and `windows-latest` with Node 22, and runs a leak-guard job.

## Test conventions

- Tests use `node:test`.
- Pass a glob to `node --test`. Never pass a directory: Node tries to load the directory as a module and reports one failed test.
- An unmatched glob gives rc=0 and `# pass 0`. A zero pass count is not a pass. Read the count.
- On Windows, set `core.autocrlf false` before checkout. Otherwise CRLF line endings can change fixtures.

## Rules

- The files under `plugin/skills/maintain-wiki/scripts/` were moved byte-identical from the gvt-dev repository (see `MIGRATION.md`). Code comments there refer to gvt-dev issues and ADRs (`#NNN`, `ADR-NNNN`). Do not rewrite those references.
- The git-state guard acts only on subagents whose type starts with `gvt-wiki:`. A command from the main thread, or from any other agent, passes through.
- `wiki-editor` has no Bash tool. It never stages or commits. Keep it that way. The caller of `ingest` commits.
- Text that ships under `plugin/` does not name the gvt-dev namespace or cite its docs. The leak-guard script checks this. Root files (`README.md`, `MIGRATION.md`) may name the old namespace.
- Write technical text in short, direct sentences, with one name per component.

## Releasing

Use `/gvt-dev:release-plugin` if it is installed. It bumps `plugin/.claude-plugin/plugin.json` `version`, moves the `[Unreleased]` section of `plugin/CHANGELOG.md` and pushes a plain annotated `vX.Y.Z` tag. The marketplace catalog pins the plugin by that tag in `source.ref`. The tag without the `v` must equal the `plugin.json` `version`.

## Conventions

- Commit messages: `<scope>: <description>`.
- Branches: descriptive kebab-case.
- Pull requests are squash-merged. Merge commits are not used.
- License: MIT-0.
