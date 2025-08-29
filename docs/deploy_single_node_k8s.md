# Single-node Kubernetes on Debian 12 + FluxCD

---

## Overview

- Debian 12
- Container runtime: **cri-o**
- Kubernetes install via **ansible (kubeadm)**
- CNI: **Calico**
- GitOps with **FluxCD** bootstrapped into an existing GitHub repo

---

## 1. Provisioning via ansible

```bash
git clone https://github.com/konturio/puppetmaster2022.git && cd puppetmaster2022.git 
git checkout k8s-setup
```
Adjust interface names, IPs, etc: 
https://github.com/konturio/puppetmaster2022/blob/400e6ff1946da1bbc96467810e17bf21a798dfc3/provisioning/inventory/k8s-inventory-prod.yml#L26

https://github.com/konturio/puppetmaster2022/blob/k8s-setup/provisioning/host_vars/k8s-01.local/vars.yml

Run:
```bash
cd provisioning
ansible-playbook -i inventory/k8s-inventory-prod.yml k8s-worker-hetzner-robot.yml -l k8s-01.local
```

Initialize cluster:
```bash
export POD_CIDR=192.168.0.0/16
export NODE_IP=<IP>
kubeadm init --apiserver-advertise-address="${NODE_IP}" --pod-network-cidr="${POD_CIDR}"
```

---

## 2. Configure kubectl for the current user

```bash
mkdir -p ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
kubectl get nodes
```

---

## 3. Install CNI (Calico)

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml
kubectl -n kube-system rollout status ds/calico-node --timeout=180s
```

---

## 4. Allow workloads on the control-plane

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true
kubectl describe node k8s-01 | grep -i '^Taints'
```

---

## 5. Quick test

```bash
kubectl create deploy whoami --image=traefik/whoami --replicas=1
kubectl expose deploy whoami --port 80 --target-port 80 --type=NodePort
kubectl get svc whoami -o wide
# Open: http://$NODE_IP:<nodePort>
```

---

## 6. Install Flux cli v2.1.2 and bootstrap

```bash
curl -s https://fluxcd.io/install.sh | sudo FLUX_VERSION=2.1.2 bash
flux check --pre
kubectl create ns flux-system
flux install
kubectl get pods -n flux-system # check

kubectl -n flux-system create secret generic disaster-ninja-cd-auth \
  --from-file=identity=$HOME/.ssh/<key> \
  --from-file=identity.pub=$HOME/.ssh/<key>.pub \
  --from-file=known_hosts=./known_hosts
```

```yaml
cat <<'EOF' | kubectl apply -f -
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: flux-system
  namespace: flux-system
spec:
  interval: 3m0s
  ref:
    branch: main
  secretRef:
    name: flux-system
  url: ssh://git@github.com/konturio/k8s-harlem.git
EOF

cat <<'EOF' | kubectl apply -f -
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: flux-system
  namespace: flux-system
spec:
  interval: 10m0s
  path: ./clusters/k8s-01
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
EOF
```
```bash
kubectl get pods -n flux-system 
flux get kustomizations -A
```

---

## 7. Reconcile

```bash
flux reconcile source git -n flux-system kontur-platform
flux reconcile source git -n flux-system flux-system
flux reconcile kustomization -n flux-system kontur-platform
```

---
