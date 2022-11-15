Platform Helm Charts
======================

This folder contains helm charts for all Platform apps
---

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

# Quick Start

## Pre-requisites
You need a Postgres cluster available with the following extensions available:
- ```POSTGIS``` (may be installed by homebrew if you're on a Mac)
- ```H3``` (build and install as per https://github.com/zachasme/h3-pg):
    - ```git clone https://github.com/zachasme/h3-pg```
    - ```cd h3-pg```
    - ```cmake -B build -DCMAKE_BUILD_TYPE=Release``` Generate native build system
    - ```cmake --build build``` Build extension(s)
    - ```cmake --install build --component h3-pg``` Install extensions (might require sudo)
- ```H3_POSTGIS```
- ```BTREE_GIN```
- ```BTREE_GIST```
- ```PLPGSQL```

## Steps
Run ```install-quickstart``` goal in the ```./Makefile```

NOTE: it re-creates some databases and namespaces.

What it does:
- creates required databases in Postgres cluster accessed by ```localhost``` - please change to the desired hostname if needed
- installs Helm Releases for all apps using "values-local.yaml" values files **#TODO** change to values-quickstart