---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: committing-work
description: Use when the user asks to commit work, draft a commit message, create a branch for an issue, or make a fixup commit in a Serokell repo. Triggers on phrases like "commit these changes", "draft a commit message", "create a branch for this issue", "make a fixup commit", "git commit", "what should the branch be called", "Problem/Solution".
---

# Committing work

Use this skill whenever you are about to create a branch for a new issue,
stage changes, or write a commit message.

## Branch naming

Issue branches: `<username>/<issue_id>-<brief_description>`

- `<username>` is your GitHub username.
- `<issue_id>`:
  - GitHub issues: `#` followed by the number (e.g. `#228`).
  - YouTrack issues: lowercase letters with no dashes (e.g. `srk322`).
- If more than one issue is involved (or more than one person), concatenate
  IDs with dashes.
- `<brief_description>`: lowercase letters and dashes. Brief but clear
  enough that the topic is obvious without looking the issue up.

Examples:

- `gromakovsky/#228-add-yellow-button`
- `volhovm/srk322-eat-salad`
- `gromak-pva228/lsd666-dscp42-refactor-ssc`

Always branch off the relevant target branch (usually `master`). For
release work, start from the branch indicated by the issue (often a
`production` or release branch).

## Branching model

Serokell uses a variant of OneFlow with renamed long-lived branches:

- `master` ≡ OneFlow's `develop` — always represents the latest state
  of development (usually beyond the latest release). Issue branches
  default to branching off and merging back into `master`.
- `production` ≡ OneFlow's `master` — its HEAD is the latest released
  state. Only release / hotfix work touches it.

A repo may use only `master` (no `production`) if it has no
release-vs-development distinction. Check `docs/branching.md` in the
repo for the project-specific model before assuming.

## Commit message format

Subject line:

- Prefix with issue IDs in square brackets: `[#453]`, `[GHC-8]`. Omit if
  the repository is public and the issue is in a private tracker (e.g.
  YouTrack).
- Start with an uppercase letter.
- Use the imperative mood ("Switch from X to Y", not "Switched" or "Switches").
- Target ≤50 characters; hard limit 72.
- No trailing period.

Body:

- Separated from the subject by a single blank line.
- Begin with `Problem:` paragraph stating what is wrong / what needs to
  change.
- Continue with `Solution:` paragraph describing how this commit
  addresses the problem.
- Add additional context after that if useful.

Body is mandatory.

All commits must be signed (`git commit -S` or signing enabled by
default in your git config). If signing is not configured locally,
ask the user to configure it — do not commit unsigned.

## Example

```
[#453] Switch from avada-kedavra to expelliarmus

Problem: `avada-kedavra` library that we use to kill unwanted
process instances has a negative side-effect: it tears
programmers' souls apart. There is currently no mitigation
of this issue according to: (link to the developer issue
tracker).

Solution: Use a simpler `expelliarmus` library that blocks
process instances from performing any effects. Garbage-collect
blocked processes using the `kill` syscall.
```

## Commit hygiene

- Each commit should be a minimal and accurate answer to exactly one
  identified problem.
- A commit should not fix a problem introduced by an earlier commit in
  the same PR (clean that up via interactive rebase before merging).
- Force-push: only when rebasing on a newer target branch, and use
  `--force-with-lease`, never `-f`.

## During PR review

The clean-history rules above apply to commits that will be merged.
During a PR's review phase, write fix-up changes as **separate
commits** (do not amend), pushed as-is. Then, before merging, squash
them into their target commits via `git rebase -i --autosquash`.

The standard way to create such a fix-up commit is:

```
git commit --fixup=<sha-of-the-commit-being-fixed>
```

`git rebase -i --autosquash <target>` then auto-orders and marks
these `fixup!` commits to be squashed when the history is cleaned up.

