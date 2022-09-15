# Raster-tiler Helm Chart

> Don't install this chart manually to prod cluster. Use Flux for that.

## Create and verify secrets in prod cluster
>For the time being secrets created manually in cluster

```bash
$ cat << EOT >> secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: dev-raster-tiler
  namespace: dev-raster-tiler
  labels:
    app.kubernetes.io/managed-by: manually
    app.kubernetes.io/name: raster-tiler
    app.kubernetes.io/instance: dev-raster-tiler
    stage: dev
data:
  username: c29tZXVzZXJuYW1l
***REMOVED***
EOT
> Secret values should be base64 encoded

$ kubectl apply -f secret.yaml 

$ kubectl -n dev-rasters get secret
NAME                  TYPE                                  DATA   AGE
default-token-jv2cd   kubernetes.io/service-account-token   3      41s
dev-raster-tiler          Opaque                                2      26s
```


## How to run chart locally in minikube

### Prerequisites
 - [helm](https://helm.sh/docs/intro/install/)
 - kubernetes-client (kubectl)
 - [minikube](https://minikube.sigs.k8s.io/docs/start/)

### Create namespace
```
kubectl create namespace local-rasters
```

### Create and verify secrets
```bash
$ cat << EOT >> secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: local-raster-tiler
  namespace: local-rasters
  labels:
    app.kubernetes.io/managed-by: manually
    app.kubernetes.io/name: raster-tiler
    app.kubernetes.io/instance: local-raster-tiler
    stage: dev
data:
  username: c29tZXVzZXJuYW1l
***REMOVED***
EOT
> Secret values should be base64 encoded

$ kubectl apply -f secret.yaml 

$ kubectl -n local-rasters get secret
NAME                  TYPE                                  DATA   AGE
default-token-jv2cd   kubernetes.io/service-account-token   3      41s
local-raster-tiler          Opaque                                2      26s
```

## Create and verify Helm release
Then you can run cluster
```
helm --kube-context minikube -n local-rasters upgrade --install local-raster-tiler ./helm/raster-tiler
```
