provider "aws" {
    region = "us-east-1"
}



resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

module "myapp-subnet" {
    source = "./modules/subnet"
    subnet_cidr_block = var.subnet_cidr_block
    env_prefix = var.env_prefix
    vpc_id = aws_vpc.myapp-vpc.id
}

resource "aws_security_group" "myapp-sg" {
    name   = "myapp-sg"
    vpc_id = aws_vpc.myapp-vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name = "${var.env_prefix}-sg"
    }
}

resource "aws_key_pair" "ssh-key" {
    key_name   = "server-key"
    public_key = var.mypublic_key
}

resource "aws_instance" "myapp-server" {
    ami                         = var.ami
    instance_type               = var.instance_type
    subnet_id                   = module.myapp-subnet.subnet.id
    vpc_security_group_ids      = [aws_security_group.myapp-sg.id]
    availability_zone           = "us-east-1a"
    associate_public_ip_address = true
    key_name                    = aws_key_pair.ssh-key.key_name

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y docker
                systemctl start docker
                systemctl enable docker
                usermod -aG docker ec2-user
                docker run -d -p 8080:80 nginx
                EOF


    user_data_replace_on_change = true


    tags = {
        Name = "${var.env_prefix}-server"
    }
}

