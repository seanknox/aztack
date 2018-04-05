variable "name" {}
variable "location" {}
variable "master_count" {}
variable "etcd-ips" {}
variable "dns-service-ip" {}
variable "pod-cidr" {}
variable "service-cidr" {}
variable "bastion-ip" {}
variable "private-subnet-id" {}
variable "storage_endpoint" {}
variable "image_id" {}
variable "internal-tld" {}
variable "resource_group_name" {}
variable "depends-id" {}

variable "backend_pool_ids" {
  type = "list"
}

variable "azure" {
  type = "map"
}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "controller_private_ips" {
  value = "${azurerm_network_interface.controller.*.private_ip_address}"
}
