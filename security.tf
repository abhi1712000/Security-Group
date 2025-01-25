provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_eip" "lb" {
  domain   = "vpc"
}

resource "aws_security_group" "from_eip" {
  name        = "from_eip"
  description = "Allow TLS inbound traffic and all outbound traffic"
}

resource "aws_vpc_security_group_ingress_rule" "from_eip_ipv4" {
  security_group_id = aws_security_group.from_eip.id
  cidr_ipv4         = "${aws_eip.lb.public_ip}/32"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "from_eip_traffic_ipv4" {
  security_group_id = aws_security_group.from_eip.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}