resource "azurerm_storage_account" "aztack" {
  name                     = "aztack${ var.name }"
  resource_group_name      = "${ var.resource_group_name }"
  location                 = "${ var.location }"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "aztack" {
  name                  = "vhds"
  resource_group_name   = "${ var.resource_group_name }"
  storage_account_name  = "${ azurerm_storage_account.aztack.name }"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "aztack" {
  name = "aztack.vhd"

  resource_group_name    = "${ var.resource_group_name }"
  storage_account_name   = "${ azurerm_storage_account.aztack.name }"
  storage_container_name = "${ azurerm_storage_container.aztack.name }"
  source_uri             = "${ var.azure_vhd_uri }"
}

resource "azurerm_image" "aztack" {
  name                = "${ var.name }-image"
  location            = "${ var.location }"
  resource_group_name = "${ var.resource_group_name }"

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = "${ azurerm_storage_blob.aztack.url }"
    size_gb  = 30
  }
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_image.aztack",
  ]
}
