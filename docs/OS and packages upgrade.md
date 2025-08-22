# OS and packages upgrade

Field: Content

The distro used for k8s nodes is Debian 12 (bookworm).
* IMPORTANT:** upgrade the **test cluster** first, and only then proceed with the production cluster.

To upgrade the OS and system packages, clone the repository:

```
git clone https://github.com/konturio/puppetmaster2022
cd provisioning/
```

List the nodes in the playbook [k8s-master-hetzner-cloud.yml](https://github.com/konturio/puppetmaster2022/blob/main/provisioning/k8s-master-hetzner-cloud.yml) under the hosts section from the inventory file [k8s-inventory-test.yml](https://github.com/konturio/puppetmaster2022/blob/main/provisioning/inventory/k8s-inventory-test.yml) (or [k8s-inventory-prod.yml](https://github.com/konturio/puppetmaster2022/blob/main/provisioning/inventory/k8s-inventory-prod.yml "https://github.com/konturio/puppetmaster2022/blob/main/provisioning/inventory/k8s-inventory-prod.yml") for prod)

To upgrade **control-plane** nodes:

```
ansible-playbook -i inventory/k8s-inventory-test.yml k8s-master-hetzner-cloud.yml --tags system-upgrade -e "upgrade_system=true"
```

To upgrade **worker** nodes:

```
ansible-playbook -i inventory/k8s-inventory-test.yml k8s-worker-hetzner-cloud.yml --tags system-upgrade -e "upgrade_system=true"
```

Drain and reboot the nodes one by one with approximately a 20-minute interval if components like the kernel were upgraded.

```
kubectl drain <node>.k8s-0<x>.kontur.io --ignore-daemonsets --delete-emptydir-data
systemctl reboot
kubectl uncordon <node>.k8s-0<x>.kontur.io
```
