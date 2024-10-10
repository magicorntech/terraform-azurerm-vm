resource "azurerm_network_security_group" "main" {
  count               = (var.security_rule == []) ? 0 : 1
  name                = "${var.tenant}-${var.name}-vm-nsg-${var.vm_name}-${var.environment}"
  resource_group_name = var.rg_name
  location            = var.rg_location

  dynamic "security_rule" {
    for_each = var.security_rule

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-vm-nsg-${var.vm_name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  count                     = (var.security_rule == []) ? 0 : 1
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main[0].id
}
