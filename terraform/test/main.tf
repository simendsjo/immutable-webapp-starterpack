provider "aws" {
  version = "~> 2.0"
  region  = "eu-north-1"
}

resource "aws_s3_bucket" "tf-immutable-webapp-test" {
  bucket = "ramslok-immutable-webapp-test"
  acl    = "private"

  tags = {
    Name        = "test"
    Environment = "test"
  }
}

resource "aws_s3_bucket" "tf-immutable-webapp-assets" {
  bucket = "ramslok-immutable-webapp-assets"
  acl    = "private"

  tags = {
    Name        = "assets"
  }
}

resource "aws_s3_bucket_policy" "tf-immutable-webapp-assets" {
  bucket = aws_s3_bucket.tf-immutable-webapp-assets.id
  policy = templatefile("policy/public_bucket.json.tpl", {
    bucket_arn = aws_s3_bucket.tf-immutable-webapp-assets.arn
  })
}

resource "aws_s3_bucket_policy" "tf-immutable-webapp-test" {
  bucket = aws_s3_bucket.tf-immutable-webapp-test.id
  policy = templatefile("policy/public_bucket.json.tpl", {
    bucket_arn = aws_s3_bucket.tf-immutable-webapp-test.arn
  })
}
