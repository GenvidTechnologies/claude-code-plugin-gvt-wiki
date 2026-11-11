# Migration from the gvt-dev plugin

The wiki practice used to ship inside the gvt-dev plugin (`GenvidTechnologies/claude-code-plugin-gvt-dev`). It now ships as `gvt-wiki`. The history of this repository starts fresh. The history of the moved files before the copy is in the gvt-dev repository.

A bare `#NNN` or `ADR-NNNN` reference in a code comment under `plugin/skills/maintain-wiki/scripts/` refers to the gvt-dev repository (`GenvidTechnologies/claude-code-plugin-gvt-dev`).

## Copy base

The files were copied from the gvt-dev `main` commit `3aa5ca5e0b5e8fe4d3118f707c14ef89b65efd28`.

The files are unchanged on gvt-dev `main` from that commit until their removal. So this command, run in gvt-dev, gives their full history:

```
git log 3aa5ca5 -- plugin/skills/maintain-wiki plugin/agents/wiki-librarian.md
```

## What moved

Sixteen files were copied from gvt-dev:

- `plugin/skills/maintain-wiki/SKILL.md`
- the four templates: `raw-readme.template.md`, `wiki-index.template.md`, `wiki-log.template.md` and `wiki-schema.template.md`
- `plugin/skills/maintain-wiki/scripts/wiki-lint.mjs`
- the four modules in `plugin/skills/maintain-wiki/scripts/lib/`: `checks.mjs`, `git-raw.mjs`, `md-links.mjs` and `wiki-pages.mjs`
- the five tests in `plugin/skills/maintain-wiki/scripts/test/`: `checks.test.mjs`, `git-raw.test.mjs`, `md-links.test.mjs`, `wiki-lint.test.mjs` and `wiki-pages.test.mjs`
- `plugin/agents/wiki-librarian.md`

The files under `scripts/` were moved byte-identical. The skill, the templates and the agent use the `gvt-wiki:` namespace here.

## What is new

- The `wiki-editor` agent. It writes the pages for `ingest`. It has no Bash tool and never stages or commits.
- The git-state guard hook. It blocks state-changing git commands (stash, reset, checkout, switch, restore, clean, merge, rebase, cherry-pick, revert, pull and am) for subagents whose type starts with `gvt-wiki:`.

## Changed behavior

`/gvt-wiki:maintain-wiki ingest` leaves the changed files uncommitted. The caller reviews and commits them.

## Steps for a consuming repository

1. Install `gvt-wiki`:

   ```
   claude plugin marketplace add https://github.com/GenvidTechnologies/claude-code-gvt-marketplace.git
   claude plugin install gvt-wiki@gvt-plugins
   ```

2. Change each invocation from `/gvt-dev:maintain-wiki` to `/gvt-wiki:maintain-wiki`.
3. Leave the `wiki` block in `.gvt-agent.json` as it is. The keys are the same.
4. In `<wikiDir>/schema.md`, edit the marker line near the top. It names the skill that consumes the schema. Change the namespace from `gvt-dev` to `gvt-wiki`.
`gvt-wiki` does not need the gvt-dev plugin, and the gvt-dev plugin does not need `gvt-wiki`.
