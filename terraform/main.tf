provider "aws" {
  region = "us-east-1"  # Choose a region, us-east-1 is a common choice
}

# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "app-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
  tags = {
    Name = "app-igw"
  }
}

# Create a route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a security group
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow inbound traffic for the app"
  vpc_id      = aws_vpc.app_vpc.id

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

# EC2 instance (free tier eligible)
resource "aws_instance" "app_server" {
  ami                    = "ami-0261755bbcb8c4a84"  # Amazon Linux 2023 AMI - free tier eligible
  instance_type          = "t2.micro"  # Free tier eligible
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = "app-key-pair"  # You'll need to create this key pair in AWS
  
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