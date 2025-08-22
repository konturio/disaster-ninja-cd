# Crash Course: PGO, the Postgres Operator from Crunchy Data

Developers who plan to use PGO, the Postgres Operator from Crunchy Data, for their services are advised to see the list of tutorials by the PGO authors [here](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/). Instead of the repository [CrunchyData/postgres-operator-examples](https://github.com/CrunchyData/postgres-operator-examples) mentioned throughout their website, they can use its forked copy [https://github.com/**konturio/postgres-operator-examples**](https://github.com/konturio/postgres-operator-examples).

## Useful references:

1. [PostgresCluster – CRD Reference](https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgres-operatorcrunchydatacomv1beta1)
2. [minikube is local Kubernetes – installation instructions](https://minikube.sigs.k8s.io/docs/start/ "https://minikube.sigs.k8s.io/docs/start/")
3. [Kustomize – Kubernetes configuration transformation tool (guides)](https://kubectl.docs.kubernetes.io/guides/ "https://kubectl.docs.kubernetes.io/guides/")

## Crash course contents:

1. Installing PGO on a new local [minikube](https://minikube.sigs.k8s.io/docs/start/) Kubernetes cluster
2. Working with PGO documentation using `kubectl explain`
3. Creating a simple Postgres cluster using Kustomize
4. Creating a simple Pod that uses initContainers to connect to a Postgres cluster

### 1. Installing PGO on a new local [minikube](https://minikube.sigs.k8s.io/docs/start/) Kubernetes cluster

```
# Start or create a new local Kubernetes cluster with minikube [2].
# The Kubernetes version 1.23.1 that the minikube VM matches versions
# of k8s-01 and k8s-02 clusters as of 11/15/2022.
$ minikube start --kubernetes-version=1.23.1
<some lines omitted>
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

# Download PGO examples by cloning the forked repository
$ git clone https://github.com/konturio/postgres-operator-examples.git
Cloning into 'postgres-operator-examples'...
remote: Enumerating objects: 1141, done.
remote: Counting objects: 100% (52/52), done.
remote: Compressing objects: 100% (43/43), done.
remote: Total 1141 (delta 17), reused 28 (delta 9), pack-reused 1089
Receiving objects: 100% (1141/1141), 363.77 KiB | 2.22 MiB/s, done.
Resolving deltas: 100% (585/585), done.

# Use Kustomize [3] built into kubectl to create the target namespace
$ kubectl apply -k postgres-operator-examples/kustomize/install/namespace
namespace/postgres-operator created
# ... and to install PGO itself in cluster-wide mode
$ kubectl apply --server-side -k postgres-operator-examples/kustomize/install/default
customresourcedefinition.apiextensions.k8s.io/pgupgrades.postgres-operator.crunchydata.com serverside-applied
customresourcedefinition.apiextensions.k8s.io/postgresclusters.postgres-operator.crunchydata.com serverside-applied
serviceaccount/pgo serverside-applied
serviceaccount/postgres-operator-upgrade serverside-applied
clusterrole.rbac.authorization.k8s.io/postgres-operator serverside-applied
clusterrole.rbac.authorization.k8s.io/postgres-operator-upgrade serverside-applied
clusterrolebinding.rbac.authorization.k8s.io/postgres-operator serverside-applied
clusterrolebinding.rbac.authorization.k8s.io/postgres-operator-upgrade serverside-applied
deployment.apps/pgo serverside-applied
deployment.apps/pgo-upgrade serverside-applied

# Confirm that the PGO installation is healthy. You should see a couple of Pods.
$ kubectl -n postgres-operator get pods
NAME                           READY   STATUS    RESTARTS   AGE
pgo-c5cb9d687-wnqwf            1/1     Running   0          2m23s
pgo-upgrade-7b94fcc659-l5ctc   1/1     Running   0          2m23s
```

### 2. Working with PGO documentation using `kubectl explain`

```
# "kubectl explain" works with Kubernetes API fetching documentation on resources.
# Let's learn how to use it.
$ kubectl explain --help
List the fields for supported resources.

 This command describes the fields associated with each supported API resource. Fields are identified via a simple
JSONPath identifier:

  <type>.<fieldName>[.<fieldName>]
<some lines omitted>

# Jump into reading about PostgresCluster CRD...
$ kubectl explain PostgresCluster
KIND:     PostgresCluster
VERSION:  postgres-operator.crunchydata.com/v1beta1

DESCRIPTION:
     PostgresCluster is the Schema for the postgresclusters API

FIELDS:
<some lines omitted>

# ... by appending additional fields you can dive deeper into the fields hierarchy
$ kubectl explain PostgresCluster.spec.backups.pgbackrest
KIND:     PostgresCluster
VERSION:  postgres-operator.crunchydata.com/v1beta1

RESOURCE: pgbackrest <Object>

DESCRIPTION:
     pgBackRest archive configuration

FIELDS:
   configuration	<[]Object>
     Projected volumes containing custom pgBackRest configuration. These files
     are mounted under "/etc/pgbackrest/conf.d" alongside any pgBackRest
     configuration generated by the PostgreSQL Operator:
     https://pgbackrest.org/configuration.html
<some lines omitted>
```

You can find a similar ascetic description of PostgresCluster CRD [here](https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgres-operatorcrunchydatacomv1beta1).

### 3. Creating a simple Postgres cluster using Kustomize

Unpack `mycluster-skeleton.tar.xz` attached to this document or run the following one-liner:

```
base64 -d <<< "/Td6WFoAAATm1rRGAgAhARwAAAAQz1jM4Cv/BD5dADaeSIpruknnGam14+b4KosZDpd/Clm/+Bbw0sckXAHQ30+QQzgnwqutsiK7SPhMUeCM6zWMTo3WJ+XRp8jn6q6Aq0mIXq0F8KPPopIe2QL1H49BkyOF0qSCY9yORXoBxO/DDu/Y/yANXkXgJGVQ9cvt3RSeerylJnwhICZmbaqb9o/eY4XuZFNMSq+0aREcZM7NjXjXhlKy8dd2mFG8dNq3SeL46DZHHOyTK2J7m+DsiubycL5x14VCVsJ/8QI9Lec08CbuSg+KxPrRc8eOJWXdcHlnlMu7BZQEEL8NZysOuycJRCvTiujm5LM/Nde98xwg8MFKiz5MxpRJUERHG0kh0lqv9rgx19KzNWMRHgnBPae3N6Qqhsv/HaJRFmeJOcW4cSJP34icIwYFG4ewYXSR5YQsQb9tZ0Wr+W1WfeAKOFzzBwCEwHLNEbaWeY2ZFj5PQjRlvEkwo+smM4RzhSEwLQXiJV6QEYJ8a/8XREJ4/fy384aEZtgIVFACNz/F8V6SWZQlHfEriAuz/n/54NHPInQrlD/I+dOndDYtifdOpylNMU6pWD62J4R/c1ICPBhBo3qJ/tfbc6KdAnDOi9pQDevqQdAdUo7EVmSViE4VoRh4BuShRLZHtpjXT9C6K9ME1FhU2xGi+nW3m2tTi7OaZEh4t0BJDVCXbkM+8SFS3Xhmhl5pwc7lOWI7z+39NQ3xEKAUcXSlQlfs6osiJm6shDWUsMpL3yW2SNPlIkK69PzN9ZNoHwoQjLl1M7lRu7nKYF0NzjAbQ30A51O3X7GDMSXn9aAAn6Dr0LEvW63k9H3Kbzeoghvl21lpZBwwcEPGY8QLbdk8eEYp/1AkWPSeMyfska7NBwBhJcgVzT77VIzPsQW97OZZLOrxtjsWD9TKPq9xPBz3uaWhd1Qqyzm720ihGhSplcD5HDukLcvpvu9L8SqTleHvvimv7ixinOtL2dDxI9MoeUApm9NZKtfmifchxrEBHNxyMoJ1Zmt/OUBSb///We/o6QF2gk8UBV9d1Z6ptSSzrfAMmr+zTpiNoV1Z5q8JBXITjySX1afrc+SuVmJxKa/jqRYEd0NgO2oSQLHvs5fLbBetVhZp8wbJlCmCAPVvcNr33IUL1g3H3yurBtpFAWuLnqfkk/TtcHMcWnJskDAQbDSSESGKfT0Rpdcc8ime6IHuij4ZHGT5CZ4kxcSezBUmbD8CHPqkWNtIaFd83E7U+b/g9U07UxMRXOi8A5isEL0En8Mm1PZkGw8v2BjK8F7p5/La8VVV5F0HXyn22p46EfpqRBy1k7HACtNKP4eFqX+Qz+hjTfOxpp0jl1bt79ys+aiq4t+XfRqSVDKvEM2nwlxBPuTeQiZ2o1/QgbMrQlcZ7Oj0A7YFdUZ8yi36xVz1glUej/QNoW5m7RR3v4ldsaopLRsVtDfPolaUpemjNt8ZOHtDOQAAAJjlCh96uY37AAHaCIBYAABmaXbPscRn+wIAAAAABFla" | xz -d | tar xvf -
```

You now have a filesystem layout to manage the DEV, TEST, and PROD variants of PostgresCluster cluster with Kustomize. You should first read the [Kustomize](https://kubectl.docs.kubernetes.io/guides/ "https://kubectl.docs.kubernetes.io/guides/") and [PostgresCluster](https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/ "https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/") documentation to understand these files. Below the list of directory contents, you will find individual file comments and several commands with which you can deploy this cluster.

```
$ tree mycluster-skeleton/
mycluster-skeleton/
├── base
│   ├── kustomization.yaml
│   └── postgrescluster.yaml
└── overlays
    ├── DEV
    │   └── kustomization.yaml
    ├── PROD
    │   ├── kustomization.yaml
    │   └── postgrescluster-replica-count.yaml
    └── TEST
        └── kustomization.yaml

5 directories, 6 files
```

The `base/postgrescluster.yaml` file is the key file describing the cluster being created. It contains the base variant of PostgresCluster resource, which we apply to a namespace in Kubernetes. Once we do this, PGO operator takes charge and makes a lot of supplemental resources, with some of which our applications interact. A single PostgresCluster resource **in this example** results in the creation of 37 resources total – Secrets, ConfigMaps, Services, and others. \
\
Interacting with this many resources (monitoring, querying, editing) through APIs or command-line tools can be more manageable if you use [Kubernetes labels and selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ "https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/"). Like any other Kubernetes resource, PostgresCluster can have its labels assigned. It also can contain instructions on how to apply labels to Kubernetes resources that PGO creates for it. [**Here**](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/customize-cluster/#labels:~:text=There%20are%20several%20ways%20to%20add%20your%20own%20custom%20Kubernetes%20Labels%20to%20your%20Postgres%20cluster. "https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/customize-cluster/#labels:~:text=There%20are%20several%20ways%20to%20add%20your%20own%20custom%20Kubernetes%20Labels%20to%20your%20Postgres%20cluster.")**, please read about ways to add custom Kubernetes labels to your Postgres clusters and use them.**

The command below is the only thing needed to create a customized `DEV` deployment for the cluster defined by `base/postgrescluster.yaml`. Kustomize here uses the file `mycluster-skeleton/overlays/DEV/kustomization.yaml` as a starting point to build resource definitions.

```
$ kustomize build mycluster-skeleton/overlays/DEV/ | kubectl apply -f -
postgrescluster.postgres-operator.crunchydata.com/mycluster created
```

Please pay attention to specific names that you use when defining a `PostgresCluster` cluster. `metadata.name`, `spec.backups.pgbackrest.repos.[*].name`, `spec.instances.[*].name`, and elements of the list `spec.users` – all these become parts of the names of resources that you will interact with. For example, you will need to use the cluster name, your database name, and the database user to locate current connection credentials for your application. Read about connecting to a PGO  Postgres cluster [here](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/connect-cluster/#connect-an-application:~:text=features%20of%20PGO\).-,Connect%20an%20Application,-For%20this%20tutorial "https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/connect-cluster/#connect-an-application:~:text=features%20of%20PGO).-,Connect%20an%20Application,-For%20this%20tutorial").

\
Pay attention to `PostgresCluster.spec.image` the field. **You only need to use it when you have a customized Kontur image of PGO PostgreSQL.** Otherwise, specifying `spec.postGISVersion` and `spec.postgresVersion` correctly would be sufficient to let PGO use the correct container images. Ask the Operations team (`@op`) about the exact name of a container image that your service needs.

### 4. Creating a simple Pod that uses initContainers to connect to a Postgres cluster

The following static manifest defines Pod `myapp-pod` in namespace `dev-myapp` that, as part of its initialization sequence, connects to the Postgres cluster `mycluster` as DB user `mydbuser` and runs the series of commands using `psql`. Its init container uses an additional check to ensure that PGO has already provisioned Service `mycluster-primary`.

```
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  namespace: dev-myapp
  labels:
    app.kubernetes.io/name: MyApp
spec:
  containers:
    - command:
        - sh
        - '-c'
        - echo The app is running! && sleep 3600
      image: 'busybox:1.28'
      name: myapp-container
  initContainers:
    - args:
        - '-c'
        - '$(STARTUP_SCRIPT)'
      command:
        - /usr/bin/bash
      env:
        - name: CONNECTION_URI
          valueFrom:
            secretKeyRef:
              name: mycluster-pguser-mydbuser
              key: uri
              optional: false
        - name: STARTUP_SCRIPT
          value: |
            #!/usr/bin/env bash
            exec &> >(tee -a /STARTUP_SCRIPT_OUTPUT.txt)

            SVC=mycluster-primary
            until nslookup $SVC.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do
              echo Waiting for Service $SVC
              sleep 1
            done

            psql "$CONNECTION_URI" -f - <<< "$SQL_QUERIES_01"
        - name: SQL_QUERIES_01
          value: |-
            \conninfo
            \l
            \dx
            SELECT PostGIS_Full_Version();
      image: 'nexus.kontur.io:8084/konturdev/crunchy-postgres-gis:test'
      name: myapp-init-container
      securityContext:
        privileged: true
```
