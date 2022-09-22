Kontur platform
======================

---
<a name="structure"></a>Repository structure
---
```flux``` folder contains configurations for Flux

```helm``` folder contains Helm Charts for Kontur platform apps

---
Impact of helm upgrade on different stages
---
***Changes to helm charts will be applied to all helm releases (stages) sharing a single helm chart once merged to main.*** This is the price for maintaining just a single branch for multiple stages.

There is still room for a workaround to use separate branches for different stages - this can be configured on per-HelmRelease basis - but it seems to be an overcomplication now, taking into account the following note.

Pods will not get rolled (restarted) until actual ```deployment/configmap``` changes in a particular stage occur during a helm upgrade. There is no need to to that otherwise. ```Secrets``` are managed manually in our setup and so are the related restarts. All other resources (```ingresses/servicemonitors```/etc) are customised per stage in our setup (using separate values files) - so there are small env-level changes in ```values.yaml``` that you can apply without any impact on other stages.

We usually do not make many significant changes to our templates for apps that have already reached k8s prod. If we need to make/test one - there is a property that stops Flux from reconciling a particular ```helm release``` - which you can use to protect stages when testing such changes: ```suspend: true```.

One should consider that this repository is the storage for the cluster state and should only contain resources that should exist in the cluster.

---
<a name="deploy-specific"></a>How to deploy a specific version
---
1. Set image tag in corresponding stage's ```values.yaml``` file under your app's Helm Chart.
Example:

To deploy ```user-profile-api``` v ```0.1.2``` to ```TEST```, set in ```helm/user-profile-api/values/values-test.yaml```:
```
image:
  tag: 0.1.2
```
Particular property names may depend on a particular application.

2. Bump the corresponding helm chart version.
For example:

To trigger ```user-profile-api``` deployment, bump the chart version in ```helm/user-profile-api/Chart.yaml```:
```diff
- version: 0.0.2
+ version: 0.0.3
```

3. Create MR to ```main``` branch and get it merged.

---
<a name="constant-tags"></a>Problem with stable image tags like "latest"
---
You must explicitly change the container image version in a new commit to trigger a redeploy. Therefore you cannot usually use stable tags like "latest".
Either use variable tags in your CI when building an image or use image digest instead of image tags.
Example of the variable image tag containing a commit ref slug: ```disaster-ninja-be``` deployment:
```
containers:
- name: disaster-ninja-be
  image: ghcr.io/konturio/disaster-ninja-be:main.5e163fb.1
```
Example of using image digest instead of tags ```disaster-ninja-fe``` deployment:
```
containers:
- name: disaster-ninja-fe
  image: ghcr.io/konturio/disaster-ninja-fe@sha256:40f6c7ffab4710d585035a2ce5c9b24307bf20f8cd85cab88e1a119345d93ef5
```
**Please note that in the case of using image digest - it's specified with @ between image name and digest** - so if you use this approach, please change your helm chart accordingly. See ```disaster-ninja-fe``` for the example.


<a name="minikube"></a>How to run a platform app in local minikube, the example for disaster-ninja-be
---

Requirements:
 - [helm](https://helm.sh/docs/intro/install/)
 - kubernetes-client (kubectl)
 - [minikube](https://minikube.sigs.k8s.io/docs/start/)

Create namespace
```
kubectl create namespace local-disaster-ninja
```
Remove strict requirements for CPUs / memory
from `./helm/disaster-ninja-be/templates/deployment.yaml`
```diff
- spec:
-   containers:
-   - name: disaster-ninja-be
-     image: {{ .Values.image.be.repository }}:{{ .Values.image.be.tag }}
-     imagePullPolicy: {{ .Values.image.pullPolicy }}
-     resources:
-       requests:
-         cpu: "10"
-         memory: "2G"
-       limits:
-         memory: "4G"
```

Create secrets (values are encoded with base64, use ```echo -n mypassword | base64```):
```
cat << EOT >> secret.yaml
apiVersion: v1
data:
***REMOVED***
  kontur.platform.keycloak.username: ZGlzYXN0ZXIubmluamE=
kind: Secret
metadata:
  labels:
    app.kubernetes.io/instance: local-disaster-ninja-be
    app.kubernetes.io/name: disaster-ninja-be
    stage: local
  name: local-disaster-ninja-be
  namespace: local-disaster-ninja
EOT

kubectl apply -f secret.yaml 
```

Then you can install helm release
```
helm --kube-context minikube -n local-disaster-ninja upgrade --install local-disaster-ninja-be ./helm/disaster-ninja-be
```

To connect to the application running within the cluster, you might need to setup port forwarding:
You can use [Lens](https://github.com/lensapp/lens) for that, 
or the next line:
```
kubectl -n local-disaster-ninja port-forward svc/local-disaster-ninja-be 8627:8627
```
After that back-end will be available by
```
http://localhost:8627/swagger-ui/index.html
```

Stop minikube
```
minikube stop
```

Uninstall helm release
```
helm uninstall local-disaster-ninja-be
```
