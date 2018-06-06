variable "azure" {
  default = {
    subscription_id = ""
    client_id       = ""
    client_secret   = ""
    tenant_id       = ""
  }
}

variable "cluster-domain" {
  default = "cluster.local"
}

variable "dns-service-ip" {
  default = "10.3.0.10"
}

variable "etcd-ips" {
  default = "10.0.30.10,10.0.30.11,10.0.30.12"
}

variable "master-ips" {
  default = "10.0.10.10,10.0.10.11,10.0.10.12"
}

variable "internal-tld" {}

variable "master_count" {
  default = 3
}

variable "node_count" {
  default = 3
}

variable "name" {}
variable "azure_vhd_uri" {}

variable "cidr" {
  default = {
    allow-ssh       = "0.0.0.0/0"
    pods            = "10.2.0.0/16"
    service-cluster = "10.3.0.0/24"
    vnet            = "10.0.0.0/16"
  }
}

variable "location" {
  default = "West US 2"
}

variable "kube-api-public-fqdn" {}
variable "kube-api-internal-ip" {}
variable "kube-api-internal-fqdn" {}

variable "bootstrap_token" {}

output "cluster-domain" {
  value = "${ var.cluster-domain }"
}

output "dns-service-ip" {
  value = "${ var.dns-service-ip }"
}

output "etcd1-ip" {
  value = "${ element( split(",", var.etcd-ips), 0 ) }"
}

output "internal-tld" {
  value = "${ var.internal-tld }"
}

output "name" {
  value = "${ var.name }"
}

output "location" {
  value = "${ var.location }"
}

output "kube-api-public-fqdn" {
  value = "${ var.kube-api-public-fqdn }"
}

output "kube-api-internal-ip" {
  value = "${ var.kube-api-internal-ip }"
}

output "bastion-ip" {
  value = "${ module.bastion.public-ip }"
}

output "ips" {
  value = "${
    map(
      "bastion", "${ module.bastion.public-ip }",
      "dns-service", "${ var.dns-service-ip }",
      "etcd", "${ var.etcd-ips }",
      "master", "${ var.master-ips }",
    )
  }"
}

# output "vm_ips" {
#   value = "${
#     map(
#       "node_private_ips", "${ module.node.node_private_ips }",
#       "controller_private_ips", "${ module.controller.controller_private_ips }"
#     )
#   }"
# }

output "bootstrap_token" {
  value = "${ var.bootstrap_token }"
}
