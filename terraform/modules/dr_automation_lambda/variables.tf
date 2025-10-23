variable "env" {
  default = "dev"
}

variable "app_name" {
  default = "ddr-app"
}

variable "azure_storage_account_name" {
  
}

variable "azure_storage_account_key" {}

variable "azure_container_name" {}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to sync from"
  type        = string
}
