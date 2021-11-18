# module "aurora" {
#   source  = "terraform-aws-modules/rds-aurora/aws"

#   engine         = var.db_engine
#   engine_version = var.db_engine_version
#   instance_class = var.db_instance_type
#   instances = {
#     one = {}
#     2 = {
#       instance_class = "db.r6g.2xlarge"
#     }
#   }

#   vpc_id  = "vpc-12345678"
#   subnets = ["subnet-12345678", "subnet-87654321"]

#   allowed_security_groups = ["sg-12345678"]
#   allowed_cidr_blocks     = ["10.20.0.0/20"]

#   storage_encrypted   = true
#   apply_immediately   = true
#   monitoring_interval = 30

#   db_parameter_group_name         = "default"
#   db_cluster_parameter_group_name = "default"

#   master_username = var.db_admin_username
#   master_password = random_password.grafana_db_pwd[0].result

#   name               = module.label.name
#   stage              = module.label.stage
#   environment        = module.label.environment
#   namespace          = module.label.namespace
#   tags               = module.label.tags
# }