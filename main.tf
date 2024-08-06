provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "g73-techchallenge-db-infra"
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
  vpc_security_group_ids    = [aws_security_group.allow_rds_postgres.id]
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_security_group" "allow_rds_postgres" {
  name        = "allow_tls"
  description = "Allow RDS Postgres inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id
}
resource "aws_security_group_rule" "g73_techchallenge_db_sg_rule" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_rds_postgres.id
  cidr_blocks       = ["0.0.0.0/0"]
}
