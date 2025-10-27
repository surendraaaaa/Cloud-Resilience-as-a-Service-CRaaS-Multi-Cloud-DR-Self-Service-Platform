output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "resource_group_name" {
  value = azurerm_resource_group.my_rg.name
}