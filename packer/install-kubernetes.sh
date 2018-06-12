#!/bin/bash -eux

kubernetes_release_tag="v1.10.4"

export DEBIAN_FRONTEND=noninteractive
apt_flags=(-o "Dpkg::Options::=--force-confnew" -qy)

apt-get update -q
apt-get upgrade "${apt_flags[@]}"

apt-get install "${apt_flags[@]}" conntrack ipset socat jq traceroute ca-certificates

# Download the official Kubernetes release binaries
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/${kubernetes_release_tag}/bin/linux/amd64/kube-apiserver" \
  "https://storage.googleapis.com/kubernetes-release/release/${kubernetes_release_tag}/bin/linux/amd64/kube-controller-manager" \
  "https://storage.googleapis.com/kubernetes-release/release/${kubernetes_release_tag}/bin/linux/amd64/kube-scheduler" \
	"https://storage.googleapis.com/kubernetes-release/release/${kubernetes_release_tag}/bin/linux/amd64/kube-proxy" \
	"https://storage.googleapis.com/kubernetes-release/release/${kubernetes_release_tag}/bin/linux/amd64/kubelet" \
  "https://storage.googleapis.com/kubernetes-release/release/${kubernetes_release_tag}/bin/linux/amd64/kubectl"

# Install the Kubernetes binaries
chmod +x kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy kubectl
mv kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy kubectl /usr/local/bin/

## Save release version, so that we can call `kubeadm init --use-kubernetes-version="$(cat /etc/kubernetes_community_vhd_version)` and ensure we get the same version
echo "${kubernetes_release_tag}" > /etc/kubernetes_community_vhd_version
