variable "aws_region" {
  description = "AWS region to deploy primary resources"
  default     = "us-east-2"
}

variable "azure_location" {
  description = "Azure location for secondary resources"
  default     = "East US"
}

variable "azure_storage_account_name" {
  type = string
}

variable "azure_storage_account_key" {
  type = string
  sensitive = true
}

variable "azure_container_name" {
  type    = string
  default = "my-container"  # or your container name
}