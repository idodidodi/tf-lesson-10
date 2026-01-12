data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-server-sg"
  description = "Allow HTTP, HTTPS and SSH traffic"
  vpc_id      = data.aws_vpc.default.id


  # HTTP access from anywhere
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from your IPs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["147.235.180.110/32", "79.177.129.158/32"]
  }

  # SSH access for EC2 Instance Connect (AWS managed prefix list)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    prefix_list_ids = ["pl-0e4bcff02b13bef1e"] # EC2 Instance Connect for us-east-1
  }

  # Outbound Rules: Allow the server to talk to the internet 
  # (Necessary for downloading WordPress updates and plugins)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-sg"
  }
}