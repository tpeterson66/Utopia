# Resource Group
variable "resource_group_name" {
  description = "Resource group name for all components"
  type        = string
}

variable "location" {
  description = "Azure region for all locations"
  type        = string
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}