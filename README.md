
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
kubectl create namespace dev-disaster-ninja-be
```
Remove strict requirements for CPUs
from `./helm/disaster-ninja-be/templates/deployment.yaml`
```diff
- spec:
-   containers:
-   - name: disaster-ninja-be
-     image: {{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}
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
    app.kubernetes.io/instance: dev-disaster-ninja-be
    app.kubernetes.io/name: disaster-ninja-be
    stage: dev
  name: dev-disaster-ninja-be
  namespace: dev-disaster-ninja-be
EOT

kubectl apply -f secret.yaml 
```

Then you can run cluster
```
helm --kube-context minikube -n dev-disaster-ninja-be upgrade --install dev-disaster-ninja-be ./helm/disaster-ninja-be/ -f ./helm/disaster-ninja-be/values/values-dev.yaml
```

Now you need to make back-end available outside of cluster.
You can use [Lens](https://github.com/lensapp/lens) for that, 
or next command
```
kubectl -n dev-disaster-ninja-be port-forward svc/dev-disaster-ninja-be 8627:8627
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
helm uninstall dev-disaster-ninja-be
```