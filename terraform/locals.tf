
resource "random_uuid" "main" {
}
locals {
  uuid  = substr(replace(random_uuid.main.result, "-", ""), 0, 20)
  nssas = nonsensitive(data.azurerm_storage_account_sas.main.sas)
}
