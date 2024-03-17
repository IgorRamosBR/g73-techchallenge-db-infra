provider "aws" {
  region = "us-east-1"
}

terraform {
    backend "s3" {
    bucket = "g73-techchallenge-infra"
    key    = "db/state/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


resource "aws_db_instance" "g73_techchallenge_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.1"
  instance_class       = "db.t3.micro"
  name                 = "techchallengedb"
  identifier           = "g73-techchallenge-db"
  username             = var.g73_techchallenge_db_username
  password             = var.g73_techchallenge_db_password
  parameter_group_name = "default.postgres16"
  publicly_accessible  = true
}