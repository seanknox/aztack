#!/bin/bash -e

set -x

SECRETS_DIR=$PWD/.secrets/${CLUSTER_NAME}
CFSSL_DIR=$(dirname "${BASH_SOURCE[0]}")

cfssl gencert -ca=$SECRETS_DIR/ca.pem \
    -ca-key=$SECRETS_DIR/ca-key.pem \
    -config=$CFSSL_DIR/ca-config.json \
    -profile=kubernetes $CFSSL_DIR/kube-proxy-csr.json | cfssljson -bare $SECRETS_DIR/kube-proxy
