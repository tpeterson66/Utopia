
variable "gwlb_name" {
  description = "Name of the gateway load balancer"
  type        = string
}

resource "azurerm_lb" "gwlb" {
  name                = var.gwlb_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Gateway"

  frontend_ip_configuration {
    name = "gateway_load_balancer"
    # public_ip_address_id = azurerm_public_ip.example.id
    subnet_id                     = azurerm_subnet.data.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.gwlb.id
  name            = "GatewayLoadBalancerPool"
  tunnel_interface { # if you change the tunnel interface data, you will need to update the custom data!
    identifier = "800"
    type       = "Internal"
    protocol   = "VXLAN"
    port       = "2000"
  }
  tunnel_interface {
    identifier = "801"
    type       = "External"
    protocol   = "VXLAN"
    port       = "2001"
  }
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.gwlb.id
  name            = "ssh-probe"
  port            = 22
}

resource "azurerm_lb_rule" "gwlb_rule" {
  loadbalancer_id                = azurerm_lb.gwlb.id
  name                           = "gatewaylbrule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = "gateway_load_balancer"
  probe_id                       = azurerm_lb_probe.probe.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
}