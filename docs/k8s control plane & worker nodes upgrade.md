# k8s control plane & worker nodes upgrade

In general, automatic cluster upgrades via Ansible are not recommended - the roles were primarily intended for quickly provisioning a cluster or individual nodes, and automated upgrades may lead to overlooked errors.
* IMPORTANT:** start by upgrading the k8s-02 cluster, test it thoroughly, and only then proceed with upgrading the k8s-01 cluster. It's also critical to **read the release notes** ***before*** performing the upgrade.

It is recommended to perform upgrades manually by following the official Kubernetes documentation:

<https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/>

However, after the upgrade, it's necessary to sync the component versions in the [host_vars](https://github.com/konturio/puppetmaster2022/blob/2f23442a22f6b4b1ea3aa1d54a2d11949daca3da/provisioning/host_vars/node01.k8s-02.kontur.io/vars.yml#L10-L14 "https://github.com/konturio/puppetmaster2022/blob/2f23442a22f6b4b1ea3aa1d54a2d11949daca3da/provisioning/host_vars/node01.k8s-02.kontur.io/vars.yml#L10-L14") files for each node to reflect the actual state.

Post-upgrade checklist:
* All nodes are in Ready status
* Kubernetes version matches the expected one (kubectl version)
* No issues with pods in kube-system (kubectl get pods -A)
* Component versions synced in vars.yml
* Core features and workloads tested
* Logs checked (kubectl logs, dmesg, journalctl)
* Grafana dashboards for system components and services were checked for anomalies over the past 2 days since the upgrade
