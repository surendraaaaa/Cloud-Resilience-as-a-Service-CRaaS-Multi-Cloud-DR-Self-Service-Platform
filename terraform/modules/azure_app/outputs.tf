output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}