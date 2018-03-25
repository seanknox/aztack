# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  client_secret   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  tenant_id       = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

data "azurerm_resource_group" "image" {
  name = "ACStackImages"
}

data "azurerm_image" "image" {
  name                = "acstack-ubuntu-17.10-1521986033"
  resource_group_name = "${data.azurerm_resource_group.image.name}"
}

resource "azurerm_resource_group" "acstack" {
  name     = "acstack"
  location = "West US 2"
}

resource "azurerm_virtual_network" "test" {
  name                = "acctvn"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.acstack.location}"
  resource_group_name = "${azurerm_resource_group.acstack.name}"
}

resource "azurerm_subnet" "master" {
  name                 = "mastersubnet"
  resource_group_name  = "${azurerm_resource_group.acstack.name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_network_interface" "master" {
  name                = "master${ count.index + 1 }"
  location            = "${azurerm_resource_group.acstack.location}"
  resource_group_name = "${azurerm_resource_group.acstack.name}"

  # count               = "${ length( split(",", var.master_ips) ) }"
  count = 3

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.master.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${lookup(var.master_ips, count.index)}"
  }
}

resource "azurerm_managed_disk" "master" {
  name                 = "datadisk_existing${ count.index + 1 }"
  count                = 3
  location             = "${azurerm_resource_group.acstack.location}"
  resource_group_name  = "${azurerm_resource_group.acstack.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_virtual_machine" "master" {
  name                  = "k8smaster${ count.index + 1 }"
  location              = "${azurerm_resource_group.acstack.location}"
  resource_group_name   = "${azurerm_resource_group.acstack.name}"
  network_interface_ids = ["${azurerm_network_interface.master.*.id[count.index]}"]
  vm_size               = "Standard_DS1_v2"

  # count                 = "${ length( split(",", var.master_ips) ) }"
  count = 3

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${data.azurerm_image.image.id}"
  }

  storage_os_disk {
    name              = "myosdisk${ count.index + 1 }"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new${ count.index + 1 }"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.master.*.name[count.index]}"
    managed_disk_id = "${azurerm_managed_disk.master.*.id[count.index]}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.master.*.disk_size_gb[count.index]}"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "staging"
  }
}
