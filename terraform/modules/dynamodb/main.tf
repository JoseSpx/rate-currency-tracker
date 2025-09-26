resource "aws_dynamodb_table" "exchange_rates" {
  name           = "exchange-rates-${var.prefix}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  
  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  global_secondary_index {
    name               = "TimestampIndex"
    hash_key           = "timestamp"
    projection_type   = "ALL"
  }

  tags = {
    Environment = var.environment
    Project     = "rate-currency-tracker"
    ProvisionedBy = "Terraform"
  }

}