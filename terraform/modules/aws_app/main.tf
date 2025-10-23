# --------------------------
# VPC
# --------------------------
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.env}-${var.app_name}-${var.vpc_name}"
  }
}

# --------------------------
# Public Subnet
# --------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.pub_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[0]

  tags = {
    Name = "${var.env}-${var.app_name}-public-subnet"
  }
}

# --------------------------
# Private Subnet
# --------------------------
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zones[0]

  tags = {
    Name = "${var.env}-${var.app_name}-private-subnet"
  }
}

# --------------------------
# Internet Gateway
# --------------------------
resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.env}-${var.app_name}-igw"
  }
}

# --------------------------
# Public Route Table
# --------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }

  tags = {
    Name = "${var.env}-${var.app_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# --------------------------
# Security Group
# --------------------------
resource "aws_security_group" "my_sg" {
  name   = "${var.env}-${var.app_name}-sg"
  vpc_id = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow inbound traffic on port ${ingress.value}"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

# --------------------------
# Key Pair
# --------------------------
resource "aws_key_pair" "my_key" {
  key_name   = "${var.env}-${var.key_name}"
  public_key = file(var.public_key_path)
}

# --------------------------
# EC2 Instances
# --------------------------
resource "aws_instance" "public_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name               = aws_key_pair.my_key.key_name

  tags = {
    Name = "${var.env}-${var.app_name}-public"
  }
}

resource "aws_instance" "private_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name               = aws_key_pair.my_key.key_name

  tags = {
    Name = "${var.env}-${var.app_name}-private"
  }
}

# --------------------------
# S3 Bucket
# --------------------------
resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "my_bucket" {
  bucket        = "${var.app_name}-aws-replication-${random_id.bucket.hex}"
  force_destroy = true

  tags = {
    Name = "${var.env}-${var.app_name}-replication-bucket"
  }
}
















# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "public" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true
# }

# resource "aws_instance" "web" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = var.instance_type
#   subnet_id     = aws_subnet.public.id

#   tags = {
#     Name = "${var.app_name}-aws-web"
#   }
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["099720109477"]
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
#   }
# }

# resource "aws_s3_bucket" "storage" {
#   bucket = "${var.app_name}-aws-replication-${random_id.bucket.hex}"
# }

# resource "random_id" "bucket" {
#   byte_length = 4
# }

