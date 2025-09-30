resource "aws_s3_bucket" "rate_currency_tracker_images" {
  bucket = "rate-currency-tracker-images-${var.prefix}"

  tags = {
    Name        = "rate-currency-tracker-images"
    Environment = var.environment
    Project     = "rate-currency-tracker"
    ProvisionedBy = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "rate_currency_tracker_images_versioning" {
  bucket = aws_s3_bucket.rate_currency_tracker_images.id
  versioning_configuration {
    status = "Disabled"
  }
}

