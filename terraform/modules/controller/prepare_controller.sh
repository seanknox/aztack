#!/bin/bash -eu

# create SSL dirs
mkdir -p /etc/kubernetes/ssl
mkdir -p /etc/kubernetes/manifests
mkdir -p /var/lib/kubelet/pki/

# copy TLS certs
mv /home/ubuntu/{ca,ca-key,kube-apiserver,kube-apiserver-key}.pem /etc/kubernetes/ssl/.
mv kubelet{.crt,.key} /var/lib/kubelet/pki/

# reinitialize daemons and start etcd + kube components
sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy
sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy
