---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: reuse-headers
description: Use when the user asks to add SPDX headers to a new source file, fix a `reuse lint` failure, copy third-party code, or annotate files in bulk. Triggers on phrases like "add SPDX header", "REUSE lint failing", "add license header to this file", "reuse annotate", "missing copyright header", "fix REUSE compliance", "SPDX-FileCopyrightText".
---

# REUSE / SPDX headers

This repo follows the REUSE Practices. `reuse lint` must pass on every
commit. The repo-wide license registration lives in
`.reuse/dep5`; per-file headers cover everything not blanket-covered there.

<!-- REUSE-IgnoreStart -->

## Add a header to every new source file

The two required lines, in a comment of the file's language:

```
SPDX-FileCopyrightText: <year> <copyright holder> <<URL>>
SPDX-License-Identifier: <SPDX-ID>
```

Place the header at the very top of the file, below the shebang if there
is one.

The license identifier should match the project's existing license —
check `LICENSE` (and the `LICENSES/` directory) before guessing. For
new projects, see the `license-choice` skill.

## Comment style by file type

Examples (copyright holder and license are illustrative; use whatever
the project uses):

Haskell:

```haskell
-- SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io/>
--
-- SPDX-License-Identifier: MPL-2.0
```

YAML, shell, Python, Makefile, Dockerfile:

```yaml
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io/>
#
# SPDX-License-Identifier: MPL-2.0
```

Markdown:

```markdown
<!--
   - SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io/>
   -
   - SPDX-License-Identifier: MPL-2.0
   -->
```

Markdown files that start with YAML frontmatter (e.g. Claude Code
`SKILL.md`): put the SPDX lines as YAML comments inside the frontmatter
block, since the frontmatter must be the first thing in the file.

```yaml
---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: ...
description: ...
---
```

<!-- REUSE-IgnoreEnd -->

## Bulk annotation

The REUSE tool can annotate many files at once:

```
reuse annotate --copyright 'Serokell <https://serokell.io/>' \
               --license 'MPL-2.0' \
               --style haskell \
               **/*.hs
```

`--style` should match the file's language (`haskell`, `python`, `c`,
`shell`, `xml-document`, etc.). Run `reuse annotate --help` for the
full list.

## Copying third-party code

If you copy a file from another project:

- Preserve its existing SPDX header. Do not overwrite the original
  copyright.
- If the license differs from this project, add the license text to
  `LICENSES/<SPDX-ID>.txt` (one file per identifier).
- If the file's header contains the *entire* license text inline, move
  that text to a separate file in `LICENSES/` and leave only the
  short SPDX-License-Identifier reference in the header.
- If you copy only a fragment, leave a comment stating where it came
  from, the copyright owner, and the applicable license. Prefer copying
  whole files into their own file rather than inlining fragments.
- The same rules apply to documentation files, not just code.

## Files that cannot carry a header

Binary files, generated files, or files whose format does not allow
comments: register them in `REUSE.toml` (in the repo root) via an
`[[annotations]]` entry with `path`, `SPDX-FileCopyrightText`, and
`SPDX-License-Identifier`. Do not invent comment syntax. (The older
`.reuse/dep5` format is deprecated — run `reuse convert-dep5` to
migrate an existing one.)

## Verifying compliance

Run `reuse lint`. The check baseline in this repo expects it to pass.

