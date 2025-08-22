# How to connect to PGO-based postgres in k8s

## **Option 1. kubectl**:

1\. Find the pod of postgres:

```
$ kubectl get pods -n dev-user-profile-api | grep -E '(-01-|hwn)'
db-user-profile-api-01-cdx6-0   4/4   Running
or 
db-user-profile-api-hwn0x-cdx6-0   4/4   Running # copy this as <pod_name>
```

2\. Port-forward the pod:

```
  $ kubectl port-forward -n dev-user-profile-api pod/<pod_name> 5432:5432
```

And then you'll be able to connect to the db via localhost:5432.

## **Option 2. Lens**:

1\. Go to Workloads → Pods


\
2. Select needed namespace


3. Find the postgres pod in the service namespace (e.g. db-<service_name>-01-xxxx-0):

4. Scroll to the button Forward and press it


5. Make up a number, e.g., 11111, 22222, 12345, etc., uncheck the checkbox Open in Browser, and press Start


6. And then you'll be able to connect to the db via localhost: 11111

* \
Important note:** 

Since the HA mode was enabled for the production Postgres databases, we have two instances: one is the **leader**, and the other is a streaming replica. We need to connect specifically to the **leader**.

to connect to the **PRODUCTION** databases:

find out which specific pod is needed from the two (the leader), do the following:

```
1. kubectl get pods -n prod-user-profile-api
db-user-profile-api-01-7rff-0                   4/4     Running     0          46h
db-user-profile-api-01-lwvv-0                   4/4     Running     0          8d

2. kubectl exec -ti -n prod-user-profile-api db-user-profile-api-01-7rff-0 -- sh
(or just dive into the pod if you're using Lens)

3. patronictl list
you'll see a table with Member/Role columns.
| db-user-profile-api-01-7rff-0 |...| Replica | streaming 
| db-user-profile-api-01-lwvv-0 |...| Leader  | running

4. kubectl port-forward -n test-user-profile-api pod/db-user-profile-api-01-lwvv-0 5432:5432
(port-forward to the Leader pod)
```
