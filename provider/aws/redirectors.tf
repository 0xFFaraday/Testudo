variable "linux_rd_vm_config" {
  type = map(object({
    name               = string
    ami                = string
    instance_type      = string
    private_ip_address = string
    password           = string
  }))

default = {
  "rd-01" = {
    name                = "RD-01"
    ami                 = "ami-0a0e5d9c7acc336f1"
    instance_type       = "t3.medium"
    private_ip_address  = "172.16.1.10"
    password            = "r3directingAllTh0sePackets!"
  }
}
}

# creation of redirector servers
resource "aws_instance" "redirector" {
  for_each = var.linux_rd_vm_config
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = aws_subnet.redirectors_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_testudo_redirectors.id]
  key_name               = aws_key_pair.linux_key_pair.key_name

  availability_zone = var.AWS_AVAIL_ZONE

  associate_public_ip_address = true
  private_ip                  = each.value.private_ip_address

  tags = {
    Name = "Testudo-${each.value.name}"
  }
}