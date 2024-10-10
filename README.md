# terraform-azurerm-vm

Magicorn made Terraform Module for Azure Provider
--
```
module "vm-nginx" {
  source      = "magicorntech/vm/azurerm"
  version     = "0.0.1"
  tenant      = var.tenant
  name        = var.name
  environment = var.environment
  rg_name     = azurerm_resource_group.main.name
  rg_location = azurerm_resource_group.main.location
  subnet      = module.network.pbl_subnet_ids[0]

  # VM Configuration
  vm_name      = "nginx"
  vm_size      = "Standard_B1ms"
  az           = null
  create_pblip = true
  username     = "ubuntu"
  key_data     = "ssh-rsa PUBLIC_KEY"

  ##### Disk Configuration
  # Base Image
  publisher     = "canonical"
  offer         = "0001-com-ubuntu-server-jammy"
  sku           = "22_04-lts-gen2"
  image_version = "latest"

  # OS Disk Configuration
  disk_type    = "StandardSSD_LRS"
  os_disk_size = 32
  caching      = "ReadWrite"

  # Data Disk Configuration
  data_disks = {}

  # Misc
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  # Security Rule Configuration
  security_rule = [
    {
      name                       = "ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "123.123.123.123/32"
      destination_address_prefix = "*"
    },
    {
      name                       = "http"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "https"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

```