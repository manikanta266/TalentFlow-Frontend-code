provider "aws" {
  region = "eu-north-1"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "tf-demo-frontend-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "frontend-deployment"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.frontend_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls   = true
  block_public_policy = false
  ignore_public_acls  = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
