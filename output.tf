output "server_id" {
  value = aws_instance.name_windows_server.id
}

output "private_ip" {
  value = aws_instance.name_windows_server.private_ip
}

output "sg_id" {
  value = aws_security_group.name_sg.id
}

output "eni_id" {
  value = aws_network_interface.name_eni.id
}
