# IAM Policy for Lambda Function

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.env}-${var.app_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.env}-${var.app_name}-lambda-policy"
  description = "Lambda permissions to read from S3 bucket and write logs"

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
          aws_s3_bucket.my_bucket.arn,
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}



# Lambda function
resource "aws_lambda_function" "s3_to_azure_sync" {
  filename         = "../lambda_functions/s3_to_azure_sync/package/lambda_function.zip"
  function_name    = "${var.env}-${var.app_name}-s3-to-azure-sync"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  

  runtime = "python3.9"

  environment {
    variables = {
      AZURE_STORAGE_ACCOUNT = var.azure_storage_account_name
      AZURE_STORAGE_KEY     = var.azure_storage_account_key
      AZURE_CONTAINER_NAME  = var.azure_container_name
    }
  }

}

# lambda_permission

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_to_azure_sync.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.my_bucket.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.my_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_to_azure_sync.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
