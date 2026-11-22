---
type: convention
title: Issue Triage Conventions
description: Project conventions that /gvt-dev:triage-issues reads for this repository - types, priorities, labels, required fields, splitting, duplicates, dependencies and mutation recipes.
tags: [triage, process]
status: stable
---

# Issue Triage Conventions

> Project conventions consumed by `/gvt-dev:triage-issues`. The skill copies this
> file to the contract path `.gvt-agent.json` resolves for `docs/issue-triage.md`; edit it for your tracker and taxonomy. The companion
> **access mechanics** (fetch queries, label names) live in the `bugTracker`
> block of `.gvt-agent.json` — see the skill's SKILL.md for that block.
>
> This is the **structured-taxonomy variant** (`type:*`/`priority/*`/`area:*`). If
> your repo uses a simple flat category-label set (GitHub's defaults: `bug`,
> `enhancement`, `documentation`, `duplicate`, `question`, …) with no such scheme,
> copy `issue-triage.flat.template.md` instead.
>
> The example commands below assume **GitHub Issues via the `gh` CLI**. Replace
> them with your tracker's equivalents (Jira `acli`, Linear API, …); the section
> headings must stay the same — the skill and analyst locate guidance by heading.

## Types

- `bug` — incorrect behavior in shipped functionality (default).
- `crash` — hard failure, exception, or hang.
- `regression` — worked in a prior build, broken now.

Set the type via the matching `type:*` label; exactly one per issue.

**Non-defect work** (a feature request, docs change, or chore) is *not* a
`type:*` — `type:*` is reserved for defects. Classify it by its category label
instead (`enhancement`, `documentation`, `chore`) and leave `type:*` unset. It
may carry more than one category label when both apply, for example
`documentation` and `chore`. It still gets a `priority/*` and at least one
`area:*`.

## Priorities

- `P0` — blocks release or breaks the build; fix now.
- `P1` — major feature broken, no workaround; fix this sprint.
- `P2` — broken with a workaround, or a minor feature; schedule.
- `P3` — cosmetic or nice-to-have; backlog.

Decision rule: pick by the worst **observable** impact, not the suspected cause.

## Labels

- `type:*` — exactly one (mutually exclusive): `type:bug`, `type:crash`, `type:regression`.
- `area:*` — one or more subsystem tags:
  - `area:maintain-wiki` — the `maintain-wiki` skill, its `SKILL.md` and its templates.
  - `area:wiki-lint` — the `wiki-lint` script and its tests under `scripts/`.
  - `area:agents` — the `wiki-librarian` and `wiki-editor` agents.
  - `area:hooks` — the git-state guard hook.
  - `area:docs-release` — `README.md`, `MIGRATION.md`, `CHANGELOG.md` and releases.
  - `area:repo-docs` — this repository's own `wiki/` pages and `.gvt-agent.json`.
- `priority/*` — exactly one: `priority/P0` … `priority/P3`.
- `needs-info` — set when required fields are missing; cleared when supplied.
- `duplicate` — set on non-canonical members of a duplicate cluster.
- `triaged` — set **last**, by the skill, when triage is complete.

The triager sets `type:*`, `area:*`, and `priority/*`. Reporters may set `area:*`.

The road block is not a label. It is the `Road block` field of the GitHub
project GenvidTechnologies/1: one option per larger goal of the project, plus
`Standalone` for a bug or small improvement that serves no larger goal. Each
option's description gives the goal and its "done when". Propose a road block
for each triaged issue, and set it only with the coach's approval, through the
recipe "Set road block". When no road block fits and the issue is not
standalone, say so in the triage report: the project may need a new goal.

Read the options and the issue's current road block first, with the recipe
"Read road block". Report the current value beside the proposal. When they are
the same, say "no change" and do not ask or write. "Set road block" has no dry
run, so it cannot be used to look. Observed in the triage of #66 and #67
(2026-11-21): both issues already held the road block that the triage would
have proposed, and this file had no recipe to read it.

## Required fields

Every triaged **bug** must have: a reproduction (steps or a failing case),
expected vs. actual behavior, the build/version, and at least one `area:*` label.
Missing any of these → add `needs-info` and comment exactly what is missing.

A **non-defect** issue (enhancement, docs, chore) has no repro or build/version;
it instead needs a clear **proposed change** (or acceptance criteria, as `- [ ]` rows under an `## Acceptance Criteria` heading) and at least
one `area:*` label. Never `needs-info` an enhancement for lacking a repro — flag
it only when the proposed change itself is too vague to act on.

## Splitting

