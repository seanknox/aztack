#!/bin/bash -eux

# create SSL dirs
mkdir -p /etc/kubernetes/ssl

# copy TLS certs
cp /home/ubuntu/*.pem /etc/kubernetes/ssl/.
rm /home/ubuntu/*.pem

sudo kubectl config set-cluster mycluster \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=https://10.0.10.250:6443 \
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

# reinitialize daemons and start kube components
sudo systemctl daemon-reload
sudo systemctl enable docker kubelet
sudo systemctl start docker kubelet
