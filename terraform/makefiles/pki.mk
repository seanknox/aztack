## create PKI and k8s/etcd TLS certs
create-certs:
	mkdir -p $(DIR_SECRETS)
	./scripts/cfssl/generate_ca.sh
	./scripts/cfssl/generate_server.sh k8s_etcd $(ETCD_IPS)
	./scripts/cfssl/generate_server.sh k8s_master "$(ETCD_IPS),master.$(CLUSTER_NAME).acs,kubernetes.default,kubernetes"
	./scripts/cfssl/generate_client.sh k8s_master

## delete SSH key-pair
delete-certs:
	@-rm -rf $(DIR_SECRETS)/

.PHONY: create-certs delete-certs
