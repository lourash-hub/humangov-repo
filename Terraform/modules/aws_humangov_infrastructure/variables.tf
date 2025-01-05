variable "state_name" {
  description = "The name of the US state"
  type        = string
  
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "webserver_vpc"
}

variable "public_subnets" {
  description = "A list of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "humangov_ec2_key" {
  description = "The name of the EC2 key pair"
  type        = string
  default     = "icloud"
}

variable "region" {
  default = "us-east-1"
}