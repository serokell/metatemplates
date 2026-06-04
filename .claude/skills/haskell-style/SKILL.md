---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: haskell-style
description: Use when editing .hs source files, configuring a Haskell package, running hlint or stylish-haskell, or setting GHC warning flags. Covers Serokell's Haskell style conventions and the local hlint/stylish/package.yaml configs.
---

# Haskell style

The rules below are the most-applied subset of Serokell's Haskell
style guide. They are inlined so an agent can act on them without
fetching anything; the upstream guide is referenced only for human
provenance.

## Local configuration in this repo

This repo (and any repo created from it) provides Haskell defaults under
`haskell/`:

- `haskell/.hlint.yaml` — hlint settings. Disables a curated list of
  noisy/incorrect rules. Run `hlint` against the package; resolve all
  remaining warnings or justify them inline.
- `haskell/.stylish-haskell.yaml` — stylish-haskell settings. Formats
  imports (alignment, padding, qualified-post). Run `stylish-haskell`
  on every `.hs` file before committing.
- `haskell/.hindent.yaml` — hindent settings (legacy; many repos
  rely on stylish-haskell only).
- `haskell/package.yaml` — reference `package.yaml` with the default
  `default-extensions` list and the `-Weverything` + `-Wno-...` warning
  set. Use it as a starting point when creating a new package.
- `haskell/Makefile` (and `haskell/make/Makefile`) — standard `make`
  targets for Haskell packages (see "Tooling commands" below).

## Build configuration rules

- GHC options live in `package.yaml` (or `*.cabal`), **never** in
  `stack.yaml`.
- Enable `-Weverything` and explicitly disable the warnings you don't
  need (see `haskell/package.yaml` for the standard disable list).
- Enable `-Werror` **only** in CI builds, not dev builds. (haskell.nix:
  `packages.<name>.ghcOptions = ["-Werror"]`.)
- For test suites and any multithreaded executable, set
  `-threaded -with-rtsopts=-N`.
- For libraries, set lower and upper version bounds on dependencies;
  maintain a `min`-snapshot CI job that builds against the lower
  bounds.
- Do **not** enable flags that change the compiler's behaviour for
  purely subjective reasons (e.g. `-freverse-errors`). Such flags
  belong in a developer's local config, not in the project's build
  settings.

## Style rules (digest from `serokell/style`)

### Layout

- Line length: target ≤80 chars; ≤100 chars maximum (discouraged).
  Imports may wrap at 100.
- Indent with **2 spaces**. Tabs are forbidden.
- One blank line between top-level definitions.
- No blank lines between a type signature and its function definition.

### Module structure

- Every module has an explicit export list.
- Use **singular** module names (`Data.Map`, not `Data.Maps`).
  Exceptions: `Types`, `Instances`, etc.
- All top-level functions must have type signatures.

### Imports

- Use explicit import lists or `qualified` imports for anything outside
  the current project. Prefer explicit import lists; use `qualified`
  when the list would be too long or names collide.
- Use the `ImportQualifiedPost` extension (already in the default
  extensions in `haskell/package.yaml`). Form: `import Data.Map qualified as M`.
- For packages that still need to support GHC <8.10.1, put `qualified`
  imports in a separate group.
- **Group imports in this order**, separated by a single blank line:
  1. Custom prelude (if the project uses one — e.g. `Universum`).
  2. External packages (anything from Hackage / Stackage).
  3. Modules from the current project (same package or local repo).
  4. Modules from the current target (e.g. internal test helpers
     when the file is in a test suite).
  Inside each group, sort imports alphabetically.

### Data declarations

- **Records must not have multiple constructors** — their getters would
  be partial functions. Use a multi-constructor sum type *without*
  record syntax instead.
- For multi-constructor (sum) types: one constructor per line, align
  pipes.
- **Single-constructor data type name**: when a data type has only
  one constructor, the constructor should share the type's name.
  Example: `data Foo = Foo { ... }`, not `data Foo = MkFoo { ... }`.
- **Record field prefix from type name**: for a `data` record, prefix
  each field with an abbreviation of the type name. Example:
  `NetworkConfig { ncDelay :: Int, ncRetries :: Int }` (not
  `NetworkConfig { delay, retries }`). This avoids field-name
  collisions across types.
- **`newtype` field prefix**: the single field of a `newtype` should
  start with `un` or `run` followed by the type name. Example:
  `newtype Coin = Coin { unCoin :: Int }`,
  `newtype PureDHT a = PureDHT { runPureDHT :: State (Set NodeId) a }`.
- (Local hlint convention, not from the style guide:) a `data` with a
  single field can stay `data` (not `newtype`) if more fields are
  expected later — see the rationale comment in `haskell/.hlint.yaml`.

### Pragmas

- **File-level** `LANGUAGE` pragmas (and file-level `OPTIONS_GHC` that
  apply to the whole module) go at the top of the file, before the
  `module` keyword.
- **Per-function** pragmas (e.g. `{-# INLINE foo #-}`, `{-# SPECIALIZE foo #-}`)
  go next to the function they apply to.
- **Per-data-type** pragmas go before the type they apply to.
- Project-wide extensions belong in `package.yaml`'s
  `default-extensions`, not in per-file LANGUAGE pragmas.

### Naming

- Types and constructors: `UpperCamelCase`.
- Functions, variables: `lowerCamelCase`.
- Do **not** capitalize all letters in an abbreviation:
  `HttpServer`, not `HTTPServer`. Exception: two- or three-letter
  abbreviations such as `IO`, `STM`.

### Comments and Haddock

- Every exported function, type, and class **must** carry a Haddock
  comment explaining what it does.
- Haddock format: `-- | ...` for the leading comment on a definition,
  `-- ^ ...` for trailing arg/field annotations.
- Non-Haddock comments use `--`; separate from code with a single
  space (`-- like this`, not `--like this`).
- Comments belong above the line they describe, on their own line,
  not at the end of the line of code (except for short field/arg
  annotations).

## Tooling commands

- Lint: `hlint .` (uses `haskell/.hlint.yaml`).
- Format: `stylish-haskell -ir <files>` (uses `haskell/.stylish-haskell.yaml`).

The repo's `haskell/Makefile` (with `haskell/make/Makefile` as the
shared utility) provides the standard targets:

- `make` (or `make <packagename>`) — dev build of the package.
- `make test` — run tests (assumes `tasty` as primary runner).
- `make test-hide-successes` — tests with `--hide-successes`.
- `make haddock` / `make haddock-no-deps` — build Haddock.
- `make clean` — clean build artefacts.
- `make all` / `make test-all` — build / test every package in a
  multi-package repo.

Dev vs CI distinction is handled by Makefile-level flag sets in
`haskell/make/Makefile`. CI builds set `-Werror`; dev builds don't.

## Local files this skill refers to

`haskell/.hlint.yaml`, `haskell/.stylish-haskell.yaml`,
`haskell/.hindent.yaml`, `haskell/package.yaml`, `haskell/Makefile`,
`docs/code-style.md`.
