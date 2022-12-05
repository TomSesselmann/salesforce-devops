# Salesforce DevOps Examples

## [Dockerfile](/Dockerfile)

The dockerfile essentially just installs the [Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli) and then installs the [SFDX-Git-Delta Plugin](https://github.com/scolladon/sfdx-git-delta)

## Project 1 (Azure Devops Pipelines)

### [Validation](/project-1/validation.yml)

The validation pipeline is set up to run when a Pull Request is created. It uses the docker container created by the above dockerfile. It then runs the following commands:

  * `sfdx auth:sfdxurl:store` - This logs into the org using the secret variable stored in Azure Devops.
  * `sfdx sgd:source:delta` - This generates a delta package of the changes in the pull request.
  * `sfdx force:source:deploy` - This validates the delta package against the org.

### [Deployment](/project-1/deployment.yml)

Same as Validation, but it deploys the delta package to the org.

### [Create Release Branch](/project-1/create-release-branch.yml)

This is a script that helps deploy stories to further testing environments. It essentially does this by creating a new release branch and cherry-picking commits that are related to those stories which don't exist yet in the release branch. The process is more or less as follows:

  * You pass in a comma seperated list of stories and the name of the target org you want to deploy to.
  * `git fetch && git pull` to fetch all the commits from the develop branch and the target branch.
  * `git log --grep` to find all the commits that are related to the stories you passed in.
  * `git cherry` to find the commits that exist in develop but don't yet exist in the target branch.
  * `grep` to find the intersection of the two sets of commits.
  * `git checkout -b` to create the release branch.
  * `git cherry-pick` to cherry-pick the commits.
  * `git push --force` to push the release branch to the remote and overwrite any existing release branches.

## Project 2 (GitHub Actions)

Validation and Deployment are more or less the same as Project 1.

### [Create Feature Branch](/project-2/create-feature-branch.yml)

This is a script that pulls metadata from an org and creates a feature branch. It is particularly useful for functional consultants, who may not be familiar with git commands. The process is more or less as follows:

  * You first create an Outbound Change Set in the development sandbox with the components that you want to push into the feature branch.
  * Don't upload the Change Set to the target org. We want to use the CI/CD pipeline to do that.
  * Instead run this action and pass in the name of the change set. Then we run,
  * `sfdx auth:sfdxurl:store` - to log into the development sandbox using the secret variable stored in GitHub.
  * `sfdx force:source:retrieve -n` – to retrieve the metadata from the change set.
  * `cp -r` – to move the metadata into the correct folder.
  * Then we run the [EndBug/add-and-commit](https://github.com/EndBug/add-and-commit) action to add and commit the changes to a new feature branch.