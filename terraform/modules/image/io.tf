variable "name" {}
variable "location" {}
variable "depends-id" {}
variable "azure_vhd_uri" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "image_id" {
  value = "${ azurerm_image.acs.id }"
}
