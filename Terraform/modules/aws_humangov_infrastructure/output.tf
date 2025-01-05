/*
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.state_vpc.id
}

# output "ec2_pub_ip" {
#   description = "The public IP address of the EC2 instance"
#   value       = aws_instance.example.public_ip
# }

# output "state_ec2_public_dns" {
#   value = aws_instance.example.public_dns
# }
*/

output "state_dynamodb_table" {
  value = aws_dynamodb_table.state_dynamodb.name
}

output "state_s3_bucket" {
  value = aws_s3_bucket.state_s3.bucket
}
