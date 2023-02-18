module "vpc" {
  source            = "./vpc"
  region            = "us-east-1"
  environment       = "Home"
  vpc_cidr          = "10.0.0.0/16"
  public_subnets    = "10.0.1.0/24"
  private_subnets   = "10.0.2.0/24"
  private02_subnets = "10.0.3.0/24"

}

