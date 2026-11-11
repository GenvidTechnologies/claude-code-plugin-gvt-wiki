# gvt-wiki

A Claude Code plugin for an LLM-maintained project wiki. It adds pages from source captures, answers questions from those pages, and checks the wiki for broken structure.

## Components

| Component | Kind | What it does |
|---|---|---|
| `maintain-wiki` | skill | Maintains the wiki with three verbs: `ingest`, `query` and `lint`. Invoke it as `/gvt-wiki:maintain-wiki`. |
| `wiki-librarian` | agent | Read-only. Answers a question from the wiki pages, the index and the log. Runs the `query` verb. |
| `wiki-editor` | agent | Writes the pages, the index entry and the log entries for one `ingest` run. Its tools are Read, Write, Edit, Grep and Glob. It has no Bash tool and never stages or commits. |
| git-state guard | PreToolUse hook | Blocks state-changing git commands issued by a `gvt-wiki:` subagent. |
| `wiki-lint` | script | `plugin/skills/maintain-wiki/scripts/wiki-lint.mjs`. A mechanical checker that uses Node built-ins only. It always exits 0. |

## Install

```
claude plugin marketplace add https://github.com/GenvidTechnologies/claude-code-gvt-marketplace.git
claude plugin install gvt-wiki@gvt-plugins
```

The marketplace catalog is `gvt-plugins`. The catalog entry for `gvt-wiki` exists from the `v0.1.0` release on.

## Configuration

The skill reads the `wiki` block of the consuming repository's `.gvt-agent.json`: `wiki.wikiDir` and `wiki.rawDir`. The keys are defined in the gvt-dev plugin's [`CONVENTIONS.md`](https://github.com/GenvidTechnologies/claude-code-plugin-gvt-dev/blob/main/plugin/CONVENTIONS.md). This repository does not copy that definition.

## Relation to gvt-dev

`gvt-wiki` and the gvt-dev plugin are separate plugins. Neither declares a dependency on the other. Each installs and runs alone. They share only the file-level `wiki` block contract above.

## Moving from gvt-dev

The wiki practice used to ship inside the gvt-dev plugin. See [`MIGRATION.md`](MIGRATION.md) for what moved, what changed and the steps for a consuming repository.

## License

MIT-0. See [`LICENSE`](LICENSE).
