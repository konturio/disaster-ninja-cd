Flux configuration
======================

This folder is used by Flux to define which applications should be automatically deployed to the cluster.

```base``` folder contains list of HelmRelease manifests (without per-stage details)

```clusters``` folder contains kustomizations for each stage of each app, like
```
├── base                         -- this folder is used by references from "/clusters" folder below
│   ├── disaster-ninja
│   │   │── helmrelease-be.yaml  -- BackEnd Helm Release manifest  
│   │   └── helmrelease-be.yaml  -- FrontEnd Helm Release manifest
│   │  
│   │── insights-api
│   └── ...
│
└── clusters                    -- this folder is directly monitored by corresponding Flux
    ├── k8s-01
    │   │── disaster-ninja
    │   │   │──dev
    │   │   │  └──kustomization.yaml  -- overrides for DEV over (base/disaster-ninja)
    │   │   │  └──....
    │   │   │──test
    │   │   │  └──kustomization.yaml  -- for TEST
    │   │   └──prod
    │   │      └──kustomization.yaml  -- for PROD
    │   │
    │   │── insights-api
    │   │   │──dev
    │   │   │──test
    │   │   └──prod
    │   │
    │   └── kustomization.yaml  -- contains the list of subfolders that should be processed (disaster-ninja, insights-api)
    │
    ├── k8s-02 -- some day :)
    └── ...
```