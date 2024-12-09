provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Project = "terraform-example"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.0.0/24"
}

resource "aws_instance" "example" {
  ami           = "ami-023ff3d4ab11b2525"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main.id
}