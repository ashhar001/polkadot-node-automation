resource "aws_security_group" "validator_sg" {
  name        = "validator_security_group"
  description = "Security group for Polkadot validator nodes"
  vpc_id      = aws_vpc.main.id

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # Allow p2p ports for Polkadot
  ingress {
    from_port   = 30333
    to_port     = 30333
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Polkadot p2p port"
  }

  # Allow RPC ports
  ingress {
    from_port   = 9933
    to_port     = 9934
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "RPC ports"
  }

  # Allow WebSocket ports
  ingress {
    from_port   = 9944
    to_port     = 9945
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "WebSocket ports"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "validator_security_group"
  }
}
