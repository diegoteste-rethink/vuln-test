provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  # Insecure security group
  vpc_security_group_ids = [aws_security_group.insecure.id]

  tags = {
    Name = "example-instance"
  }
}

resource "aws_security_group" "insecure" {
  name        = "insecure-security-group"
  description = "Security group with overly permissive rules"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "example-vulnerable-bucket"

  # Unencrypted bucket
  acl    = "public-read"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "example-vulnerable-bucket"
    Environment = "Dev"
  }
}

resource "aws_db_instance" "example" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "exampledb"
  username             = "root"
  password             = "insecurepassword"
  parameter_group_name = "default.mysql5.7"

  # Disable storage encryption
  storage_encrypted = false

  skip_final_snapshot = true

  tags = {
    Name = "exampledb"
  }
}
