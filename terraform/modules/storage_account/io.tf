variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "primary_blob_endpoint" {
  value = "${ azurerm_storage_account.diag.primary_blob_endpoint }"
}
