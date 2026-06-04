---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: changelog
description: Use when the user asks to add a changelog entry, set up a `CHANGES.md` / `CHANGELOG.md` file, document user-facing changes in a release, or write a migration note for a breaking change. Triggers on phrases like "add to changelog", "CHANGES.md entry", "document this release", "release notes", "breaking change migration note", "what's new", "user-facing changes".
---

# Changelog

## When a changelog entry is required

- Add an entry when the PR results in **user-visible** changes (CLI
  behaviour changes, API additions/changes/removals, output format
  changes, config knobs added, defaults changed, dependencies bumped
  if they affect users).
- Add a migration note when the change is **breaking** — even inside
  a major-version bump.
- Skip when the PR is purely internal (refactor with no behaviour
  change, test additions, dev tooling changes).

## What every entry must contain

Regardless of format:

- **Version + date** of the release the entry belongs to. Use the
  literal `Unreleased` (or equivalent) heading for changes not yet
  shipped — promote to a versioned heading at release time.
- **One bullet per user-visible change**, written from the user's
  perspective ("Added support for X", "Fixed crash when Y"). Not
  "Refactored Z". Prefer too much detail over too little — a reader
  six months from now should be able to act on the entry without
  re-reading the PR.
- **PR or issue reference** alongside each bullet (e.g. `(#123)`).
- **Breaking changes** clearly marked (e.g. a leading `BREAKING:` tag
  or a separate "Breaking changes" subsection), with **migration
  guidance** — inline if short, or a link to a longer migration doc.

For Haskell packages published to Hackage: ensure the file matches the
package's `changelog-file` field in `*.cabal` (default `CHANGELOG.md`).

## Format

**If the repo already has a `CHANGES.md` / `CHANGELOG.md`**: follow the
existing format.

**If the repo has no changelog yet**: use the
[Keep a Changelog](https://keepachangelog.com/) format. Its category
vocabulary — use only categories you actually have content for, don't
pre-stub empties:

- **Added** — new features.
- **Changed** — changes to existing functionality.
- **Deprecated** — soon-to-be-removed features.
- **Removed** — features removed in this release.
- **Fixed** — bug fixes.
- **Security** — vulnerability fixes.

Structural conventions:

- Version headings: `## [X.Y.Z] - YYYY-MM-DD`.
- Unreleased changes live under a literal `## [Unreleased]` heading at
  the top, no date. At release time, rename it to the new version +
  date and add a fresh `[Unreleased]` block above it.
- Category headings: `### Added`, `### Fixed`, etc. — one level deeper
  than the version.
