variable "azure" {
  default = {
    subscription_id = ""
    client_id       = ""
    client_secret   = ""
    tenant_id       = ""
  }
}

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
