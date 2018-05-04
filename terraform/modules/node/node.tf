resource "azurerm_dns_a_record" "A-node" {
  count = "${ var.node_count }"

  name                = "node${ count.index+1 }"
  zone_name           = "${ var.internal-tld }"
  resource_group_name = "${ var.resource_group_name }"
  ttl                 = 300

  records = [
    "${ azurerm_network_interface.node.*.private_ip_address[count.index] }",
  ]
}

resource "null_resource" "node_cert" {
  count = "${ var.node_count }"

  # Generate node client certificate
  provisioner "local-exec" {
    command = <<EOF
        ${path.module}/../../scripts/cfssl/generate_node.sh "node${ count.index + 1 }.${ var.internal-tld }"
      EOF
  }
}

resource "azurerm_availability_set" "nodeavset" {
  name                         = "nodeavset"
  location                     = "${var.location}"
  resource_group_name          = "${ var.resource_group_name }"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_virtual_machine" "node" {
  name                = "node${ count.index + 1 }.${ var.internal-tld }"
  location            = "${ var.location }"
  resource_group_name = "${ var.resource_group_name }"

  network_interface_ids = [
    "${azurerm_network_interface.node.*.id[count.index]}",
    "${azurerm_network_interface.pod.*.id[count.index]}",
  ]

  primary_network_interface_id = "${azurerm_network_interface.node.*.id[count.index]}"

  availability_set_id = "${azurerm_availability_set.nodeavset.id}"
  vm_size             = "Standard_DS1_v2"

  count = "${ var.node_count }"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${ var.image_id }"
  }

  storage_os_disk {
    name              = "nodeosdisk${ count.index + 1 }"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "nodedatadisk${ count.index + 1 }"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  os_profile {
    computer_name  = "node${ count.index + 1 }"
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
    host                = "${azurerm_network_interface.node.*.private_ip_address[count.index]}"
    bastion_host        = "${ var.bastion-ip }"
    bastion_private_key = "${ data.template_file.ssh-private-key.rendered }"
    user                = "ubuntu"
    type                = "ssh"
    private_key         = "${ data.template_file.ssh-private-key.rendered }"
    timeout             = "5m"
    agent               = true
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/${ var.name }/ca.pem"
    destination = "/home/ubuntu/ca.pem"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/${ var.name }/kube-proxy.pem"
    destination = "/home/ubuntu/kube-proxy.crt"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/${ var.name }/node${ count.index + 1 }.${ var.internal-tld }.pem"
    destination = "/home/ubuntu/kubelet.crt"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/${ var.name }/node${ count.index + 1 }.${ var.internal-tld }-key.pem"
    destination = "/home/ubuntu/kubelet.key"
  }

  provisioner "file" {
    source      = "${ path.module }/../../.secrets/${ var.name }/kube-proxy-key.pem"
    destination = "/home/ubuntu/kube-proxy.key"
  }

  provisioner "file" {
    source      = "${ path.module }/prepare_node.sh"
    destination = "/home/ubuntu/prepare_node.sh"
  }

  provisioner "remote-exec" {
    on_failure = "continue"

    inline = [
      "sudo /bin/bash -eux /home/ubuntu/prepare_node.sh ${ var.kube-api-internal-ip } ${ var.bootstrap_token } node${ count.index + 1 }.${ var.internal-tld }",
      "sudo rm /home/ubuntu/prepare_node.sh",
    ]
  }

  tags {
    environment = "staging"
  }
}

data "template_file" "cloud-config" {
  template = "${file("${path.module}/cloud-config.yaml")}"
  count    = "${ var.node_count }"

  vars {
    HOSTNAME       = "node${ count.index + 1 }.${ var.internal-tld}"
    DNS_SERVICE_IP = "${ var.dns-service-ip }"
    POD_CIDR       = "${ var.pod-cidr }"
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
    "azurerm_virtual_machine.node",
  ]
}
