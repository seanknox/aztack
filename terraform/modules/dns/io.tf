variable "etcd-ips" {}
variable "internal-tld" {}
variable "name" {}
variable "resource_group_name" { }
variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}
