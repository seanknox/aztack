## create SSH key-pair
create-keypair:
	mkdir -p $(DIR_KEY_PAIR)/$(CLUSTER_NAME)
	ssh-keygen -t rsa -b 4096 -N "" -f $(DIR_KEY_PAIR)/$(CLUSTER_NAME)/$(AZURE_VM_KEY_NAME).pem
	@chmod 700 $(DIR_KEY_PAIR)/$(CLUSTER_NAME)/*

## delete SSH key-pair
delete-keypair:
	@-rm -rf $(DIR_KEY_PAIR)/$(CLUSTER_NAME)

.PHONY: create-key-pair delete-key-pair
