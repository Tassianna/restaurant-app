
key_name = "london_key"

######### Scaling groups & policies

scaling_groups = {
  items = {
    loadbalancer = "" # to be updated after load balancers are created with automation script
    template     = "items_ami_template"
  }
  discounts = {
    loadbalancer = "" # to be updated after load balancers are created with automation script
    template     = "discounts_ami_template"
  }
  auth = {
    loadbalancer = "" # to be updated after load balancers are created with automation script
    template     = "auth_ami_template"
  }
}

launch_templates = {
  items = {
    name = "items_template"
    ami_name = "items_ami"
  }
  discounts = {
    name = "discounts_template"
    ami_name = "discounts_ami"
  }
  auth = {
    name = "auth_template"
    ami_name = "auth_ami"
  }
}


images = {
  items     = {
    name = "items_ami"
    source_instance_id = ""
  } 
  auth      = {
    name = "auth_ami"
    source_instance_id = ""
  } 
  discounts = {
    name = "discounts_ami"
    source_instance_id = ""
  }  
}
