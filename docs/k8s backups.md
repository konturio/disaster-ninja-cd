# k8s backups

### PostgreSQL DB backups

PostgreSQL backups are implemented natively using the PGO operator. 

Example: <https://github.com/konturio/disaster-ninja-cd/tree/main/flux/clusters/k8s-01/keycloak-db/overlays/DEV>

Backup & disaster recovery: <https://access.crunchydata.com/documentation/postgres-operator/latest/tutorials/backups-disaster-recovery>

Backup location (Hetzner S3, k8s-01 project): [hel1.your-objectstorage.com/pgbackrest-k8s-01/](https://hel1.your-objectstorage.com/pgbackrest-k8s-01/)

### ETCd backups

Since we have a stacked control plane, etcd backup is implemented using a script.

Github: <https://github.com/konturio/puppetmaster2022/tree/main/gists/etcd-backup>

Location: [master01.k8s-01.kontur.io](https://master01.k8s-01.kontur.io),  /root/etcd-backup.sh

Schedule: 0 3 \* \* \*

Backup location (Hetzner S3, k8s-01 project): [hel1.your-objectstorage.com/kontur/](https://hel1.your-objectstorage.com/kontur/)

### Kubernetes manifests & pv backups

Implemented using [Velero.io](https://velero.io/docs/v1.15/ "https://velero.io/docs/v1.15/")

Github: <https://github.com/konturio/k8s-harlem/tree/main/core-apps/base/velero>

Backup location (Hetzner S3, k8s-01 project): [hel1.your-objectstorage.com/velero-backups](https://hel1.your-objectstorage.com/velero-backups)

Disaster recovery: <https://velero.io/docs/v1.15/disaster-case/>
