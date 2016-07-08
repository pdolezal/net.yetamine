# Yetamine flow #

This guide explains the work flow used for Yetamine projects and the structure of the project repositories.


## Background ##

The goal of the flow is supporting semantic versioning which is great for ensuring version compatibility and stability. On the other hand, keeping stability intrinsically limits changes and this might become a problem, e.g., during incubation phases of new projects and version, when compatibility requirements are suspended and significant changes may occur. This flow tries to merge both ways.


## Repository structure ##

Some work flows use a single master branch as the development mainline; the master branch serves as an integration branch, which gathers all the changes, and as the source for releases, which are often managed as separate release branches or as tags on a common release branch that merges changes from the master branch. While such work flows have a few advantages (like simplicity), they can't cope well with non-linear development, e.g., when multiple versions are being developed in parallel.

The described structure and work flow elaborates the idea of a master branch as the central line of development, but uses multiple such branches in order to both enable and separate parallel development of multiple versions. Therefore every major version development happens on separate master branch with its own releases (by the way, this separation enables starting a new version from scratch). This freedom is possible at the cost of limiting the master branch to the particular major version; if a change on a branch requires the major version number increment, then a master branch for the new major version must be created.

To support the incubation phase of a new version (including the initial version), a master branch consists logically of two parts: the beginning of the branch runs in the incubation mode until the first official release on that branch when the incubation mode switches to the regular mode in order to keep compatibility and stability of the future releases on the branch.


### Root commit ###

The first commit in the repository, called the **root commit**, must be empty and it must be the least common ancestor of all branches in the repository. This allows easier splitting and merging of whole repositories, providing the common root for the merging and rebasing.


### Master branches ###

A **master branch** exists for each major version and serves as the source for actual releases of the particular version, which is the reason why building any commit of a master branch should succeed. A master branches for a major version has the name of `version/`*n*`.x` where *n* is the major version number of the particular version. Noticee that although all these branches are called master branches, no branch with the name `master` actually exists – instead all branches have more meaningful names that indicate their purpose and content and avoid name clashes.

A master branch forks from the previous version's master branch usually (the first version master branch starts at the root commit, of course). Having separate master branches allows developing multiple versions in parallel, e.g., earlier versions can be still maintained, while newer versions are under development. The basic structure of a repository looks like this example then:

```
version/1.x          R - C - C1 - C2 - C3 - C4 - C5 - C7 - C10 - C11 ------->
                                             \
version/2.x                                   C6 - C8 - C9 - C12 - C14 ----->
                                                               \
version/3.x                                                     C13 - C15 -->
```

The most recent version's master branch is usually the default branch. For better orientation, the initial commit of the master branch `version/`*n*`.x` (like *C1*, *C6* and *C13*) should be tagged as `fork/`*n*`.x`; for instance, *C1* shall be then tagged as `fork/1.x` or *C6* as `fork/2.x`.

The example depicts the root commit as *R*. It shows a configuration commit *C* as well; see the note about this commit in the recommendations.


### Release branches ###

A **release branch** exists for every official release. A release branch has the name `version/`*a.b.c*, where *a.b.c.* is the version number of the release, and it forks from the appropriate master branch `version/`*a*`.x`. Because the version number for a release defines a final version, unlike the version number of the master branch, release branches are sealed and should not be forked. Release branches are usually very short (just one commit) as they merely adjust last details for the release (e.g., they set the release version number in the build instructions). The final commit of these branches then should be tagged with a signed tag `release/`*a.b.c* that captures the actual release input and may provide notes on that.

Until the first release on a master branch, the master branch runs in the incubation mode as described above. The forking point of the first release branch, where the incubation mode ends, should be tagged with a tag `stable/`*n*`.x`, in order to indicate switching to the regular development mode. The forking point should fix the version settings accordingly.

A more detailed structure of a repository therefore looks like this example:

```
                     stable/2.x
                     |
version/2.x       -- C6 - C8 - C9 - C12 - C14 ----->
                      \               \
                       version/2.0.0   version/2.1.0
                       |               |
                       release/2.0.0   release/2.1.0
```



### Fix branches ###

The best way to release a bug fix is integrating it in the next regular release of the same major version. Usually, with a good interface/implementation design and split, there is a good chance that the more recent release containing the fix can substitute the older release. However, this ideal situation does not happen always and sometimes it is required to release a fix just for the particular release. Naturally, the fix must fork from the source for that release.

