terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Choose a region, us-east-1 is a common choice
}

# Use the default VPC
data "aws_vpc" "default" {
  default = true
}

# Use a default subnet
data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a"
  default_for_az    = true
}

# No need for internet gateway and route table with default VPC

# Security group in the default VPC
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow inbound traffic for the app"
  vpc_id      = data.aws_vpc.default.id

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # For production, restrict this to your IP
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}

# Use existing key pair
# No need to create a new one

# EC2 instance (free tier eligible)
resource "aws_instance" "app_server" {
  ami                    = "ami-0261755bbcb8c4a84"  # Amazon Linux 2023 AMI - free tier eligible
  instance_type          = "t2.micro"  # Free tier eligible
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = "app-key-pair"  # Use the existing key pair
  
  # User data script to install Node.js and set up the application
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git
              curl -sL https://rpm.nodesource.com/setup_18.x | bash -
              yum install -y nodejs
              mkdir -p /home/ec2-user/app
              chown ec2-user:ec2-user /home/ec2-user/app
              # Install PM2 globally for process management
              npm install -g pm2
              EOF

  tags = {
    Name = "app-server"
  }
}

# Output the public IP for easy access
output "public_ip" {
  value = aws_instance.app_server.public_ip
}

# No private key output needed