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
variable "trust_subnet" {
  type        = list(string)
  description = "Address prefix for the trust network"
}
variable "untrust_subnet" {
  type        = list(string)
  description = "Address prefix for the untrust network"
}
variable "loadbalancer_subnet" {
  type        = list(string)
  description = "Address prefix for the untrust network"
}

variable "management_public_ips" {
  description = "Public IP address to manage the firewalls"
  type        = list(string)
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
resource "azurerm_subnet" "trust" {
  name                 = "trust"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.trust_subnet
}
resource "azurerm_subnet" "untrust" {
  name                 = "untrust"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.untrust_subnet
}
resource "azurerm_subnet" "loadbalancer" {
  name                 = "loadbalancer"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.loadbalancer_subnet
}

resource "azurerm_network_security_group" "mgmt" {
  name                = "management-snet-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes      = var.management_public_ips
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "https"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes      = var.management_public_ips
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "mgmt" {
  subnet_id                 = azurerm_subnet.mgmt.id
  network_security_group_id = azurerm_network_security_group.mgmt.id
}

resource "azurerm_network_security_group" "trust" {
  name                = "trust-snet-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet_network_security_group_association" "trust" {
  subnet_id                 = azurerm_subnet.trust.id
  network_security_group_id = azurerm_network_security_group.trust.id
}

resource "azurerm_network_security_group" "untrust" {
  name                = "untrust-snet-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet_network_security_group_association" "untrust" {
  subnet_id                 = azurerm_subnet.untrust.id
  network_security_group_id = azurerm_network_security_group.untrust.id
}
