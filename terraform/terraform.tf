terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.17.0"
    }

     azurerm = {
      source = "hashicorp/azurerm"
      version = "4.49.0"
    }

     cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.11.0"
    }
  }

  cloud {
    organization = "my-remote-backend" # Replace with your actual org

    workspaces {
      name = "dev" # Replace with your actual workspace name
    }
  }
  
}



