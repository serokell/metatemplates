---
# SPDX-FileCopyrightText: 2026 Serokell <https://serokell.io>
# SPDX-License-Identifier: CC0-1.0
name: code-review
description: Use when the user asks to review a pull request, leave review comments, decide between approve / request changes / comment, or resolve conversations on someone else's PR. Triggers on phrases like "review this PR", "leave a code review", "approve or request changes", "review someone's PR", "resolve this conversation", "PR review comments", "comment on the PR".
---

# Code review

Code review has two goals at Serokell: spreading knowledge (so the bus
factor stays high) and catching bugs before merge. Use this skill
whenever you act as reviewer on a PR or MR.

## When to review

- After opening your own PR, review at least two other open PRs in
  the repo. If fewer than two are open, review all of them. This
  keeps reviews evenly distributed.
- It is your responsibility to get your own changes merged — ping
  reviewers if they go silent.
- Start with PRs where your review was explicitly requested. Use
  `https://github.com/pulls/review-requested` on GitHub.
- Within that, review **old PRs first**. Don't cherry-pick by topic
  interest — older PRs accumulate review debt.

## How to review

- **Ask questions liberally.** If a piece of code isn't obvious to
  you, ask. It's the author's job to explain everything they did. It
  is your job to learn from the code and ensure the repo keeps only
  high-quality code.
- Check the commit history, not just the diff. Each commit should
  satisfy the policy in the `committing-work` skill (one problem,
  Problem/Solution body, signed, no within-PR fix-ups by merge time).
- If you are satisfied with the code changes but the commit history
  is messy, request changes (not approve) and say specifically that
  the code is fine but history needs cleanup — otherwise the author
  may merge with messy history.
- If your review wasn't requested and you don't think it should have
  been, remove yourself and request a review from a more appropriate
  person.
- If your review wasn't requested but you want a chance to review the
  PR before it is merged, request a review from yourself.

## Verdict choice

Three GitHub / GitLab verdicts: **approve**, **request changes**,
**comment**.

- Use **approve** when you're confident the PR is mergeable as-is
  (or trusting the author to fix tiny nits after).
- Use **request changes** when you want changes made before merge.
- Use **comment** only when you genuinely have neither approve nor
  request-changes confidence — for example, when raising a question
  you can't yet judge.

## Comment hygiene

- When the issue raised by **your** comment is addressed (e.g.
  requested change made, question answered), you (the reviewer) mark
  the conversation as resolved — not the author.
- You may also mark **another reviewer's** conversation as resolved,
  but only if you are 100% confident it has been resolved.
- Every time you look at the PR (e.g. after the author addresses
  feedback), check for stale comments of yours that are no longer
  relevant and resolve them.

## Last reviewer shortcut

If you are the last reviewer whose review was requested, all the
comments are minor and indisputable, and they can be addressed
quickly: it is acceptable to make the fixes yourself, push, and
approve in one step.

## Merging

After all reviewers approve and CI is green, the PR is mergeable.
Either the author or a reviewer merges (see the `pull-requests`
skill for merge mode). Generally let the author merge — they may
want to polish history first.

## See also

- `pull-requests` skill — opening / updating / merging PRs.
- `committing-work` skill — commit history expectations.
