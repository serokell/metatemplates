---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: nix-binary-cache
description: Use when the user reports nix commands are slow, asks how to set up the Serokell binary cache, or when about to run nix builds locally for the first time. Triggers on phrases like "nix is slow", "nix taking forever", "set up binary cache", "nix substituter", "S3 cache", "nix cache".
---

# Nix binary cache

Serokell runs a private S3-backed Nix binary cache. With it configured,
Nix fetches pre-built derivations instead of rebuilding from source.
Without it, a full build can take anywhere from tens of minutes to
several hours — building GHC from scratch, for example, can easily
exceed two hours — and consume significant disk space.

CI runners always have the cache configured. Local machines do not get
it automatically; it must be set up once per machine.

**When this skill is loaded, immediately run the check below** and
report the result before doing anything else.

## Check whether the cache is configured

```
nix config show | grep substituters
```

If the output contains `serokell-private-nix-cache`, the cache is
configured. If not, follow the setup steps below.

## Setting up the cache

Steps 1 and 2 must be performed by the user — do not ask for or handle
the credentials yourself. Secrets must never appear in the agent
context; if they do, they must be rotated immediately. Ask the user to
complete both steps and confirm before continuing.

### Step 1 — Request credentials (user)

Ask OPS in `#sre-general` for read-only AWS credentials for the Nix
cache. They will send an `[serokell-private-nix-cache]` block with
`aws_access_key_id` and `aws_secret_access_key`.

### Step 2 — Store the credentials (user)

Place the credentials block in `~/.aws/credentials` (single-user Nix)
or in both `~/.aws/credentials` and `/root/.aws/credentials`
(multi-user Nix / NixOS). Set permissions:

```
chmod 700 ~/.aws
chmod 600 ~/.aws/credentials
```

Repeat for `/root/.aws` if applicable.

Once the user confirms steps 1 and 2 are done, proceed with step 3.

### Step 3 — Configure the substituters

**NixOS** — add to `/etc/nixos/configuration.nix`:

```nix
nix.settings.substituters = [
  "https://cache.nixos.org"
  "s3://serokell-private-nix-cache?endpoint=s3.us-west-000.backblazeb2.com&profile=serokell-private-nix-cache"
];

nix.settings.trusted-public-keys = [
  "serokell-1:aIojg2Vxgv7MkzPJoftOO/I8HKX622sT+c0fjnZBLj0="
];
```

Then run `sudo nixos-rebuild switch`.

**Non-NixOS** — add to `~/.config/nix/nix.conf` (single-user) or
`/etc/nix/nix.conf` (multi-user):

```
substituters = https://cache.nixos.org s3://serokell-private-nix-cache?endpoint=s3.us-west-000.backblazeb2.com&profile=serokell-private-nix-cache s3://serokell-private-cache?endpoint=s3.eu-central-1.wasabisys.com&profile=serokell-private-cache
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= serokell-1:aIojg2Vxgv7MkzPJoftOO/I8HKX622sT+c0fjnZBLj0=
```

Multi-user: restart the daemon afterwards:

```
systemctl restart nix-daemon
```

### Step 4 — Verify (agent)

```
nix build /nix/store/7050aihmcmqfb9yljaslx9nb5dq6bd1h-hello-serokell
cat result
```

A fast fetch (rather than a build) confirms the cache is working.

## If setup is not desired right now

Do not run `nix build` or `nix flake check` locally without the cache.
Verify CI instead by pushing to a branch and reading the run logs.
The `setup-ci` skill describes this workflow.
