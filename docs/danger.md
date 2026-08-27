<!--
   - SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
   -
   - SPDX-License-Identifier: CC0-1.0
   -->

# Danger checks

[serokell/danger](https://github.com/serokell/danger) is a GitHub/GitLab-agnostic
gem of [Danger](https://danger.systems/ruby/) checks: commit style, license
headers, MR/PR conventions, merge-commit hygiene, trailing whitespace. It's
optional. Not every bootstrapped repo needs it, and skipping it here is fine.

To add it, create a `Gemfile` and a `Dangerfile` at your repo root:

```ruby
# Gemfile
gem "serokell_danger", git: "https://github.com/serokell/danger"
```

```ruby
# Dangerfile
require "serokell_danger"

check_commits_style
check_premerge_commits
check_merge_request
check_merge_commits
check_license_headers
check_trailing_whitespace
```

Each check's severity can be lowered from its default (e.g.
`check_premerge_commits(premerge_commits_default_config.with(severity: :warn))`)
if you'd rather it post a comment than fail CI, without needing a
separate CI job for it. If an agent is setting this up, ask the user
for their severity preference on each check rather than guessing:
there's nothing in the repo to infer it from.

Wire it into CI as its own job, alongside whatever other CI jobs this
repo already has. It needs a full checkout (some checks walk the commit
history), and a token with permission to post PR/MR comments:

```yaml
# GitHub Actions
danger:
  runs-on: ubuntu-latest
  if: github.event_name == 'pull_request'
  permissions:
    contents: read
    issues: read
    pull-requests: write
  steps:
    - uses: actions/checkout@v7
      with:
        fetch-depth: 0
    - uses: ruby/setup-ruby@v1
      with:
        ruby-version: "3.4"
        bundler-cache: true
    - run: bundle exec danger
      env:
        DANGER_GITHUB_API_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

On GitLab CI, use `DANGER_GITLAB_API_TOKEN` instead, with a token that
has API access to the project. Don't use a personal token for this:
comments will post as whoever the token belongs to. Ask the team lead
or SRE for a dedicated bot account's token instead.

See [serokell/danger's README](https://github.com/serokell/danger#readme)
for per-check configuration, and its own
[`.github/workflows/ci.yml`](https://github.com/serokell/danger/blob/master/.github/workflows/ci.yml#L38-L56)
for a working example.
