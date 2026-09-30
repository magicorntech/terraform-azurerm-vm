variable "tenant" {}
variable "name" {}
variable "vm_name" {}
variable "environment" {}
variable "rg_name" {}
variable "rg_location" {}
variable "subnet" {}
variable "vm_size" {}
variable "delete_os_disk_on_termination" {}
variable "delete_data_disks_on_termination" {}
variable "az" {}
variable "create_pblip" {}
variable "publisher" {}
variable "offer" {}
variable "sku" {}
variable "image_version" {}
variable "caching" {}
variable "disk_type" {}
variable "os_disk_size" {}
variable "username" {}
variable "key_data" {}
variable "data_disks" {}
variable "security_rule" {}

variable "plan" {
  description = "Marketplace plan info for images that require accepting legal terms (e.g. Rocky Linux/resf). Leave null for images that don't need a plan (e.g. Canonical, Debian, MicrosoftWindowsServer)."
  type = object({
    name      = string
    product   = string
    publisher = string
  })
  default = null
}