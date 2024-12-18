# Output the public IP addresses of both validator nodes
output "validator_1_public_ip" {
  description = "Public IP address of validator 1"
  value       = aws_eip.eip_1.public_ip
}

output "validator_2_public_ip" {
  description = "Public IP address of validator 2"
  value       = aws_eip.eip_2.public_ip
}

# Output the EC2 instance IDs of both validator nodes
output "validator_1_instance_id" {
  description = "Instance ID of validator 1"
  value       = aws_instance.validator_1.id
}

output "validator_2_instance_id" {
  description = "Instance ID of validator 2"
  value       = aws_instance.validator_2.id
}

# Output the VPC ID where all resources are deployed
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# Output the public subnet ID where validator nodes are placed
# This subnet has internet connectivity for node operation
# Used for resource placement and network configuration
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}
