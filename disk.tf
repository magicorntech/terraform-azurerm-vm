resource "azurerm_managed_disk" "main" {
  for_each             = var.data_disks
  name                 = "${var.tenant}-${var.name}-vm-datadisk-${each.key}-${var.vm_name}-${var.environment}"
  resource_group_name  = var.rg_name
  location             = var.rg_location
  storage_account_type = each.value.disk_type
  disk_size_gb         = each.value.disk_size
  create_option        = "Empty"
  zone                 = (var.az != null) ? var.az : null

  tags = {
    Name        = "${var.tenant}-${var.name}-vm-datadisk-${each.key}-${var.vm_name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  for_each           = var.data_disks
  managed_disk_id    = azurerm_managed_disk.main[each.key].id
  virtual_machine_id = azurerm_virtual_machine.main.id
  lun                = index(keys(var.data_disks), each.key)
  caching            = each.value.disk_cache
}
