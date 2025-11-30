variable "aws_region" {
  description = "AWS Region to deploy resources in"
  type        = string
  default     = "us-east-1"
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

variable "project_name" {
  description = "Project tag value for all resources"
  type        = string
}