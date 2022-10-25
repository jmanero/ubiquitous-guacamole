##
## Contains S3 resources for the application
##

## Configure the application's state-storage bucket and access policy
resource "aws_s3_bucket" "state" {
  bucket = local.unique_name
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
