# Managing PGO instances with kustomize

This is a new suggested approach, superceding previously used replica-count based configuration.

# Context

1. Longhorn was proved to be ineffective as storage solution for postgres backends → we opt for using local-path provisioner
2. Local-path volumes can not be easily migrated or shared across cluster nodes → every instance/replica is therefore bound to the node it was provisioned on
3. We need to explicitly manage placement of postgres replicas across nodes
4. Any data migration should be done via postgres replication mechanisms

# Concept

1. Every replica is configured as a separate instance of PGO cluster, as its the only mechanism to control its `nodeAffinity`
   1. Its recommended (although not mandatory) for each cluster to have at least two instances, hosted on different nodes 
2. Every instance is identified by unique name. Its suggested to use node names as identifiers
   1. Caution! Renaming instances effectively means their re-creation and data loss. **Never rename a single instance in the cluster unless you plan to wipe all data.**
3. Switchovers are handled by kustomize configs
   1. For the reference: pgo treats all instances equally, and master cannot be strictly defined via main configuration. Selection of master happens via competition between instances, which try to grab lease annotation. However, PGO provides configuration mechanism for one-off switchovers, described below
4. All instances of cluster should be completely described in a single overlay patch, named `postgrescluster-instances.yaml`
   1. Base config should have empty `instances` section, serving as placeholder

# Migration

