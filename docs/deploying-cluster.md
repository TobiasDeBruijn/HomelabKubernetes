# Deploying the Kubernetes Cluster

1. Fill up the`hosts` file

### Run ansible playbooks:
1. initial.yml
2. kube-dependencies.yml

### Create the cluster
1. One one of your master nodes: ``kubeadm init --upload-certs --pod-network-cidr 172.17.0.0/16 --service-cidr 10.80.4.0/22 --control-plane-endpoint kube-control.intern.array21.dev``
>Note: Replace the IPs with your own. kube-control.intern.array21.dev points to 10.10.4.254, a virtual IP, assigned to nodes with keepalived
2. Join **one** worker, then follow this document before joining more nodes.

### Install & Configure Calico
>See: https://docs.projectcalico.org/getting-started/kubernetes/quickstart
1. kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
2. kubectl apply -f kubernetes/manifests/system/calico.yaml
3. watch kubectl get pods -n calico-system
>Note: Wait until all pods show `Running`

### Install NGINX Ingress Controller
1. kubectl apply -f kubernetes/manifests/system/nginx.yaml

### Metrics server
1. kubectl apply -f kubernetes/manifests/system/metrics-server.yaml

### Certmanager
1. kubectl apply -f https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml
2. kubectl apply -f secrets/certmanager/cloudflare-array21.yaml
>Note: Also apply other secrets here
3. kubectl apply -f kubernetes/manifests/system/certmanager/letsencrypt-array21.yaml
>Note: Also apply other secrets here

### Longhorn
1. kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.1.2/deploy/longhorn.yaml
2. kubectl apply -f kubernetes/manifests/system/longhorn/ingress.yaml
3. kubectl create -f https://raw.githubusercontent.com/longhorn/longhorn/v1.1.2/examples/storageclass.yaml


## See also 
- https://github.com/leocavalcante/up-n-running-k8s
