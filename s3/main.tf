provider "aws"  {
  region = var.region_name
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}