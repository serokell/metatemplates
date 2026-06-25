---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: gitignore
description: Use when the user asks to add patterns to `.gitignore`, fix imprecise ignore patterns, decide between project / global / local-only ignores, or set up `.gitignore` for a new Haskell or multi-language repo. Triggers on phrases like "add to gitignore", "ignore these files", "fix gitignore", "what goes in gitignore", "global git ignore", "ignore build output", ".stack-work", "dist-newstyle", "editor files in gitignore".
---

# .gitignore

Every non-trivial project needs a `.gitignore`.

## What goes in a project `.gitignore`

- Files produced by **standard build tools** for the languages used in
  the project (e.g. `.stack-work/`, `dist-newstyle/`, `/build/`).
- Anything else that **every developer** working on this project would
  produce and should not commit.

If you would only ignore something because of your editor, your OS, or
a tool that not everyone uses — that does **not** belong here. See
"Global ignore" below.

## Pattern precision

Always make patterns as precise as possible.

- `/build/` — leading `/` anchors to repo root; trailing `/` matches
  only directories (and their contents).
- `build` — matches `build` anywhere in the tree, as file or directory.
  Usually too broad.

Example for a Haskell project at repo root:

```
# Build tools

## Stack
.stack-work/

## Cabal
dist-newstyle/
/.ghc.environment.*
/cabal.project.local
```

## Multi-component repos

If the repo has independent components in subdirectories (especially
with different technology stacks), put each component's
language-specific ignores in a `.gitignore` **inside that component**,
not in the root.

## Global ignore (not in this repo)

Editor files, OS files, and personal-tool files go in your **global
ignore**, not in the project `.gitignore`. The standard location is
`~/.config/git/ignore` (or `$XDG_CONFIG_HOME/git/ignore`). Create the
file if it doesn't exist.

Typical content:

```
# Tools
/tags
/result
/result-*

# macOS
.DS_Store
```

## Local-only ignores (not in this repo, not in global)

For project-and-user-specific scratch or temporary files you want git
to ignore without committing the rule and without globally affecting
all projects: use `.git/info/exclude` inside the repo. This file is
not synced.

