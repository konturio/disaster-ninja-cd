# k8s etcd maintenance

## Overview

An etcd cluster needs periodic maintenance to remain reliable. Depending on an etcd application’s needs, this maintenance can usually be automated and performed without downtime or significantly degraded performance.

All etcd maintenance manages storage resources consumed by the etcd keyspace. Failure to adequately control the keyspace size is guarded by storage space quotas; if an etcd member runs low on space, a quota will trigger cluster-wide alarms which will put the system into a limited-operation maintenance mode. To avoid running out of space for writes to the keyspace, the etcd keyspace history must be compacted. Storage space itself may be reclaimed by defragmenting etcd members. Finally, periodic snapshot backups of etcd member state makes it possible to recover any unintended logical data loss or corruption caused by operational error.

## History compaction

Since etcd keeps an exact history of its keyspace, this history should be periodically compacted to avoid performance degradation and eventual storage space exhaustion. Compacting the keyspace history drops all information about keys superseded prior to a given keyspace revision. The space used by these keys then becomes available for additional writes to the keyspace.

The keyspace can be compacted automatically with `etcd`’s time windowed history retention policy, or manually with `etcdctl`. The `etcdctl` method provides fine-grained control over the compacting process whereas automatic compacting fits applications that only need key history for some length of time.

## Space quota

The space quota in `etcd` ensures the cluster operates in a reliable fashion. Without a space quota, `etcd` may suffer from poor performance if the keyspace grows excessively large, or it may simply run out of storage space, leading to unpredictable cluster behavior. If the keyspace’s backend database for any member exceeds the space quota, `etcd` raises a cluster-wide alarm that puts the cluster into a maintenance mode which only accepts key reads and deletes. Only after freeing enough space in the keyspace and defragmenting the backend database, along with clearing the space quota alarm can the cluster resume normal operation.

## Troubleshooting

### Issue:

```
etcdserver: mvcc: database space exceeded
```

#### Solution 1 (manually with `etcdctl`):

Removing excessive keyspace data and defragmenting the backend database can help to put the cluster back within the quota limits.

1\. Checking if the etcd container is running:

```
crictl ps | grep etcd
```

2\. Start a shell session inside a container of any ectd pod on master node:

```
[root@master01 ~]# kubectl get pods -n kube-system | grep etcd
etcd-master01.k8s-01.kontur.io 1/1     Running
etcd-master02.k8s-01.kontur.io 1/1     Running
etcd-master03.k8s-01.kontur.io 1/1     Running 

[root@master01 ~]# kubectl exec -ti -n kube-system etcd-master01.k8s-01.kontur.io -- sh
sh-5.1#
```
* Note: for all steps below set the next environment variables**:

```
ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt 
ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key
ETCDCTL_API=3
```

```
$ export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key ETCDCTL_API=3
```

 3\. Check enpoint status of the current member:

```
$ etcdctl --write-out=table endpoint status

+--------------+----------------+-------+-------+-------------------+
|   ENDPOINT   |       ID       |VERSION|DB SIZE| ERRORS            |
+--------------+----------------+-------+-------+-------------------+
|127.0.0.1:2379|d4f116f9b34b7ef5|  3.5.1| 2.1 GB|memberID:1160511389|
|              |                |       |       |     alarm:NOSPACE |
+--------------+----------------+-------+-------+-------------------+
```

4\. Get the current revision:

```
$ etcdctl endpoint status --write-out="json"

[{"Endpoint":"127.0.0.1:2379","Status":{"header":{"cluster_id":9233608010275996133,"member_id":5073427164705191642,"revision":154340496,"raft_term":280},"version":"3.5.1","dbSize":93241344,"leader":15344070667138727669,"raftIndex":176073694,"raftTerm":280,"raftAppliedIndex":176073694,"dbSizeInUse":36872192}}]

# "revision":154340496
```

5\. Initiate compaction of the revision:

```
$ etcdctl compact 154340496
```

\
6. After compacting the keyspace, the backend database may exhibit internal fragmentation. The process of defragmentation releases this storage space back to the file system. Defragmentation is issued on a per-member so that cluster-wide latency spikes may be avoided. To defragment an etcd member, use the `etcdctl defrag` command:

