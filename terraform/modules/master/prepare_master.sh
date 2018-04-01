#!/bin/bash -eux

# create SSL dirs
mkdir -p /etc/kubernetes/ssl
mkdir -p /etc/etcd/ssl

# copy TLS certs
cp /home/ubuntu/{ca,ca-key,kube-apiserver,kube-apiserver-key}.pem /etc/etcd/ssl/.
cp /home/ubuntu/{ca,ca-key,kube-apiserver,kube-apiserver-key}.pem /etc/kubernetes/ssl/.
rm /home/ubuntu/*.pem

# reinitialize daemons and start etcd + kube components
sudo systemctl daemon-reload
sudo systemctl enable etcd kube-apiserver kube-controller-manager kube-scheduler
sudo systemctl stop etcd
sudo systemctl start etcd kube-apiserver kube-controller-manager kube-scheduler
