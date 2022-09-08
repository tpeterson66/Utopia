# variable "internal_lb_name" {
#   type        = string
#   description = "Name of the internal load balancer for trust traffic"
# }

# resource "azurerm_lb" "internal" {
#   name                = var.internal_lb_name
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "Standard"

#   frontend_ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.trust.id
#     private_ip_address_allocation = "Dynamic"
#     # private_ip_address            = var.internal_lb_address
#     private_ip_address_version = "IPv4"
#   }
# }

# resource "azurerm_lb_probe" "ssh_probe" {
#   # resource_group_name = azurerm_resource_group.rg.name
#   loadbalancer_id = azurerm_lb.internal.id
#   name            = "ssh-health-probe"
#   port            = 22
# }

# resource "azurerm_lb_rule" "internal_01" {
#   # resource_group_name            = azurerm_resource_group.rg.name
#   loadbalancer_id                = azurerm_lb.internal.id
#   name                           = "trust"
#   protocol                       = "All"
#   frontend_port                  = 0
#   backend_port                   = 0
#   frontend_ip_configuration_name = "internal"
#   probe_id                       = azurerm_lb_probe.ssh_probe.id
#   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.internal_backends.id]
#   load_distribution              = "SourceIPProtocol"
#   enable_floating_ip             = true
# }

# resource "azurerm_lb_backend_address_pool" "internal_backends" {
#   # resource_group_name = azurerm_resource_group.rg.name
#   loadbalancer_id = azurerm_lb.internal.id
#   name            = "trust-backend"
# }

# # Primary Firewall
# resource "azurerm_network_interface_backend_address_pool_association" "internal" {
#   network_interface_id    = azurerm_network_interface.trust.id
#   ip_configuration_name   = "ipconfig" # must be updated if changed in virtual_appliance_pri.tf
#   backend_address_pool_id = azurerm_lb_backend_address_pool.internal_backends.id
# }