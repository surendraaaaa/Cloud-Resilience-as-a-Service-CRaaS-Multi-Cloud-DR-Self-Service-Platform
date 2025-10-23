# --------------------------
# Outputs
# --------------------------
output "public_instance_ip" {
  value = aws_instance.public_instance.public_ip
}

output "private_instance_id" {
  value = aws_instance.private_instance.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}
