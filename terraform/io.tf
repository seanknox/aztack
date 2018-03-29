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

variable "master-ips" {
  default = "10.0.10.10,10.0.10.11,10.0.10.12"
}

variable "internal-tld" {}

variable "node_count" {
  default = 3
}

variable "name" {}
variable "azure_image_name" {}

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

output "bastion-ip" {
  value = "${ module.bastion.public-ip }"
}

output "cluster-domain" {
  value = "${ var.cluster-domain }"
}

output "dns-service-ip" {
  value = "${ var.dns-service-ip }"
}

output "master1-ip" {
  value = "${ element( split(",", var.master-ips), 0 ) }"
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
