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
	--kubeconfig=/var/lib/kubelet/bootstrap.kubeconfig

sudo kubectl config set-credentials \
	kubelet-bootstrap --token=${NODE_TOKEN}
	--kubeconfig=/var/lib/kubelet/bootstrap.kubeconfig

sudo kubectl config set-context default \
  --cluster=mycluster \
  --kubeconfig=/var/lib/kubelet/bootstrap.kubeconfig

sudo kubectl config use-context default --kubeconfig=/var/lib/kubelet/bootstrap.kubeconfig
sudo chmod 644 /var/lib/kubelet/kubeconfig

sudo sed -i -- 's/#DNS=/DNS=168.63.129.16/g' /etc/systemd/resolved.conf

# reinitialize daemons and start kube components
sudo systemctl daemon-reload
sudo systemctl restart systemd-resolved
sudo systemctl enable docker kubelet
sudo systemctl start docker kubelet
