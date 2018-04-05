# variable "etcd-ips" { default = "10.0.1.10,10.0.1.11,10.0.1.12" }
# variable "etcd-ips" {
#   default = "10.0.1.10"
# }

variable "name" {}
variable "location" {}
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
