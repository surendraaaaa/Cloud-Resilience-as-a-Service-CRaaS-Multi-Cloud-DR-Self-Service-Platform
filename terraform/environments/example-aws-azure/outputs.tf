output "aws_public_ip" {
  value = module.aws_app.public_instance_ip
}

output "azure_public_ip" {
  value = module.azure_app.public_ip
}

output "aws_s3_bucket" {
  value = module.aws_app.my_bucket
}

output "azure_storage_account" {
  value = module.azure.storage_account_name
}

output "vm_id" {
  value = module.azure_app.vm_id
}

output "aws_s3_bucket_name" {
  description = "Name of the AWS S3 bucket created by aws_app module"
  value       = module.aws_app.s3_bucket_name
}

output "azure_storage_account_name" {
  description = "Azure Storage Account name from azure module"
  value       = module.azure.azure_storage_account_name
}

output "dr_lambda_function_name" {
  description = "Name of the DR automation Lambda function"
  value       = module.dr_automation_lambda.lambda_function_name
}

output "dr_lambda_function_arn" {
  description = "ARN of the DR automation Lambda function"
  value       = module.dr_automation_lambda.lambda_function_arn
}