---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: repository-settings
description: Use when bootstrapping a new GitHub or GitLab repository, configuring branch protection, setting merge-mode flags, or running `gh repo edit` / `gh api` to wire up Serokell-default repo policies.
---

# Repository settings

When creating a new repository at Serokell — or auditing an existing
one — apply the canonical settings below. Most of these live in the
web UI; an agent should either drive them with `gh api` / `glab api`
where possible, or ask the user to toggle them manually.

## Access

- Admin access for the Operations team.
- Write access for the `developers` team
  (https://github.com/orgs/serokell/teams/developers).
- `Read` as the default access level for everyone else.

The creator of a repository is `Admin` by default. If you don't have
admin permission and think you should, tag `@serokell/operations` (and
the repo creator if known) to request it. If you can't tag that team in
this repo, ask the team lead (see `PROJECT.md`).

**When you change repo settings, notify your colleagues and justify
the change.** Settings drift between repos is hard to debug, so
changes need to be visible.

## General options ("Options" panel on GitHub)

- **Allow auto-merge** — **enable**.
- **Automatically delete head branches** — **enable**.
- **Allow rebase merging** — **disable** (we use merge commits; see
  the `pull-requests` skill).
- **Allow squash merging** — enable. We don't squash multi-commit PRs,
  but squashing a single-commit PR is fine (see the `pull-requests`
  skill). Caveat: squash-merge replaces the author's signature with
  GitHub's, which can clash with the required-signed-commits rule.

Equivalent `gh` invocation (set everything via CLI in one call):

```
gh repo edit \
  --enable-auto-merge \
  --delete-branch-on-merge \
  --allow-rebase-merge=false \
  --allow-squash-merge=true \
  --allow-merge-commit
```

## Branch protection on long-lived branches

Apply to `master` (and `production` if used) — Notion *Create a
repository* is the source. Each repo should have these enabled
except possibly the tiniest ones:

- **Require pull request reviews before merging** — enable; required
  approvals usually 1.
  - "Dismiss stale pull request approvals" — usually disable.
  - "Require review from Code Owners" — usually disable (codeowners
    may be on vacation).
  - "Restrict who can dismiss pull request reviews" — usually disable.
- **Require status checks to pass before merging** — enable once CI
  exists. See the `setup-ci` skill.
  - **Require branches to be up to date before merging** — usually
    enable, to avoid accidental breakage from out-of-date merges. May
    be disabled in high-throughput repos where the up-to-date
    requirement would slow merges by an order of magnitude.
- **Require signed commits** — enable.
- **Require linear history** — usually disable.
- **Include administrators** — usually disable.
- **Restrict who can push** — usually disable.

Equivalent `gh api` invocation for setting the rule on `master`
(replace `OWNER/REPO`, and `<check-name-1>` with your CI status-check
contexts):

```
gh api -X PUT /repos/OWNER/REPO/branches/master/protection \
  -F required_pull_request_reviews.required_approving_review_count=1 \
  -F required_pull_request_reviews.dismiss_stale_reviews=false \
  -F required_status_checks.strict=true \
  -F required_status_checks.contexts[]=<check-name-1> \
  -F enforce_admins=false \
  -F required_linear_history=false \
  -F allow_force_pushes=false \
  -F allow_deletions=false \
  -F required_signatures=true
```

If the agent can't make these calls, ask the user to apply the
matching settings in the GitHub web UI under Settings → Branches.

## Repo metadata

- Set a description — short but specific. Required for every repo.
- Add topics where applicable for discoverability.

## Issue tracking

- If the repo uses YouTrack as the sole tracker, disable GitHub
  Issues to avoid confusion.

## See also

- `setup-ci` skill — wiring up the CI status checks that branch
  protection requires.
- `committing-work` skill — why we use merge commits, not rebase /
  squash.
