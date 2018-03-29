variable "depends-id" {}
variable "etcd-ips" {}
variable "internal-tld" {}
variable "name" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "internal-zone-id" {
  value = "${ azurerm_dns_zone.internal.id }"
}
