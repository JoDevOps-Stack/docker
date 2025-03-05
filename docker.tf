resource "aws_instance" "this" { # "this" means name of resource
  ami                    = "ami-09c813fb71547fc4f"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  instance_type          = "t3.micro"
  
  # 20GB is not enough
  root_block_device {
    volume_size = 50  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
  }
  user_data = file("docker.sh")
  tags = {
    Name    = "docker"
  }
}

resource "aws_security_group" "allow_tls" { #here allow_tls is the name of resource,we can give anything
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # tcp means internet protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" # tcp means internet protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "allow_tls"
  }
}
  output "docker_ip" {
  value       = aws_instance.this.public_ip
}