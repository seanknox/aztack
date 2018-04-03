variable "depends-id" {}
variable "etcd-ips" {}
variable "internal-tld" {}
variable "name" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}