```
$ etcdctl member list
46686f204a11f6da, started, master01.k8s-01.kontur.io, https://10.217.128.201:2380, https://10.217.128.201:2379, false
...
```

```
$ etcdctl defrag https://10.217.128.201:2379
```

7\. Disarm the `alarm:NOSPACE` alarm:

```
$ etcdctl alarm disarm
```

\
8. Repeat the steps 1-6 for each etcd member.

9\. Verify the endpoint status and database size:

```
$ etcdctl -w table endpoint status --cluster
```

10\. Check k8s components status:

```
$ kubectl get --raw='/readyz?verbose'

[+]ping ok
[+]log ok
[+]etcd ok
[+]informer-sync ok
[+]poststarthook/start-kube-apiserver-admission-initializer ok
[+]poststarthook/generic-apiserver-start-informers ok
[+]poststarthook/priority-and-fairness-config-consumer ok
[+]poststarthook/priority-and-fairness-filter ok
[+]poststarthook/start-apiextensions-informers ok
[+]poststarthook/start-apiextensions-controllers ok
[+]poststarthook/crd-informer-synced ok
[+]poststarthook/bootstrap-controller ok
[+]poststarthook/rbac/bootstrap-roles ok
[+]poststarthook/scheduling/bootstrap-system-priority-classes ok
[+]poststarthook/priority-and-fairness-config-producer ok
[+]poststarthook/start-cluster-authentication-info-controller ok
[+]poststarthook/aggregator-reload-proxy-client-cert ok
[+]poststarthook/start-kube-aggregator-informers ok
[+]poststarthook/apiservice-registration-controller ok
[+]poststarthook/apiservice-status-available-controller ok
[+]poststarthook/kube-apiserver-autoregistration ok
[+]autoregister-completion ok
[+]poststarthook/apiservice-openapi-controller ok
[+]shutdown ok
readyz check passed
```

#### Solution 2 (time windowed history retention policy, etcd v3.5.1):

In [v3.3.3](https://github.com/etcd-io/etcd/blob/master/CHANGELOG-3.3.md), `--auto-compaction-mode=revision --auto-compaction-retention=1000` automatically `Compact` on `"latest revision" - 1000` every 5-minute (when latest revision is 30000, compact on revision 29000). Previously, `--auto-compaction-mode=periodic --auto-compaction-retention=72h` automatically `Compact` with 72-hour retention windown for every 7.2-hour. **Now, `Compact` happens, for every 1-hour but still with 72-hour retention window.** Previously, `--auto-compaction-mode=periodic --auto-compaction-retention=30m` automatically `Compact` with 30-minute retention windown for every 3-minute. **Now, `Compact` happens, for every 30-minute but still with 30-minute retention window.** Periodic compactor keeps recording latest revisions for every compaction period when given period is less than 1-hour, or for every 1-hour when given compaction period is greater than 1-hour (e.g. 1-hour when `--auto-compaction-mode=periodic --auto-compaction-retention=24h`). For every compaction period or 1-hour, compactor uses the last revision that was fetched before compaction period, to discard historical data. The retention window of compaction period moves for every given compaction period or hour. For instance, when hourly writes are 100 and `--auto-compaction-mode=periodic --auto-compaction-retention=24h`, `v3.2.x`, `v3.3.0`, `v3.3.1`, and `v3.3.2` compact revision 2400, 2640, and 2880 for every 2.4-hour, while `v3.3.3` *or later* compacts revision 2400, 2500, 2600 for every 1-hour. Furthermore, when `--auto-compaction-mode=periodic --auto-compaction-retention=30m` and writes per minute are about 1000, `v3.3.0`, `v3.3.1`, and `v3.3.2` compact revision 30000, 33000, and 36000, for every 3-minute, while `v3.3.3` *or later* compacts revision 30000, 60000, and 90000, for every [[---#^7a8452d0-8558-11ea-8035-51799a2fd608/f823f160-a336-11ed-a5e3-a536ae553712]]

```
$ etcd --auto-compaction-mode=periodic --auto-compaction-retention=24h
```

Links: 

<https://etcd.io/docs/v3.5/op-guide/maintenance/>

<https://etcd.io/blog/2023/how_to_debug_large_db_size_issue/>

<https://etcd.io/docs/v3.4/dev-guide/interacting_v3/>
