
locals {
  management_nic_name = "nic-${var.firewall_name}-mgmt"
  trust_nic_name      = "nic-${var.firewall_name}-trust"
  untrust_nic_name    = "nic-${var.firewall_name}-untrust"
}
variable "number_of_firewalls" {
  default     = 2
  description = "Number of Egress firewalls to deploy w/ tf."
  type        = number

}

variable "firewall_name" {
  type        = string
  description = "Name of the firewall"
}

variable "username" {
  description = "username for the palo firewall"
  type        = string
  default     = "paloadmin"
}

variable "password" {
  description = "Password for the palo firewalls"
  type        = string
}

variable "sku" {
  description = "Palo Alto Marketplace SKU (bundle1,bundle2,byol)"
  type        = string
}
variable "palo_version" {
  description = "Palo Alto software version"
  type        = string
}

resource "azurerm_public_ip" "mgmt" {
  count               = var.number_of_firewalls
  name                = "${local.management_nic_name}-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "mgmt" {
  count               = var.number_of_firewalls
  name                = "${local.management_nic_name}-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mgmt[count.index].id
  }
}

resource "azurerm_network_interface" "trust" {
  count               = var.number_of_firewalls
  name                = "${local.trust_nic_name}-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.trust.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "untrust" {
  count               = var.number_of_firewalls
  name                = "${local.untrust_nic_name}-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.untrust.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "firewall" {
  count                           = var.number_of_firewalls
  name                            = "${var.firewall_name}-${count.index + 1}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D3_v2"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.mgmt[count.index].id,
    azurerm_network_interface.trust[count.index].id,
    azurerm_network_interface.untrust[count.index].id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries-flex"
    sku       = var.sku
    version   = var.palo_version
  }
  plan {
    name      = var.sku
    publisher = "paloaltonetworks"
    product   = "vmseries-flex"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "internal_pri" {
  count                   = var.number_of_firewalls
  network_interface_id    = azurerm_network_interface.trust[count.index].id
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.internal_backends.id # comes from loadbalancer.tf
}