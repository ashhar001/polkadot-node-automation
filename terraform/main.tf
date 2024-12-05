# Terraform configuration block specifies required providers and their versions
# This ensures consistent provider behavior across different environments
terraform {
  required_providers {
    # AWS provider configuration
    # Source: official HashiCorp AWS provider
    # Version: Any 5.8.x version is acceptable (for stability while allowing patches)
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8.0"
    }
  }
}

# AWS Provider configuration block
# Configures authentication and region for AWS API calls
provider "aws" {
  region     = var.region      # AWS region where resources will be created
  access_key = var.aws_access_key  # AWS access key for authentication
  secret_key = var.aws_secret_key  # AWS secret key for authentication
}
