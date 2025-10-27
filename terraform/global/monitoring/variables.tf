variable "lambda_function_name" {
  description = "Name of the AWS Lambda function for DR replication"
  type        = string
}

variable "sns_alert_email" {
  description = "Email address for CloudWatch alerts"
  type        = string
}

variable "azure_vm_name" {
  description = "Azure VM name to monitor"
  type        = string
}

variable "azure_rg_name" {
  description = "Azure resource group containing monitored resources"
  type        = string
}

variable "azure_action_group_name" {
  description = "Azure Monitor action group name"
  type        = string
  default     = "dr-alert-group"
}


variable "azure_vm_id" {
  description = "ID of the Azure VM to monitor"
  type        = string
}





