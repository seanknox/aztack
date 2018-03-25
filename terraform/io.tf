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
