#!/bin/bash -eu

# create SSL dirs
mkdir -p /etc/kubernetes/ssl
mkdir -p /etc/kubernetes/manifests

# copy TLS certs
cp /home/ubuntu/{ca,ca-key,kube-apiserver,kube-apiserver-key}.pem /etc/kubernetes/ssl/.
rm /home/ubuntu/*.pem

# reinitialize daemons and start etcd + kube components
sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler
