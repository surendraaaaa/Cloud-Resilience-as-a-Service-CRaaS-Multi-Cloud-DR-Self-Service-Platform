##############################################################
# Outputs
##############################################################

output "azure_vm_public_ip" {
  description = "Public IP of Azure VM"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "azure_storage_account_name" {
  description = "Azure Storage Account Name"
  value       = azurerm_storage_account.storage.name
}

output "azure_storage_account_key" {
  description = "Azure Storage Account Access Key"
  value       = azurerm_storage_account.storage.primary_access_key
  sensitive   = true
}

output "azure_container_name" {
  description = "Azure Storage Container Name"
  value       = azurerm_storage_container.container.name
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

