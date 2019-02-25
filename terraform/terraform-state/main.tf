variable "paramStateBucket" {
  type = "string"
}
variable "paramLockTable" {
  type = "string"
}
variable "REGION" {
  type = "string"
}
provider "aws" {
  region = "${var.REGION}"
}
# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage-s3" {
    bucket = "${var.paramStateBucket}"
 
    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = false
    }
 
    tags {
      Name = "S3 Remote Terraform State Store"
    }      
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "${var.paramLockTable}"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}