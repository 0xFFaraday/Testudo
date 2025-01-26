variable "linux_jumpbox_vm_config" {
  type = map(object({
    name               = string
    ami                = string
    instance_type      = string
    private_ip_address = string
    password           = string
  }))

default = {
  "jbl-01" = {
    name                = "JBL-01"
    ami                 = "ami-0a0e5d9c7acc336f1"
    instance_type       = "t3.medium"
    private_ip_address  = "172.16.3.20"
    password            = "linuxJumpb0xTime!"
  }
  # "jbl-02" = {
  #   name                = "JBL-02"
  #   ami                 = "ami-0a0e5d9c7acc336f1"
  #   instance_type       = "t3.medium"
  #   private_ip_address  = "172.16.3.21"
  #   password            = "linuxJumpb0xTime!"
  # }
}
}

# creation of linux jumpboxes
resource "aws_instance" "linux_jumpbox" {
    for_each = var.linux_jumpbox_vm_config

    ami                    = each.value.ami
    instance_type          = each.value.instance_type
    subnet_id              = aws_subnet.operators_subnet.id
    vpc_security_group_ids = [aws_security_group.sg_testudo_jumpboxes.id]
    key_name               = aws_key_pair.linux_key_pair.key_name
    
    availability_zone      = var.AWS_AVAIL_ZONE

    ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 16
    }

    associate_public_ip_address = true
    private_ip                  = each.value.private_ip_address

    tags = {
      Name = "Testudo-${each.value.name}"
    }

    connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = tls_private_key.linux_key_pair.private_key_pem
  }

    provisioner "file" {
    source      = "../../${aws_key_pair.linux_key_pair.key_name}.pem"
    destination = "/home/ubuntu/.ssh/id_rsa"
  }

    provisioner "file" {
    source      = "../../${aws_key_pair.linux_key_pair.key_name}.pem"
    destination = "/home/ubuntu/.ssh/windows_id_rsa"
  }

}

variable "windows_jumpbox_vm_config" {
  type = map(object({
    name               = string
    ami                = string
    instance_type      = string
    private_ip_address = string
    password           = string
  }))
default = {
  "jbw-01" = {
    name                = "JBW-01"
    ami                 = "ami-0b1f2b17be9b81cdc"
    instance_type       = "t3.medium"
    private_ip_address  = "172.16.3.10"
    password            = "windowsJumpb0xTime!"
  }
}
}

# creation of windows jumpboxes
resource "aws_instance" "windows_jumpbox" {
    for_each = var.windows_jumpbox_vm_config

    ami                    = each.value.ami
    instance_type          = each.value.instance_type
    subnet_id              = aws_subnet.operators_subnet.id
    vpc_security_group_ids = [aws_security_group.sg_testudo_jumpboxes.id]
    key_name               = aws_key_pair.windows_key_pair.key_name
    
    availability_zone      = var.AWS_AVAIL_ZONE

    associate_public_ip_address = true
    private_ip                  = each.value.private_ip_address

    tags = {
      Name = "Testudo-${each.value.name}"
    }

    user_data = templatefile("${path.module}/instance-init.ps1.tpl", {
                            username = var.jumpbox_username
                            password = each.value.password
                        })

}