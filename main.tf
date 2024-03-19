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
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = "16.1"
  instance_class            = "db.t3.micro"
  name                      = "techchallengedb"
  identifier                = "g73-techchallenge-db"
  final_snapshot_identifier = "g73-techchallenge-db"
  username                  = var.g73_techchallenge_db_username
  password                  = var.g73_techchallenge_db_password
  parameter_group_name      = "default.postgres16"
  publicly_accessible       = true
  skip_final_snapshot       = true
}

resource "aws_security_group_rule" "g73_techchallenge_db_sg_rule" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = "sg-0806beb2f784f5aba"
  cidr_blocks       = ["0.0.0.0/0"]
}