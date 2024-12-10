resource "aws_instance" "bastion" {
  ami                    = "ami-05c172c7f0d3aed00"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_a1.id
  key_name               = "bastion-key"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh_ingress" {
  description       = "Allow SSH from the Austin Lab."
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "99.153.67.105/32"
}

resource "aws_vpc_security_group_egress_rule" "bastion_all_egress" {
  description       = "Allow all outbound traffic"
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
