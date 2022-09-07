resource "azurerm_resource_group" "consumer" {
  name     = "consumer-test-rg"
  location = "eastus"
}

# virtual networks
resource "azurerm_virtual_network" "consumer" {
  name                = "consumer-vnet"
  address_space       = ["10.66.69.0/24"]
  location            = azurerm_resource_group.consumer.location
  resource_group_name = azurerm_resource_group.consumer.name
}

resource "azurerm_subnet" "default1" {
  name                 = "default1"
  resource_group_name  = azurerm_resource_group.consumer.name
  virtual_network_name = azurerm_virtual_network.consumer.name
  address_prefixes     = ["10.66.69.0/25"]
}
resource "azurerm_subnet" "default2" {
  name                 = "default2"
  resource_group_name  = azurerm_resource_group.consumer.name
  virtual_network_name = azurerm_virtual_network.consumer.name
  address_prefixes     = ["10.66.69.128/25"]
}

# vnet peering
resource "azurerm_virtual_network_peering" "consumer-1" {
  name                      = "spoke-to-hub"
  resource_group_name       = azurerm_resource_group.consumer.name
  virtual_network_name      = azurerm_virtual_network.consumer.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_virtual_network_peering" "consumer-2" {
  name                      = "hub-to-spoke"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.consumer.id
}

# NSGs
resource "azurerm_network_security_group" "default1" {
  name                = "consumer-default1-nsg"
  location            = azurerm_resource_group.consumer.location
  resource_group_name = azurerm_resource_group.consumer.name
}
resource "azurerm_subnet_network_security_group_association" "default1" {
  subnet_id                 = azurerm_subnet.default1.id
  network_security_group_id = azurerm_network_security_group.default1.id
}

resource "azurerm_network_security_group" "default2" {
  name                = "consumer-default2-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet_network_security_group_association" "default2" {
  subnet_id                 = azurerm_subnet.default2.id
  network_security_group_id = azurerm_network_security_group.default2.id
}

# route tables
resource "azurerm_route_table" "default1" {
  name                          = "consumer-default1-rt"
  location                      = azurerm_resource_group.consumer.location
  resource_group_name           = azurerm_resource_group.consumer.name
  disable_bgp_route_propagation = false
}
resource "azurerm_subnet_route_table_association" "default1" {
  subnet_id      = azurerm_subnet.default1.id
  route_table_id = azurerm_route_table.default1.id
}
resource "azurerm_route_table" "default2" {
  name                          = "consumer-default2-rt"
  location                      = azurerm_resource_group.consumer.location
  resource_group_name           = azurerm_resource_group.consumer.name
  disable_bgp_route_propagation = false
}
resource "azurerm_subnet_route_table_association" "default2" {
  subnet_id      = azurerm_subnet.default2.id
  route_table_id = azurerm_route_table.default2.id
}

# Routing

## default routes
resource "azurerm_route" "default1_route01" {
  name                = "default"
  resource_group_name = azurerm_resource_group.consumer.name
  route_table_name    = azurerm_route_table.default1.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_lb.internal.private_ip_address
}
resource "azurerm_route" "default2_route01" {
  name                = "default"
  resource_group_name = azurerm_resource_group.consumer.name
  route_table_name    = azurerm_route_table.default2.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_lb.internal.private_ip_address
}


# VMs and NICs

resource "azurerm_network_interface" "consumer1" {
  name                = "consumer1-nic"
  location            = azurerm_resource_group.consumer.location
  resource_group_name = azurerm_resource_group.consumer.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "consumer1" {
  name                = "consumervm01"
  resource_group_name = azurerm_resource_group.consumer.name
  location            = azurerm_resource_group.consumer.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.consumer1.id,
  ]
  boot_diagnostics {
    storage_account_uri = "https://mypalodiagsetings.blob.core.windows.net/"
  }
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}


resource "azurerm_network_interface" "consumer2" {
  name                = "consumer2-nic"
  location            = azurerm_resource_group.consumer.location
  resource_group_name = azurerm_resource_group.consumer.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default2.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "consumer2" {
  name                = "consumervm02"
  resource_group_name = azurerm_resource_group.consumer.name
  location            = azurerm_resource_group.consumer.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.consumer2.id,
  ]
  boot_diagnostics {
    storage_account_uri = "https://mypalodiagsetings.blob.core.windows.net/"
  }
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}