resource "azurerm_resource_group" "consumer" {
  name     = "consumer"
  location = var.location
}

resource "azurerm_public_ip" "consumer" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = azurerm_resource_group.consumer.name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "consumer" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.consumer.location
  resource_group_name = azurerm_resource_group.consumer.name
  sku = "Standard"

  frontend_ip_configuration {
    name                                               = "PublicIPAddress"
    public_ip_address_id                               = azurerm_public_ip.consumer.id
    gateway_load_balancer_frontend_ip_configuration_id = azurerm_lb.gwlb.frontend_ip_configuration[0].id
  }
}

resource "azurerm_lb_backend_address_pool" "consumer" {
  loadbalancer_id = azurerm_lb.consumer.id
  name            = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "consumer" {
  network_interface_id    = azurerm_network_interface.consumer.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.consumer.id
}

resource "azurerm_lb_rule" "consumer" {
  loadbalancer_id                = azurerm_lb.consumer.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.consumer.id]
}

resource "azurerm_virtual_network" "consumer" {
  name                = "example-network"
  address_space       = ["10.255.255.0/24"]
  location            = azurerm_resource_group.consumer.location
  resource_group_name = azurerm_resource_group.consumer.name
}

resource "azurerm_subnet" "consumer" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.consumer.name
  virtual_network_name = azurerm_virtual_network.consumer.name
  address_prefixes     = ["10.255.255.0/28"]
}

resource "azurerm_network_interface" "consumer" {
  name                = "consumervmnic"
  location            = azurerm_resource_group.consumer.location
  resource_group_name = azurerm_resource_group.consumer.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.consumer.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "consumer" {
  name                            = "example-machine"
  resource_group_name             = azurerm_resource_group.consumer.name
  location                        = azurerm_resource_group.consumer.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.consumer.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

