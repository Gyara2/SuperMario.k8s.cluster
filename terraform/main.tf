# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
## Este provider será usado para crear la infraestructura básica en Azure.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.1"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
## Creamos un grupo de recursos que contendrá toda la estructura generada.
resource "azurerm_resource_group" "rg" {
    name     =  "kubernetes_rg"
    location = var.location

    tags = {
        environment = "CP2"
    }

}

# Storage account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
# https://www.terraform.io/language/functions/format - To concat multiple vars
## Servirán para almacenar la información respecto a las máquinas desplegadas.
resource "azurerm_storage_account" "stAccount" {
    name                     = format("%s%s", var.storage_account,var.vms[count.index])
    count                    = length(var.vms)
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "CP2"
    }

}