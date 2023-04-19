#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "this" {
  bucket = "terraform-is-love"
  acl    = "public"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "aws_kms_key.this.arn"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags = {
    Owner = "WeScale"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = false
  block_public_policy     = true
  restrict_public_buckets = false
  ignore_public_acls      = true
}

resource "aws_kms_key" "this" {
  description             = "KMS key demo"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}
