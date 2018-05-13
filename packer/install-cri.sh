#!/bin/bash -eux

# export DEBIAN_FRONTEND=noninteractive
# apt_flags=(-o "Dpkg::Options::=--force-confnew" -qy)

# mkdir /etc/docker
# mv $HOME/daemon.json /etc/docker/daemon.json
# apt-get install "${apt_flags[@]}" docker.io

wget -q --show-progress --https-only --timestamping \
"https://storage.googleapis.com/cri-containerd-release/cri-containerd-1.1.0.linux-amd64.tar.gz"
sudo tar -xvf cri-containerd-1.1.0.linux-amd64.tar.gz -C /


