resource "random_password" "vmpass" {
  count            = (var.publisher == "MicrosoftWindowsServer") ? 1 : 0
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 2
  min_special      = 2
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
