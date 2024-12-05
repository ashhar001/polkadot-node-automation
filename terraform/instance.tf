# EC2 instance for the first Polkadot validator node
# Uses Amazon Linux 2 AMI optimized for EC2
resource "aws_instance" "validator_1" {
  ami                    = "ami-0e731c8a588258d0d"  # Amazon Linux 2 AMI ID
  instance_type          = "c5.4xlarge"             # Compute-optimized instance with 16 vCPUs and 32 GiB RAM
  key_name               = "test-key"               # SSH key pair name for instance access
  subnet_id              = aws_subnet.public.id     # Places instance in the public subnet
  vpc_security_group_ids = [aws_security_group.validator_sg.id]  # Attaches security group rules

  # Storage configuration for blockchain data
  root_block_device {
    volume_size = 1024    # 1 TB storage for blockchain data
    volume_type = "gp3"   # General Purpose SSD with better performance
    iops        = 16000   # Maximum IOPS for gp3
    throughput  = 500     # Maximum throughput in MB/s
  }

  tags = {
    Name = "Polkadot-Validator-1"  # Instance name tag
  }
}

# EC2 instance for the second Polkadot validator node
# Identical configuration to validator_1 for high availability
resource "aws_instance" "validator_2" {
  ami                    = "ami-0e731c8a588258d0d"
  instance_type          = "c5.4xlarge"
  key_name               = "test-key"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.validator_sg.id]

  root_block_device {
    volume_size = 1024
    volume_type = "gp3"
    iops        = 16000
    throughput  = 500
  }

  tags = {
    Name = "Polkadot-Validator-2"
  }
}

# Elastic IP for validator_1
# Provides a static public IP address that remains constant even if instance is stopped/started
resource "aws_eip" "eip_1" {
  instance = aws_instance.validator_1.id  # Associates EIP with validator_1
  domain   = "vpc"                        # VPC scope for the EIP

  tags = {
    Name = "EIP-001"  # EIP identifier
  }
}

# Elastic IP for validator_2
# Ensures both validators have static public IPs for consistent access
resource "aws_eip" "eip_2" {
  instance = aws_instance.validator_2.id
  domain   = "vpc"

  tags = {
    Name = "EIP-002"
  }
}