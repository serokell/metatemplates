---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: license-choice
description: Use when the user asks to pick a license for a new Serokell project, add a LICENSE file, set up a proprietary repository, or handle copyright on customer / derived work. Triggers on phrases like "pick a license", "what license should we use", "add LICENSE file", "set up a proprietary repo", "MPL or GPL", "LicenseRef-Proprietary", "customer owns the copyright".
---

# Choosing a license

This decision tree applies to **Serokell-owned** projects. If the project
is paid for by a client, the client has the ultimate say on licensing
terms (and usually owns the copyright).

## Default: MPL-2.0

Use `MPL-2.0` for most Serokell-owned libraries and projects. Any team
member can start a small library under this license without further
approval.

## When to choose otherwise

- **`GPL-3.0-or-later`** — when the project has good commercial
  potential. GPL-licensed code is hard to embed in proprietary
  commercial products, so this license encourages potential commercial
  users to come back to us. Consult your manager before applying this.

- **`AGPL-3.0-or-later`** — when the project's main value comes from
  being run as a service (e.g. it is a server). AGPL is one of the few
  licenses that prevents someone from forking, modifying, and selling
  the service without sharing changes back. Consult your manager.

- **Other licenses** — possible if there is a good reason. Check with
  your manager before applying anything not in the list above.

<!-- REUSE-IgnoreStart -->

## Proprietary (closed-source) projects

When the source is not intended to be freely used by anyone:

1. Create `LICENSES/LicenseRef-Proprietary.txt` with:

   ```
   © <year> <holder name>, all rights reserved.
   ```

2. Use `LicenseRef-Proprietary` as the `SPDX-License-Identifier` in
   per-file SPDX headers.

<!-- REUSE-IgnoreEnd -->

(This is a temporary workaround until SPDX supports a `NONE` tag.)

## Files in the repository

Whichever license you pick:

- Add the license text at `LICENSES/<SPDX-ID>.txt`. This repo's
  `LICENSES/` directory holds commonly-used Serokell licence texts;
  copy from there or download via `reuse download <SPDX-ID>`.
- Also copy the primary license as `LICENSE` at the repo root — GitHub
  and GitLab treat this file specially.
- Add per-file SPDX headers (see the `reuse-headers` skill).

## Copyright holder

- Customer-funded project: copyright belongs to the customer unless the
  contract says otherwise. Use their name in `SPDX-FileCopyrightText`.
- Internal Serokell project: copyright belongs to `Serokell
  <https://serokell.io/>`.

For customer projects, an authorised representative of the customer
should confirm the chosen license — typically by approving the PR that
adds the license file.

## Derived work from third-party code

If a customer asks us to take existing third-party-owned code and
produce a derived work:

- Any **generic helper / utility** functionality that can be cleanly
  separated should be put into its own repo with the customer as
  copyright holder (so it's not encumbered by the third-party's
  license).
- Code **closely related** to the original third-party code: copyright
  stays with the original owner; contact them to negotiate licensing
  terms.
- If the customer insists on doing something legally wrong (using
  third-party code under terms that don't allow it), refuse the work
  and communicate this clearly.

If a customer comes to us and tells us that *they* were hired by yet
another party to do the work: we don't engage with that further
upstream party. Per our standard contract, the immediate customer
becomes the copyright holder of whatever we produce, unless they
explicitly tell us otherwise.

## See also

- `reuse-headers` skill — per-file SPDX header conventions.
