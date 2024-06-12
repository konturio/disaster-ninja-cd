kustomization.yaml validation
=============================

To validate changes before committing you can use commands below

#### To replicate the build:
```bash
kustomize build --load-restrictor=LoadRestrictionsNone --reorder=legacy flux/clusters/k8s-01/user-profile-api-db/overlays/DEV/ | less
```

#### To replicate the build and apply dry run locally:
```bash
kustomize build --load-restrictor=LoadRestrictionsNone --reorder=legacy flux/clusters/k8s-01/user-profile-api-db/overlays/DEV/ | kubectl apply --server-side --dry-run=server -f-
```
