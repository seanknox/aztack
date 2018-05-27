SHELL += -eu

BLUE	:= \033[0;34m
GREEN	:= \033[0;32m
RED   := \033[0;31m
NC    := \033[0m

export DIR_KEY_PAIR   := .keypair
export DIR_SECRETS 		:= .secrets
export DIR_SSL        := .secrets
export DIR_KUBECONFIG := .kube

# CIDR_PODS: flannel overlay range
# - https://coreos.com/flannel/docs/latest/flannel-config.html
#
# CIDR_SERVICE_CLUSTER: apiserver parameter --service-cluster-ip-range
# - http://kubernetes.io/docs/admin/kube-apiserver/
#
# CIDR_VNET: VNET subnet
# - https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html#address_prefix
#

# ∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨∨

export LOCATION       		 ?= westus2
export KUBE_API_PUBLIC_FQDN      := $(CLUSTER_NAME).$(LOCATION).cloudapp.azure.com

export AZURE_VM_KEY_NAME    ?= $(CLUSTER_NAME)
export AZURE_VM_KEY_PATH    := ${DIR_KEY_PAIR}/$(CLUSTER_NAME)/${AZURE_VM_KEY_NAME}.pem
# docker.io
# export AZURE_VHD_URI 				?= https://acstackimages.blob.core.windows.net/system/Microsoft.Compute/Images/acs-vhds/acstack-1526251964-osDisk.7fdd6d44-e3bd-4020-8033-47877b422c07.vhd
# cri/containerd/runc
export AZURE_VHD_URI 				?= https://atack.blob.core.windows.net/system/Microsoft.Compute/Images/atack-vhds/atack-1526674778-osDisk.be03a407-d029-457b-8c64-02a8b0441850.vhd
export INTERNAL_TLD         := ${CLUSTER_NAME}.atack

export CIDR_VNET            ?= 10.0.0.0/8
export CIDR_CONTROLLER      ?= 10.10.0.0/24
export CIDR_NODE        	  ?= 10.20.0.0/24
export CIDR_ETCD        	  ?= 10.30.0.0/24
export CIDR_DMZ        	    ?= 10.254.250.0/24
export CIDR_PODS            ?= 192.168.0.0/16
export CIDR_SERVICE_CLUSTER ?= 10.0.0.0/16

export K8S_SERVICE_IP       ?= 10.0.0.1
export K8S_DNS_IP           ?= 10.0.0.10
export KUBE_API_INTERNAL_IP	?= 10.10.0.250

export ETCD_IPS           	?= 10.30.0.10,10.30.0.11,10.30.0.12
export MASTER_IPS           ?= 10.20.0.247,10.20.0.248,10.20.0.249
export NODE_COUNT 					?= 1

ifndef CLUSTER_NAME
$(error CLUSTER_NAME is not set)
endif

# Alternative:
# CIDR_PODS ?= "172.15.0.0/16"
# CIDR_SERVICE_CLUSTER ?= "172.16.0.0/24"
# K8S_SERVICE_IP ?= 172.16.0.1
# K8S_DNS_IP ?= 172.16.0.10

# This file must exist before starting the container or it gets created as a
# directory. This is done automatically in the prereqs target
export SP_PATH := $(HOME)/.azure/atack-sp.json
export DOCKER_SP_PATH := /root/$(CLUSTER_NAME).json

# Wrap the makefile shell in a Docker container
# by setting the SHELL variable. We store the
# original value for later so that targets can
# override the wrapped shell and use the host instead
# i.e. `mytarget : SHELL := $(LOCAL_SHELL)`.
LOCAL_SHELL := $(SHELL)
DOCKER_IMAGE ?= atack
DOCKER_CODE_PATH := /src
DOCKER_ARGS ?= -it --rm \
	-v ${HOME}/.azure:/root/.azure \
	-v ${PWD}:${DOCKER_CODE_PATH} -w ${DOCKER_CODE_PATH} \
	-v ${SP_PATH}:${DOCKER_SP_PATH} \
	-e CLUSTER_NAME=${CLUSTER_NAME} \
	-e LOCATION=${LOCATION} \
	-e SP_PATH=${DOCKER_SP_PATH} \
	-e AZURE_VHD_URI=${AZURE_VHD_URI} \
	-e INTERNAL_TLD=${INTERNAL_TLD} \
	-e CIDR_VNET=${CIDR_VNET} \
	-e CIDR_CONTROLLER=${CIDR_CONTROLLER} \
	-e CIDR_NODE=${CIDR_NODE} \
	-e CIDR_ETCD=${CIDR_ETCD} \
	-e CIDR_DMZ=${CIDR_DMZ} \
	-e CIDR_PODS=${CIDR_PODS} \
	-e CIDR_SERVICE_CLUSTER=${CIDR_SERVICE_CLUSTER} \
	-e K8S_SERVICE_IP=${K8S_SERVICE_IP} \
	-e K8S_DNS_IP=${K8S_DNS_IP} \
	-e KUBE_API_PUBLIC_FQDN=${KUBE_API_PUBLIC_FQDN} \
	-e KUBE_API_INTERNAL_IP=${KUBE_API_INTERNAL_IP} \
	-e MASTER_IPS=${MASTER_IPS} \
	-e ETCD_IPS=${ETCD_IPS} \
	-e NODE_COUNT=${NODE_COUNT}
SHELL := docker run ${DOCKER_ARGS} ${DOCKER_IMAGE} /bin/bash

export TERRAFORM_DIR := ./build

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.addons: ; @scripts/do-task "initialize add-ons" ./scripts/init-addons

## generate key-pair, variables and then `terraform apply`
all: prereqs create-keypair create-certs init apply
	@echo "${GREEN}✓ terraform portion of 'make all' has completed ${NC}\n"
	@$(MAKE) post-terraform

.PHONY: post-terraform
post-terraform:
	@$(MAKE) create-kubeconfig
	@$(MAKE) wait-for-cluster
	@$(MAKE) create-tls-bootstrap-config
	@$(MAKE) create-addons
	kubectl get nodes -o wide
	kubectl --namespace=kube-system get cs
	@echo "View nodes:"
	@echo "% make nodes"
	@echo "---"
	@echo "View uninitialized kube-system pods:"
	@echo "% make pods"
	@echo "---"
	@echo "Status summaries:"
	@echo "% make status"
	@echo "---"


## destroy and remove everything
clean: destroy delete-keypair
	@-pkill -f "kubectl proxy" ||:
	@-rm -rf build/${CLUSTER_NAME}
	@-rm -rf tmp ||:
	@-rm -rf ${DIR_SSL}/${CLUSTER_NAME} ||:
	@-kubectl config delete-cluster cluster-${CLUSTER_NAME}
	@-kubectl config delete-context ${CLUSTER_NAME}

## create tls bootstrap config
create-tls-bootstrap-config:
	@scripts/create-bootstrap-rbac
	@scripts/create-bootstrap-secret

## create kube-system addons
create-addons:
	scripts/create-default-storage-class
	scripts/create-kube-dns-service
	scripts/create-kube-system-configmap
	kubectl apply --recursive -f addons

create-admin-certificate: ; @scripts/do-task "create admin certificate" \
	scripts/create-admin-certificate

create-busybox: ; @scripts/do-task "create busybox test pod" \
	kubectl create -f test/pods/busybox.yml

create-kubeconfig: ; @scripts/do-task "create kubeconfig" \
	scripts/create-kubeconfig

## start proxy and open kubernetes dashboard
dashboard: ; @./scripts/dashboard

prereqs : SHELL := $(LOCAL_SHELL)
prereqs:
	touch $(SP_PATH)
	docker build -t $(DOCKER_IMAGE) .

## ssh into hostname=host
ssh: ; @scripts/ssh "ssh $(hostname).$(INTERNAL_TLD)"

## ssh into bastion host
ssh-bastion: ; @scripts/ssh

wait-for-cluster: ; @scripts/do-task "wait-for-cluster" scripts/wait-for-cluster

include makefiles/*.mk

.DEFAULT_GOAL := help
.PHONY: all clean create-addons create-admin-certificate create-busybox
.PHONY: delete-addons get-ca instances journal prereqs ssh ssh-bastion ssl
.PHONY: status test wait-for-cluster
