
# PROVIDERS
provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = ""
  region                   = "us-east-1"
}

# S3 BUCKET FOR TERRAFORM STATE FILE 
# resource "aws_s3_bucket" "b" {
#   bucket = "iti_eks_bucket"
#   acl    = "private"

#   versioning {
#     enabled = true
#   }
# }

# # BACKEND STATE FILE
# terraform {
#   backend "s3" {
#     bucket = "iti_eks_bucket"
#     key    = "eks.tfstate"
#     region = "us-east-1"

#   }
# }