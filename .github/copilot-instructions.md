<!--
   - SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
   -
   - SPDX-License-Identifier: CC0-1.0
   -->

# Project conventions for GitHub Copilot

## Project info

- Repo-specific facts (issue tracker, YouTrack project key, team lead)
  are in `PROJECT.md`. When you cannot do something yourself (repo
  admin actions, CI-runner requests), ping the team lead yourself — tag
  their GitHub/GitLab username (from `PROJECT.md`) in a PR or issue
  comment. Only if you can't post a comment (no access, or no PR/issue
  to comment on) ask the user to relay.

## Committing work

- Branch name: `<github-username>/<issue-id>-<brief-description>`. Issue
  ID is `#<number>` for GitHub issues, lowercase letters with no dashes
  for YouTrack (e.g. `srk322`). Brief description uses lowercase letters
  and dashes.
- Commit subject: `[ISSUE-ID] Brief description`. Uppercase first letter,
  imperative mood, target ≤50 chars (hard limit 72), no trailing period.
- Commit body: blank line after subject, then `Problem: …` paragraph,
  then `Solution: …` paragraph. Body is mandatory.
- All commits must be signed.

## PR template

- PR title: `[ISSUE-ID] Brief description`. Omit `[ISSUE-ID]` for public
  repos with private issue trackers.
- Fill every section of `.github/pull_request_template.md` (or its
  GitLab equivalent at `.gitlab/merge_request_templates/default.md`).
  PR description must not be empty.
- Tick every checkbox you can substantiate. If a checkbox is irrelevant
  to this PR, still tick it — that signals you considered it and dealt
  with it by irrelevance. Only leave a checkbox unticked when you can
  justify the omission.
- One PR per issue (1:1). Aim for ≤500 additions+deletions.

## REUSE / SPDX headers

<!-- REUSE-IgnoreStart -->

- Every new source file gets an SPDX header below any shebang:
  - `SPDX-FileCopyrightText: <year> <copyright holder>`
  - `SPDX-License-Identifier: <SPDX-ID>` (default `MPL-2.0` for
    Serokell-owned projects; customer projects use the customer as
    copyright holder).
- Use the comment style of the file type. Haskell: `--`. YAML / shell:
  `#`. Markdown: HTML comment.
- Use `reuse annotate --copyright '...' --license '...' --style <type>
  <files>` to add headers in bulk.
- `reuse lint` must pass. Files that cannot carry a header are
  registered in `REUSE.toml`.

<!-- REUSE-IgnoreEnd -->
