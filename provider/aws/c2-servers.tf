variable "linux_c2_vm_config" {
  type = map(object({
    name               = string
    ami                = string
    instance_type      = string
    private_ip_address = string
    password           = string
  }))

default = {
  "c2-01" = {
    name                = "C2-01"
    ami                 = "ami-04b4f1a9cf54c11d0"# 22.04 if needed ami-0a0e5d9c7acc336f1
    instance_type       = "t3.medium"
    private_ip_address  = "172.16.2.10"
    password            = "c2isTooC00lForYou!"
  }
}
}

# creation of C2 servers
resource "aws_instance" "c2_server" {
  
  for_each = var.linux_c2_vm_config
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = aws_subnet.c2_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_testudo_c2_servers.id]
  key_name               = aws_key_pair.linux_key_pair.key_name

  availability_zone = var.AWS_AVAIL_ZONE

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 32
  }

  associate_public_ip_address = true
  private_ip                  = each.value.private_ip_address

  tags = {
    Name = "Testudo-${each.value.name}"
  }
}
