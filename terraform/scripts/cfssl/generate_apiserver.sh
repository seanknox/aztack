#!/bin/bash -e

set -x

SECRETS_DIR=$PWD/.secrets
CFSSL_DIR=$(dirname "${BASH_SOURCE[0]}")

cfssl gencert -ca=$SECRETS_DIR/ca.pem \
    -ca-key=$SECRETS_DIR/ca-key.pem \
    -config=$CFSSL_DIR/ca-config.json \
	-hostname=${ETCD_IPS},${KUBE_API_PUBLIC_FQDN},${KUBE_API_INTERNAL_IP},127.0.0.1,kubernetes.default \
    -profile=kubernetes $CFSSL_DIR/kube-apiserver-csr.json | cfssljson -bare $SECRETS_DIR/kube-apiserver
