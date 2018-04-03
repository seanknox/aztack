# variable "etcd-ips" { default = "10.0.1.10,10.0.1.11,10.0.1.12" }
# variable "etcd-ips" {
#   default = "10.0.1.10"
# }

variable "name" {}
variable "location" {}
variable "depends-id" {}

output "depends-id" {
  value = "${null_resource.dummy_dependency.id}"
}

output "backend_pool_id" {
  value = "${azurerm_lb_backend_address_pool.backend_pool.id}"
}

# output "public_load_balancer_ip" {
#   value = "${azurerm_public_ip.lbpip.ip_address}"
# }
