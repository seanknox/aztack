variable "master-ips" {
  default = "10.0.1.10,10.0.1.11,10.0.1.12"
}

variable "node_count" {
  default = 3
}

variable "name" {
  default = "acstack"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

variable "location" {
  default = "West US 2"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
