# creation of ansible provisioner
  resource "aws_instance" "ansible_controller" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = try(var.prefered_instance_type, "t3.micro")
  subnet_id              = aws_subnet.operators_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_testudo_jumpboxes.id]
  key_name               = aws_key_pair.linux_key_pair.key_name

  availability_zone = var.AWS_AVAIL_ZONE

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 16
  }

  associate_public_ip_address = true
  private_ip                  = "172.16.3.5"

  tags = {
    Name = "Testudo-ansible_controller_linux"
  }

  # setup ssh connection to copy files
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

  # ansible playbooks and inventory files
  provisioner "file" {
    source      = "../../ansible"
    destination = "/home/ubuntu/ansible"
  }

  # C2 setup scripts
  provisioner "file" {
    source      = "../../c2-setup-scripts"
    destination = "/home/ubuntu/"
  }

  # pre-req script to execute
  user_data = file("../../utils/resource-setup.sh")

}