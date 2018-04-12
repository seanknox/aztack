#!/bin/bash -ux

KUBE_API_INTERNAL_IP=$1
BOOTSTRAP_TOKEN=$2

# create SSL dirs
mkdir -p /etc/kubernetes/ssl

# copy TLS certs
cp /home/ubuntu/*.pem /etc/kubernetes/ssl/.
rm /home/ubuntu/*.pem

sudo kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=https://${KUBE_API_INTERNAL_IP}:6443 \
  --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

sudo kubectl config set-credentials \
  tls-bootstrap-token-user --token=${BOOTSTRAP_TOKEN} \
  --user=tls-bootstrap-token-user \
  --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

sudo kubectl config set-context default \
  --cluster=kubernetes \
  --user=tls-bootstrap-token-user \
  --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

sudo kubectl config use-context default --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

sudo sed -i -- 's/#DNS=/DNS=168.63.129.16/g' /etc/systemd/resolved.conf

# reinitialize daemons and start kube components
sudo systemctl daemon-reload
sudo systemctl restart systemd-resolved
sudo systemctl enable docker kubelet
sudo systemctl start docker kubelet
