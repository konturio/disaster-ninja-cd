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
  namespace: dev-event-api
spec:
  backups:
    pgbackrest:
      configuration:
      - secret:
          name: db-event-api-pgo-s3-credentials
      global:
        log-level-file: info
        log-level-stderr: info
        repo1-retention-full: "2"
        repo1-retention-full-type: count
        repo2-path: /pgbackrest/dev-event-api/db-event-api/repo2
        repo2-retention-full: "30"
        repo2-retention-full-type: time
      image: registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:ubi8-2.40-1
      manual:
        options:
        - --type=full
        repoName: repo2
      repos:
      - name: repo1
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
  instances:
  - affinity:
      podAntiAffinity:
        preferredDuringSchedulingIgnoredDuringExecution:
        - podAffinityTerm:
            labelSelector:
              matchLabels:
                postgres-operator.crunchydata.com/cluster: db-event-api
                postgres-operator.crunchydata.com/instance-set: "01"
            topologyKey: kubernetes.io/hostname
          weight: 1
    dataVolumeClaimSpec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 100Gi
    name: "01"
    replicas: 1
    resources:
      limits:
        cpu: "4"
        memory: 24Gi
      requests:
        cpu: "2"
        memory: 24Gi
    topologySpreadConstraints:
    - labelSelector:
        matchLabels:
          postgres-operator.crunchydata.com/instance-set: "01"
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
          auto_explain.log_nested_statements: "on"
          auto_explain.log_verbose: "on"
          autovacuum_analyze_scale_factor: 0.005
          autovacuum_naptime: 15s
          autovacuum_vacuum_cost_limit: 1000
          autovacuum_vacuum_insert_scale_factor: 0.01
          autovacuum_vacuum_scale_factor: 0.01
          effective_cache_size: 18GB
          effective_io_concurrency: 200
          log_autovacuum_min_duration: 250ms
          log_checkpoints: "on"
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
          shared_preload_libraries: auto_explain,pg_stat_statements
          track_activity_query_size: 4kB
          track_functions: pl
          track_io_timing: "on"
          vacuum_cost_page_miss: 5
          wal_compression: "on"
          work_mem: 1GB
  postGISVersion: "3.2"
  postgresVersion: 14
  users:
  - name: postgres
  - databases:
    - event-api
    name: event-api
    options: SUPERUSER
