variable "app_name" {
  default = "ddr-app"
}

variable "azure_location" {
  default = "East US"
}

variable "env" {
  default = "dev"
}

variable "vn_address_space" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

variable "allowed_ports" {
  default = ["80", "443", "22", "8080"]
}

variable "public_subnet_address_prefixes" {
  type = list(string)
  default = ["10.1.1.0/24"]
}

variable "private_subnet_address_prefixes" {
  type = list(string)
  default = ["10.1.2.0/24"]
}

variable "admin_username" {
  default = "azureuser"
}

variable "public_key_path" {
  default = "my_key.pub"
}

variable "vm_size" {
  default = "Standard_B1s"
}


