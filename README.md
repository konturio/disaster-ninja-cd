Kontur platform
======================

---
<a name="structure"></a>Repository structure
---
```flux``` folder contains configurations for Flux

```helm``` contains Helm Charts for kontur platform apps

---
<a name="deploy-specific"></a>How to deploy specific version
---
Set image tag in corresponding stage's ```values.yaml``` file under your app's Helm Chart.
Example:

To deploy user-profile-api v.0.1.2 to TEST, set in ```helm/user-profile-api/values/values-test.yaml```:
```
image:
  tag: 0.0.1-SNAPSHOT
```
Particular property name may depend on particular application.

Create MR to ```main``` branch and get it merged.

---
<a name="constant-tags"></a>Problem with constant image tags like "latest"
---
Container image version should be explicitly changed in new commit in order to trigger a redeploy. This means you can't normally use constant tags like "latest".
Either use some variable tags in your CI when building an image or use image digest instead of tags.
Example of variable tag containing a commit ref slug: ```disaster-ninja-be``` deployment:
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
**Note that in case of using image digest - it's specified with @ between image name and digest** - so if you use this approach, please change your helm chart accordingly. See ```disaster-ninja-fe``` for sample.


<a name="minikube"></a>How to run a platform app in local minikube, example for disaster-ninja-be
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

In order to connect to the application running within the cluster, you might need to setup port forwarding:
You can use [Lens](https://github.com/lensapp/lens) for that, 
or next command
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