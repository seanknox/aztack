#!/bin/bash -eux

KUBE_API_INTERNAL_IP=$1

# create SSL dirs
mkdir -p /etc/kubernetes/ssl

# copy TLS certs
cp /home/ubuntu/*.pem /etc/kubernetes/ssl/.
rm /home/ubuntu/*.pem

sudo kubectl config set-cluster mycluster \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=https://${KUBE_API_INTERNAL_IP}:6443 \
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig

sudo kubectl config set-credentials system:node:${HOSTNAME} \
  --client-certificate=/etc/kubernetes/ssl/${HOSTNAME}.pem \
  --client-key=/etc/kubernetes/ssl/${HOSTNAME}-key.pem \
  --embed-certs=true \
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig

sudo kubectl config set-context default \
  --cluster=mycluster \
  --user=system:node:${HOSTNAME} \
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig

sudo kubectl config use-context default --kubeconfig=/etc/kubernetes/kubelet.kubeconfig
sudo chmod 644 /etc/kubernetes/kubelet.kubeconfig

sudo sed -i -- 's/#DNS=/DNS=168.63.129.16/g' /etc/systemd/resolved.conf

# reinitialize daemons and start kube components
sudo systemctl daemon-reload
sudo systemctl restart systemd-resolved
sudo systemctl enable docker kubelet
sudo systemctl start docker kubelet
