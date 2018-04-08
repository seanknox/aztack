resource "null_resource" "pause" {
  provisioner "local-exec" {
    command = <<EOF
        sleep 5
      EOF
  }
}

resource "azurerm_subnet" "private" {
  depends_on = [
    "null_resource.pause",
  ]

  name                 = "private"
  resource_group_name  = "${ var.resource_group_name }"
  virtual_network_name = "${ var.name }"

  # 10.0.0.0/16 -> 10.0.128.0/17
  address_prefix = "${ cidrsubnet(var.cidr, 1, 1) }"
}
