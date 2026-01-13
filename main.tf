provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "default" {
  default = true
}

module "wordpress_sg" {
  source      = "./modules/aws_sg"
  vpc_id      = data.aws_vpc.default.id
  sg_name     = "wordpress-server-sg"
  allowed_ips = ["147.235.180.110/32", "79.177.129.158/32"]
}

module "wordpress_ec2" {
  source             = "./modules/aws_ec2"
  ami_id             = data.aws_ami.ubuntu.id
  instance_type      = "t2.micro"
  security_group_ids = [module.wordpress_sg.security_group_id]
  user_data          = "${file("main.sh")}\n${file("docker.sh")}\n${file("wordpress.sh")}"
  instance_name      = "learn-terraform"
}

moved {
  from = aws_instance.app_server
  to   = module.wordpress_ec2.aws_instance.this
}

moved {
  from = aws_security_group.wordpress_sg
  to   = module.wordpress_sg.aws_security_group.this
}
