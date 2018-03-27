#!/bin/bash -eux

kubernetes_release_tag="v1.9.6"

## Install official Kubernetes package

curl --silent "https://packages.cloud.google.com/apt/doc/apt-key.gpg" | apt-key add -

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

export DEBIAN_FRONTEND=noninteractive
apt_flags=(-o "Dpkg::Options::=--force-confnew" -qy)

apt-get update -q
apt-get upgrade "${apt_flags[@]}"
# TODO pin versions here
apt-get install "${apt_flags[@]}" docker.io kubelet kubeadm kubectl kubernetes-cni etcd

## Also install `jq`, `traceroute`, `ca-certificates`

apt-get install "${apt_flags[@]}" jq traceroute ca-certificates

## Pre-fetch Kubernetes release image, so that `kubeadm init` is a bit quicker

images=(
  "gcr.io/google_containers/kube-proxy-amd64:${kubernetes_release_tag}"
  "gcr.io/google_containers/kube-apiserver-amd64:${kubernetes_release_tag}"
  "gcr.io/google_containers/kube-scheduler-amd64:${kubernetes_release_tag}"
  "gcr.io/google_containers/kube-controller-manager-amd64:${kubernetes_release_tag}"
  "gcr.io/google_containers/etcd-amd64:3.1.10"
  "gcr.io/google_containers/pause-amd64:3.0"
  "gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.7"
  "gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.7"
  "gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.7"
)

for i in "${images[@]}" ; do docker pull "${i}" ; done

## Save release version, so that we can call `kubeadm init --use-kubernetes-version="$(cat /etc/kubernetes_community_vhd_version)` and ensure we get the same version
echo "${kubernetes_release_tag}" > /etc/kubernetes_community_vhd_version

## Cleanup packer SSH key and machine ID generated for this boot

rm /root/.ssh/authorized_keys
rm /home/packer/.ssh/authorized_keys
rm /etc/machine-id
touch /etc/machine-id

## Done!
