#!/bin/bash -e

set -x

SECRETS_DIR=$PWD/.secrets
CFSSL_DIR=$(dirname "${BASH_SOURCE[0]}")

instance=$1

CSR=$(cat <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "San Francisco",
      "O": "system:nodes",
      "OU": "ACS",
      "ST": "CA"
    }
  ]
}
EOF
)

echo "$CSR" > $CFSSL_DIR/$instance-csr.json

cfssl gencert -ca=$SECRETS_DIR/ca.pem \
    -ca-key=$SECRETS_DIR/ca-key.pem \
    -config=$CFSSL_DIR/ca-config.json \
		-hostname=${instance} \
    -profile=kubernetes \
		 $CFSSL_DIR/$instance-csr.json | cfssljson -bare $SECRETS_DIR/${instance}

