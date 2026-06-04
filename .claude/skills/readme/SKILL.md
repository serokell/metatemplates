---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: readme
description: Use when creating or editing a README.md file. Covers Standard Readme spec compliance, Serokell-specific additions (promo blurb for public repos), and the multi-component README rule.
---

# README.md

Every Serokell repository must have a README.

## Standard Readme

The README must comply with the Standard Readme spec.

Standard Readme distinguishes **required** sections (must be present)
from **optional** sections (include only when applicable).

Required (in spec order):

- **Title** — single `# Name` heading.
- **Short description** — a single line, **<120 characters**,
  immediately after the title. Should match the package-manager
  `description` field and the GitHub repo description.
- **Install** — how to install / build.
- **Usage** — how to use it; CLI examples; the most common operations.
- **Contributing** — link to `CONTRIBUTING.md` if it exists, or
  inline guidance.
- **License** — SPDX identifier and link to `LICENSE`.

Optional (include when applicable, in spec order between
short-description and license):

- **Banner** — logo / illustration.
- **Badges** — license, CI status, package-registry presence.
  (Start with just a license badge if there is nothing else yet.)
- **Long description** — what the project does and why, in more
  detail.
- **Table of contents** — required if the README is over ~100 raw
  lines (count `.md` file lines, not rendered output).
- **Security** — when applicable.
- **Background** — when context is needed.
- **API** / **CLI** — when the project exposes one.
- **Maintainers** — list of people responsible.
- **Thanks** — acknowledgements.

## Public-repo additions

If the repository is **public**, include the standard Serokell
promotional blurb at the end. The template README in this repo (look
for the "About Serokell" section) is the reference for that text.

## Multi-component repos

If the repo contains multiple independent components (e.g. several
packages / libraries in subdirectories), each component's directory
**must** also contain its own Standard-Readme-compliant README.
Treat "independent component" as a semi-formal criterion — use your
judgement.

## Forks

If the repository is a fork, explain *why* the fork exists at the very
top of the README (in the `master` branch). Without this, nobody will
know whether the fork is still needed two months later.

## Pitfall: do not mirror the metatemplates README shape

The README in the `serokell/metatemplates` repository itself is **not**
Standard-Readme-compliant — it is a placeholder template. Do not copy
its shape into your real README. Rewrite from scratch to match the spec.

When customising the README for a new repo created from this template,
strip every `[//]: # (...)` meta-comment. Verify with:

```
git grep '\[\/\/\]:'
```

The above should return nothing in a finished README.

