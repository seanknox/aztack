data "azurerm_resource_group" "image" {
  name = "ACStackImages"
}

data "azurerm_image" "image" {
  name                = "${ var.azure_image_name }"
  resource_group_name = "${data.azurerm_resource_group.image.name}"
}

resource "azurerm_public_ip" "bastion" {
  name                         = "bastion"
  location                     = "${ var.location }"
  resource_group_name          = "${ var.name }"
  public_ip_address_allocation = "static"

  tags {
    environment = "test"
  }
}

resource "azurerm_network_interface" "bastion" {
  name                = "bastion"
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"

  ip_configuration {
    name                          = "private"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.bastion.id}"
  }
}

resource "azurerm_virtual_machine" "bastion" {
  name                  = "bastion"
  location              = "${ var.location }"
  resource_group_name   = "${ var.name }"
  network_interface_ids = ["${azurerm_network_interface.bastion.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${data.azurerm_image.image.id}"
  }

  storage_os_disk {
    name              = "bastionosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "bastion"
    admin_username = "ubuntu"
    admin_password = "Kangaroo-jeremiah-thereon1!"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys = [{
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${ data.template_file.ssh-pub-key.rendered }"
    }]
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${ var.storage_endpoint }"
  }

  connection {
    host        = "${azurerm_public_ip.bastion.ip_address}"
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${ data.template_file.ssh-private-key.rendered }"
    timeout     = "2m"
    agent       = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker run -d -p 8080:80 nginx",
    ]
  }

  tags {
    environment = "staging"
  }
}

data "template_file" "ssh-private-key" {
  template = "${ file( "${ path.module }/../../.keypair/acstack-${ var.name }.pem" )}"
}

data "template_file" "ssh-pub-key" {
  template = "${ file( "${ path.module }/../../.keypair/acstack-${ var.name }.pem.pub" )}"
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_virtual_machine.bastion",
  ]
}
