variable "management_nic_name" {
  type        = string
  description = "Name of the management nic"
}

variable "data_nic_name" {
  type        = string
  description = "Name of the data nic"
}

variable "firewall_name" {
  type        = string
  description = "Name of the firewall"
}

variable "custom_data" {
  type        = string
  description = "Palo Alto GWLB settings, base64 encode them before the variable"
  default     = "cGx1Z2luLW9wLWNvbW1hbmRzPWF6dXJlLWd3bGItaW5zcGVjdDplbmFibGUraW50ZXJuYWwtcG9ydC0yMDAwK2V4dGVybmFsLXBvcnQtMjAwMStpbnRlcm5hbC12bmktODAwK2V4dGVybmFsLXZuaS04MDE="
  # plugin-op-commands=azure-gwlb-inspect:enable+internal-port-2000+external-port-2001+internal-vni-800+external-vni-801
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

resource "azurerm_network_interface" "mgmt" {
  name                = var.management_nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "data" {
  name                = var.data_nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.data.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "firewall" {
  name                            = var.firewall_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D3_v2"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  custom_data = var.custom_data
  network_interface_ids = [
    azurerm_network_interface.mgmt.id,
    azurerm_network_interface.data.id
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
  network_interface_id    = azurerm_network_interface.data.id
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}