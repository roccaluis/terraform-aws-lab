resource "aws_s3_bucket" "terraform_state" {
  bucket = "high-lab-state-bucket-shimbita" # Use a globally unique name

  tags = {
    Name = "Terraform State Bucket"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Locks Table"
  }
}