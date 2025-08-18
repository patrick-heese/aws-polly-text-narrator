provider "aws" {
  region = var.aws_region
}

# Package Lambda code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../src"
  output_path = "../src/function.zip"
}

# Account + region data for unique naming
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "polly_audio_bucket" {
  bucket = "my-polly-audio-files-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

  tags = {
    Name = "PollyAudioBucket"
    Project = "PollyTextNarrator"
  }
}

# Lambda execution role
resource "aws_iam_role" "lambda_exec_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = {
    Project = "PollyTextNarrator"
  }
}

# Attach AWS managed basic execution role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Inline policy for S3 + Polly
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.lambda_role_name}-policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
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
        Effect = "Allow",
        Action = [
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

  memory_size = 128
  timeout     = 10

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.polly_audio_bucket.bucket
    }
  }

  tags = {
    Project = "PollyTextNarrator"
  }
}
