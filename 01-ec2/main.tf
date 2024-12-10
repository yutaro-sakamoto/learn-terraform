variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Project = "terraform-example"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.0.0/24"
}

resource "aws_instance" "example" {
  ami           = "ami-023ff3d4ab11b2525"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data_replace_on_change = true

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World!" > index.html
    nohup busybox httpd -f -p ${var.server_port} &
    EOF
}

resource "aws_security_group" "instance" {
  name   = "terraform-example-instance"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the instance"
}