Split when one issue bundles unrelated defects, or when a single defect spans
subsystems that ship independently. Prefer **sub-issues** (a task-list of
checkboxes referencing new issues) when the parent is a tracking umbrella;
prefer **separate issues** when the parts share no parent. Keep the original as
the canonical/umbrella and move each split-out defect's repro into its own issue.

## Duplicates

Policy: **link, do not auto-close.** For a duplicate cluster, choose the
canonical (usually the oldest with the best repro), add `duplicate` to the
others, and comment `Duplicate of #<canonical>` on each. Close a duplicate only
with explicit per-item approval.

## Dependencies

Express a dependency with a comment on the blocked issue: `Blocked by #<id>`
(optionally `Blocks #<id>` on the other). For umbrellas, list dependencies as a
GitHub task-list under a `Depends on` heading.

## Mutation recipes

The exact commands the triage skill runs to apply **approved** changes. `{id}`,
`{type}`, `{otherTypes}`, `{p}`, `{otherPriorities}`, `{a}`, `{canonical}`, `{other}`, `{title}`,
`{tmpfile}`, `{triagedLabel}`, `{needsInfoLabel}`, and `{closeReason}` are substituted
by the skill.

When a recipe's set would be empty, omit its --remove-label flag.

{otherTypes} is the set of type labels, written out in full, with the label being added removed; {otherPriorities} is the set of priority labels, written out in full, with the label being added removed.

- Set type: `gh issue edit {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --add-label "type:{type}" --remove-label "{otherTypes}"`
- Set priority: `gh issue edit {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --add-label "priority/{p}" --remove-label "{otherPriorities}"`
- Add area: `gh issue edit {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --add-label "area:{a}"`
- Remove area: `gh issue edit {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --remove-label "area:{a}"`
- Edit body (language fix / fill missing info): `gh issue edit {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --body-file {tmpfile}` — the skill writes the approved new body to `{tmpfile}` first
- Comment: `gh issue comment {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --body-file {tmpfile}` — the skill writes the comment text to `{tmpfile}` first
- Flag missing info: `gh issue edit {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --add-label {needsInfoLabel}` (pair with a Comment saying what's missing)
- Mark duplicate: `gh issue edit {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --add-label duplicate` then `gh issue comment {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --body "Duplicate of #{canonical}"`
- Close duplicate (only with approval): `gh issue close {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --reason "not planned" --comment "Duplicate of #{canonical}"`
- Close as completed or not planned (only with approval): `gh issue close {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --reason "{closeReason}"` — post the reason first through the Comment recipe; `{closeReason}` is `completed` or `not planned`
- Create split issue: `gh issue create --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --title "{title}" --body-file {tmpfile} --label "type:{type},area:{a}"` — the skill writes the drafted split body to `{tmpfile}` first; for a **non-defect** split, replace `type:{type}` with the category label (`enhancement`/`documentation`/`chore`)
- Link dependency: `gh issue comment {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --body "Blocked by #{other}"`
- Read road block (read-only): `gh api graphql -F n={id} -f query='query($n:Int!){organization(login:"GenvidTechnologies"){projectV2(number:1){field(name:"Road block"){... on ProjectV2SingleSelectField{options{name description}}}}} repository(owner:"GenvidTechnologies",name:"claude-code-plugin-gvt-wiki"){issue(number:$n){projectItems(first:20){nodes{project{number} roadBlock:fieldValueByName(name:"Road block"){... on ProjectV2ItemFieldSingleSelectValue{name}}}}}}}'` — prints every option of the `Road block` field with its description, and the issue's project items with their `Road block` value. Use the item of project number 1. No item of project 1 means the issue is not in the project; a `null` value means the field is not set. The query reads the issue's `projectItems`, which lists only projects of the repository's owner; project 1 is one of them. Run 2026-11-21 on #66: 32 options, and the item of project 1 with its road block.
- Set road block (only with the coach's approval): `node <gvt-fleet workspace>/.claude/skills/groom-road-blocks/scripts/set.mjs --dir <scratch folder> --project GenvidTechnologies/1 "GenvidTechnologies/claude-code-plugin-gvt-wiki#{id}={roadBlock}"`, where `<gvt-fleet workspace>` is the absolute path of the gvt-fleet workspace root. `{roadBlock}` is the full option name, for example `G3 maintain-wiki and wiki-lint are trustworthy`. The script has no dry run: it writes at once. It creates the `--dir` folder for its query files, adds the issue to the project when it is missing, reads the value back, and prints `OK` for each issue.
- Stamp triaged: `gh issue edit {id} --repo GenvidTechnologies/claude-code-plugin-gvt-wiki --add-label {triagedLabel}`

Read the labels back after this edit: confirm the issue now carries exactly the intended labels before it is stamped triaged (use the tracker's read-one query, or the native issue view).
