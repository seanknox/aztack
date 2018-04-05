variable "name" {}
variable "location" {}
variable "etcd-ips" {}
variable "bastion-ip" {}
variable "private-subnet-id" {}
variable "storage_endpoint" {}
variable "image_id" {}
variable "internal-tld" {}
variable "resource_group_name" {}
variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}
