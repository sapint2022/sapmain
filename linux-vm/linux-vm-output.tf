output "linux_vm_name" {
  description = "Virtual Machine name"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "linux_vm_ip_address" {
  description = "Virtual Machine name IP Address"
  value       = azurerm_public_ip.vm-ip.ip_address
}

output "linux_vm_admin_username" {
  description = "Username password for the Virtual Machine"
  value       = var.vm_admin_user
  #sensitive   = true
}

output "linux_vm_admin_password" {
  description = "Administrator password for the Virtual Machine"
  value       = random_password.vm-password.result
  sensitive   = true
}