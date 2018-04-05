resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${ var.resource_group_name }"
  }

  byte_length = 8
}

resource "azurerm_storage_account" "diag" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${ var.resource_group_name }"
  location                 = "${ var.location }"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags {
    environment = "Terraform Demo"
  }
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    "azurerm_storage_account.diag",
  ]
}
