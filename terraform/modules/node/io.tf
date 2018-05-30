variable "name" {}
variable "location" {}
variable "private-subnet-id" {}
variable "node_count" {}

variable "bastion-ip" {
  type = "string"
}

variable "storage_endpoint" {
  type = "string"
}

variable "image_id" {
  type = "string"
}

variable "internal-tld" {
  type = "string"
}

variable "dns-service-ip" {
  type = "string"
}

variable "pod-cidr" {
  type = "string"
}

variable "resource_group_name" {
  type = "string"
}

variable "kube-api-internal-fqdn" {
  type = "string"
}

variable "bootstrap_token" {
  type = "string"
}

variable "azure" {
  type = "map"
}

variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "node_private_ips" {
  value = "${azurerm_network_interface.node.*.private_ip_address}"
}
