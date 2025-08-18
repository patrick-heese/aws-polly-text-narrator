output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.polly_narrator.function_name
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.polly_narrator.arn
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.polly_audio_bucket.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.polly_audio_bucket.arn
}

output "lambda_role_arn" {
  description = "The ARN of the IAM role for Lambda"
  value       = aws_iam_role.lambda_exec_role.arn
}
