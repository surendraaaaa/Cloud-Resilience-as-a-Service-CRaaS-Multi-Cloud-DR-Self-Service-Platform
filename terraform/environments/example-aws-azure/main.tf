variable "app_name" {
  default = "ddr-app"
}

module "aws_app" {
  source              = "../../modules/aws_app"
  app_name            = var.app_name  
  env                 = "dev"
  vpc_name            = "demo-vpc"
  vpc_cidr            = "10.0.0.0/16"
  pub_subnet_cidr     = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zones  = ["us-east-2a", "us-east-2b"]
  subnet_name         = "demo-subnet"
  allowed_ports       = ["80", "443", "22", "8080"]
  key_name            = "demo-key"
  public_key_path     = "my_key.pem"
  instance_count      = 1
  instance_type       = "t3.micro"
  ami                 = "ami-0cfde0ea8edd312d4"
}

module "azure" {
  source          = "../../modules/azure_app"
  app_name        = var.app_name
  azure_location  = "East US"
  env             = "dev"
  vn_address_space = ["10.0.0.0/16"]
  allowed_ports    = ["80", "443", "22", "8080"]
  public_subnet_address_prefixes = ["10.1.1.0/24"]
  private_subnet_address_prefixes = ["10.1.2.0/24"]
  admin_username = "azureuser"
  public_key_path = "my_key.pub"
  vm_size = "Standard_B1s"
}

module "dr_automation_lambda" {
  source = "../../modules/dr_automation_lambda"

  app_name                   = var.app_name
  env                        = "dev"
  s3_bucket_name             = module.aws_app.s3_bucket_name      
  azure_storage_account_name = var.azure_storage_account_name
  azure_storage_account_key  = var.azure_storage_account_key
  azure_container_name       = var.azure_container_name
  
}

module "dns" {
  source        = "../../modules/dns_failover"
  app_domain    = "dr-demo.yourdomain.com"
  primary_ip    = module.aws.aws_web_public_ip
  secondary_ip  = module.azure.azure_vm_private_ip
  cloudflare_zone_id = "YOUR_ZONE_ID"
}
