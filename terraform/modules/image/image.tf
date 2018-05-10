resource "azurerm_storage_account" "acstack" {
  name                     = "acstack${ var.name }"
  resource_group_name      = "${ var.resource_group_name }"
  location                 = "${ var.location }"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "acstack" {
  name                  = "vhds"
  resource_group_name   = "${ var.resource_group_name }"
  storage_account_name  = "${ azurerm_storage_account.acstack.name }"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "acstack" {
  name = "acstack.vhd"

  resource_group_name    = "${ var.resource_group_name }"
  storage_account_name   = "${ azurerm_storage_account.acstack.name }"
  storage_container_name = "${ azurerm_storage_container.acstack.name }"
  source_uri             = "${ var.azure_vhd_uri }"
}

resource "azurerm_image" "acs" {
  name                = "${ var.name }-image"
  location            = "${ var.location }"
  resource_group_name = "${ var.resource_group_name }"

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = "${ azurerm_storage_blob.acstack.url }"
    size_gb  = 30
  }
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_image.acs",
  ]
}
