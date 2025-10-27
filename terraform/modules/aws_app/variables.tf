
variable "aws_region" {
  default =  "us-east-2"
}


variable "env" {
    type = string
    default = "dev" 
}

variable "vpc_name" {
  type = string
  default = "myvpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type = string
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
  type = string
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
  type = string
  
}


variable "availability_zones" {
  type = list(string)
  default = ["us-east-2a", "us-east-2b"]
}

variable "subnet_name" {
  type = string
  default = "myvpc"
}

variable "allowed_ports" {
  type = list(string)
  default = ["80", "443", "22", "8080"]
}

variable "key_name" {
  type = string
  default = "mykey"
}

variable "public_key_path" {
  
}


variable "instance_type" {
  default = "t3.micro"
}

variable "ami" {
  default = "ami-0cfde0ea8edd312d4" 
}

variable "instance_count" {
  default = 1
}

variable "app_name" {
  default = "my-app"
}




