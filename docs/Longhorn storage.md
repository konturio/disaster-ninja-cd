# Longhorn storage

**1. Longhorn Deployment**

Longhorn is deployed in core-apps using a Helm chart. The configurations and manifests can be found in the following repository: <https://github.com/konturio/k8s-harlem/tree/main/core-apps/base/longhorn>

The variables used for the deployment are located in the [release.yaml](https://github.com/konturio/k8s-harlem/blob/main/core-apps/base/longhorn/release.yaml "https://github.com/konturio/k8s-harlem/blob/main/core-apps/base/longhorn/release.yaml") file in the values section.

Current version: 1.6.2 <https://longhorn.io/docs/1.6.2/>
* 2. Storage Classes**

The system is configured with the following storage classes:
* **longhorn-single** (default StorageClass): single replica.

* l**onghorn-ha**: two replicas by default.
* 3. Deploying an Application Using Longhorn Storage**

To deploy an application using Longhorn storage, modify or create a PersistentVolumeClaim (PVC). Here is an example YAML configuration for the PVC:

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-pvc
  namespace: example-namespace
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: longhorn-single # or longhorn-ha if needed
```
* 4. Accessing the Longhorn UI**

To access the Longhorn UI, execute the following port-forward command:

```
kubectl port-forward -n longhorn-system svc/longhorn-frontend 3000:80
```

Then, in browser: [http://localhost:3000](http://localhost:3000 "http://localhost:3000")
