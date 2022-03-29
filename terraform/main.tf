terraform {
  required_version = "1.1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = local.uuid
  location = "australiaeast"
}

resource "azurerm_service_plan" "main" {
  name                = local.uuid
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku_name            = "B1"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "main" {
  name                = local.uuid
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {}
}

resource "null_resource" "deploy" {
  triggers = {
    zip_hash = "${var.zip_name}-${base64encode(filesha256("${var.zip_path}"))}.zip"
  }
  provisioner "local-exec" {
    command = "az webapp deploy --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_windows_web_app.main.name} --type zip --src-url 'https://${azurerm_storage_account.main.name}.blob.core.windows.net/${azurerm_storage_container.main.name}/${azurerm_storage_blob.main.name}${local.nssas}'"
  }
}
