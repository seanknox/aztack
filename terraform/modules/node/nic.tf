resource "azurerm_network_interface" "node" {
  name                = "node${ count.index + 1 }"
  location            = "${ var.location }"
  resource_group_name = "${ var.resource_group_name }"

  count = "${ var.node_count }"

  ip_configuration {
    name                          = "private1"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
    primary                       = true
  }

  ip_configuration {
    name                          = "private2"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private3"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private4"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private5"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private6"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private7"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private8"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private9"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private10"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private11"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private12"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private13"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private14"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private15"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private16"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private17"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private18"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private19"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private20"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private21"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private22"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private23"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private24"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private25"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private26"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private27"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private28"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private29"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private30"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private31"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private32"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private33"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private34"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private35"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private36"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private37"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private38"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private39"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private40"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private41"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private42"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private43"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private44"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private45"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private46"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private47"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private48"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private49"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private50"
    subnet_id                     = "${ var.private-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }
}
