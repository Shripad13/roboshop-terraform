env          = "dev"
def_vpc_cidr = "172.31.0.0/16"      # Added this additional input to cater maps iterated from vpc
bastion_host = ["172.31.43.201/32"] # update workstation private IP as bastion_host
zone_id      = "Z3AADJGX6KTTL2"     # us-east-1 zone id, we will use this zone id for creating public hosted zone in route53 for dev environment. We will create a public hosted zone for dev environment, so that we can access the application from internet using a domain name. We will create a record set in the public hosted zone to point to the load balancer DNS name. We will use the same zone id for all the environments, as we are creating only one public hosted zone for all the environments.
vpc = {
  main = {
    cidr               = "10.0.0.0/16"
    availability_zones = ["us-east-1a", "us-east-1b"]
    subnets = {
      public = {
        cidr = ["10.0.0.0/24", "10.0.1.0/24"]
        igw  = true
      }
      web = {
        cidr = ["10.0.2.0/24", "10.0.3.0/24"]
        ngw  = true
      }
      app = {
        cidr = ["10.0.4.0/24", "10.0.5.0/24"]
        ngw  = true
      }
      db = {
        cidr = ["10.0.5.0/24", "10.0.6.0/24"]
        ngw  = true
      }
    }
    # Enable VPC Peering between Tools VPC & Project VPC, supply below details of tools vpc only
    # If tools vpc in different account, then you have to create VPC peering manually from AWS console
    peering_vpcs = {
      tools = {
        id              = "vpc-0bb1c79de3EXAMPLE"
        cidr            = "172.31.0.0/16"
        route_table_ids = "rtb-0e1f2g3h4i5j6k7l8"
      }

    }
  }
}

db_servers = {
  rabbitmq = {
    instance_type = "t3.small"
    ports = {
      rabbitmq = {
        port = 5672
        cidr = ["10.0.4.0/24", "10.0.5.0/24"] # only App subnet should have access to DB servers, so we are giving APp subnet CIDR here.
      }
    }
  }

mongodb = {
    instance_type = "t3.small"
    ports = {
      mongodb = {
        port = 27017
        cidr = ["10.0.4.0/24", "10.0.5.0/24"] # only App subnet should have access to DB servers, so we are giving APp subnet CIDR here.
      }
    }
  }

mysql = {
    instance_type = "t3.small"
    ports = {
      mysql = {
        port = 3306
        cidr = ["10.0.4.0/24", "10.0.5.0/24"] # only App subnet should have access to DB servers, so we are giving APp subnet CIDR here.
      }
    }
  }
redis = {
    instance_type = "t3.small"
    ports = {
      redis = {
        port = 6379
        cidr = ["10.0.4.0/24", "10.0.5.0/24"] # only App subnet should have access to DB servers, so we are giving APp subnet CIDR here.
      }
    }
  }
}

eks = {
    main = {
        subnet_ref = "app"
        eks_cluster_version = "1.30"
    }
}