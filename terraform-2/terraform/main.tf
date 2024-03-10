provider "aws" {
    region = "ap-northeast-1"
}

locals {
  instance_type = "t2.micro"
  location = "ap-northeast-1"
  env = "dev"
  vpc_cidr = "10.123.0.0/16"
}

module "networking" {
    vpc_cidr = local.vpc_cidr
    source = "../modules/networking"
    access_ip = var.access_ip
    private_sn_count = 2
    public_sn_count = 2
}

module "compute" {
  source = "../modules/compute"
  instance_type = local.instance_type
  ssh_key = "test"
  lb_tg_name = "test"
  key_name = "test"
  public_subnets = module.networking.public_sn_count
  private_subnets = module.networking.private_sn_count
  frontend_app_sg = module.networking.frontend_app_sg
  bastion_sg = module.networking.bastion_sg
  backend_app_sg = module.networking.backend_app_sg
}

module "database" {
  source = "../modules/database"
  db_allocated_storage = 10
  db_instance_class = "db.t2.micro"
  db_engine_version = "8.0"
  db_name = "test"
  db_username = "test"
  db_password = "pwd123"
  db_subnet_group_name = module.networking.rds_db_subnet_group[0]
  identifier = "ee-instance-demo"
  rds_sg = module.networking.rds_sg
  db_skip_snapshot = true
}

module "loadbalancing" {
  source = "../modules/loadbalancing"
  lb_sg = module.networking.lb_sg
  public_subnets = module.networking.private_subnets
  app_sg = module.compute.app_asg
  port = 80
  protocol = "HTTP"
  vpc_id = module.networking.vpc_id

}
