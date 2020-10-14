resource "aws_instance" "server" {
  ami     = data.aws_ami.linux-ami-id.id
  instance_type = var.web_lc_instance_type
  key_name        = var.key_name
  user_data       = file("userdata.sh")
  subnet_id       = aws_subnet.group3_public1_subnet.id
  security_groups = [aws_security_group.group3_web_sg.id]
  associate_public_ip_address = true

  root_block_device {
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name    = "Bastion host"
    
  }
}
output "public_ip" {
  value = aws_instance.server.public_ip
}

output "private_ip" {
  value = aws_instance.server.private_ip
}

output "instance_id" {
  value = aws_instance.server.id
}