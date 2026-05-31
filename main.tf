provider "aws" {
    region = "us-east-1"
    
}

variable "subnet_cidr_block" {
    description = "CIDR block for the subnet"
}

variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
}

variable "environment" {
    description = "Environment for the resources"
}

resource "aws_vpc" "development-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "development"
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id            = aws_vpc.development-vpc.id
    cidr_block        = var.subnet_cidr_block
    availability_zone = "us-east-1a"
    tags = {
        Name    = "subnet-1-dev"
        vpc_env = "dev"
    }
}

data "aws_vpc" "existing-vpc" {
    default = true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id            = data.aws_vpc.existing-vpc.id
    cidr_block        = "172.31.96.0/20"   # ✅ fixed
    availability_zone = "us-east-1c"        # ✅ fixed
    tags = {
        Name = "subnet-2-dev"
    }
}

output "dev-vpc-id" {
    value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
}