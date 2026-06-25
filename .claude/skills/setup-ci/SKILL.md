---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: setup-ci
description: Use when the user asks to bootstrap CI for a Serokell repo, add a GitHub Actions workflow, create a `.gitlab-ci.yml`, wire up self-hosted nix runners, or apply a haskell.nix CI template. Triggers on phrases like "set up CI", "add a workflow", "create .gitlab-ci.yml", "configure CI for this repo", "self-hosted nix runner", "nix flake init for CI", "haskell.nix CI template", "common CI checks".
---

# Setting up CI/CD

Long-lived branches (`master`, sometimes `production`) must always be in
a good state, so CI is mandatory for any non-trivial repo. The same
infrastructure is often used for CD (re-deploys, releases triggered by
push to a specific branch).

## Pick the service

- GitHub repos → GitHub Actions. Config goes in `.github/workflows/*.yml`.
- GitLab repos → GitLab CI. Config goes in `.gitlab-ci.yml`.

Both can run on shared runners (provided by GitHub/GitLab) or on Serokell
self-hosted runners.

## Self-hosted runners

Self-hosted runners are pre-installed with `nix` and rootless-docker.
Faster than shared runners and required for most of our nix-based builds.

GitHub Actions — for each job:

```yaml
runs-on: [self-hosted, nix]
```

GitLab CI — runner selection is instance-specific; there's no universal
tag. For a new repo, ping the team lead (tag their username from
`PROJECT.md` in a comment) for the instance's runner convention; for an
existing repo, follow its `.gitlab-ci.yml`.

macOS builds:

- GitHub shared macOS: `runs-on: macos-latest` (non-nix builds).
- Nix macOS via our infrastructure: our self-hosted GitHub runners
  already act as remote builders for `x86_64-darwin` and
  `aarch64-darwin` — no extra config needed.

## Preferred: nix-based CI via the generic template

In a repo that does not yet have a flake:

```
nix flake init -t github:serokell/nix-templates#generic
```

This sets up a `flake.nix` with our standard CI checks. The CI pipeline
files it produces:

- GitHub Actions → `.github/workflows/check.yml`
- GitLab CI → `.gitlab-ci.yml`

Delete the one for the host you are not using.

For Haskell projects, prefer the haskell.nix templates:

```
nix flake init -t github:serokell/nix-templates#haskell-application
nix flake init -t github:serokell/nix-templates#haskell-library
```

The library variant supports building/testing across multiple stack
resolvers and GHC versions.

For nix on **shared runners** (when self-hosted runners aren't an
option):

- GitHub: use the [install-nix-action](https://github.com/marketplace/actions/install-nix)
  Marketplace action.
- GitLab: run the pipeline inside a `nixos/nix` Docker image.

If your repo already has its own `flake.nix`, adjust the existing one
rather than overwriting it. If the repo has a flake but no CI,
temporarily rename the existing flake, run the `nix flake init` command
above, then merge the two flakes into one (Nix expressions can be
merged).

The generic and Haskell templates above already wire up the checks in
the next two sections — when you used a template, don't re-add them by
hand. Those sections are for two cases: (1) assembling CI manually if
you can't use a template, and (2) checking that a template-provided
pipeline includes every check you want.

## Haskell-specific CI

For Haskell projects, in addition to the standard build/test jobs:

- Build Haddock to confirm it builds, even if not published.
- Run `hlint` against the package (uses `haskell/.hlint.yaml`).
- Optional: run `weeder` to detect dead code.
- If the repo has both `package.yaml` and `*.cabal` files, add a job
  that checks they are in sync (`.cabal` is generated from
  `package.yaml` via hpack and should be committed).
- For libraries: track new dependency releases. Either run `cabal
  outdated` periodically (works only with explicit upper bounds) or
  build against the latest Stackage Nightly resolver (catches actual
  breakage). For libraries we care about, also have CI jobs that
  build against the lower-bound snapshot (`min`) and the
  upper-bound snapshot (`max`) — these guard the bounds declared in
  `package.yaml` / `*.cabal`.
- Nix-less fallback CI: for generally-useful public libraries with
  external contributors, prefer a non-nix workflow (e.g. just
  `stack` and `cabal` on shared GitHub runners, with Windows + macOS
  + Linux coverage). Nix-based CI is faster for internal projects
  but raises the contribution bar for outsiders.

## Common checks (apply everywhere)

Regardless of language or build system, include these:

- `reuse lint` — REUSE/SPDX compliance.
- No trailing whitespace.
- `xrefcheck` — broken link detection.
- `shellcheck` — applied to any shell scripts in the repo.

Beyond that, the rest of your CI should build all code, run tests, and
optionally do something with the result (deploy, upload an artefact,
publish docs).

## Caching (nix)

Nix-based CI gets caching automatically. Builds are keyed by hash of the
full input, so identical builds across repos hit the cache. Changing the
compiler version (even slightly) invalidates the cache for affected
derivations.

## Branch protection (CI side)

After CI exists, configure the protected branches (usually `master`)
to require the CI status checks you just added:

- GitHub: enable "Require status checks to pass before merging" and
  select the relevant workflow jobs.
- GitLab: enable "Pipelines must succeed" in Settings → General →
  Merge requests.

Setting these usually requires `gh api` / `glab api` calls or web
UI access, plus admin rights on the repo. If you lack admin access,
tag `@serokell/operations` to apply these or grant you access; if you
can't tag that team in this repo, ping the team lead (see `PROJECT.md`).
For the full set of Serokell-default branch-protection,
merge-mode, and repo-level flags (signed commits required,
auto-merge, delete-head-branches, disable rebase merging, etc.),
see the `repository-settings` skill.

