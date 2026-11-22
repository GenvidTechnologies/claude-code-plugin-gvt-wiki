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
wiki/                        # This repo's own docs, in the maintain-wiki format
  index.md                   # Documentation index
  log.md                     # Change log of the page set
  schema.md                  # Maintenance rules for this wiki
  issue-triage.md            # Triage contract read by /gvt-dev:triage-issues
raw/                         # Immutable captures for ingest (README.md only so far)
.gvt-agent.json              # Commands for this repo, and the wiki block
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
- An issue can cite a gvt-dev version that is not released yet. Check gvt-dev's tags first: `gh api repos/GenvidTechnologies/claude-code-plugin-gvt-dev/tags --jq '.[].name'`. When the version has no tag, read the claims on the gvt-dev branch that carries it (its `plugin.json` `version`, its CHANGELOG `[Unreleased]` entry), and say in the issue that this branch stands in for the release, with the commit read. Observed 2026-11-21 on #60: the issue cited gvt-dev 6.0.0 while the newest tag was v5.2.0, and the 6.0.0 rules were only on the integration branch `worktree-claude-code-plugin-gvt-dev-938`.
- An issue filed from one ingest run can describe a choice the agent made in that run as something it "already does". Check the claim against the agent body before you accept it. Observed 2026-11-20 on #57: the issue said that `wiki-editor` "already flags" an unchecked code example, and `wiki-editor.md` has no rule about code examples.
- An issue that copies rules from a consuming repository's `CLAUDE.md` can carry that repository's local choices, and can say that the plugin does not state a rule that it already states. Check each value against this plugin's templates and against the gvt-dev skill that owns the file (for decision records, gvt-dev's `create-adr` and its `docs/decision-record.template.md`). For each rule the issue calls missing, search all of `plugin/`, including the `lint` section of `SKILL.md` and the comments in the templates. Observed 2026-11-21 on #67: it proposed construct3-sample's `type: decision-context`, while the template vocabulary and `create-adr` use `decision-record`. It also said that `SKILL.md` did not state the reserved-file rule or the exit-0 rule, and the `lint` section of `SKILL.md` states both.
- Before you accept a claim about what `wiki-lint.mjs` checks, read its `printGroup` calls. Each call is one check. At v0.2.0 there are four: dead links, out-of-bundle links, orphaned pages and unreachable subtrees, and `raw/` immutability. The script reads no frontmatter. The `lint` section of `SKILL.md` describes the `lint` verb, which the model runs and which also covers stale pages, so an issue that quotes that section can attribute a verb check to the script. Observed 2026-11-22 in the triage of #70: #26 says "frontmatter the linter already parses", and #33 lists `stale_after` among the mechanical checks.
- The `sources[]` rule is stated in four files: `wiki-schema.template.md` (the `sources[]` bullet, the frontmatter example and the "Citations on an update" paragraph of "Page lifecycle"), `SKILL.md` (ingest steps 1 and 3), `agents/wiki-editor.md` (the Inputs list, the `sources[]` rule and the "Citing a changed source" section) and `agents/wiki-librarian.md` (the `sources[]` bullet and step 5). A change to the rule changes all four in one commit. The template alone is not enough: an existing `<wikiDir>/schema.md` keeps the old text, so a rule that the ingest thread or an agent must follow also goes in the plugin-owned files. Observed 2026-11-19 on #13. No script reads `sources[]`, so the tests pass whether or not the four files agree.
- An issue's acceptance criteria can name fewer of the four files than the rule above requires. The rule still applies: change all four, and name the extra files in the pull request so that the reviewer can accept or drop them. Observed 2026-11-20 on #41: the criteria named the template and `wiki-editor.md`, and the pull request also changed `SKILL.md` ingest step 1 and `wiki-librarian.md` step 5. It merged with all four.
- The OKF spec that the template pins can be read at its pinned commit: `gh api "repos/GoogleCloudPlatform/knowledge-catalog/contents/okf/SPEC.md?ref=<sha>" --jq .content`, then base64-decode it. Read the spec before you define a frontmatter form. For example, §5.1 allows a `sources[].resource` that a consumer cannot follow (a scope descriptor), which is what makes `resource: none` legal (#13).
- This repository's own documentation is the `wiki/` bundle (#46). A change to a page under `wiki/`, such as a triage retro that edits `wiki/issue-triage.md`, adds a dated entry to `wiki/log.md`, newest first, as `wiki/schema.md` requires. A new page also gets an entry in `wiki/index.md`. No test checks either rule; the `maintain-wiki` lint reports a page that no index lists, but not a missing log entry.
- `wiki/log.md` and `wiki/index.md` are OKF reserved files, not concept pages (OKF §3). `log.md` carries no frontmatter (§9), and `index.md` carries only `okf_version` (§8). An acceptance criterion that asks for frontmatter on "every page under `wiki/`" means the concept pages. Observed 2026-11-21 on #46.

## Releasing

Use `/gvt-dev:release-plugin` if it is installed. It bumps `plugin/.claude-plugin/plugin.json` `version`, moves the `[Unreleased]` section of `plugin/CHANGELOG.md` and pushes a plain annotated `vX.Y.Z` tag. The marketplace catalog pins the plugin by that tag in `source.ref`. The tag without the `v` must equal the `plugin.json` `version`.

## Conventions

- Commit messages: `<scope>: <description>`.
- Branches: descriptive kebab-case.
- Pull requests are squash-merged. Merge commits are not used.
- License: MIT-0.
