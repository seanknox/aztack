#!/bin/bash -eu

KUBE_API_INTERNAL_IP=$1
BOOTSTRAP_TOKEN=$2

IFS=. read TOKEN_ID TOKEN_CONTENT <<< $BOOTSTRAP_TOKEN
TOKENID_BASE64=$(base64 <<< $TOKEN_ID)
TOKEN_CONTENT_BASE64=$(base64 <<< $TOKEN_CONTENT)

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
