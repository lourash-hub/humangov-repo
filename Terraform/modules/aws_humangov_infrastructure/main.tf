/*
# VPC
resource "aws_vpc" "state_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "humangov-${var.state_name}-${var.vpc_name}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "state_igw" {
  vpc_id = aws_vpc.state_vpc.id
  tags = {
    Name = "humangov-${var.state_name}-igw"
  }
}

# Route Table with route to Internet Gateway
resource "aws_route_table" "state_public_rt" {
  vpc_id = aws_vpc.state_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.state_igw.id
  }

  tags = {
    Name = "humangov-${var.state_name}-public-rt"
  }
}

# Public Subnet and Route Table Association
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.state_vpc.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count         = length(var.public_subnets)
  subnet_id     = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.state_public_rt.id
}

# Security Group with specific rules for EC2 Instance Connect
resource "aws_security_group" "state_ec2_sg" {
  name = "humangov-${var.state_name}-ec2-sg"

  # Allow HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow custom TCP on port 5000
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access from all IPs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH access from EC2 Instance Connect IP range
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.206.107.24/29"]
  }

  # Allow all inbound traffic (remove or modify as per your needs)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.state_vpc.id

  tags = {
    Name = "humangov-${var.state_name}"
  }
}

# EC2 Instance
resource "aws_instance" "example" {
  ami                    = "ami-0e86e20dae9224db8"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet[0].id
  key_name               = var.humangov_ec2_key
  vpc_security_group_ids = [aws_security_group.state_ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.s3_dynamodb_full_access_instance_profile.name

    provisioner "local-exec" {
	  command = "sleep 60; ssh-keyscan ${self.public_ip} >> ~/.ssh/known_hosts"
	}
	
	provisioner "local-exec" {
	  command = "echo ${var.state_name} id=${self.id} ansible_host=${self.public_ip} ansible_user=ubuntu us_state=${var.state_name} aws_region=${var.region} aws_s3_bucket=${aws_s3_bucket.state_s3.bucket} aws_dynamodb_table=${aws_dynamodb_table.state_dynamodb.name} >> /etc/ansible/hosts"
	}
	
	provisioner "local-exec" {
	  command = "sed -i '/${self.id}/d' /etc/ansible/hosts"
	  when = destroy
	}

  tags = {
    Name = "humangov-${var.state_name}"
  }
}
*/

# DynamoDB Table
resource "aws_dynamodb_table" "state_dynamodb" {
  name           = "humangov-${var.state_name}-dynamodb"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "humangov-${var.state_name}"
  }
}

# S3 Bucket
resource "random_string" "bucket_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "aws_s3_bucket" "state_s3" {
  bucket = lower(replace("humangov-${var.state_name}-s3-${random_string.bucket_suffix.result}", "_", "-"))

  tags = {
    Name = "humangov-${var.state_name}"
  }
}

/*
# IAM Role and Policy for S3 and DynamoDB
resource "aws_iam_role" "s3_dynamodb_full_access_role" {
  name = "humangov-${var.state_name}-s3_dynamodb_full_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "humangov-${var.state_name}"
  }
}

resource "aws_iam_role_policy_attachment" "s3_full_access_role_policy_attachment" {
  role       = aws_iam_role.s3_dynamodb_full_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access_role_policy_attachment" {
  role       = aws_iam_role.s3_dynamodb_full_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_instance_profile" "s3_dynamodb_full_access_instance_profile" {
  name = "humangov-${var.state_name}-s3_dynamodb_full_access_instance_profile"
  role = aws_iam_role.s3_dynamodb_full_access_role.name

  tags = {
    Name = "humangov-${var.state_name}"
  }
}
*/