provider "aws" {
  region = var.aws_region
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../src/polly_function"       # Adjust relative path if needed
  output_path = "../src/polly_function/function.zip"
}

# S3 bucket with unique prefix
resource "aws_s3_bucket" "polly_audio_bucket" {
  bucket_prefix = "my-polly-audio-files-"

  tags = {
    Name    = "PollyAudioBucket"
  }
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = var.lambda_role_name

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

# Attach AWS managed Lambda basic execution role (for logs)
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom inline policy for S3 + Polly
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.lambda_role_name}-policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.polly_audio_bucket.arn,
          "${aws_s3_bucket.polly_audio_bucket.arn}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = [
          "polly:SynthesizeSpeech"
        ],
        Resource = "*"
      }
    ]
  })
}

# Lambda function
resource "aws_lambda_function" "polly_narrator" {
  function_name    = var.lambda_function_name
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler          = "index.handler"
  runtime          = "nodejs22.x"
  role             = aws_iam_role.lambda_exec_role.arn

  # Match SAM defaults
  memory_size = 128
  timeout     = 10

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.polly_audio_bucket.bucket
    }
  }
}
