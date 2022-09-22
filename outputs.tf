output "public_ip" {
  description = "Public IP address of the provisioned website."
  value       = module.webserver-aws.public_ip
}

output "public_dns" {
  description = "Public DNS name of the provisioned website."
  value       = module.webserver-aws.public_dns
}
