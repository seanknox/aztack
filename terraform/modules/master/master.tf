data "azurerm_resource_group" "image" {
  name = "ACStackImages"
}

resource "azurerm_network_interface" "master" {
  name                = "master${ count.index + 1 }"
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"

  count = "${ length( split(",", var.etcd-ips) ) }"

  ip_configuration {
    name                          = "private"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "static"
    private_ip_address            = "${ element(split(",", var.etcd-ips), count.index) }"
  }
}

resource "azurerm_virtual_machine" "master" {
  name                  = "k8smaster${ count.index + 1 }"
  location              = "${ var.location }"
  resource_group_name   = "${ var.name }"
  network_interface_ids = ["${azurerm_network_interface.master.*.id[count.index]}"]
  vm_size               = "Standard_DS1_v2"

  count = "${ length( split(",", var.etcd-ips) ) }"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${ var.image_id }"
  }

  storage_os_disk {
    name              = "masterosdisk${ count.index + 1 }"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "masterdatadisk${ count.index + 1 }"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  os_profile {
    computer_name  = "k8smaster${ count.index + 1 }"
    admin_username = "ubuntu"
    admin_password = "Kangaroo-jeremiah-thereon1!"

    custom_data = "${ data.template_file.master_yaml.rendered }"
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
    host                = "${azurerm_network_interface.master.*.private_ip_address[count.index]}"
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
    destination = "/home/ubuntu/ca.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/k8s_etcd.pem"
    destination = "/home/ubuntu/etcd.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/k8s_etcd-key.pem"
    destination = "/home/ubuntu/etcd-key.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/k8s_master.pem"
    destination = "/home/ubuntu/apiserver.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/k8s_master-key.pem"
    destination = "/home/ubuntu/apiserver-key.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/client-k8s_master.pem"
    destination = "/home/ubuntu/client.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/client-k8s_master-key.pem"
    destination = "/home/ubuntu/client-key.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/prepare_master.sh"
    destination = "/home/ubuntu/prepare_master.sh"
  }

  provisioner "remote-exec" {
    on_failure = "continue"

    inline = [
      "sudo /bin/bash -eux /home/ubuntu/prepare_master.sh",
      "sudo rm /home/ubuntu/prepare_master.sh",
    ]
  }

  tags {
    environment = "staging"
  }
}

data "template_file" "master_yaml" {
  template = "${file("${path.module}/master.yaml")}"

  vars {
    INTERNAL_IP      = "${ element(split(",", var.etcd-ips), count.index) }"
    DNS_SERVICE_IP   = "${ var.dns-service-ip }"
    ETCD_IP1         = "${azurerm_network_interface.master.*.private_ip_address[0]}"
    ETCD_IP2         = "${azurerm_network_interface.master.*.private_ip_address[1]}"
    ETCD_IP3         = "${azurerm_network_interface.master.*.private_ip_address[2]}"
    POD_NETWORK      = "${ var.pod-cidr }"
    SERVICE_IP_RANGE = "${ var.service-cidr }"
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
    "azurerm_virtual_machine.master",
  ]
}
