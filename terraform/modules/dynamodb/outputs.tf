output "exchange_rates_table_arn" {
  description = "The ARN of the exchange_rates DynamoDB table"
  value       = aws_dynamodb_table.exchange_rates.arn
}