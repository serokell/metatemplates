---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: pull-requests
description: Use when the user asks to open a PR or MR, draft a PR description, fill the PR template, request reviewers, or merge a PR in a Serokell repo. Triggers on phrases like "open a PR", "create a pull request", "make an MR", "write PR description", "fill the PR template", "request review", "merge this PR", "tick the checkboxes".
---

# Pull requests and merge requests

Use this skill when opening, updating, or reviewing a PR (GitHub) or MR
(GitLab).

## Title

Scheme: `[ISSUE-ID] Brief description`.

- Omit `[ISSUE-ID]` if the repository is public and the issue is in a
  private tracker (e.g. YouTrack).
- Brief description: short but understandable on its own.

## Description

Must not be empty.

- This repo provides templates at `.github/pull_request_template.md`
  (GitHub) or `.gitlab/merge_request_templates/default.md` (GitLab).
  Use whichever applies to the host.
- Fill every section of the template (`Description`, `Related issue(s)`,
  the various `Checklist` subsections, and `Release Checklist` where
  applicable).
- Describe what changed AND why.
- Link related issues. For GitHub / GitLab public issues, use
  `Fixed #N` / `Resolves #N` to auto-close them on merge. For YouTrack
  issues, paste the full URL
  (`https://issues.serokell.io/issue/<PROJECT>-<N>`) prefixed with
  `Resolves`.

## Checkboxes

This is the rule that catches people out:

- Tick every checkbox you can substantiate.
- **If a checkbox is irrelevant to this PR, still tick it.** That
  signals you considered the item and judged it irrelevant. Do not
  silently leave irrelevant items unticked.
- The only acceptable unticked checkbox is one you can justify (e.g.
  in a PR comment).

The PR template itself states this explicitly in its meta-comments;
follow that instruction.

### What each checkbox actually means

The PR template groups checkboxes into conditional sections. For each
one, know what triggers it and what evidence backs ticking it:

- **Tests** — fires when the PR adds functionality or fixes a bug. For
  new functionality: add tests covering it. For a bugfix: add a
  regression test that would have caught the bug.
- **Documentation** — fires when the PR changes behaviour visible to
  users or to other code. Update the `README` and in-code API
  documentation as needed.
- **Public contracts** — fires when the PR changes public API or
  protocol. Comply with the project's public-contracts policy
  (semver, deprecation cycles, etc.), add a `CHANGES.md` entry, and
  provide a migration note for breaking changes.
- **Release Checklist** — fires on release PRs only. Bump the version
  in the project's package manifest; add `@since`-style annotations to
  new public API where the language supports them; create the GitHub
  `releases` entry after merge with the `vX.Y.Z` tag; publish to the
  relevant package registry for public libraries (e.g. Hackage for
  Haskell).
- **Stylistic guide (mandatory)** — never irrelevant. Confirm commit
  policy compliance, plus code style compliance if the repo has a
  style guide.
- **Agent instructions (conditional)** — fires when the PR touches
  `.claude/skills/` or `.github/copilot-instructions.md`. Keep the two
  in sync: when one changes, verify the other still reflects the
  changed content.

## Scope

- One PR per issue (1:1 mapping). Don't bundle unrelated work.
- An exception: trivial in-place fixes (a typo, wrong formatting) in a
  file you're already editing are fine.
- Size guideline: aim for ≤500 additions+deletions. If your PR is
  larger, think first whether the issue can be split.

## Reviewers

- Request review from the project's expected number of reviewers
  (project-dependent, often 2). If unsure, check `CODEOWNERS` and
  recent merged PRs, or ask the user. Look for people who touched this
  code before or are likely interested.
- Codeowners may be auto-requested; check the final reviewer list after
  opening the PR.

## During review

- Make requested changes in separate commits — do NOT amend earlier
  commits during review. Use `git commit --fixup=<sha>` (see the
  `committing-work` skill).
- Do NOT force-push during review, except to rebase on a newer target
  branch (and use `--force-with-lease`, never `-f`).
- Sync with the target branch periodically by rebasing onto it, not by
  merging it in.
- **Do not mark a reviewer's comment as resolved.** That is the
  reviewer's call — they decide whether their concern was addressed.
- If reviewers don't respond within ~3 working days, ping them
  explicitly. If still silent, ping the team lead too — tag their
  username (from `PROJECT.md`) in a comment.

## Merging

- Use a merge commit (GitHub's "Create a merge commit" option).
- Do NOT use "Squash and merge" unless the PR has exactly one commit.
- Do NOT use "Rebase and merge" by default. (Exception: fast-forwarding
  a release branch from `master`.)
- Before merging, ensure the commit history satisfies the project's
  commit policy (see the `committing-work` skill). PR author usually
  cleans history before merge.
- When merging **someone else's PR**: confirm the author is fine with
  merging and doesn't want to touch the commit history first. If the
  PR is trivial (e.g. a one-line fix) you can merge without asking;
  otherwise ping the author. On GitLab, the author's self-approval
  counts as agreement to merge.

