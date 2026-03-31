output "key_pair_filename" {
  value = local_file.ssh_private_key_as_pem.filename
}

output "key_pairname" {
  value = aws_key_pair.my_key_pair.key_name
}