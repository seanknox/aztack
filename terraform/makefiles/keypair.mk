## create SSH key-pair
create-keypair:
	mkdir -p $(DIR_KEY_PAIR)
	ssh-keygen -t rsa -b 2048 -f $(DIR_KEY_PAIR)/$(AZURE_VM_KEY_NAME).pem
	@chmod 700 $(DIR_KEY_PAIR)/*

## delete SSH key-pair
delete-keypair:
	@-rm -rf $(DIR_KEY_PAIR)/

.PHONY: create-key-pair delete-key-pair
