# Homelab Kubernetes
I currently run a 4-node Kubernetes cluster in my homelab

Currently I have:
- 1 master node
- 3 worker nodes

## Why?
To learn, mostly

## TODO
- [ ] Scale to 3 master nodes to get full HA
- [ ] keepalived to make sure my router can always route to the K8s cluster
- [ ] Moving all applications from current Docker and LXCs deployments into the cluster
