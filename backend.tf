terraform {
  backend "s3" {
    bucket         = "high-lab-state-bucket-shimbita"
    key            = "envs/dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    profile        = "iamadmin-general"
  }
}