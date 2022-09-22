variable "region" {
  description = "The region where the resources are created."
}

variable "hcp_channel_name" {
  description = "The channel name which should be referenced from HCP Packer"

  validation {
    condition     = contains(["production", "development", "testing"], var.hcp_channel_name)
    error_message = "The HCP Packer channel name can only be of: production, development, testing"
  }
}

variable "prefix" {
  description = "This prefix will be included in the name of most resources."
  default     = "pthrasher"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}

variable "instance_type" {
  description = "Specifies the AWS instance type."
  default     = "t3.micro"
}

variable "key_name" {
  description = "The key name of the Key Pair to use for the instance"
  default     = "pthrasher-packer-demo"
}

variable "hcp_bucket_name" {
  description = "The bucket name which should be referenced from HCP Packer"
  default     = "centos7-web-aws"
}

variable "hcp_provider" {
  description = "The provider which should be referenced from HCP Packer"
  default     = "aws"
}
