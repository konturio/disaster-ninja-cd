Platform Helm Charts
======================

This folder contains all platform apps helm charts
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