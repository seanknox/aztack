#!/bin/bash -eux

cni_release_tag="v1.0.4"

# Download CNI networking components
wget -q --show-progress --https-only --timestamping \
	"https://github.com/Azure/azure-container-networking/releases/download/${cni_release_tag}/azure-vnet-cni-linux-amd64-${cni_release_tag}.tgz" \
	"https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz"

# Create CNI conf and bin directories
mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin

# Install CNI
tar -xvf cni-plugins-amd64-v0.6.0.tgz -C /opt/cni/bin/
tar -xvf azure-vnet-cni-linux-amd64-${cni_release_tag}.tgz
mv azure-vnet azure-vnet-ipam /opt/cni/bin
mv 10-azure.conflist /etc/cni/net.d




