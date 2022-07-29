variable "address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the gwlb virtual network"
}
variable "vnet_name" {
  type        = string
  description = "Name of the gwlb virtual network"
}
variable "management_subnet" {
  type        = list(string)
  description = "Address prefix for the management network"
}
variable "data_subnet" {
  type        = list(string)
  description = "Address prefix for the data network"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_prefixes
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "mgmt" {
  name                 = "management"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.management_subnet
}
resource "azurerm_subnet" "data" {
  name                 = "data"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.data_subnet
}