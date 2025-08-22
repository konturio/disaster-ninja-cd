# Handling Postgres disk 100% usage

Postgres may encounter disk space issues due to the accumulation of WAL files. These issues can cause the database to stop functioning, requiring manual intervention. The primary causes of this issue are:

1\. Accumulation of WAL files due to backup failures\
In this case, we need to check the status of the latest backup:

```
kubectl get pods -n <namespace>
...
<cluster-name>-repo2-incr/diff/full-xxxxxxx-xxxxx 0/1 Completed
...
```

If the status is not "Completed" but "Error", further actions involve analyzing the cause.

```
kubectl logs -n <namespace> <cluster-name>-repo2-incr/diff/full-xxxxxxx-xxxxx
```

\
2. Accumulation of WAL files due to connectivity issues with the s3 storage (minio or with exceeding the bucket limits):\
In this case we need to check minio available space: \
<https://minio.kontur.io/tenants> access should be requested from the ops team, or you can get the token via the following command:

```
kubectl -n minio-operator get secret console-sa-secret -o jsonpath="{.data.token}" | base64 --decode
```

![image.png](https://kontur.fibery.io/api/files/1b20c94a-121e-4eb8-97ea-90f86d9db78f#align=%3Aalignment%2Fblock-left&width=364&height=167 "")

\
**In all cases**, to continue resolving the issue, it's necessary to free up space. To do this, we will delete the previous backups:

```
kubectl exec -ti -n <namespace> db-dbname-01-xxxx-0 -- sh
sh-4.4$ pgbackrest --stanza=db expire
```

\
3. To resolve timeout issues, you can try increasing the backup timeout, in the case where the following is found in the backup job logs:

```
WAL segment 00000005000006EB000000FF was not archived before the 360000ms timeout
```

Example: <https://github.com/konturio/disaster-ninja-cd/blob/65ac2f5ad10f893f3a5747f9a62310ad07132fb3/flux/clusters/k8s-01/user-profile-api-db/overlays/DEV/postgrescluster-pgbackrest-adjustment.yaml#L3>

```
archive_timeout = 720s
```

\
4. Other causes such as increased database activity do not have a predefined solution and may require experimenting with the pgbackrest configuration. \
Example: ([https://github.com/konturio/disaster-ninja-cd/blob/main/flux/clusters/k8s-01/user-profile-api-db/overlays/DEV/postgrescluster-pgbackrest-adjustment.yaml](https://github.com/konturio/disaster-ninja-cd/blob/main/flux/clusters/k8s-01/user-profile-api-db/overlays/DEV/postgrescluster-pgbackrest-adjustment.yaml#L3))

```
- op: add
  path: /spec/backups/pgbackrest/global/archive-timeout
  value: '360'

- op: add
  path: /spec/backups/pgbackrest/global/process-max
  value: '16'

- op: add
  path: /spec/backups/pgbackrest/global/archive-push-queue-max
  value: '50GB'

- op: add
  path: /spec/backups/pgbackrest/global/archive-async
  value: 'y'

- op: replace
  path: /spec/patroni/dynamicConfiguration/postgresql/parameters/max_wal_size
  value: '10GB'
```
