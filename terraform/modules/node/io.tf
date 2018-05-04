variable "name" {}
variable "location" {}
variable "private-subnet-id" {}
variable "pod-subnet-id" {}
variable "node-subnet-id" {}
variable "node_count" {}
variable "bastion-ip" {}
variable "storage_endpoint" {}
variable "image_id" {}
variable "internal-tld" {}
variable "dns-service-ip" {}
variable "pod-cidr" {}
variable "resource_group_name" {}
variable "kube-api-internal-ip" {}
variable "bootstrap_token" {}
variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "node_private_ips" {
  value = "${azurerm_network_interface.node.*.private_ip_address}"
}
