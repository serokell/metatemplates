---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: bootstrap-repo
description: Use when the user asks to create a new Serokell repository, bootstrap a fresh repo from `metatemplates`, fork an external repo into the Serokell org, initialize a new project, or sequence the full new-repo setup (create → customise → license → CI → settings). Triggers on phrases like "create a new Serokell repo", "bootstrap this repo", "set up a fresh repo", "fork this repo into serokell", "initialize new project", "new repo from metatemplates", "start a new project", "first commit on a new repo".
---

# Bootstrap a new repository

## Fork or new repo?

- **Temporary fork** — fork into the `serokell` GitHub org so
  colleagues inherit access. Add a one-paragraph "why this fork
  exists" both to the README on `master` and to the GitHub "About"
  section — an agent should do both for maximum visibility. **Stop
  here.** No further steps apply.
- **A normal new repo** — follow the sequence below.

## The sequence (non-fork repos)

1. **Create the new repo from `metatemplates`.** On GitHub:
   `gh repo create <owner>/<name> --template serokell/metatemplates`
   (use `--private` or `--public` for the visibility you need now — a
   repo that's private today but may open later still starts
   `--private`). GitLab has no template feature — clone `metatemplates`
   and copy its contents into a fresh project.
2. **Open a bootstrap PR.** Don't push customisation directly to
   `master` — even initialisation goes through review.
   → `pull-requests` skill.
3. **Customise inherited files** (any order — these are independent):
   - Fill `PROJECT.md` with this repo's issue tracker, YouTrack project
     key, and team lead — several skills read it.
   - License + `LICENSES/` + root `LICENSE` → `license-choice` skill.
   - SPDX headers on every file → `reuse-headers` skill.
   - README rewritten to Standard Readme → `readme` skill.
   - `.gitignore` for the project's stack → `gitignore` skill.
   - Haskell configs in `haskell/` (or delete the directory) →
     `haskell-style` skill.
   - PR/MR template: always keep it. Keep the directory for your host
     (`.github/` *or* `.gitlab/`) and delete the other.
   - `CONTRIBUTING.md`: keep and adapt it if it carries repo-specific
     contribution info; otherwise remove it.
   - Agent instruction files: review `.github/copilot-instructions.md`
     and `.claude/skills/`; customise or delete what's irrelevant.
   - Strip meta-comments and placeholders (see *Gotchas*).
4. **Bootstrap CI** → `setup-ci` skill. Must complete before step 5.
5. **Apply repo settings** → `repository-settings` skill. Branch
   protection's status-check requirement needs the CI from step 4.
6. **Optionally set up a changelog** → `changelog` skill. Worth
   doing now for libraries or anything user-visible.
7. **Merge the bootstrap PR** → `pull-requests` skill.

## Bootstrap-specific gotchas

- The template README is **not** Standard-Readme-compliant. Don't
  mirror its shape; rewrite from scratch to spec.
- The template `.gitignore` is intentionally minimal. Replace it.
- The root `LICENSE` must exist regardless of where your real
  license metadata lives — GitHub and GitLab key off it.
- Placeholders are scattered across files: `mypackage`, `KEK`,
  `Patak`, `LicenseRef-ReplaceMe`. Search-and-replace them all
  before merging.
- Strip every `[//]: # (...)` meta-comment from inherited files —
  they exist to guide the human creator, not to ship. Verify
  removal with `git grep '\[\/\/\]:'` (should return nothing in
  committed files).
