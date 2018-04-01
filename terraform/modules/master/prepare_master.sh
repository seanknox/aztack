#!/bin/bash -eux

# create SSL dirs
mkdir -p /etc/kubernetes/ssl
mkdir -p /etc/etcd/ssl

# copy TLS certs
cp /home/ubuntu/{ca,etcd,etcd-key}.pem /etc/etcd/ssl/.
cp /home/ubuntu/{ca,apiserver,apiserver-key,client,client-key,etcd,etcd-key}.pem /etc/kubernetes/ssl/.
rm /home/ubuntu/*.pem

sudo systemctl daemon-reload
sudo systemctl stop etcd2
sudo systemctl start etcd2
