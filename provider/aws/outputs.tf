output "jumpbox_windows_instance_details" {
  value = {
    for k, v in aws_instance.windows_jumpbox: k => {
      instance_id = v.id
      public_ip = v.public_ip
      private_ip = v.private_ip
    }
  }
}

output "jumpbox_ubuntu_instance_details" {
  value = {
    for k, v in aws_instance.linux_jumpbox: k => {
      instance_id = v.id
      public_ip = v.public_ip
      private_ip = v.private_ip
    }
  }
}

output "redirectors_instance_details" {
  value = {
    for k, v in aws_instance.redirector: k => {
      instance_id = v.id
      public_ip = v.public_ip
      private_ip = v.private_ip
    }
  }
}

output "c2_servers_instance_details" {
  value = {
    for k, v in aws_instance.c2_server: k => {
      instance_id = v.id
      public_ip = v.public_ip
      private_ip = v.private_ip
    }
  }
}

output "ansible_controller_instance_details" {
    value = {
    "ap-01" = {
      instance_id = aws_instance.ansible_controller.id
      public_ip  = aws_instance.ansible_controller.public_ip
      private_ip = aws_instance.ansible_controller.private_ip
    }
  }
}
