variable "region" {
  description = "The AWS region to deploy the resources"
  default     = "us-east-2"
}

variable "aws_account" {
  description = "AWS account details"
  type        = map(string)
  default     = {
    id      = "123456789012"
    profile = "admin"
  }
}

variable "environment" {
  description = "The environment to deploy the resources (e.g., dev, staging, prod)"
  default     = "dev"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}