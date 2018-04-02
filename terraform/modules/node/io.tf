variable "name" {}
variable "location" {}
variable "private-subnet-id" {}
variable "node_count" {}
variable "depends-id" {}
variable "bastion-ip" {}
variable "storage_endpoint" {}
variable "image_id" {}
variable "internal-tld" {}
variable "dns-service-ip" {}
variable "pod-cidr" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "node_private_ips" {
  value = "${azurerm_network_interface.node.*.private_ip_address}"
}
