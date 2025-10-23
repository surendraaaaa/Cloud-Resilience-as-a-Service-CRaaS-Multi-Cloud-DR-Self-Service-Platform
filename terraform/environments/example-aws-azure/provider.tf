provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}
}

provider "cloudflare" {
  # Auth handled via environment variable: CLOUDFLARE_API_TOKEN
}
