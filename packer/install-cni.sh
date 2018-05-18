#!/bin/bash -eux

calico_release_tag="v3.1.2"
cni_plugins_release_tag="v0.7.1"

# Download CNI networking components
wget -q --show-progress --https-only --timestamping \
	"https://github.com/projectcalico/cni-plugin/releases/download/${calico_release_tag}/calico" \
	"https://github.com/projectcalico/cni-plugin/releases/download/${calico_release_tag}/calico-ipam" \
	"https://github.com/containernetworking/plugins/releases/download/${cni_plugins_release_tag}/cni-plugins-amd64-${cni_plugins_release_tag}.tgz"

# Create CNI conf and bin directories
mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin

# Install CNI
tar -xvf cni-plugins-amd64-${cni_plugins_release_tag}.tgz -C /opt/cni/bin/
mv calico* /opt/cni/bin




