.terraform: ; terraform get

terraform.tfvars:
	@./scripts/init-variables

module.%:
	@echo "${BLUE}❤ make $@ - commencing${NC}"
	@time terraform apply -target $@
	@echo "${GREEN}✓ make $@ - success${NC}"
	@sleep 5.2

## terraform apply
apply: plan
	cd build/$(CLUSTER_NAME)
	@echo "${BLUE}❤ terraform apply - commencing${NC}"
	terraform apply terraform.tfplan
	@echo "${GREEN}✓ make $@ - success${NC}"

## terraform destroy
destroy:
	@echo "${RED}****** DESTRUCTIVE ACTION AHEAD! ******${NC}"
	@./scripts/delete_cluster_resource_groups

## terraform get
get: ; terraform get

## generate variables
init: terraform.tfvars

## terraform plan
plan: get init
	cd build/$(CLUSTER_NAME)
	terraform init
	terraform validate -var-file=build/$(CLUSTER_NAME)/terraform.tfvars
	@echo "${GREEN}✓ terraform validate - success${NC}"
	terraform plan -var-file=build/$(CLUSTER_NAME)/terraform.tfvars -out terraform.tfplan

## terraform show
show: ; terraform show

.PHONY: apply destroy get init module.% plan show
