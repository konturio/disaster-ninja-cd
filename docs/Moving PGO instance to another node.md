# Moving PGO instance to another node


**2024/10/01: See also [https://kontur.fibery.io/favorites/Tasks/document/1258#Tasks/document/Managing-PGO-instances-with-kustomize-1388](https://kontur.fibery.io/favorites/Tasks/document/1258#Tasks/document/Managing-PGO-instances-with-kustomize-1388) which suggests alternative approach, elaborated from this document and reanalyzed affinity constraints.**
* 1.** To move the postgrescluster from one node to another, use the method of modifying **nodeAffinity** in the kustomize file **postgrescluster-assigning.yaml**:

For example we need to move postgrescluster from hwn-03 to hwn-02:

<https://github.com/konturio/disaster-ninja-cd/blob/main/flux/clusters/k8s-01/user-profile-api-db-exp/overlays/DEV/postgrescluster-assigning.yaml> 

```
- op: add
  path: /spec/instances/0/affinity/nodeAffinity
  value:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - hwn03.k8s-01.kontur.io
```

Add the new section:

```
- op: add
  path: /spec/instances/0/affinity/nodeAffinity
  value:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - hwn03.k8s-01.kontur.io

- op: add
  path: /spec/instances/1/affinity/nodeAffinity
  value:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - hwn02.k8s-01.kontur.io
```

and scale postgrescluster **replicas to 2**, by adding or modifying the following section in the kustomize file **postgrescluster-resource-adjustment.yaml**.

For example (<https://github.com/konturio/disaster-ninja-cd/blob/main/flux/clusters/k8s-01/user-profile-api-db-exp/overlays/DEV/postgrescluster-resource-adjustment.yaml>):

```
- op: replace
  path: /spec/instances/0/resources
  value:
    limits:
      memory: 12Gi
      cpu: '8'
    requests:
      memory: 4Gi
      cpu: '1'

- op: replace
  path: /spec/instances/0/replicas
  value: 2
```

Then commit the changes. 
* 2.** PGO will create a new replica on the desired node. The process will take some time depending on the size of the database. To ensure that the process is complete, we should see two instances of postgrescluster in the required namespace. For example:

```
  $ kubectl get pods -n dev-user-profile-api-exp
NAME                                                READY   STATUS      RESTARTS   AGE
db-user-profile-api-exp-01-nxzv-0                   2/2     Running     0          44s
db-user-profile-api-exp-01-r6ch-0                   2/2     Running     0          8m48s
```

We also need to ensure that the replica does not have any lag. Connect to the any pod of the postgres and check the replication status:

```
patronictl list
```

![image.png](https://kontur.fibery.io/api/files/95756fb1-364c-409e-9500-9fb28102ad98#align=%3Aalignment%2Fblock-center&width=1008&height=120.85000610351562 "")
* \
3.** Now we need to perform a switchover to the replica (use the following command from the Leader pod):

```
patronictl switchover
```

Next, patroni will automatically determine the leader and the candidate. press Enter → Enter → Enter to confirm and agree with the process.​

![image.png](https://kontur.fibery.io/api/files/8cee4554-198e-4d4f-9f3d-9f9043921248#align=%3Aalignment%2Fblock-left&width=464&height=179 "")
* 4.** Scale postgrescluster **replicas to 1** and delete irrelevant nodeAffinity section, and correct the cluster instance index.

```
- op: replace
  path: /spec/instances/0/replicas
  value: 1
```

```
- op: add
  path: /spec/instances/0/affinity/nodeAffinity
  value:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - hwn02.k8s-01.kontur.io
```