Assuming the feasible and non-problematic case (see the traps described below), the solution is forking a **fix branch** at a suitable point where the fix shall be applied, usually on the master branch at the commit where the release branch to be fixed forks, or it can possibly continue from a previous fix branch. The actual fix release employs a release branch as usual and the release branch just forks from the fix branch instead of the master branch. Here is an example:

```
                         release/2.1.1  release/2.1.2
                         |              |
                         version/2.1.1  version/2.1.2
                        /              /
                       fix/2.1.1 ---- fix/2.1.2
                      /
version/2.x       -- C6 - C8 - C9 - C12 - C14 ----->
                      \               \
                       version/2.0.0   version/2.1.0
                       |               |
                       release/2.0.0   release/2.1.0
```

This graph shows a fix (`fix/2.1.1`) forking from the master branch and then some fix of the fix (`fix/2.1.2`). Both fix branches are terminated with a release branch (and properly tagged). Keeping the release branch conventions even for fix branches allows to list all releases easily as every release has always its own tag.


## Versioning traps ##

Forking a version brings usually some problems, at least if the artifact aggregates multiple versioned items, and it does not matter if creating a new master branch or just a fix branch. A fix branch, which should change implementation details only (i.e., some private code) and therefore influence just the micro version number, can still bring problems.

For instance, let's have an OSGi bundle in version 1.5.2 with packages *foo* in version 1.2.0 and *bar* in version 1.3.0 which is about to change the major version; this forces the artifact to fork a new version 2.0.0 that contains the *foo* package, without any change, and *bar* with the new major version 2.0.0. However, any further development of the *foo* package becomes troublesome, because changes of the package on both branches must be synchronized in order to maintain consistent versioning.

There are some acceptable solutions (although not without pain):

* Separating the common packages in another artifact. When taking this choice, the common packages probably provide a well-defined functionality that can exist on its own. Making a new project for further development of them usually is a good idea anyway, which solves the synchronization problem.

* Having the same version for all packages. Forking a branch results in forking the packages as well, keeping them independent and synchronized with the branch. This choice makes sense when the packages form a consistent group, which shall be used together, and when more of those packages are affected by major changes; then even if a package from the group is not changed, changing its version number might be an acceptable price for re-releasing the actually same code under a new version number.

* Having a package master branch. The stable packages are maintained on the current branch and their changes are merged in the other branches. This choice is difficult to manage, but possibly still acceptable when there are few such packages and they are stable. Using tools for managing the changes and versions is recommended then, e.g., the slave branches might have restrictions on the package changes that force using the merges, instead of any development of the package on the slave branch.

* Limiting existing branches on fork. Forking a new version limits strictly existing branches to prevent conflicts; existing branches still may continue in the maintenance mode, but can't advance beyond the limits. As a result, the version tree may become (almost) linear. To restore the parallelism, the incubation phase of the new version should be long enough to accumulate more changes and hopefully more packages switch their major version meanwhile too.


## How to… ##

This section gathers the recommendations and procedures for the most usual tasks.


### Create a new repository ###

1. Make a new empty repository.
2. Make the **root commit**: `git commit --allow-empty -m "Make the root commit"`
3. Make the root commit tag: `git tag root`
4. Make the **configuration commit**: `git commit -m "Configure the workspace"`

The configuration commit provides the configuration for the workspace, which is usually common for all master branches. Such a configuration commit contains, e.g., `.gitignore` and `.gitattributes`. This commit is usually the commit where from-scratch master branches (and the first version master branch) fork from.


### Create a from-scratch master branch ###

A from-scratch master branch forks from the configuration commit. The first master branch, i.e., the branch `version/1.x`, is the prominent example of a from-scratch master branch.

1. Commit the skeleton of the project structure: `git commit -m "Fork version `*n*`.x"`
2. Tag the fork of the branch: `git tag fork/`*n*`.x`

The skeleton of the project structure should contain:

* The `README.md` which explains the goals and fundamental ideas of the project or the branch.
* An empty project structure which defines the package space for the code and the form of the project.
* The build scripts to build the (yet empty) project.
* Versioning information set to the snapshot of the version.
* Ensuring limits of the artifacts and packages not to reach the next (major) version.

