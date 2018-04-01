# variable "etcd-ips" { default = "10.0.1.10,10.0.1.11,10.0.1.12" }
# variable "etcd-ips" {
#   default = "10.0.1.10"
# }

variable "etcd-ips" {}
variable "name" {}
variable "location" {}
variable "bastion-ip" {}
variable "private-subnet-id" {}
variable "depends-id" {}
variable "storage_endpoint" {}
variable "image_id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}
