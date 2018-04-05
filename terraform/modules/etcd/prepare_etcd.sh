#!/bin/bash -eux

# create SSL dirs
mkdir -p /etc/kubernetes/ssl
mkdir -p /etc/etcd/ssl

# copy TLS certs
cp /home/ubuntu/{ca,ca-key,kube-apiserver,kube-apiserver-key}.pem /etc/etcd/ssl/.
cp /home/ubuntu/{ca,ca-key,kube-apiserver,kube-apiserver-key}.pem /etc/kubernetes/ssl/.
rm /home/ubuntu/*.pem

systemctl enable etcd.service
systemctl start etcd.service

mkdir -p /etc/systemd/system/etcd.service.d

cat <<EOF > /etc/systemd/system/etcd.service.d/local.conf
[Service]
Environment="ETCD_INITIAL_CLUSTER_STATE=existing"
EOF

systemctl daemon-reload