Using the snapshot version is natural as the branch runs in the incubation mode initially. When switching to the regular development mode, the version information changes (surprisingly) to the snapshot of the next (major) version, which is set as the limit for the branch.


### Make a preview ###

Making a preview means publishing a snapshot build and marking the source of the build with a signed snapshot tag: `git tag -s snapshot/`*a.b.c*`/`*date*, where *a.b.c* stands for the base version and the date of the source commit is in the format of *YYYYMMDD*, e.g., `snapshot/1.0.0/20151231` (a snapshot of version 1.0.0 from the New Year's Eve of 2015). Usually, previews are created in incubation phase only.


### Make the first release on a master branch ###

As long as no release is forked from a master branch, the branch is in the incubation mode and may change freely. The first release has some additional steps when comparing to next releases:

1. Set the version baseline and constraints for the artifacts and packages if not done yet.
2. Set the version information to the snapshot of the next (major) version.
3. Check that the build can pass.
4. Commit the changes: `git commit -m "Update to version `*a.b.c*`"`
5. Mark that the incubation mode is over: `git tag stable/`*n*`.x`
6. Fork the release branch: `git checkout -b version/`*a.b.c*
7. Update the version information for the final artifact.
8. Perform clean full build of the artifacts.
9. Stage the artifacts for releasing.
10. If release is approved, commit the version: `git commit -m "Release version "`*a.b.c*
11. Make the release tag: `git tag -sm "Release version "`*a.b.c*` release/`*a.b.c*
12. Publish the code (i.e., push the changes) and the artifacts.

In the case of problems after the commit on the master branch, reverting this commit, fixing the problem and repeating the procedure is the preferred way. However, it assumes that commits on the master branch are suspended until the release does succeed. If committing on the master branch can't be suspended, then an integration branch can be used instead for commits and the master branch merges the changes from the integration branch in a safe way.


### Make next releases on a master branch ###

1. Set the version baseline for the artifacts and packages if not done yet.
2. Check that the build can pass.
3. Commit the changes: `git commit -m "Update to version `*a.b.c*`"`
4. Fork the release branch: `git checkout -b version/`*a.b.c*
5. Update the version information for the final artifact.
6. Perform clean full build of the artifacts.
7. Stage the artifacts for releasing.
8. If release is approved, commit the version: `git commit -m "Release version "`*a.b.c*
9. Make the release tag: `git tag -sm "Release version "`*a.b.c*
10. Publish the code (i.e., push the changes) and the artifacts.


### Create a forked master branch ###

A forked master branch forks from another master branch, i.e., it is a natural successor of the source branch. The fork can happen as the result of an intended changed that forces incrementing the major version. Such a commit may not occur on the current master branch, instead a new master branch is created and the changes are committed to it.

1. Create the new master branch at the suitable point (usually at the `HEAD` of the current master branch): `git checkout -b version/`*n*`.x`
2. Set the version information (baseline, constraints and snapshot).
3. Add any other important changes. The build should pass and produce a good starting point for the new version.
4. Commit the new master branch first commit: `git commit -m "Fork version `*n*`.x`
5. Tag the new master branch start: `git tag fork/`*n*`.x`
6. Continue development on the new master branch (e.g., commit the postponed changes).
7. Commit constraints for the original master branch: `git commit -m "Update version information"`
8. Commit constraints for other master branches that might be applicable as in the previous point.

The *Update version information* commits should occur as soon as possible after making the new master branch. They actually confirm the new version, making the branch valid.


### Create a fix branch ###

A fix branch should be as short as possible and follows basically the procedure for a regular master branch. Usually, a fix branch consists of three parts/commits:

1. Fork commit that sets the branch version information and other important metadata. This should be tagged as usual.
2. Actual fix (which allows to cherry-pick it).
3. Branch version information update for forking the release branch.


### Make a regular commit ###

1. Check if version numbers for all affected packages and for the bundle require no changes of the version information.
2. Adjust version information if necessary (or mark the need of updating them for release).
3. Try to build the project; especially with a version check tool an error should occur on any version violation.
4. If the changes violate any version constraints, fall back to forking a new version (i.e., do not continue here).
5. Commit the changes with a proper message. If version information changed, include an explanation for the change.

It is recommended to commit just in fast-forward manner. Merging another branch into the master should be justified, e.g., the branch is a shared feature branch or a package master branch that supplies the changes to multiple branches at once.
