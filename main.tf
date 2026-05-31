provider "aws" {
    region = "us-east-1"

    ####
}

variable "subnet_cidr_block" {
    description = "CIDR block for the subnet"
}

variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
}

variable "my_ip" {
    description = "Your IP address in CIDR notation"
}

variable "mypublic_key" {
    description = "Your SSH public key"
}

variable "env_prefix" {}
variable "ami" {}
variable "instance_type" {}
variable "private_key_location" {}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "myapp-subnet-1" {
    vpc_id            = aws_vpc.myapp-vpc.id
    cidr_block        = var.subnet_cidr_block
    availability_zone = "us-east-1a"
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }
}

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id
    tags = {
        Name = "${var.env_prefix}-igw"
    }
}

