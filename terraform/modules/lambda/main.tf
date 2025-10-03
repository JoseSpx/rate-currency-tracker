## Lambda Function: Exchange Rate Reader ##

# IAM Role for Lambda execution
resource "aws_iam_role" "rate_currency_tracker_reader_role" {
  name = "rate-currency-tracker-reader-role-${var.prefix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "rate_currency_tracker_reader_role" {
  role       = aws_iam_role.rate_currency_tracker_reader_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "rate_currency_tracker_reader_lambda" {
  function_name = "rate-currency-tracker-reader-${var.prefix}"
  handler       = "dist/index.handler" # points to compiled JS
  runtime       = "nodejs22.x"
  timeout       = 30

  filename         = "../../lambdas/exchange-rate-reader/exchange-rate-reader.zip"
  source_code_hash = filebase64sha256("../../lambdas/exchange-rate-reader/exchange-rate-reader.zip")

  role = aws_iam_role.rate_currency_tracker_reader_role.arn

  environment {
    variables = {
      NODE_ENV = "production"
      APP_ENV = var.environment
      APP_AWS_REGION = var.region
      DYNAMODB_TABLE_NAME = "exchange-rates"
      ENV_PREFIX = var.prefix
    }
  }
}

resource "aws_iam_policy" "rate_currency_tracker_reader_dynamodb_policy" {
  name   = "rate_currency_tracker_reader_dynamodb_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = var.dynamodb_table_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rate_currency_tracker_reader_dynamodb_policy_attachment" {
  role       = aws_iam_role.rate_currency_tracker_reader_role.name
  policy_arn = aws_iam_policy.rate_currency_tracker_reader_dynamodb_policy.arn
}


### Image Processor Lambda ###

resource "aws_iam_role" "image_processor_lambda_role" {
  name = "image-processor-lambda-role-${var.prefix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "image_processor_lambda_role" {
  role       = aws_iam_role.image_processor_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# S3 PutObject permission for image processor Lambda
resource "aws_iam_policy" "image_processor_lambda_s3_policy" {
  name   = "image_processor_lambda_s3_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "image_processor_lambda_s3_policy_attachment" {
  role       = aws_iam_role.image_processor_lambda_role.name
  policy_arn = aws_iam_policy.image_processor_lambda_s3_policy.arn
}

resource "aws_lambda_function" "image_processor_lambda" {
  function_name = "image-processor-${var.prefix}"
  handler       = "image_processor.handler" # points to compiled Python
  runtime       = "python3.12"
  timeout       = 10
  architectures = [ "x86_64" ]
  layers = [ 
    "arn:aws:lambda:us-east-2:770693421928:layer:Klayers-p312-pillow:2"  # Pillow layer
   ]

  filename         = "../../lambdas/image-processor/image-processor.zip"
  source_code_hash = filebase64sha256("../../lambdas/image-processor/image-processor.zip")

  role = aws_iam_role.image_processor_lambda_role.arn

  environment {
    variables = {
      NODE_ENV = "production"
      APP_ENV = var.environment
      APP_AWS_REGION = var.region
      ENV_PREFIX = var.prefix
      SAVE_IMG_LOCALLY = "false"
    }
  }
}