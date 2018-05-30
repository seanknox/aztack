#!/bin/bash -e

set -x

SECRETS_DIR=$PWD/.secrets/${CLUSTER_NAME}
CFSSL_DIR=$(dirname "${BASH_SOURCE[0]}")

cfssl gencert -ca=$SECRETS_DIR/ca.pem \
    -ca-key=$SECRETS_DIR/ca-key.pem \
    -config=$CFSSL_DIR/ca-config.json \
	-hostname=etcd1.${INTERNAL_TLD},etcd2.${INTERNAL_TLD},etcd3.${INTERNAL_TLD},${ETCD_IPS},${MASTER_IPS},controller1.${INTERNAL_TLD},controller2.${INTERNAL_TLD},controller3.${INTERNAL_TLD},${KUBE_API_PUBLIC_FQDN},${KUBE_API_INTERNAL_IP},10.0.0.1,127.0.0.1,${KUBE_API_INTERNAL_FQDN},kubernetes.default \
    -profile=kubernetes $CFSSL_DIR/kube-apiserver-csr.json | cfssljson -bare $SECRETS_DIR/kube-apiserver
