resource "azurerm_virtual_machine" "main" {
  name                             = "${var.tenant}-${var.name}-vm-${var.vm_name}-${var.environment}"
  resource_group_name              = var.rg_name
  location                         = var.rg_location
  network_interface_ids            = [azurerm_network_interface.main.id]
  vm_size                          = var.vm_size
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination
  zones                            = (var.az != null) ? [var.az] : null

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${var.tenant}-${var.name}-vm-osdisk-${var.vm_name}-${var.environment}"
    caching           = var.caching
    create_option     = "FromImage"
    managed_disk_type = var.disk_type
    disk_size_gb      = var.os_disk_size
  }

  os_profile {
    computer_name  = (var.publisher != "MicrosoftWindowsServer") ? "${var.tenant}-${var.name}-vm-${var.vm_name}-${var.environment}" : "${var.vm_name}"
    admin_username = var.username
    admin_password = (var.publisher == "MicrosoftWindowsServer") ? random_password.vmpass[0].result : null
  }

  dynamic "os_profile_linux_config" {
    for_each = (var.publisher != "MicrosoftWindowsServer") ? [true] : []
    content {
      disable_password_authentication = true
      ssh_keys {
        key_data = var.key_data
        path     = "/home/${var.username}/.ssh/authorized_keys"
      }
    }
  }

  dynamic "os_profile_windows_config" {
    for_each = (var.publisher == "MicrosoftWindowsServer") ? [true] : []
    content {
      provision_vm_agent        = true
      enable_automatic_upgrades = false
    }
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-vm-${var.vm_name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}
