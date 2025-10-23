output "lambda_function_name" {
  value       = aws_lambda_function.s3_to_azure_sync.function_name
  description = "Name of the DR automation Lambda function"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.s3_to_azure_sync.arn
  description = "ARN of the DR automation Lambda function"
}