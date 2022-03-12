# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.1"
    }
  }
}

# crea un service principal y rellena los siguientes datos para autenticar
provider "azurerm" {
  features {}
  subscription_id = "71a0e8d6-4dbe-459d-8f26-ebd2c975dab5"
  client_id       = "7eabf43d-7934-419b-ba70-5572f52eca85"
  client_secret   = "FwN~mj6F~9zJhK_HKiX._lrzVM2J7PpVyj"
  tenant_id       = "899789dc-202f-44b4-8472-a6d40f9eb440"
}


# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

resource "azurerm_resource_group" "rg" {
    name     =  "kubernetes_rg"
    location = var.location

    tags = {
        environment = "CP2"
    }

}

# Storage account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

resource "azurerm_storage_account" "stAccount" {
    name                     = "staccountcp2${var.vms[count.index]}" 
    count                    = length(var.vms)
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "CP2"
    }

}