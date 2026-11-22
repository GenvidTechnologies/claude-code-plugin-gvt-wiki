# Wiki Log

Record of every change to the wiki's page set: what changed, why, and which
source drove it, grouped under `## YYYY-MM-DD` date headings (ISO 8601) with
the newest date group first. Entries are prose bullets, for example
`* **Update**: …`, `* **Creation**: …`, `* **Deprecation**: …`.

Add newest first. Never edit or remove a prior entry. If a past entry needs a
correction, add a new entry that says so. The maintenance rules are in
[the schema](schema.md).

## 2026-11-22

* **Update**: `issue-triage.md` gains a rule under Types: an issue that asks to change what the code documents about itself is non-defect work, even when its title reads like a defect. From the retro of the triage of #77, whose title read like a defect while `wiki-lint.mjs` did what its header said.

## 2026-11-21

* **Update**: `issue-triage.md` gains the road-block rule (under Labels) and the recipes "Read road block" and "Set road block", from the retro of the triage of #66 and #67. The triage had to read the `Road block` field of project GenvidTechnologies/1 with an ad-hoc query, because this file named neither the field nor a recipe.
* **Creation**: the wiki bundle, from the `maintain-wiki` templates of gvt-wiki 0.2.0: `index.md`, `log.md`, `schema.md` and `raw/README.md` (#46). `raw/` holds no capture yet; it exists so that a later `ingest` finds the full three-tier layout.
* **Creation**: `issue-triage.md`, moved from `docs/issue-triage.md` with OKF frontmatter added (#46). The `area:repo-docs` label text now names `wiki/` pages instead of `docs/`. No `raw/` capture drove this run: the source is the page itself, at `git:GenvidTechnologies/claude-code-plugin-gvt-wiki@b4fdaa607bda0b134a4f96f1f5f8e841a2c65237:docs/issue-triage.md`.
* **Creation**: `index.md` replaces `docs/TOC.md` (#46). Its links to the root files and the plugin components leave the bundle on purpose.
