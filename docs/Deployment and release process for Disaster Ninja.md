# Deployment and release process for Disaster Ninja

Field: Content

Deployment UPS and BE to all stages via GitHub interface: <https://drive.google.com/file/d/1mGvWpx9Qve5cDDFHz6jKuabMnHElpezB/view>

# Deployment to test/dev from feature branches

If you want to deploy your feature to the test/dev environment only, without a prod release: 

1. Create MR to the main branch
2. Run the build for your branch manually [[Tasks/document: How create disaster ninja frontend build#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/ebd034d0-ecd6-11ec-b061-f9bcf631f788]] 
3. Wait to build to be finished
4. Update [disaster-ninja-cd](https://github.com/konturio/disaster-ninja-cd) according instruction bellow

# How to release

## Step 1. Prepare for testing

1. Make sure the previous release is merged in main ([fe](https://github.com/konturio/disaster-ninja-fe/pulls "https://github.com/konturio/disaster-ninja-fe/pulls") / [be](https://github.com/konturio/disaster-ninja-be/pulls "https://github.com/konturio/disaster-ninja-be/pulls"))
2. Create a new release branch from the **main** branch:
   1. Front-end:
      1. `git checkout main`
      2. `gut pull`
      3. `npm i`
      4. `npm run release` and follow instructions
   2. Back-end:
      1. `git checkout main`
      2. `git pull`
      3. Create release branch. Release branch should have a name: `release-[VERSION]` (ex. release-0.9.0)
      4. Rename version in the `build.gradle` file (ex. `0.9.0` → `0.10.0`)
      5. `add . && git commit -m 'Release <your-version-here>'`
      6. `git push`
3. Create MR to main from release branch. If your build require some configuration changes - mention it in MR description\
   ⚠️ Do not merge it! ⚠️
4. Wait until build in CI finished
5. [Deploy build to **test stage**](https://kontur.fibery.io/Tasks/document/Deployment-and-release-process-for-Disaster-Ninja-1114/anchor=How-to-deploy-build-to-stage--4359082a-f0f2-4f7b-a3f8-3a014d1e6639 "https://kontur.fibery.io/Tasks/document/Deployment-and-release-process-for-Disaster-Ninja-1114/anchor=How-to-deploy-build-to-stage--4359082a-f0f2-4f7b-a3f8-3a014d1e6639")** (**🟡)
6. Write about deployment in slack channel `#01_test_tier_changes` 
7. Wait until assigned tester finishes testing

## Step 2. Deploy to production

1. [Deploy build to **prod stage**](https://kontur.fibery.io/Tasks/document/Deployment-and-release-process-for-Disaster-Ninja-1114/anchor=How-to-deploy-build-to-stage--4359082a-f0f2-4f7b-a3f8-3a014d1e6639)** (**🔴)
2. Write message to slack channel `#02_prod_tier_changes`
3. Merge release branch created in [STEP 1: Prepare for testing](https://kontur.fibery.io/Tasks/document/Deployment-and-release-process-for-Disaster-Ninja-1114/anchor=Step-1.-Prepare-for-testing--e2838c4d-059f-44ec-9d32-62952cecfecd) to **main**
4. Create release in GitHub
   1. Go to releases page
   2. Create release targeting release branch
   3. Select tag for release branch containing release version, ex. `v0.10.0`.
   4. Generate auto release choosing previous tag as tag for previous release (start typing previous release version)

      ![image.png](https://kontur.fibery.io/api/files/cfb114ab-1424-4149-93c9-6c9c3b01a970#width=1173&height=426 "")
   5. Publish release
5. Write release notes in [#release-notes](https://konturio.slack.com/archives/C03RR3WJLL8) slack channel
6. Done! 🫡 🎉

# How to deploy a build to a stage

1. Find build tag that you want to deploy: [BE builds](https://github.com/konturio/disaster-ninja-be/pkgs/container/disaster-ninja-be/versions "https://github.com/konturio/disaster-ninja-be/pkgs/container/disaster-ninja-be/versions") / [FE builds](https://github.com/konturio/disaster-ninja-fe/pkgs/container/disaster-ninja-fe/versions "https://github.com/konturio/disaster-ninja-fe/pkgs/container/disaster-ninja-fe/versions")

![image.png](https://kontur.fibery.io/api/files/20903592-286d-4247-84b8-496b26e28966#align=%3Aalignment%2Fblock-left&width=679&height=492 "")

(For releases this build created automatically, for other cases you can do it manually [[Tasks/document: How create disaster ninja frontend build#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/ebd034d0-ecd6-11ec-b061-f9bcf631f788]] )

3. Open [disaster-ninja-cd](https://github.com/konturio/disaster-ninja-cd) `main` branch
4. Create new branch - `<app-name>-<stage>-<version>` For example: `disaster-ninja-fe-test-0.0.0`
5. Select deployment config directory `/helm/<your_app>/values`\
   FE:  [/helm/disaster-ninja-fe/values](https://github.com/konturio/disaster-ninja-cd/tree/main/helm/disaster-ninja-fe)\
   BE: [/helm/disaster-ninja-be/values](https://github.com/konturio/disaster-ninja-cd/tree/main/helm/disaster-ninja-fe)
6. Select stage where you want to deploy `/helm/<your_app>/values/values-<stage>.yaml`:
   1. Front-end: 
      1. dev: [/disaster-ninja-fe/values/values-dev.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/helm/disaster-ninja-fe/values/values-dev.yaml)
      2. test 🟡: [/disaster-ninja-fe/values/values-test.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/helm/disaster-ninja-fe/values/values-test.yaml)
      3. prod 🔴: [/disaster-ninja-fe/values/values-prod.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/helm/disaster-ninja-fe/values/values-prod.yaml)
   2. Back-end: 
      1. dev:  [/disaster-ninja-be/values/values-dev.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/helm/disaster-ninja-be/values/values-dev.yaml)
      2. test 🟡: [/disaster-ninja-be/values/values-test.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/helm/disaster-ninja-be/values/values-test.yaml)
      3. prod 🔴: [/disaster-ninja-be/values/values-prod.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/helm/disaster-ninja-be/values/values-prod.yaml)
7. Add build tag from step 1\
   For example:

```
image:
  fe:
    repository: ghcr.io/konturio/disaster-ninja-fe
    algorithm: ""
    tag: # <---- put tag here 
```

 7. Update `Chart.yaml` version in same folder. This version should also be **incremented** to trigger release update (will refresh all stages according to tags)
    1. FE: [Chart.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/helm/disaster-ninja-fe/Chart.yaml)
    2. BE: [Chart.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/helm/disaster-ninja-be/Chart.yaml)
 8. Commit your changes, create MR to main, ask approval
 9. After branch merged - wait few minutes until it deployed
10. Done! 🫡 🎉

# Troubleshooting 

You can check what version deployed  on page <https://grafana02.kontur.io/d/2NMN6KGVk/k8s-pod-images-start-times?orgId=1>

> 👉 Note that you need to select correct `{stage}-disaster-ninja` in dropdown `namespace`
>
> ![image.png](https://kontur.fibery.io/api/files/144fa517-4140-41c9-a54b-9e9e4659fd29#align=%3Aalignment%2Fblock-center&width=696&height=100 "production case example")

Also changes available at `#flux` slack channel - <https://konturio.slack.com/archives/C03UYRBEQE5>

## See also

[[Tasks/document: Deployment and release process for Java applications and Layers DB ETL#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/82759010-550a-11ed-8d36-f3567567770c]]

[[Tasks/document: Development and release process#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/3101b7f0-952b-11ea-9a56-990e9abb4537]]

Suggestions

|     |     |
| --- | --- |
| **Rules** | **Comments** |
| Make brunches for user stories (feature branch) | Create a branch from the current state of branch `main` Branch name template `release-x.x.x` where x.x.x. semver Should we create a git tag with the latest release version? For this purpose make user stories much shorter  |
| Release each time when feature branch was merged to Main | In this case a feature branch may be a task or a user story/ part of user story In this case we should plan short user stories (or feature branches) closely together with developers (split them in meaningful chunks that can be developed within one feature branch) |
| ~~OR~~~~ Coordinate each time developer would like to merge feature branch to Main ????~~ | ~~In this case we need to have strict planes for each release, nevertheless we wan't avoid cases when one team will be waiting for another release ~~ |
| In Release Plan mark dependent FE-BE tasks | Reorganize Release Plan in a table  |
| If a feature branch was broken, revert it from main and continue to work on it in feature branch |  |
| All new features come with feature flags  | Feature flags switch on when the feature is ready to users  |
| API versioning |  |
| No renaming: add new endpoints (etc) and delete old one in some period later  |  |
| Test only release branch  |  |
| Make user stories much shorter  |  |
| Deploy only tested tags on PROD | Only those tags that successfully passed testing allowed to be deployed on PROD. |
