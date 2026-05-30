variable subnet_cidr_block {
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