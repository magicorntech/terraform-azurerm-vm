resource "azurerm_public_ip" "main" {
  count               = (var.create_pblip == true) ? 1 : 0
  name                = "${var.tenant}-${var.name}-vm-pblip-${var.vm_name}-${var.environment}"
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = "Static"
  sku                 = (var.az != null) ? "Standard" : "Basic"
  zones               = (var.az != null) ? [var.az] : null

  tags = {
    Name        = "${var.tenant}-${var.name}-vm-pblip-${var.vm_name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.tenant}-${var.name}-vm-nic-${var.vm_name}-${var.environment}"
  resource_group_name = var.rg_name
  location            = var.rg_location

  ip_configuration {
    name                          = "nic1"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = (var.create_pblip == true) ? azurerm_public_ip.main[0].id : null
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-vm-nic-${var.vm_name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}
