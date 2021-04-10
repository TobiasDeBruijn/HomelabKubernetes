# Deploying the Kubernetes Cluster

1. Fill up the`hosts` file

### Run ansible playbooks:
1. initial.yml
2. kube-dependencies.yml


### Create the cluster
1. One one of your master nodes: ``kubeadm init --pod-network-cidr 10.253.0.0/16 --service-cidr 10.254.0.0/16 --control-plane-endpoint 192.168.1.254 --apiserver-advertise-address 192.168.1.254 --upload-certs``
>Note: Replace the IPs with your own. In my case 192.168.1.254 is a virtual IP, assigned to nodes with keepalived
2. Join your masters and workers to the cluster with the provided commands by kubeadm.

### Install & Configure Calico
>See: https://docs.projectcalico.org/getting-started/kubernetes/quickstart
1. kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
2. kubectl apply -f /manifests/calico-custom-resources.yaml
3. watch kubectl get pods -n calico-system
>Note: Wait until ALL pods show RUNNING


### Install MetalLB
>See: https://metallb.universe.tf/installation/
1. `kubectl edit configmap -n kube-system kube-proxy`, change `strictARP: false` to `strictARP: true`
2. kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
3. kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
4. kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

### Configure MetalLB
>See: https://metallb.universe.tf/configuration/
5. kubectl apply -f /manifest/metallb.yaml

### Install NGINX Ingress Controller
1. kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/baremetal/deploy.yaml
2. Edit the NGINX ingress controller configuration: `kubectl -n ingress-nginx edit svc ingress-nginx-controller`. Change `type: NodePort` to `type: LoadBalancer`

You should now be able to see that the nginx-ingress-controller service has received External IP from MetalLB: `kubectl get svc -n ingress-nginx`  
This should give something like:
```
k8s@K8s-M1:~/manifests$ kubectl get svc -n ingress-nginx
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.254.183.79   10.10.10.10   80:30058/TCP,443:31237/TCP   58m
ingress-nginx-controller-admission   ClusterIP      10.254.64.193   <none>        443/TCP                      58m
```

## See also 
- https://github.com/leocavalcante/up-n-running-k8s
