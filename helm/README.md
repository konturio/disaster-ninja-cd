Platform Helm Charts
======================

### This folder contains helm charts for all Platform apps

Helm Charts:
```
helm
├── disaster-ninja-be
│   ├── templates
│   │   ├─ configmap.yaml
│   │   ├─ .....
│   │   └─ servicemonitor.yaml
│   ├── values
│   │   ├─ values-dev.yaml
│   │   ├─ values-test.yaml
│   │   └─ values-prod.yaml
│   ├── Chart.yaml
│   └── values.yaml
│
├── insights-api
│   └── ...
│
├── layers-api
│   └── ...
```

# Quick Local Start

## Pre-requisites
1. A k8s cluster (**minikube** is enough) (```brew install minikube``` if you're on a Mac)
2. ```kubectl``` CLI configured with the k8s cluster
 
3. A local Postgres instance available with the following extensions available:
  - ```postgis``` (may be installed by homebrew if you're on a Mac)
  - ```h3``` (build and install as per https://github.com/zachasme/h3-pg):
      - ```git clone https://github.com/zachasme/h3-pg```
      - ```cd h3-pg```
      - ```cmake -B build -DCMAKE_BUILD_TYPE=Release``` Generate native build system
      - ```cmake --build build``` Build extension(s)
      - ```cmake --install build --component h3-pg``` Install extensions (might require sudo)
  - ```h3_postgis```
  - ```postgis_sfcgal```
  - ```btree_gin```
  - ```btree_gist```
  - ```plpgsql```
  - ```uuid-ossp```
  - ```http```
  - ```pgRouting``` (may be installed by homebrew if you're on a Mac)

These extensions might be installed either with ```brew``` (https://brew.sh if you're on a Mac) or with ```pgxn``` (https://github.com/pgxn/pgxnclient)

## Quick start
**- Step 1:** ```kubectl config use-context minikube``` setup ```kubectl``` to use minikube (or change to the desired context)

**- Step 2:** Create authorization for private Kontur nexus: #TODO remove this step once all required images are at ```ghcr.io```

```kubectl create secret docker-registry nexus8084 --docker-server='nexus.kontur.io:8084' --docker-username='YOUR-USERNAME' --docker-password='YOUR-PASSWORD' -o yaml --dry-run=server | grep -v namespace > nexus.yaml``` this creates a file ```nexus.yaml``` with your auth data - it will be used in next step

**- Step 3:** ```make install-quickstart```
What it does:
- **DROPs** if they exist and **CREATEs** databases/roles required by platform applications
- **DELETEs** and **CREATEs** namespaces required for platform applications
- installs Helm Releases for all apps using ```values-quickstart.yaml``` values files

**- Step 4:** ```kubectl get po -A``` wait until all pods are in Running and Ready state (may take some time - depending on your internet connection as all application images have to be downloaded). There might be failing pods in ```quickstart-osrm``` namespace, that's ok for a while. There is a series of three CrobJobs - once they all succeed at least once - the deployment will be restarted and will finally get up. The series reruns every 15 minutes (clock) so that's the maximal wait time due this CronJob.