#================================#
# STATE PERSISTENT BACKEND
#================================#
terraform {
  backend "s3" {
    bucket = "ecsworkshopbucket00"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Name = "btc-on-ecs"
    }
  }
}
