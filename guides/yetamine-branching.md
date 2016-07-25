# Yetamine branching #

A *public branch* must respect common naming schema and must not depend on any branch that is not public (rebasing is required to keep the public branch graph concise and understandable). Public repositories should expose only public branches.

A *shared branch* must use `shared/` prefix (see below about branch naming) and it should respect the rules for public branches. The purpose of shared branches is sharing the work in progress within a team or a group without exposing the details outside.

A *private branch* does not have to obey any rules, besides avoiding conflicts with public and shared branches. No private branch may be published (unlike public or shared branches). Commonly used private branch names are `current` for the current working state or `playground` for experiments that shall be scratched later.

Using the `master` branch should be avoided, except for simple repositories with usually linear history.


## Branch naming ##

Published branches for Yetamine projects (i.e., public and shared branches) should use slashes for splitting their name parts that form some hierarchy. Long or structure name parts should use dashes as word separators.

A branch name should fit into one of these categories, using an appropriate prefix:

* `feature/`: introduces a new feature with the working name of the feature included in the branch name.

* `improve/`: provides improvements with preferably no external visibility, like code refactoring, reformatting or clean-up. Attempts to resolve an issue should be rather handled within a `resolve/` branch.

* `resolve/`: supplies an issue resolution. The name of the branch should refer to the ticket number. It is a good idea to start the branch with an empty commit with the commit message describing the problem to solve, the final commit before merging the branch elsewhere should then describe the solution or the state after the resolution.

Besides those, `shared/` prefix has been mentioned above for distinguishing shared branches, `version/` and `fix/` are defined by Yetamine flow for the version tree maintenance.

Another branch prefix may be introduced on demand.
