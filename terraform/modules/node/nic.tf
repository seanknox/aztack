resource "azurerm_network_interface" "pod" {
  name                 = "node${ count.index + 1 }pod"
  location             = "${ var.location }"
  resource_group_name  = "${ var.resource_group_name }"
  enable_ip_forwarding = true

  count = "${ var.node_count }"

  ip_configuration {
    name                          = "private1"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
    primary                       = true
  }

  ip_configuration {
    name                          = "private2"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private3"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private4"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private5"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private6"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private7"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private8"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private9"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private10"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private11"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private12"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private13"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private14"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private15"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private16"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private17"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private18"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private19"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private20"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private21"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private22"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private23"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private24"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private25"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private26"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private27"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private28"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private29"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private30"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private31"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private32"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private33"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private34"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private35"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private36"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private37"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private38"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private39"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private40"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private41"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private42"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private43"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private44"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private45"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private46"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private47"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private48"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private49"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private50"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private51"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private52"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private53"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private54"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private55"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private56"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private57"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private58"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private59"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private60"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private61"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private62"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private63"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private64"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private65"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private66"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private67"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private68"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private69"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private70"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private71"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private72"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private73"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private74"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private75"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private76"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private77"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private78"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private79"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private80"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private81"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private82"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private83"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private84"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private85"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private86"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private87"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private88"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private89"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private90"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private91"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private92"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private93"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private94"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private95"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private96"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private97"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private98"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private99"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private100"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private101"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private102"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private103"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private104"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private105"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private106"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private107"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private108"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private109"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private110"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }

  ip_configuration {
    name                          = "private111"
    subnet_id                     = "${ var.pod-subnet-id }"
    private_ip_address_allocation = "dynamic"
  }
}
