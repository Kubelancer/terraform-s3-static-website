provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "staticwebsite" {
  bucket = var.s3staticweb
  acl = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = var.s3staticweb
  key = "index.html"
  content_type = "text/html"
  source = "index.html"
  force_destroy = true
  depends_on = [aws_s3_bucket.staticwebsite]
}

resource "aws_s3_bucket_object" "error_html" {
  bucket = var.s3staticweb
  key = "error.html"
  content_type = "text/html"
  source = "error.html"
  force_destroy = true
  depends_on = [aws_s3_bucket.staticwebsite]
}

resource "aws_s3_bucket_policy" "staticwebsite_policy" {
  bucket = aws_s3_bucket.staticwebsite.id
  policy = file("policy.json")
  depends_on = [aws_s3_bucket.staticwebsite, aws_s3_bucket_object.index_html, aws_s3_bucket_object.error_html]
}