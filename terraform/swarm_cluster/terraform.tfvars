#environment           = "prod"
#project               = "timeoff"
manager_count         = 1
worker_count          = 1
manager_instance_type = "t3.small"
worker_instance_type  = "t3.small"
create_efs_sg         = true
create_nfs_sg         = false
external_eips         = true
