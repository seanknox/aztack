variable "name" {}
variable "location" {}
variable "private-subnet-id" {}
variable "depends-id" {}
variable "storage_endpoint" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "public-ip" {
  value = "${azurerm_public_ip.bastion.ip_address}"
}
