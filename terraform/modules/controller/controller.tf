resource "azurerm_network_interface" "controller" {
  name                = "controller${ count.index + 1 }"
  location            = "${ var.location }"
  resource_group_name = "${ var.resource_group_name }"

  count = "${ var.master_count }"

  ip_configuration {
    name                                    = "private"
    subnet_id                               = "${ var.private-subnet-id }"
    private_ip_address_allocation           = "dynamic"
    load_balancer_backend_address_pools_ids = ["${ var.backend_pool_ids }"]
  }
}

resource "azurerm_dns_a_record" "A-controllers" {
  count = "${ var.master_count }"

  name                = "controller${ count.index+1 }"
  zone_name           = "${ var.internal-tld }"
  resource_group_name = "${ var.resource_group_name }"
  ttl                 = 300

  records = [
    "${ azurerm_network_interface.controller.*.private_ip_address[count.index] }",
  ]
}

resource "azurerm_availability_set" "controlleravset" {
  name                         = "controlleravset"
  location                     = "${var.location}"
  resource_group_name          = "${ var.resource_group_name }"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_virtual_machine" "controller" {
  name                  = "k8scontroller${ count.index + 1 }"
  location              = "${ var.location }"
  resource_group_name   = "${ var.resource_group_name }"
  network_interface_ids = ["${azurerm_network_interface.controller.*.id[count.index]}"]
  availability_set_id   = "${azurerm_availability_set.controlleravset.id}"
  vm_size               = "Standard_DS1_v2"

  count = "${ var.master_count }"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${ var.image_id }"
  }

  storage_os_disk {
    name              = "controllerosdisk${ count.index + 1 }"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "controllerdatadisk${ count.index + 1 }"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  os_profile {
    computer_name  = "k8scontroller${ count.index + 1 }"
    admin_username = "ubuntu"
    admin_password = "Kangaroo-jeremiah-thereon1!"

    custom_data = "${element(data.template_file.cloud-config.*.rendered, count.index)}"
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
    host                = "${azurerm_network_interface.controller.*.private_ip_address[count.index]}"
    bastion_host        = "${ var.bastion-ip }"
    bastion_private_key = "${ data.template_file.ssh-private-key.rendered }"
    user                = "ubuntu"
    type                = "ssh"
    private_key         = "${ data.template_file.ssh-private-key.rendered }"
    timeout             = "5m"
    agent               = true
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/ca.pem"
    destination = "/home/ubuntu/ca.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/ca-key.pem"
    destination = "/home/ubuntu/ca-key.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/kube-apiserver.pem"
    destination = "/home/ubuntu/kube-apiserver.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/kube-apiserver-key.pem"
    destination = "/home/ubuntu/kube-apiserver-key.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/prepare_controller.sh"
    destination = "/home/ubuntu/prepare_controller.sh"
  }

  provisioner "remote-exec" {
    on_failure = "continue"

    inline = [
      "sudo /bin/bash -eux /home/ubuntu/prepare_controller.sh",
      "sudo rm /home/ubuntu/prepare_controller.sh",
    ]
  }

  tags {
    environment = "staging"
  }
}

data "template_file" "ssh-private-key" {
  template = "${ file( "${ path.module }/../../.keypair/${ var.name }.pem" )}"
}

data "template_file" "ssh-pub-key" {
  template = "${ file( "${ path.module }/../../.keypair/${ var.name }.pem.pub" )}"
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_virtual_machine.controller",
  ]
}
