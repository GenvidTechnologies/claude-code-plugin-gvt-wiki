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
docs/issue-triage.md         # Triage contract read by /gvt-dev:triage-issues
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
- Text under `plugin/` has no `gvt-dev:<name>` colon form and no `${CLAUDE_PLUGIN_ROOT}/docs/` citation. Exception: `plugin/hooks/test/` names `gvt-dev:validator` to prove the guard is not widened. Plain mentions of "the gvt-dev plugin" and GitHub URLs to gvt-dev's `CONVENTIONS.md` (the `wiki` block contract, gvt-dev ADR-0096) are allowed. No script runs this check. Run it by hand: `git grep -n -E 'gvt-dev:[a-z]|CLAUDE_PLUGIN_ROOT[}]/docs/' -- plugin ':!plugin/hooks/test/'` must print nothing. Root files (`README.md`, `MIGRATION.md`) may name the old namespace.
- The leak-guard script (`.github/scripts/leak-guard.sh`) keeps only the local-path rule. gvt-dev's `@genvidtech` scope rule does not apply here, because this plugin has no `@genvidtech` dependency.
- Write technical text in short, direct sentences, with one name per component.
- When you fix a stale issue or ADR reference, search all of `plugin/` for it, not only the file the issue names. The skill templates are copied into consuming repos and often repeat the skill body's claims. Observed 2026-11-13 on #30: the issue named `SKILL.md`, and `wiki-schema.template.md` held the same stale `gvt-dev#150` claim.
- A template change reaches only wikis scaffolded after the release. An existing `<wikiDir>/schema.md` keeps the old text. When a template fix corrects a wrong claim, say in the `CHANGELOG.md` entry that consumers edit their copy by hand.
- An issue moved from gvt-dev can name gvt-dev checks that this repo does not have, such as `pointer-baseline.mjs` and the pointer audit. Nothing under `plugin/` points to line numbers in a template (checked with `git grep` on 2026-11-13, #31). You can still keep an edit line-neutral when the issue asks for it, but no check here enforces it.

## Releasing

Use `/gvt-dev:release-plugin` if it is installed. It bumps `plugin/.claude-plugin/plugin.json` `version`, moves the `[Unreleased]` section of `plugin/CHANGELOG.md` and pushes a plain annotated `vX.Y.Z` tag. The marketplace catalog pins the plugin by that tag in `source.ref`. The tag without the `v` must equal the `plugin.json` `version`.

## Conventions

- Commit messages: `<scope>: <description>`.
- Branches: descriptive kebab-case.
- Pull requests are squash-merged. Merge commits are not used.
- License: MIT-0.
