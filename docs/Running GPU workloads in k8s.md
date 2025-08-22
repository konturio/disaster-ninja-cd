# Running GPU workloads in k8s

### Environment overview

Our Kubernetes cluster includes the following components for GPU workload orchestration:

1. [NVIDIA GPU Operator](https://github.com/NVIDIA/gpu-operator): Installs and manages NVIDIA GPU drivers, container runtime, monitoring stack, and more.
2. [Kai Scheduler](https://github.com/NVIDIA/kai): NVIDIA's scheduler for fine-grained GPU sharing (memory-based or fractional)

The GPU node (gpu01.k8s-01.kontur.io) in the cluster is equipped with an NVIDIA RTX 6000 Ada Generation GPU, featuring:
* 18,176 CUDA cores
* 568 Tensor Cores
* 142 RT Cores
* 48 GB of GDDR6 ECC memory

Kubernetes schedules one pod per GPU by default, often wasting valuable compute. KAI Scheduler changes that by enabling:
* **Multiple pods to share a single GPU**
* **Memory-based GPU requests in MiB**
* **Smarter scheduling across queues and namespaces**

### Workflow

![image.png](https://kontur.fibery.io/api/files/0ab72e98-d650-4d2d-964d-e280a962857a#align=%3Aalignment%2Fblock-left&width=949.0333251953125&height=474 "")

### Scheduling Queue in KAI Scheduler

KAI Scheduler uses a hierarchical queue system to manage how cluster resources like GPUs and memory are allocated across workloads. This queue system helps ensure fairness, resource isolation and flexibility.

Queues serve as the foundational entities for enforcing resource fairness. Each queue has specific properties that guide its resource allocation:
* **Quota:** the baseline resource allocation guaranteed to the queue.
* **Over-quota weight:** influences how additional, surplus resources are distributed beyond the baseline quota amongst all queues.
* **Limit:** defines the maximum resources that the queue can consume.
* **Queue priority:** determines the scheduling order relative to other queues, influencing queue prioritization.

Defining queues:

```
apiVersion: scheduling.run.ai/v2
kind: Queue
metadata:
  name: default
spec:
  resources:
    cpu:
      quota: -1
      limit: -1
      overQuotaWeight: 1
    gpu:
      quota: -1
      limit: -1
      overQuotaWeight: 1
    memory:
      quota: -1
      limit: -1
      overQuotaWeight: 1
---
apiVersion: scheduling.run.ai/v2
kind: Queue
metadata:
  name: test
spec:
  parentQueue: default
  resources:
    cpu:
      quota: -1
      limit: -1
      overQuotaWeight: 1
    gpu:
      quota: -1
      limit: -1
      overQuotaWeight: 1
    memory:
      quota: -1
      limit: -1
      overQuotaWeight: 1

# NOTE:
# Here, -1 means unlimited access to resources. This setup allows workloads in the test queue to consume as many cluster resources as available.
# The overQuotaWeight defines how resources are fairly shared when multiple queues go over their defined quotas. It acts as a weight-based fairness policy.
```

### Scheduling workloads in KAI Scheduler

Kai Scheduler enables fine-grained GPU sharing in Kubernetes. It supports two mutually exclusive modes for sharing:

1. **GPU Fraction Sharing**: share a GPU based on compute fraction (e.g., 0.25 of a GPU)
2. **GPU Memory Sharing**: share a GPU based on allocated memory (e.g., 2000 MiB)

Example:

```
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
  namespace: gpu-workload
  labels:
    kai.scheduler/queue: test
  annotations:
    # choose only one of the two options below:
    #gpu-fraction: "0.2"     # 20% of GPU compute
    gpu-memory: "2000"       # 2000 MiB of GPU memory
spec:
  schedulerName: kai-scheduler
  restartPolicy: Never
  containers:
    - name: cuda-container
      image: nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda12.5.0
  tolerations:
    - key: nvidia.com/gpu
      operator: Exists
      effect: NoSchedule
```

links:

<https://developer.nvidia.com/blog/nvidia-open-sources-runai-scheduler-to-foster-community-collaboration/>

<https://github.com/NVIDIA/KAI-Scheduler>

<https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/overview.html>\`
