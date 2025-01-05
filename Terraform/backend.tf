terraform {
  backend "s3" {
    bucket         = "humangov-terraform-state-lourash"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tcb-devops-state-lock-table"

  }
}