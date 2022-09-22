
data "hcp_packer_iteration" "hashiapp_iteration" {
  bucket_name = var.hcp_bucket_name
  channel     = var.hcp_channel_name
}

data "hcp_packer_image" "hashiapp_image" {
  bucket_name    = var.hcp_bucket_name
  cloud_provider = var.hcp_provider
  iteration_id   = data.hcp_packer_iteration.hashiapp_iteration.ulid
  region         = var.region

  # lifecycle {
  #   postcondition {
  #     condition = 
  #   }
  # }
}

resource "aws_vpc" "hashiapp" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = {
    name        = "${var.prefix}-vpc-${var.region}"
    environment = "Production"
  }
}

resource "aws_subnet" "hashiapp" {
  vpc_id     = aws_vpc.hashiapp.id
  cidr_block = var.subnet_prefix

  tags = {
    name = "${var.prefix}-subnet"
  }
}

resource "aws_security_group" "hashiapp" {
  name = "${var.prefix}-security-group"

  vpc_id = aws_vpc.hashiapp.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "${var.prefix}-security-group"
  }
}

resource "aws_internet_gateway" "hashiapp" {
  vpc_id = aws_vpc.hashiapp.id

  tags = {
    Name = "${var.prefix}-internet-gateway"
  }
}

resource "aws_route_table" "hashiapp" {
  vpc_id = aws_vpc.hashiapp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hashiapp.id
  }
}

resource "aws_route_table_association" "hashiapp" {
  subnet_id      = aws_subnet.hashiapp.id
  route_table_id = aws_route_table.hashiapp.id
}

resource "aws_instance" "hashiapp" {
  ami                         = data.hcp_packer_image.hashiapp_image.cloud_image_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.hashiapp.id
  vpc_security_group_ids      = [aws_security_group.hashiapp.id]
  key_name                    = var.key_name

  tags = {
    Name = "${var.prefix}-centos7-instance"
  }

  lifecycle {
    postcondition {
      condition = self.ami == data.hcp_packer_image.hashiapp_image.cloud_image_id
      error_message = "Must use the latest available AMI, ${data.hcp_packer_image.hashiapp_image.cloud_image_id}."
    }
  }
}

resource "aws_eip" "hashiapp" {
  instance = aws_instance.hashiapp.id
  vpc      = true
}

resource "aws_eip_association" "hashiapp" {
  instance_id   = aws_instance.hashiapp.id
  allocation_id = aws_eip.hashiapp.id
}
