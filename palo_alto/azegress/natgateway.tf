locals {
  nat_gateway_name = "natgw-transit-untrust"
}

variable "nat_gateway_zones" {
  default     = ["1"]
  description = "Zones where NAT Gateway will be deployed"
  type        = list(string)
}

resource "azurerm_public_ip_prefix" "egress_prefix" {
  name                = "egress-prefix"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  prefix_length       = 30
  zones               = ["1"]
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = local.nat_gateway_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "public_ip_nat_gateway" {
  nat_gateway_id      = azurerm_nat_gateway.nat_gateway.id
  public_ip_prefix_id = azurerm_public_ip_prefix.egress_prefix.id
}

resource "azurerm_subnet_nat_gateway_association" "untrust" {
  subnet_id      = azurerm_subnet.untrust.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}