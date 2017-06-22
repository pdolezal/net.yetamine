# Yetamine branching #

A *published branch* must respect a common naming schema with following rules:

* Branch names are hierachical.
* Branch name components are separated with `/`.
* The first name component indicates the type of the branch.

The usual `master` branch should be avoided, except for simple repositories with strict linear history or when the `master` branch name is required for some reason.

A *private branch* does not have to obey any rules. The commonly used private branch names are `current` for the current working state and `playground` for experiments that shall be scratched later.


## Branch types ##

Some of the branch types are defined by the used workflow, e.g., `version/` or `fix/` defined by Yetamine workflow. The list below provides a few more branch types:

* `feature/`: introduces a new feature with the working name of the feature included in the branch name.

* `improve/`: provides improvements with preferably no external visibility, like code refactoring, reformatting or clean-up. Attempts to resolve an issue should be rather handled within a `resolve/` branch.

* `resolve/`: supplies an issue resolution. The name of the branch should refer to the ticket number. It is a good idea to start the branch with an empty commit with the commit message describing the problem to solve, the final commit before merging the branch elsewhere should then describe the solution or the state after the resolution.
