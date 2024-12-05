# Security group resource for Polkadot validator nodes
# This defines the inbound and outbound network access rules
resource "aws_security_group" "validator_sg" {
  
  name        = "validator_security_group"
  description = "Security group for Polkadot validator nodes"
  # Associates the security group with our VPC
  vpc_id      = aws_vpc.main.id

  # Inbound rule for SSH access
  # Port 22 is the standard SSH port
  # WARNING: Opening to 0.0.0.0/0 allows access from anywhere - consider restricting in production
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 30333
    to_port     = 30333
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Polkadot p2p port"
  }

  # Inbound rule for JSON-RPC API access
  # Port 9933 allows external services to interact with the node
  # Consider restricting access to specific IPs in production
  ingress {
    from_port   = 9933
    to_port     = 9933
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "RPC ports"
  }

  ingress {
    from_port   = 9944
    to_port     = 9944
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "WebSocket ports"
  }

  # Outbound rule allowing all traffic
  # Nodes need to connect to various external services and peers
  # Protocol "-1" and port 0 means all protocols and ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  # Tags for resource identification and management
  tags = {
    Name = "validator_security_group"
  }
}
