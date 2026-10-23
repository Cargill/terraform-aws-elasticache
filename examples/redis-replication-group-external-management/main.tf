provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  region = "eu-west-1"
  name   = "ex-${basename(path.cwd)}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "elasticache" {
  source = "../../"

  replication_group_id = local.name
  engine_version       = "7.1"
  node_type            = "cache.t4g.small"

  # An external workflow owns engine upgrades, credential rotation, and
  # selected operational attributes after initial creation.
  replication_group_lifecycle_ignore_changes_mode = "external_management"
  parameter_group_lifecycle_ignore_changes_mode   = "external_management"

  transit_encryption_enabled = true
  auth_token                 = "PickSomethingMoreSecure123!"

  vpc_id = module.vpc.vpc_id
  security_group_rules = {
    ingress_vpc = {
      description = "VPC traffic"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  subnet_ids = module.vpc.private_subnets
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]
}
