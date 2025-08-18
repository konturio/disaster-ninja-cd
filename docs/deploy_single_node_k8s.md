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

---

## 2. Install kubeadm / kubelet / kubectl (stable repo)

```bash
sudo apt -y install apt-transport-https ca-certificates curl gpg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt -y install kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

> If you want another minor version, replace `v1.30` accordingly in the repo URL.

---

## 3. Pick node interface and set kubelet node IP

Use the interface that should advertise the API server and node IP.

```bash
NODE_IF=enp195s0
POD_CIDR=192.168.0.0/16

NODE_IP=$(ip -4 addr show "$NODE_IF" | awk '/inet /{print $2}' | cut -d/ -f1)
echo "$NODE_IF -> $NODE_IP"

echo "KUBELET_EXTRA_ARGS=--node-ip=$NODE_IP" | sudo tee /etc/default/kubelet >/dev/null
sudo systemctl daemon-reload && sudo systemctl restart kubelet
```

---

## 4. Initialize control-plane

```bash
sudo kubeadm config images pull
sudo kubeadm init \
  --apiserver-advertise-address="$NODE_IP" \
  --pod-network-cidr="$POD_CIDR"
```

---

## 5. Configure kubectl for the current user

```bash
mkdir -p ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
kubectl get nodes
```

---

## 6. Install CNI (Calico)

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml
kubectl -n kube-system rollout status ds/calico-node --timeout=180s
```

---

## 7. Allow workloads on the control-plane

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true
kubectl describe node k8s-01 | grep -i '^Taints'
```

---

## 8. Quick test

```bash
kubectl create deploy whoami --image=traefik/whoami --replicas=1
kubectl expose deploy whoami --port 80 --target-port 80 --type=NodePort
kubectl get svc whoami -o wide
# Open: http://$NODE_IP:<nodePort>
```

---

## 9. Install Flux cli v2.1.2 and bootstrap

```bash
curl -s https://fluxcd.io/install.sh | sudo FLUX_VERSION=2.1.2 bash
flux check --pre
kubectl create ns flux-system
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

## 10. Reconcile

```bash
flux reconcile source git -n flux-system kontur-platform
flux reconcile source git -n flux-system flux-system
flux reconcile kustomization -n flux-system kontur-platform
```

---
