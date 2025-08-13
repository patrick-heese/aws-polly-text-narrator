variable "aws_region" {
  description = "AWS Region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "Name for the S3 bucket to store Polly audio files"
  type        = string
  default     = "my-polly-audio-files-123456789012-us-east-1"  # Change this to your desired unique bucket name
}

variable "lambda_role_name" {
  description = "IAM Role name for the Lambda function"
  type        = string
  default     = "PollyNarratorRole"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "PollyNarratorFunction"
}
