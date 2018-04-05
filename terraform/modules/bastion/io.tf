variable "name" {}
variable "location" {}
variable "private-subnet-id" {}
variable "storage_endpoint" {}
variable "resource_group_name" {}
variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "public-ip" {
  value = "${azurerm_public_ip.bastion.ip_address}"
}
