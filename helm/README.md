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
You need a Postgres cluster available

## Steps
Run ```install-local``` goal in the ```./Makefile```
What it does:
- creates required databases in Postgres cluster accessed by ```localhost``` - please change to the desired hostname if needed
- installs Helm Releases for all apps using "values-local.yaml" values files **#TODO** change to values-quickstart