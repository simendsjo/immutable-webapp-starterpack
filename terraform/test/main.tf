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

locals {
  s3_origin_id = "tf-immutable-webapp-s3-origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.tf-immutable-webapp-test.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/assets/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "test"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
