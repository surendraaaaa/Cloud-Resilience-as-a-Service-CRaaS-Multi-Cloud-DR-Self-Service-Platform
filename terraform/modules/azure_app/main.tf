# -----------------------------
# Resource Group
# -----------------------------
resource "azurerm_resource_group" "my_rg" {
  name     = "${var.env}-${var.app_name}-rg"
  location = var.azure_location
}

# -----------------------------
# Virtual Network 
# -----------------------------
resource "azurerm_virtual_network" "my_vnet" {
  name                 = "${var.env}-${var.app_name}-vnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  location             = azurerm_resource_group.my_rg.location
  address_space        = var.vn_address_space
}

# -----------------------------
# Network Security Group (NSG)
# -----------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.env}-${var.app_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.allowed_ports
    content {
      name                       = "allow-port-${security_rule.value}"
      priority                   = 1000 + tonumber(security_rule.value)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range           = "*"
      destination_port_range      = security_rule.value
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    }
  }
}

# -----------------------------
# Subnets
# -----------------------------
resource "azurerm_subnet" "public" {
  name = "${var.env}-${var.app_name}-public-subnet"
  resource_group_name = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes = var.public_subnet_address_prefixes
}

resource "azurerm_subnet" "private" {
  name                 = "${var.env}-${var.app_name}-private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.private_subnet_address_prefixes
}

# -----------------------------
# Public IP + NIC
# -----------------------------
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.env}-${var.app_name}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.env}-${var.app_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Associate NSG
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# -----------------------------
# Virtual Machine
# -----------------------------
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.env}-${var.app_name}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }

  os_disk {
    name                 = "${var.env}-${var.app_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20_04-lts"
    version   = "latest"
  }

  tags = {
    Name = "${var.env}-${var.app_name}-vm"
  }
}

# -----------------------------
# Storage Account
# -----------------------------
resource "random_id" "storage_suffix" {
  byte_length = 4
}

resource "azurerm_storage_account" "storage" {
  name                     = "${replace(var.app_name, "-", "")}${random_id.storage_suffix.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}






































# resource "azurerm_resource_group" "main" {
#   name     = "${var.app_name}-rg"
#   location = var.azure_location
# }

# resource "azurerm_storage_account" "storage" {
#   name                     = "${replace(var.app_name, "-", "")}storage"
#   resource_group_name      = azurerm_resource_group.main.name
#   location                 = azurerm_resource_group.main.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# resource "azurerm_virtual_network" "vnet" {
#   name                = "${var.app_name}-vnet"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   address_space       = ["10.1.0.0/16"]
# }

# resource "azurerm_subnet" "subnet" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.1.1.0/24"]
# }

# resource "azurerm_network_interface" "nic" {
#   name                = "${var.app_name}-nic"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_linux_virtual_machine" "vm" {
#   name                = "${var.app_name}-vm"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   size                = var.vm_size
#   admin_username      = "azureuser"

#   admin_ssh_key {
#     username   = "azureuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

#   network_interface_ids = [azurerm_network_interface.nic.id]
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-focal"
#     sku       = "20_04-lts"
#     version   = "latest"
#   }
# }

