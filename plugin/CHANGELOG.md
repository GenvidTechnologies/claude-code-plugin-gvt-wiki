# Changelog

All notable changes to the `gvt-wiki` plugin are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and follows [semantic versioning](https://semver.org/).

## [Unreleased]

## [0.3.0] - 2026-11-22

### Changed

- The `maintain-wiki` §0 scaffold step now finds the documentation index through "Runtime path resolution" in gvt-dev's `CONVENTIONS.md`: `paths['docs/TOC.md']` when that override is set, else `<wikiDir>/index.md`, the default since gvt-dev 6.0.0 (gvt-dev ADR-0101). It no longer writes to a literal `docs/TOC.md`, and the `docs/TOC.md` expectation's reason names the resolved index. A schema inside the bundle is indexed in `<wikiDir>/index.md`, as before. For a schema outside the bundle, the step adds the **Knowledge Base** entry only when the documentation index is also outside `<wikiDir>/`. When the index is inside `<wikiDir>/`, the step writes no entry, because the link would leave the bundle, and reports the mismatch with two remedies: move the schema into the bundle, or set `paths['docs/TOC.md']`. A repository that kept its schema outside the bundle with no `paths['docs/TOC.md']` override no longer gets an entry in `docs/TOC.md` → minor version bump at release (#60).

### Fixed

- `maintain-wiki` ingest now writes the `wiki` block to `.gvt-agent.json`. gvt-dev's `audit-conventions` counts the block's presence as one of its wiki adoption signals, and the scaffold never wrote it, so a wiki set up exactly as the skill instructs stayed at `partial adoption`. The §0 scaffold step now adds `"wiki": { "wikiDir": "wiki", "rawDir": "raw" }` when `.gvt-agent.json` has no `wiki` key. It offers the write interactively and applies it under `--non-interactive`. It never changes a `wiki` block that exists, never creates `.gvt-agent.json`, and does not write a file that does not parse as JSON. Only `ingest` writes it; `query` and `lint` never do. A wiki scaffolded before this release gets the block on its next `ingest`, with no hand edit → patch version bump at release (#10).

## [0.2.0] - 2026-11-20

### Changed

- A page source no longer needs an upstream URL. The wiki schema template's `sources[]` rule keeps two entries per capture, the capture entry and the `<id>-upstream` entry, and now says what the upstream entry must be: a stable identifier of the source the capture was taken from, never a live path and never prose. It lists conventional forms: a URL for a web page, `git:<owner>/<repo>@<sha>:<path>` (or a permalink at that commit) for a file in a git repository, pinned to a commit the default branch contains, `<store>:<scope>/<entry>` for a local store such as auto-memory, and `none` for content that exists only in the capture, such as command output or a session insight. The template's frontmatter example no longer shows a URL placeholder. `maintain-wiki` ingest step 1 passes the upstream in one of these forms, `wiki-editor` writes it as given instead of skipping a source with no URL, and `wiki-librarian` reads every form. A `<wikiDir>/schema.md` scaffolded before this release keeps the URL-only rule. Replace its `sources[]` bullet and example by hand to match the template. `wiki-editor` now ingests sources it used to skip → minor version bump at release (#13).
- A claim about a change now cites a source that shows the change. The wiki schema template's "Page lifecycle" section gains three citation rules for an update. A claim added or changed because the code or another source changed cites a `sources[]` entry whose source shows that change: a capture taken after the change, or a commit that contains it. That claim gets a new `sources[]` entry, and no existing entry is pointed at the new capture or commit, because the existing entry still supports the claims it was first read for. Before an existing footnote is reused on a new or changed sentence, the writer confirms that the entry's source shows what the sentence says. `wiki-editor` carries the three rules in a new "Citing a changed source" section and applies them whether or not the schema states them, and it leaves out a claim that no source shows. `maintain-wiki` ingest step 1 re-captures a changed source after the change. `wiki-librarian` reports a footnote whose source does not show the claim. A `<wikiDir>/schema.md` scaffolded before this release keeps the old "refresh the frontmatter `sources` list" wording. Add the "Citations on an update" paragraph to its "Page lifecycle" section by hand to match the template. `wiki-editor` now leaves out claims it used to write → minor version bump at release (#41).

## [0.1.1] - 2026-11-16

### Changed

- The wiki schema template's starter `type` vocabulary now lists `decision-record`: an ADR kept in the bundle, superseded rather than rewritten. ADRs that a repo keeps in its wiki already carry this type, and the template did not name it. A `<wikiDir>/schema.md` scaffolded before this release keeps the old list. Add `decision-record` to it by hand if the repo keeps ADRs in the wiki. Template-only change → patch version bump at release (#31).

### Fixed

- The `maintain-wiki` skill no longer names the closed gvt-dev#150 as the owner of the OKF §11.1–11.2 conformance walk. The `lint` section now says that `wiki-lint.mjs` exists, that it covers only the deterministic subset and does not parse frontmatter, and that #19 tracks the frontmatter check. The `lint` verb still does not check conformance. The wiki schema template no longer calls the mechanical checker "future". A `<wikiDir>/schema.md` scaffolded before this release keeps the old "Tolerated, never rejected" paragraph, and its bare `#150` resolves against the consuming repo's own tracker. Edit that paragraph by hand to match the template. Prose-only skill change, no change to what `lint` or `wiki-lint.mjs` does → patch version bump at release (#30).

## [0.1.0] - 2026-11-11

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
