#!/bin/bash -eu

_retry() {
  [ -z "${2}" ] && return 1
  echo -n ${1}
  until printf "." && "${@:2}" &>/dev/null; do sleep 5.2; done; echo "✓"
}


KUBE_API_INTERNAL_IP=$1
BOOTSTRAP_TOKEN=$2

IFS=. read TOKEN_ID TOKEN_CONTENT <<< $BOOTSTRAP_TOKEN
TOKENID_BASE64=$(base64 <<< $TOKEN_ID)
TOKEN_CONTENT_BASE64=$(base64 <<< $TOKEN_CONTENT)

# create SSL dirs
mkdir -p /etc/kubernetes/ssl
mkdir -p /etc/kubernetes/manifests

# copy TLS certs
cp /home/ubuntu/{ca,ca-key,kube-apiserver,kube-apiserver-key}.pem /etc/kubernetes/ssl/.
rm /home/ubuntu/*.pem

# copy manifests
cp /home/ubuntu/*.yml /etc/kubernetes/manifests

# reinitialize daemons and start etcd + kube components
sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler


echo "❤ Polling for cluster life - this could take a minute or more"
_retry "❤ Trying to connect to cluster with kubectl" kubectl cluster-info
_retry "❤ Waiting for kube-public namespace" kubectl get namespace kube-public

set -x

# apply RBAC roles for TLS bootstrapping
kubectl apply -f /etc/kubernetes/manifests/rbac.yml


cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  creationTimestamp: null
  name: bootstrap-token-${TOKEN_ID}
  namespace: kube-system
data:
  auth-extra-groups: c3lzdGVtOmJvb3RzdHJhcHBlcnM6a3ViZWFkbTpkZWZhdWx0LW5vZGUtdG9rZW4=
  description: VGhlIGRlZmF1bHQgYm9vdHN0cmFwIHRva2VuIGdlbmVyYXRlZCBieSAna3ViZWFkbSBpbml0Jy4=
  token-id: ${TOKENID_BASE64}
  token-secret: ${TOKEN_CONTENT_BASE64}
  usage-bootstrap-authentication: dHJ1ZQ==
  usage-bootstrap-signing: dHJ1ZQ==
type: bootstrap.kubernetes.io/token
EOF

CA_CRT_BASE64=$(cat /etc/kubernetes/ssl/ca.pem | base64 -w0)

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-info
  namespace: kube-public
data:
  kubeconfig: |
    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority-data: ${CA_CRT_BASE64}
        server: https://${KUBE_API_INTERNAL_IP}:6443
      name: ""
    contexts: []
    current-context: ""
    kind: Config
    preferences: {}
    users: []
EOF
