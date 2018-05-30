DIR := ${CURDIR}

SHELL := docker rm -f ssh-agent > /dev/null 2>&1  || true; docker run -d --name=ssh-agent nardeas/ssh-agent > /dev/null 2>&1  || true; docker run --volumes-from=ssh-agent -e SSH_AUTH_SOCK=/.ssh-agent/socket ${DOCKER_ARGS} ${DOCKER_IMAGE} /bin/bash

shell : SHELL := $(LOCAL_SHELL)
mount-ssh-container : SHELL := $(LOCAL_SHELL)

shell: mount-ssh-container
	docker run --volumes-from=ssh-agent -e SSH_AUTH_SOCK=/.ssh-agent/socket ${DOCKER_ARGS} ${DOCKER_IMAGE} /bin/bash

mount-ssh-container:
	docker run --rm --volumes-from=ssh-agent -v $(DIR)/.keypair/$(CLUSTER_NAME):/root/.ssh/ -it nardeas/ssh-agent ssh-add /root/.ssh/$(CLUSTER_NAME).pem

.terraform: ; cd $(TERRAFORM_DIR) && terraform get

module.%:
	@echo "${BLUE}❤ make $@ - commencing${NC}"
	@time terraform apply -target $@
	@echo "${GREEN}✓ make $@ - success${NC}"
	@sleep 5.2

## terraform apply
apply: plan mount-ssh-container
	@echo "${BLUE}❤ terraform apply - commencing${NC}"
	terraform apply -state-out=$(TERRAFORM_DIR)/$(CLUSTER_NAME)/terraform.tfstate $(TERRAFORM_DIR)/$(CLUSTER_NAME)/terraform.tfplan
	@echo "${GREEN}✓ make $@ - success${NC}"

## terraform destroy
destroy:
	@echo "${RED}****** DESTRUCTIVE ACTION AHEAD! ******${NC}"
	$(DOCKER_CODE_PATH)/scripts/delete_cluster_resource_groups

## terraform get
get: ; terraform get

## generate variables
init:
	@cd $(TERRAFORM_DIR) && $(DOCKER_CODE_PATH)/scripts/init-variables

## terraform plan
plan: get
	terraform init
	terraform validate -var-file=$(TERRAFORM_DIR)/$(CLUSTER_NAME)/terraform.tfvars
	@echo "${GREEN}✓ terraform validate - success${NC}"
	terraform plan -state=$(TERRAFORM_DIR)/$(CLUSTER_NAME)/terraform.tfstate -var-file=$(TERRAFORM_DIR)/$(CLUSTER_NAME)/terraform.tfvars -out $(TERRAFORM_DIR)/$(CLUSTER_NAME)/terraform.tfplan

## terraform show
show: ; cd $(TERRAFORM_DIR) && terraform show

.PHONY: apply destroy get init module.% plan show foo
