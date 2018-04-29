#!/bin/bash -ux

KUBE_API_INTERNAL_IP=$1
BOOTSTRAP_TOKEN=$2
HOSTNAME=$3

# create SSL dirs
mkdir -p /etc/kubernetes/ssl
mkdir -p /var/lib/kubelet/pki
mkdir -p /var/lib/kube-proxy/pki

# copy TLS certs
cp /home/ubuntu/ca.pem /etc/kubernetes/ssl/.
cp /home/ubuntu/kubelet* /var/lib/kubelet/pki
cp /home/ubuntu/kube-proxy* /var/lib/kube-proxy/pki
rm /home/ubuntu/*{.pem,.crt,.key}

## Setup kubelet
sudo kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=https://${KUBE_API_INTERNAL_IP}:6443 \
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig

sudo kubectl config set-credentials system:node:${HOSTNAME} \
  --client-certificate=/var/lib/kubelet/pki/kubelet.crt \
  --client-key=/var/lib/kubelet/pki/kubelet.key \
  --embed-certs=true \
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig

sudo kubectl config set-context default \
  --cluster=kubernetes \
	--user=system:node:${HOSTNAME} \
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig

sudo kubectl config use-context default --kubeconfig=/etc/kubernetes/kubelet.kubeconfig

## Setup kube-proxy
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem   --embed-certs=true \
	--server=https://${KUBE_API_INTERNAL_IP}:6443 \
	--kubeconfig=/var/lib/kube-proxy/kube-proxy.kubeconfig

kubectl config set-credentials kube-proxy \
  --client-certificate=/var/lib/kube-proxy/pki/kube-proxy.crt \
	--client-key=/var/lib/kube-proxy/pki/kube-proxy.key \
	--embed-certs=true \
	--kubeconfig=/var/lib/kube-proxy/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes \
	--user=kube-proxy \
	--kubeconfig=/var/lib/kube-proxy/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=/var/lib/kube-proxy/kube-proxy.kubeconfig

# Hack to prevent CNI from disabling DNS resolver
sudo sed -i -- 's/#DNS=/DNS=168.63.129.16/g' /etc/systemd/resolved.conf

# reinitialize daemons and start kube components
sudo systemctl daemon-reload
sudo systemctl restart systemd-resolved
sudo systemctl enable containerd kubelet kube-proxy
sudo systemctl start containerd kubelet kube-proxy
