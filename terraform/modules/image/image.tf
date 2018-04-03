resource "azurerm_image" "acs" {
  name                = "${ var.name }-image"
  location            = "${ var.location }"
  resource_group_name = "${ var.name }"

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = "${ var.azure_vhd_uri }"
    size_gb  = 30
  }
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_image.acs",
  ]
}
