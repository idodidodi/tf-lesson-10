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

  # SSH access (Restrict this to your IP for better security!)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["147.235.180.110/32", "18.206.107.24/29"] # the first is my ip, the second is the aws range ips to connect through the session manager
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