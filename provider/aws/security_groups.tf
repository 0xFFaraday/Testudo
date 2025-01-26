resource "aws_security_group" "sg_testudo_jumpboxes" {
  name        = "sg_testudo_jumpboxes"
  description = "Security group for private_vpc"
  vpc_id      = aws_vpc.testudo_vpc.id

  # Allow redirector traffic to jumpboxes
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.16.1.0/24"]
  }

  # Allow c2 traffic to jumpboxes
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.16.2.0/24"]
  }

  # Allow cross traffic between jumpboxes
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.16.3.0/24"]
  }

  # Allow only operators to interact with jumpboxes
  dynamic "ingress" {
    for_each = local.INGRESS_OPERATORS
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.ip]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_testudo_c2_servers" {
  name        = "sg_testudo_c2_servers"
  description = "Security group for remote access of operators"
  vpc_id      = aws_vpc.testudo_vpc.id

  # Allow operator jumpboxes to reach out to C2 and Phishing servers for administration
  dynamic "ingress" {
    for_each = var.OPERATOR_ADMINISTRATION
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = [ingress.value.cidr_blocks]
    }
  }

  # Allow local traffic with redirectors
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.16.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_testudo_redirectors" {
  name        = "sg_testudo_redirectors"
  description = "Security group for testudo_vpc"
  vpc_id      = aws_vpc.testudo_vpc.id

  # ensure that ROE IP and Port combos are only allowed
  dynamic "ingress" {
    for_each = local.ROE_TRAFFIC_COMBINATIONS
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = [ingress.value.ip]
    }
  }

  # Allow operator jumpboxes to reach out to redirector servers for administration
  dynamic "ingress" {
    for_each = var.REDIRECTOR_ADMINISTRATION
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = [ingress.value.cidr_blocks]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}