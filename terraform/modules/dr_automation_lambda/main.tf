##############################################################
# AWS Lambda for S3 → Azure Replication
# Handles automatic replication of new S3 objects to Azure Blob
##############################################################

# Reference the source S3 bucket (passed in from parent module)
data "aws_s3_bucket" "source" {
  bucket = var.s3_bucket_name
}

##############################################################
# IAM Role & Policy for Lambda Execution
##############################################################

# IAM Role that Lambda assumes
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.env}-${var.app_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy granting access to S3 + CloudWatch Logs
resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.env}-${var.app_name}-lambda-policy"
  description = "Lambda permissions to read from S3 bucket and write to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          data.aws_s3_bucket.source.arn,
          "${data.aws_s3_bucket.source.arn}/*"
        ]
      }
    ]
  })
}

# Attach the policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

##############################################################
# Lambda Function Definition
##############################################################

resource "aws_lambda_function" "s3_to_azure_sync" {
  filename         = "../lambda_functions/s3_to_azure_sync/package/lambda_function.zip"
  function_name    = "${var.env}-${var.app_name}-s3-to-azure-sync"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"

  environment {
    variables = {
      S3_BUCKET_NAME                 = var.s3_bucket_name
      AZURE_STORAGE_CONNECTION_STRING = var.azure_storage_connection_string
      AZURE_CONTAINER_NAME           = var.azure_container_name
    }
  }

  # Ensure IAM resources are created first
  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attach
  ]
}

##############################################################
# Permissions and S3 Trigger
##############################################################

# Allow S3 to invoke this Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_to_azure_sync.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.source.arn
}

# Configure S3 bucket to trigger Lambda on new object creation
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.source.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_to_azure_sync.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