Full example (including migration from old replica-count-based configs) is covered in the set of pull requests targeting experimental dummy database [user-profile-api-db-exp](https://github.com/konturio/disaster-ninja-cd/tree/main/flux/clusters/k8s-01/user-profile-api-db-exp):

1. [Adding new config for instances management and new replica with node affinity, hwn04](https://github.com/konturio/disaster-ninja-cd/pull/1399) 
2. [Switchover to hwn04 as new master](https://github.com/konturio/disaster-ninja-cd/pull/1400/files) (original MR had syntax mistake, therefore is followed by [hotfix](https://github.com/konturio/disaster-ninja-cd/pull/1401/files))
3. [Adding new replica with node affinity, hwn03](https://github.com/konturio/disaster-ninja-cd/pull/1402)
4. [Destroying legacy instances, removing asssigning/adjustment configs, changing instances config to completely control instances section of `postgrescluster` manifest](https://github.com/konturio/disaster-ninja-cd/pull/1403)
5. [When all overlays are switched to new schema, base config is updated to contain empty array in the `instances` section  ](https://github.com/konturio/disaster-ninja-cd/pull/1404)

# Operations

## Adding new named replica

In the [overlays/OVERLAYNAME/postgrescluster-instances.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/flux/clusters/k8s-01/user-profile-api-db-exp/overlays/DEV/postgrescluster-instances.yaml) , add new entry under `instances` array. It should completely define all parameters of new instance, including node affinity. \
\
Important conventions:

1. Name of the instance should be unique. Its recommended to use name matching the deployment node. 
2. `replicas` count should be strictly 1

*Beware: name of the instance is **immutable** through instance lifecycle. **When name is changed, attached data volume is destroyed**, and new replica with new volume is created.*

Code example:

```
- op: replace 
  path: /spec/instances
  value:
    - ...
    - name: <TARGET_NODE_SHORTNAME>
      replicas: 1
      resources:
        limits:
          memory: <MEMLIMIT>
          cpu: '<CPULIMIT>'
        requests:
          memory: <MEMREQUEST>
          cpu: '<CPUREQUEST>'
      dataVolumeClaimSpec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: <STORAGEREQUEST>
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: kubernetes.io/hostname
                    operator: In
                    values:
                      - <TARGET_NODE_FQDN>
```

## Listing cluster instances

Shorter format

```
NAMESPACE=dev-user-profile-api-exp
CLUSTERNAME=db-user-profile-api-exp

kubectl -n $NAMESPACE get pods \
    -l postgres-operator.crunchydata.com/cluster=$CLUSTERNAME \
    -L postgres-operator.crunchydata.com/instance \
    -L postgres-operator.crunchydata.com/role     
```

Longer format, with node hostnames (just add `-o wide`)

```
NAMESPACE=dev-user-profile-api-exp
CLUSTERNAME=db-user-profile-api-exp

kubectl -n $NAMESPACE get pods \
    -l postgres-operator.crunchydata.com/cluster=$CLUSTERNAME \
    -L postgres-operator.crunchydata.com/instance \
    -L postgres-operator.crunchydata.com/role \
    -o wide    
```

Example output (note identifiers in the `instance` column!):

```
NAME                                                READY   STATUS      RESTARTS   AGE    INSTANCE                             ROLE
db-user-profile-api-exp-backup-ppmj-rhtbc           0/1     Completed   0          4d6h                                        
db-user-profile-api-exp-hwn03-hkz7-0                2/2     Running     0          61m    db-user-profile-api-exp-hwn03-hkz7   replica
db-user-profile-api-exp-hwn04-5hmq-0                2/2     Running     0          9h     db-user-profile-api-exp-hwn04-5hmq   master
```

## Checking replication status

```
NAMESPACE=dev-user-profile-api-exp
POD_ID=db-user-profile-api-exp-hwn03-hkz7-0  # any of the instances

kubectl -n $NAMESPACE exec $POD_ID patronictl list
```

Example output:

```

Cluster: db-user-profile-api-exp-ha (7418973289457942600) -----------------------------------------------+---------+-----------+----+-----------+
| Member                               | Host                                                              | Role    | State     | TL | Lag in MB |
+--------------------------------------+-------------------------------------------------------------------+---------+-----------+----+-----------+
| db-user-profile-api-exp-hwn03-hkz7-0 | db-user-profile-api-exp-hwn03-hkz7-0.db-user-profile-api-exp-pods | Replica | streaming |  3 |         0 |
| db-user-profile-api-exp-hwn04-5hmq-0 | db-user-profile-api-exp-hwn04-5hmq-0.db-user-profile-api-exp-pods | Leader  | running   |  3 |           |
+--------------------------------------+-------------------------------------------------------------------+---------+-----------+----+-----------+

```

## Switchover 

See [official documentation ](https://access.crunchydata.com/documentation/postgres-operator/latest/tutorials/cluster-management/administrative-tasks#changing-the-primary)for more details .

Short steps are:

1. Identify the *instance id*  of desired new master by listing cluster instances as described above in "Listing cluster instances" (the value is \*not\* the pod id, its one from `Instance` column, without extra `-0` suffix). In our examples it could be `db-user-profile-api-exp-hwn03-hkz7`
2. **Ensure the candidate replica has no lag behind current master, as described above in "Checking replication status"**
3. Add or update two sections in the JSON patch ([postgrescluster-instances.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/flux/clusters/k8s-01/user-profile-api-db-exp/overlays/DEV/postgrescluster-instances.yaml)), configuring switchover parameters and switchover trigger (see example below):
   1. for `targetInstance` use *instance identifier* from the step 1
   2. for `switchover-trigger` use any unique value, preferrably including date and either time or number of switchover operation within a day
4. Observe results by checking replication status again
5. After successful switchover, there's no need to remove appropriate patch sections; they could be kept for reference (also retaining metadata annotations on cluster resource). However, changing the value of `switchover-trigger`, will initiate switchover again. Disabling switchover flag or removing the sections will also remove appropriate annotations from cluster metadata

Example:

```
# Switchover section
# https://access.crunchydata.com/documentation/postgres-operator/latest/tutorials/cluster-management/administrative-tasks#changing-the-primary
# https://access.crunchydata.com/documentation/postgres-operator/latest/tutorials/cluster-management/administrative-tasks#targeting-an-instance
# 1. Requires fully-qualified instance id of new master
# 2. New master must be in sink with current master (check via `patronictl list`)
# 3. Its recommended to retain switchover section, to keep track of last desired master both in code and k8s

- op: add
  path: /spec/patroni/switchover
  value:
    enabled: true
    targetInstance: db-user-profile-api-exp-hwn03-hkz7
    #type: Failover

# trigger-switchover annotation triggers actual switchover whenever its updated
# value is arbitrary, but it's recommended to reference the date of switchover
# special syntax is used to escape slash with sequence ~1
# See https://windsock.io/json-pointer-syntax-in-json-patches-with-kustomize/

- op: add
  path: /metadata/annotations/postgres-operator.crunchydata.com~1trigger-switchover
  value: "2024-09-30 [01]"

```
