Platform Helm Charts
======================

### This folder contains helm charts for all Platform apps

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

# Quick Local Start

## Pre-requisites
0. Docker, ```brew``` (if you're on a Mac)
1. A k8s cluster with 6gb RAM. ```minikube``` is ok (```brew install minikube``` on a Mac)
2. Helm to manage Helm Charts - ```brew install helm```
3. If you use minikube:
- ```minikube config set driver docker``` - use Docker network driver
- ```minikube config set memory 6gb; minikube config set cpus 4``` - let it use some resources
- ```minikube delete; minikube start``` to apply the above
- https://github.com/chipmk/docker-mac-net-connect tool is required, otherwise Ingress resources will not be available from the host machine. (There is a limitation in Docker driver - which has to be workarounded - see https://minikube.sigs.k8s.io/docs/drivers/docker/ : "The ingress, and ingress-dns addons are currently only supported on Linux. See #7332"). Install it by:
  - ```brew install chipmk/tap/docker-mac-net-connect```
  - ```brew services start chipmk/tap/docker-mac-net-connect```
- addons supporting ingress resources should be enabled (see in details for other OSs: https://minikube.sigs.k8s.io/docs/handbook/addons/ingress-dns/) - example for Mac OS:
- ```minikube addons enable ingress```
- ```minikube addons enable ingress-dns```
- Get ```kubectl``` CLI configured with the k8s cluster: ```kubectl config use-context minikube```
- ```minikube ip``` and remember the ip address it returns
- Create a file ```/etc/resolver/kontur``` with the following contents replacing ```MINIKUBE_IP``` with the ip address from the previous step:
```
domain kontur
nameserver MINIKUBE_IP
search_order 1
timeout 5
```
- reload DNS services on Mac: ```sudo killall -HUP mDNSResponder```
- check that additional DNS was added by running ```scutil --dns``` (you should see your additional DNS resolver in the output)
- configure minikube DNS to use this additional resolver too: ```kubectl edit configmap coredns -n kube-system``` and add the following block to the end of ```Corefile``` section - also replacing MINIKUBE_IP with the value from previous steps:
```
    kontur:53 {
            errors
            cache 30
            forward . MINIKUBE_IP
    }
```
4. a. A local Postgres instance (```brew install postgresql``` on a Mac) with the following extensions available. If other is not specified, they can be installed with ```pgxn``` (first ```brew install pgxn``` to install the tool itself, then use ```pgxn install http``` to install an extension):
  - ```postgis``` (install with ```brew```)
  - ```postgis_sfcgal``` (installed as part of ```postgis```)
  - ```pgRouting``` (install with ```brew```)
  - ```h3``` (```cmake``` is also required for it, install with ```brew``` if it's missing)
  - ```h3_postgis```
  - ```http```

4. b. The following extensions are also required but are either available in postgres by default or are installed as part of some extensions above:
  - ```btree_gin```
  - ```btree_gist```
  - ```plpgsql```
  - ```uuid-ossp```

5. Postgres cluster should have prepared transactions enabled. Set in ```postgresql.conf``` (typically ```/usr/local/var/postgres/postgresql.conf``` if local postgres was installed by brew):

```max_prepared_transactions = 100```

## Quick start
**- Step 1:** ```kubectl config use-context minikube``` setup ```kubectl``` to use minikube (or change to the desired context)

**- Step 2:** Create authorization for private Kontur nexus: #TODO remove this step once all required images are at ```ghcr.io```. Checkout this repository and run in ```helm``` dir:
```kubectl create secret docker-registry nexus8084 --docker-server='nexus.kontur.io:8084' --docker-username='YOUR-USERNAME' --docker-password='YOUR-PASSWORD' -o yaml --dry-run=server | grep -vE 'namespace|uid' > nexus.yaml``` this creates a file ```nexus.yaml``` with your auth data - it will be used in next step

**- Step 3:** ```make install-quickstart```
What it does:
- **DROPs** if they exist and **CREATEs** databases/roles required by platform applications
- **DELETEs** and **CREATEs** namespaces required for platform applications
- installs Helm Releases for all apps using ```values-quickstart.yaml``` values files

**- Step 4:** ```kubectl get po -A``` wait until all pods are in Running and Ready state (may take some time - depending on your internet connection as all application images have to be downloaded). There might be failing pods in ```quickstart-osrm``` namespace, that's ok for a while. There is a series of three CrobJobs - once they all succeed at least once - the deployment will be restarted and will finally get up. The series reruns every 15 minutes (clock) so that's the maximal wait time due this CronJob. For me overall it takes about 30 minutes for the entire platform to start up.

**- Step 5:** ```nslookup disaster-ninja.kontur $(minikube ip)``` to check DNS configuration, it should resolve the domain to IP address, smth like:
```
Server:		192.168.64.2
Address:	192.168.64.2#53

Non-authoritative answer:
Name:	disaster-ninja.kontur
Address: 192.168.64.2
```

**- Further steps:**

- If you don't want to reinstall the entire platform but just want to deploy your changes, use
```make helm-install-quickstart-all``` to upgrade all helm releases or ```make disaster-ninja-fe``` to upgrade a single release. See the list of available goals in ```Makefile```

## Sentry

Several charts include placeholders to enable [Sentry](https://sentry.io) error reporting. The DSN string is expected in a Kubernetes Secret under the key `SENTRY_DSN`. Replace the default value in `templates/secret.yaml` of each chart (for example `keycloak` and `user-profile-api`) with the DSN from your Sentry project before deploying.
