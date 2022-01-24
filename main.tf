terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "3xmgroup"

    workspaces {
      name = "po3xmgroup-staticsite"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}



module "app" {
  source          = "./modules/app"
  vpc_id          = module.network.vpc_id
  subnet_id       = module.network.subnet_id
  iam_profile_ec2 = module.security.iam_profile_ec2
}

module "network" {
  source = "./modules/network"

}

module "routing" {
  source = "./modules/routing"
  vpc_id = module.network.vpc_id
  igw_id = module.network.igw_id
}

module "security" {
  source = "./modules/security"

}