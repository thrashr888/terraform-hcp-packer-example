terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=3.42.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.20.0"
    }
  }

  cloud {
    organization = "pthrasher"

    workspaces {
      tags = ["packer", "service:aws"]
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "Demo"
      Name        = "pthrasher"
    }
  }
}

provider "hcp" {
  client_id     = var.hcp_client
  client_secret = var.hcp_secret
}

module "webserver-aws" {
  source = "./modules/webserver-aws"

  region           = var.region
  hcp_channel_name = var.hcp_channel_name
}
