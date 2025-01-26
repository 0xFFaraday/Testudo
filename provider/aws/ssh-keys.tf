# Generates a secure private key
resource "tls_private_key" "linux_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generates a secure private key
resource "tls_private_key" "windows_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create key pair
resource "aws_key_pair" "windows_key_pair" {
  key_name   = "windows-key-pair"
  public_key = tls_private_key.windows_key_pair.public_key_openssh
}

# Create key pair
resource "aws_key_pair" "linux_key_pair" {
  key_name   = "linux-key-pair"
  public_key = tls_private_key.linux_key_pair.public_key_openssh
}

# Save file for linux SSH
resource "local_file" "linux_ssh_key" {
  filename = "../../${aws_key_pair.linux_key_pair.key_name}.pem"
  content  = tls_private_key.linux_key_pair.private_key_pem

  # create public keys for any specific use
  # provisioner "local-exec" {
  #   when = create
  #   command = "ssh-keygen -y -f ../../${aws_key_pair.linux_key_pair.key_name}.pem -m PKCS8 > ../../${aws_key_pair.linux_key_pair.key_name}.pub"
  # }

  # cleanup any SSH keys when tearing down lab
  # provisioner "local-exec" {
  #   when = destroy
  #   command = "rm ../../*.pem; rm ../../*.pub"
  # }
}

# Save file for windows RDP decrypting
resource "local_file" "windows_rdp_password_key" {
  filename = "../../${aws_key_pair.windows_key_pair.key_name}.pem"
  content  = tls_private_key.windows_key_pair.private_key_pem

  # create public keys for any specific use
  # provisioner "local-exec" {
  #   when = create
  #   command = "ssh-keygen -y -f ../../${aws_key_pair.windows_key_pair.key_name}.pem -m PKCS8 > ../../${aws_key_pair.windows_key_pair.key_name}.pub"
  # }
}
