variable "region" {
  description = "The region where the resources are created."
  default     = "eu-central-1"
}

variable "hcp_client" {
  description = "The client ID used to authenticate to the HCP Packer service."
}

variable "hcp_secret" {
  description = "The client secret used to authenticate to the HCP Packer service."
}

variable "hcp_channel_name" {
  description = "The channel name which should be referenced from HCP Packer"

  validation {
    condition     = contains(["production", "development", "testing"], var.hcp_channel_name)
    error_message = "The HCP Packer channel name can only be of: production, development, testing"
  }
}
