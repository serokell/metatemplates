---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: youtrack-issues
description: Use when filing or editing issues in YouTrack (issues.serokell.io). Covers project selection, Type, Title, the Bug vs Task description templates, and the "acceptance criteria for robots" guideline.
---

# Filing YouTrack issues

YouTrack is Serokell's primary issue tracker (`https://issues.serokell.io`).
Follow this skill when creating or editing an issue.

## Pick the project

**Rule**: file the issue in the YouTrack project the work concerns —
for work on this repo, that's the project recorded in `PROJECT.md`. Do
**not** file it in a special team-routing project (OPS, DESIGN, LEGAL)
even when you want that team to do the work — instead, set the
`Subsystem` field on the issue (e.g. `Subsystem: Operations`) to flag
the relevant team.

## Type

Set `Type` to the appropriate category (`Bug`, `Task`, `Feature`,
`Improvement`, etc.) per the project's conventions.

## Title

- Fit within ~20 words. No strict hard limit, but stay concise.
- Single grammatically-correct English sentence.
- The title should match the actual scope — neither broader nor
  narrower than the issue.

For **Bug**: summarise what you observe when reproducing the bug. Add
the condition if you can keep the title concise. Examples:

- `api/contacts/current returns incorrect data if original account was unlinked`
- `GitHub sync fails while parsing headers`
- `Bottom-left user info panel does not load`

For **Task** with explicit acceptance criteria: imperative summary of
what needs to be done. Examples:

- `Use a newer protocol for communication between clients`
- `Add "Security" tab for quick access to security parameters`

## Description

Empty descriptions are not acceptable. The required structure depends on
type.

### Bug

Answer all of these:

- In which revision of code was the bug detected? (Commit hash on a
  branch that won't be removed. If reproducible only with local changes,
  push them to a branch following the standard naming scheme — see
  `committing-work` skill.)
- In which environment? (OS, cluster, screen resolution, etc.)
- Steps to reproduce.
- Reproduction frequency. (Default assumption: 100%.)
- Expected behavior, and how to verify correct behavior.
- Actual behavior, and why it is incorrect.

Attach screenshots and relevant log excerpts when applicable.

### Task (or Feature, Improvement, etc.)

Two-part structure:

1. **Clarification and Motivation** — context, scope, and the "why".
   Written in prose for people. Explain what is meant and why this needs
   doing.

2. **Acceptance criteria** — written *for robots*. Detailed, precise,
   unambiguous, complete, self-contained. If handed to a machine that
   does exactly what it's told without asking questions, the machine
   should be able to check whether the issue is resolved.
   - Avoid implicit assumptions.
   - Quote sources fully, with links to the full context.
   - Specify the general case, not just example inputs.

   Example AC (for an issue titled *Make external imports explicit*):

   ```
   1. After this refactoring, there are no implicit imports in
      Haskell code except for modules from the same repository.
   2. If there are less than 4 imported identifiers, import lists are
      used.
   3. Otherwise, the module is imported qualified.
   4. Exceptions to the above must be documented inline with the
      reason.
   ```

## Other fields

- `State`: default `Open` for a new issue. Change only if work has
  actually started.
- `Subsystem` (when present in the project) and `Assignees`: set if you
  know them.

## State transitions (working on an issue)

The standard issue-state lifecycle:

- `Open` — default for a new issue, no work yet.
- `In Progress` — set when you start working on the issue. Also
  update `Assignees` to yourself if it isn't already.
- `Review` — set when you submit a PR (or the issue's deliverable is
  ready for review by other means, e.g. a Notion doc). Link to the
  PR / deliverable.
- `Done` — set after the PR is merged (or the deliverable accepted).
  If you've only delivered part of the work and another PR is coming,
  move back to `In Progress` instead.
- `Aborted` — set when the issue is no longer relevant (requirements
  changed; too much time has passed; etc.).

Some YouTrack projects customise this lifecycle (e.g. distinguishing
"merged to main" from "deployed to production") — check the project's
documentation if it has any.
- Some projects have additional mandatory fields — check the project's
  page in Notion.

## Branch target

By default, assume the issue's PR will target `master` (or `main`). If
not — e.g. a hotfix on a release branch — specify it explicitly in the
description or the dedicated field.

## Hard rule

If an issue is not described properly per the above, **do not start
working on it**. Fix the description first.

