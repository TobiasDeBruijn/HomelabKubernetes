# Changing Node IP
1. Make sure the Node VM has the new IP address, and can still route to the cluster
2. Stop kubelet, `systemctl stop kubelet`
3. Check every file in `/etc/kubernets` and subdirectories, and replace the old IP with the new IP in each of them
4. Delete the contents of `/etc/kubernetes/pki`
5. Regenerate certs: `kubeadm init phase certs all`
6. Restart kubelet: `systemctl restart kubelet`
7. On your master node, verify the node is up and Ready again.