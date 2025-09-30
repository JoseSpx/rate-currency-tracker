module "dynamodb" {
  source = "../dynamodb"
  environment = var.environment
  region      = var.region
  aws_account = var.aws_account
  prefix      = var.environment
}

module "s3" {
  source = "../s3"
  environment = var.environment
  region      = var.region
  aws_account = var.aws_account
  prefix      = var.environment
}

module "lambda" {
  source = "../lambda"
  environment = var.environment
  region      = var.region
  aws_account = var.aws_account
  prefix      = var.environment
  dynamodb_table_arn = module.dynamodb.exchange_rates_table_arn
}