terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

# List of local site files to upload
locals {
  site_files = ["index.html", "about.html", "contact.html", "error.html"]
}

# S3 bucket for static site
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-static-site-7e84fef1"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  # Remove ACLs; rely on bucket policy for public access
  force_destroy = true
}

# Bucket policy to allow public read for objects
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}

# Upload all site files
resource "aws_s3_object" "site_files" {
  for_each = toset(local.site_files)

  bucket = aws_s3_bucket.my_bucket.id
  key    = each.value
  source = "${path.module}/${each.value}"

  content_type = lookup({
    "index.html"   = "text/html"
    "about.html"   = "text/html"
    "contact.html" = "text/html"
    "error.html"   = "text/html"
  }, each.value, "text/plain")
}

output "site_url" {
  value = aws_s3_bucket.my_bucket.website_endpoint
}
