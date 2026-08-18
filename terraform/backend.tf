# Remote State Storage (S3 + DynamoDB) setup for production
# Uncomment and configure after creating your S3 bucket & DynamoDB table
# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket-name"
#     key            = "production/n-tier-infra/terraform.tfstate"
#     region         = "ap-south-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }