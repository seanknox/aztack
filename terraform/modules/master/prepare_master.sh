#!/bin/bash -eux

# create SSL dirs
mkdir -p /etc/kubernetes/ssl
mkdir -p /etc/etcd/ssl

cp /home/ubuntu/{ca,etcd,etcd-key}.pem /etc/kubernetes/ssl/.
cp /home/ubuntu/{ca,apiserver,apiserver-key,client,client-key}.pem /etc/kubernetes/ssl/.
cp /home/ubuntu/{ca,client,client-key}.pem /etc/etcd/ssl/
rm /home/ubuntu/*.pem
