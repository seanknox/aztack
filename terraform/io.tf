# variable "master-ips" { default = "10.0.1.10,10.0.1.11,10.0.1.12" }
# variable "master-ips" {
#   default = "10.0.1.10"
# }

variable "master_ips" {
  default = {
    "0" = "10.0.1.10"
    "1" = "10.0.1.11"
    "2" = "10.0.1.12"
  }
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
