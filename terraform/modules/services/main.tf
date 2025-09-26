module "dynamodb" {
  source = "../dynamodb"
  environment = var.environment
  region      = var.region
  aws_account = var.aws_account
  prefix      = var.environment
}
