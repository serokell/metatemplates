[//]: # (This is a template of a pull request template.)
[//]: # (You should modify it considering specifics of a particular repository and put it there.)
[//]: # (Comments like this are meta-comments, they shouldn't be present in the final template.)
[//]: # (Comments starting with '<!---' are intended to stay in the final template.)

[//]: # (Keep in mind that it's only a template which contains items relevant to almost all conceivable repository.)
[//]: # (There can be other important items relevant to your repository that you can add here.)

## Description

<!--
Describes the nature of your changes. If they are substantial, you should
further subdivide this into a section describing the problem you are solving and
another describing your solution.
-->

[//]: # (Here you can add a link to the corresponding issue tracker, e. g. https://issues.serokell.io/issue/AD-)
[//]: # (For GitHub/GitLab issues it is better to use just hash symbol or exclamation mark as it is more resistant to repo movements)
[//]: # (In this case please also prefix the link with "Resolves" keyword)
[//]: # (See https://docs.gitlab.com/ee/user/project/issues/managing_issues.html#closing-issues-automatically)
[//]: # (See https://help.github.com/en/github/managing-your-work-on-github/closing-issues-using-keywords)
## Related issue(s)

<!--
- Short description of how the PR relates to the issue, including an issue link.
For example
- Fixed #100500 by adding lenses to exported items

Write 'None' if there are no related issues (which is discouraged).
-->

Fixed #

## :white_check_mark: Checklist for your Pull Request

<!--
Ideally a PR has all of the checkmarks set.

If something in this list is irrelevant to your PR, you should still set this
checkmark indicating that you are sure it is dealt with (be that by irrelevance).

If you don't set a checkmark (e. g. don't add a test for new functionality),
you must be able to justify that.
-->

#### Related changes (conditional)

- Tests
  - [ ] If I added new functionality, I added tests covering it.
  - [ ] If I fixed a bug, I added a regression test to prevent the bug from
        silently reappearing again.

[//]: # (Add more docs here if you have them in the repository)
- Documentation
  - [ ] I checked whether I should update the docs and did so if necessary:
    - [README](../tree/master/README.md)
    - Haddock

[//]: # (Mostly for public repositories)
[//]: # (Recording changes is optional, depends on repository, useful for some libs)
- Public contracts
  - [ ] Any modifications of public contracts comply with the [Evolution
  of Public Contracts](https://www.notion.so/serokell/Evolution-of-Public-Contracts-2a3bf7971abe4806a24f63c84e7076c5) policy.
  - [ ] I added an entry to the [changelog](../tree/master/CHANGES.md) if my changes are visible to the users
        and
  - [ ] provided a migration guide for breaking changes if possible

#### Stylistic guide (mandatory)

[//]: # (Update link to style guide if necesary or remove if it's not present)

- [ ] My commits comply with [the policy used in Serokell](https://www.notion.so/serokell/Where-and-how-to-commit-your-work-58f8973a4b3142c8abbd2e6fd5b3a08e).
- [ ] My code complies with the [style guide](../tree/master/docs/code-style.md).

## ✓ Release Checklist

[//]: # (Remove or add actions as appropriate)

- [ ] I updated the version number in `package.yaml`.
- [ ] If any definitions (functions, type classes, instances, etc) were added,
      I added [`@since` haddock annotations](https://haskell-haddock.readthedocs.io/en/latest/markup.html#since).
- [ ] (After merging) I created a new entry on the [releases](../releases) page,
      with a summary of all user-facing changes.
    *  I made sure a tag was created using the format `vX.Y.Z`
- [ ] (After merging) I uploaded the package to hackage.
