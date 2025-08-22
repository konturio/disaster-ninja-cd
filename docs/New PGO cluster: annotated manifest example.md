# New PGO cluster: annotated manifest example

In this document, we will analyze an example of a PostgreSQL cluster created using [PGO, the Postgres Operator from Crunchy Data](https://access.crunchydata.com/documentation/postgres-operator/latest/ "https://access.crunchydata.com/documentation/postgres-operator/latest/"). To understand my comments below, you should get acquainted with the [CRD reference on PostgresCluster](https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/ "https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/").

On 22/7/2022, I generated the following manifest using this folder: <https://github.com/konturio/disaster-ninja-cd/tree/main/flux/clusters/k8s-01/event-api-db/overlays/PROD>. In the example, a PostgreSQL cluster is set up for running on Kubernetes:

```
apiVersion: postgres-operator.crunchydata.com/v1beta1
kind: PostgresCluster
metadata:
  annotations:
    kustomize.toolkit.fluxcd.io/prune: disabled
  labels:
    app.kubernetes.io/component: database
    app.kubernetes.io/managed-by: flux
    app.kubernetes.io/name: db-event-api
    app.kubernetes.io/part-of: event-api
  name: db-event-api
  namespace: prod-event-api
spec:
  backups:
    pgbackrest:
      configuration:
        - secret:
            name: db-event-api-pgo-s3-credentials
      global:
        log-level-file: info
        log-level-stderr: info
        repo1-retention-full: '2'
        repo1-retention-full-type: count
        repo2-path: /pgbackrest/prod-event-api/db-event-api/repo2
        repo2-retention-full: '30'
        repo2-retention-full-type: time
      image: 'registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:ubi8-2.40-1'
      manual:
        options:
          - '--type=full'
        repoName: repo2
      repos:
        - name: repo1
          schedules:
            differential: 30 21 * * 4
            full: 30 21 * * 0
            incremental: '30 21 * * 1,2,3,5,6'
          volume:
            volumeClaimSpec:
              accessModes:
                - ReadWriteOnce
              resources:
                requests:
                  storage: 100Gi
              storageClassName: local-path-regular
        - name: repo2
          s3:
            bucket: k8s-01-kontur-io--pgbackrest-backups
            endpoint: s3.eu-central-1.amazonaws.com
            region: eu-central-1
          schedules:
            differential: 15 0 * * 3
            full: 15 0 * * 6
            incremental: '15 0 * * 0,1,2,4,5'
  instances:
    - affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - podAffinityTerm:
                labelSelector:
                  matchLabels:
                    postgres-operator.crunchydata.com/cluster: db-event-api
                    postgres-operator.crunchydata.com/instance-set: '01'
                topologyKey: kubernetes.io/hostname
              weight: 1
      dataVolumeClaimSpec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 100Gi
      name: '01'
      replicas: 2
      resources:
        limits:
          cpu: '4'
          memory: 32Gi
        requests:
          cpu: '4'
          memory: 32Gi
      topologySpreadConstraints:
        - labelSelector:
            matchLabels:
              postgres-operator.crunchydata.com/instance-set: '01'
          maxSkew: 1
          topologyKey: kubernetes.io/hostname
          whenUnsatisfiable: DoNotSchedule
  metadata:
    labels:
      app.kubernetes.io/component: database
      app.kubernetes.io/managed-by: pgo
      app.kubernetes.io/name: db-event-api
      app.kubernetes.io/part-of: event-api
  patroni:
    dynamicConfiguration:
      postgresql:
        parameters:
          auto_explain.log_min_duration: 1s
          auto_explain.log_nested_statements: 'on'
          auto_explain.log_verbose: 'on'
          autovacuum_analyze_scale_factor: 0.005
          autovacuum_naptime: 15s
          autovacuum_vacuum_cost_limit: 1000
          autovacuum_vacuum_insert_scale_factor: 0.01
          autovacuum_vacuum_scale_factor: 0.01
          effective_cache_size: 18GB
          effective_io_concurrency: 200
          log_autovacuum_min_duration: 250ms
          log_checkpoints: 'on'
          log_error_verbosity: verbose
          log_line_prefix: '[%m u=%u d=%d h=%r p=%p l=%l trans_id=%x]: '
          maintenance_work_mem: 1536MB
          max_connections: 50
          max_parallel_maintenance_workers: 2
          max_parallel_workers: 4
          max_parallel_workers_per_gather: 2
          max_worker_processes: 4
          random_page_cost: 1.1
          shared_buffers: 6GB
          shared_preload_libraries: 'auto_explain,pg_stat_statements'
          track_activity_query_size: 4kB
          track_functions: pl
          track_io_timing: 'on'
          vacuum_cost_page_miss: 5
          wal_compression: 'on'
          work_mem: 1GB
  postGISVersion: '3.2'
  postgresVersion: 14
  users:
    - name: postgres
    - databases:
        - event-api
      name: event-api
      options: SUPERUSER

```

#### [PostgresCluster.metadata.annotations.kustomize.toolkit.fluxcd.io/prune](https://fluxcd.io/flux/components/kustomize/kustomization/#garbage-collection "https://fluxcd.io/flux/components/kustomize/kustomization/#garbage-collection")

At our company, we use Flux. Flux is a tool for managing the state of Kubernetes clusters. It allows users to define the desired state of their applications and services and automatically ensures that the actual state of the cluster matches the desired state. One of the features of Flux is the ability to perform "garbage collection" by finding and deleting objects that are no longer needed. This can help keep the cluster clean and free of unnecessary resources, improving performance and reducing costs.

To prevent the PostgresCluster from being removed accidentally, we can use the annotation to instruct Flux not to prune that specific resource:

```
kustomize.toolkit.fluxcd.io/prune: disabled
```

This will ensure that the PostgresCluster and its backups will not be removed, even if the definition is removed from the source code.

#### [PostgresCluster.spec.backups.pgbackrest.configuration.secret.name](https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecbackupspgbackrestconfigurationindexsecret "https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecbackupspgbackrestconfigurationindexsecret")

This cluster uses AWS S3 as one of its backup storage locations. To use the S3 API for uploading and downloading files, PGO needs security credentials. In the following example, `db-event-api-pgo-s3-credentials` is the name of the Secret in which this information is stored.

```
spec:
  backups:
    pgbackrest:
      configuration:
        - secret:
            name: db-event-api-pgo-s3-credentials
```

To create such a Secret for S3 interaction, follow the instructions in [this tutorial](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/backups/#using-s3), or contact the Operations team for assistance.

#### [PostgresCluster.spec.backups.pgbackrest](https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecbackupspgbackrest "https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecbackupspgbackrest").global

PGO relies heavily on the pgBackRest tool for creating backups and seeding new databases. The following example shows how to configure the pgBackRest software, including adjusting the verbosity levels (`log-level-file` and `log-level-stderr`), limiting the number of full onsite backups to 2 (`repo1-retention-full` and `repo1-retention-full-type`), restricting the age of full backups in S3 to a period of 30 days (`repo2-retention-full` and `repo2-retention-full-type`).

```
spec:
  backups:
    pgbackrest:
      global:
        log-level-file: info
        log-level-stderr: info
        repo1-retention-full: '2'
        repo1-retention-full-type: count
        repo2-path: /pgbackrest/prod-event-api/db-event-api/repo2
        repo2-retention-full: '30'
        repo2-retention-full-type: time
```

pgBackRest's configuration reference is [here](https://pgbackrest.org/configuration.html "https://pgbackrest.org/configuration.html").

#### [PostgresCluster.spec.backups.pgbackrest.manual](https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecbackupspgbackrestmanual "https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecbackupspgbackrestmanual")

PGO allows us to create a single, one-time database backup easily. The following block tells pgBackRest to use *full* backups when archiving to S3, leaving onsite manual backups at its default *incremental* setting.

```
spec:
  backups:
    pgbackrest:
      manual:
        options:
          - '--type=full'
        repoName: repo2
```

Learn how to trigger one-time backups [here](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/backup-management/#taking-a-one-off-backup "https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/backup-management/#taking-a-one-off-backup").

#### [PostgresCluster.spec.backups.pgbackrest.repos](https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecbackupspgbackrestreposindex "https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecbackupspgbackrestreposindex")

A backup repository is a location where data backups are stored. pgBackRest supports different types of storage. `volume` means repository in PVC. `s3` means S3-compatible storage.

```
spec:
  backups:
    pgbackrest:
      repos:
        - name: repo1
          schedules:
            differential: 30 21 * * 4
            full: 30 21 * * 0
            incremental: '30 21 * * 1,2,3,5,6'
          volume:
            volumeClaimSpec:
              accessModes:
                - ReadWriteOnce
              resources:
                requests:
                  storage: 100Gi
              storageClassName: local-path-regular
        - name: repo2
          s3:
            bucket: k8s-01-kontur-io--pgbackrest-backups
            endpoint: s3.eu-central-1.amazonaws.com
            region: eu-central-1
          schedules:
            differential: 15 0 * * 3
            full: 15 0 * * 6
            incremental: '15 0 * * 0,1,2,4,5'
```

`spec.backups.pgbackrest.repos` elements define characteristics of backup repositories and associated schedules to run backup operations. `storageClassName: local-path-regular` means we want to use magnetic drives for `repo1` the repository instead of SSD storage. `s3.bucket`, `s3.endpoint`, `s3.region` tell pgBackRest where the `repo2` repository is located.

Learn more about backup configuration in [this tutorial](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/backups/ "https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/backups/").

#### [PostgresCluster.spec.instances](https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecinstancesindex "https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecinstancesindex")

This section defines PostgreSQL pods that replicate data.

2024/10/01: see also <https://kontur.fibery.io/favorites/Tasks/document/1258#Tasks/document/Managing-PGO-instances-with-kustomize-1388> 

```
spec:
  instances:
    - affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - podAffinityTerm:
                labelSelector:
                  matchLabels:
                    postgres-operator.crunchydata.com/cluster: db-event-api
                    postgres-operator.crunchydata.com/instance-set: '01'
                topologyKey: kubernetes.io/hostname
              weight: 1
      dataVolumeClaimSpec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 100Gi
      name: '01'
      replicas: 2
      resources:
        limits:
          cpu: '4'
          memory: 32Gi
        requests:
          cpu: '4'
          memory: 32Gi
      topologySpreadConstraints:
        - labelSelector:
            matchLabels:
              postgres-operator.crunchydata.com/instance-set: '01'
          maxSkew: 1
          topologyKey: kubernetes.io/hostname
          whenUnsatisfiable: DoNotSchedule
```

`affinity` and `topologySpreadConstraints` rules ensure the even spread of pods across the cluster.  By default, the PGO is configured for high availability, so as long as we have more than one replica, high availability will be enabled. We use two replicas for this production Postgres cluster (`replicas: 2`). This is an essential requirement for production clusters, and if, due to affinity or topology contains, we will not be able to schedule replicas to run on different worker nodes, we choose to fail early (`whenUnsatisfiable: DoNotSchedule`).

`resources.limits` sets requests and limits for PostgreSQL pods. In this case, we want pods having 32Gi of RAM.

#### [PostgresCluster.spec.patroni](https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecpatroni "https://access.crunchydata.com/documentation/postgres-operator/latest/references/crd/#postgresclusterspecpatroni").dynamicConfiguration.postgresql.parameters

This is Patroni dynamic configuration settings. Changes to certain PostgreSQL parameters cause PostgreSQL to restart. The following values are optimized for Postgres using 24Gi of RAM.

```
spec:
  patroni:
    dynamicConfiguration:
      postgresql:
        parameters:
          auto_explain.log_min_duration: 1s
          auto_explain.log_nested_statements: 'on'
          auto_explain.log_verbose: 'on'
          autovacuum_analyze_scale_factor: 0.005
          autovacuum_naptime: 15s
          autovacuum_vacuum_cost_limit: 1000
          autovacuum_vacuum_insert_scale_factor: 0.01
          autovacuum_vacuum_scale_factor: 0.01
          effective_cache_size: 18GB
          effective_io_concurrency: 200
          log_autovacuum_min_duration: 250ms
          log_checkpoints: 'on'
          log_error_verbosity: verbose
          log_line_prefix: '[%m u=%u d=%d h=%r p=%p l=%l trans_id=%x]: '
          maintenance_work_mem: 1536MB
          max_connections: 50
          max_parallel_maintenance_workers: 2
          max_parallel_workers: 4
          max_parallel_workers_per_gather: 2
          max_worker_processes: 4
          random_page_cost: 1.1
          shared_buffers: 6GB
          shared_preload_libraries: 'auto_explain,pg_stat_statements'
          track_activity_query_size: 4kB
          track_functions: pl
          track_io_timing: 'on'
          vacuum_cost_page_miss: 5
          wal_compression: 'on'
          work_mem: 1GB
```

### Miscellaneous 

With this, we request PostgreSQL version 14 with PostGIS 3.2 extensions (`postgresVersion: 14`, `postGISVersion: '3.2'`). Credentials of DB users `postgres` and `event-api`) will be made available as Kubernetes Secrets (`name: postgres`, `name: event-api`). DB user `event-api` will have `SUPERUSER` privileges (`options: SUPERUSER`) and the rights to access an empty database event-api (`- event-api`).

```
spec:
  postGISVersion: '3.2'
  postgresVersion: 14
  users:
    - name: postgres
    - databases:
        - event-api
      name: event-api
      options: SUPERUSER
```

#### Disaster Recovery and Cloning

Please read about DB cloning and backup restoration in [this tutorial](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/disaster-recovery/ "https://access.crunchydata.com/documentation/postgres-operator/latest/tutorial/disaster-recovery/").
