resource "aws_kms_key" "key" {
  description             = "s3 backend key"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket" "state-bucket" {
  bucket            = "iac-tfassignment-states"
  #aws_s3_bucket_acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_dynamodb_table" "state-lock" {
  hash_key       = "LockID"
  name           = "iac-terraform-states-lock"
  write_capacity = 5
  read_capacity  = 5
  attribute {
    name = "LockID"
    type = "S"
  }
}