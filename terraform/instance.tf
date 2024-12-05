resource "aws_instance" "validator_1" {
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
    Name = "Polkadot-Validator-1"
  }
}

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

resource "aws_eip" "eip_1" {
  instance = aws_instance.validator_1.id
  domain   = "vpc"

  tags = {
    Name = "EIP-001"
  }
}

resource "aws_eip" "eip_2" {
  instance = aws_instance.validator_2.id
  domain   = "vpc"

  tags = {
    Name = "EIP-002"
  }
}