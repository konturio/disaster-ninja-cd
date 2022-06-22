How to deploy specific version
---
You must set  
`FE_IMG_TAG` for front-end deploy, and   
`BE_IMG_TAG` for back-end
In case you not set this variables - version from Chart.yaml will be used

How to run disaster-ninja-be locally
---

Requirements:
 - [helm](https://helm.sh/docs/intro/install/)
 - kubernetes-client (kubectl)
 - [minikube](https://minikube.sigs.k8s.io/docs/start/)

In case you don’t use Prometheus Operator in your cluster - which is probably the case for minikube, remove the servicemonitor.yaml file.
Also you don’t need ingress.yaml in local minikube environment.

```bash
rm ./helm/disaster-ninja-be/templates/ingress.yaml
rm ./helm/disaster-ninja-be/templates/servicemonitor.yaml
```
Then you must create namespace
```
kubectl create namespace local-disaster-ninja
```
Remove strict requirements for CPUs
from `./helm/disaster-ninja-be/templates/deployment.yaml`
```diff
- spec:
-   containers:
-   - name: disaster-ninja-be
-     image: {{ .Values.image.be.repository }}:{{ .Values.image.be.tag | default .Chart.AppVersion }}
-     imagePullPolicy: {{ .Values.image.pullPolicy }}
-     resources:
-       requests:
-         cpu: "10"
-         memory: "2G"
-       limits:
-         memory: "4G"
```

Create secrets:
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

Then you can run cluster
```
helm --kube-context minikube -n local-disaster-ninja upgrade --install local-disaster-ninja-be ./helm/disaster-ninja-be
```

Now you need to make back-end available outside of cluster.
You can use [Lens](https://github.com/lensapp/lens) for that, 
or next command
```
kubectl -n local-disaster-ninja port-forward svc/local-disaster-ninja-be 8627:8627
```
After that back-end will be available by
```
http://localhost:8627/swagger-ui/index.html
```

For stop
```
minikube stop
```

For remove
```
helm uninstall local-disaster-ninja-be
```