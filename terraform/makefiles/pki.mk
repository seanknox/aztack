## create PKI and k8s/etcd TLS certs
create-certs:
	mkdir -p $(DIR_SECRETS)
	./scripts/cfssl/generate_ca.sh
	./scripts/cfssl/generate_admin.sh
	./scripts/cfssl/generate_kube_proxy.sh
	./scripts/cfssl/generate_apiserver.sh

## delete SSH key-pair
delete-certs:
	@-rm -rf $(DIR_SECRETS)/

.PHONY: create-certs delete-certs
