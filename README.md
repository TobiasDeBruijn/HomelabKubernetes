# Homelab Kubernetes
I currently run a 10-node Kubernetes cluster in my homelab

### Cluster layout
- 4 master nodes
- 6 worker nodes

### Storage layout
- iSCSI for configuration, or when I need things to be fast (e.g Sonarr configuration)
- NFS for when storage can be a bit slower, or needs to be shared

### Network layout
- Calico as CNI
- MetalLB as loadbalancer
- NGINX Ingress

## Why?
To learn, mostly
