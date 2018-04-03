# variable "etcd-ips" { default = "10.0.1.10,10.0.1.11,10.0.1.12" }
# variable "etcd-ips" {
#   default = "10.0.1.10"
# }

variable "name" {}
variable "location" {}
variable "kube-api-internal-ip" {}
variable "private-subnet-id" {}
variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "public_backend_pool_id" {
  value = "${azurerm_lb_backend_address_pool.public_backend_pool.id}"
}

output "private_backend_pool_id" {
  value = "${azurerm_lb_backend_address_pool.private_backend_pool.id}"
}

# output "public_load_balancer_ip" {
#   value = "${azurerm_public_ip.lbpip.ip_address}"
# }

