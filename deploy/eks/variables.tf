locals {
  name     = "taskly-cluster"
  region   = "us-east-1"
  app_name = "taskly"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    cluster = local.name
  }
}
