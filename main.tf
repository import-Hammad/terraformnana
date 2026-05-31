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


module "myapp-webserver" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.myapp-vpc.id
    my_ip = var.my_ip
    mypublic_key = var.mypublic_key
    env_prefix = var.env_prefix
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = module.myapp-subnet.subnet.id
}







