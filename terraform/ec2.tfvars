instances = {

    frontend = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        subnet                      = "public_subnet"
        associate_public_ip_address = true
    }

    auth_service = {
        availability_zone           = "eu-west-2b"
        vpc_security_group          = false
        subnet                      = "private_subnet"
        associate_public_ip_address = false
    }

    discounts_service = {
        availability_zone           = "eu-west-2b"
        vpc_security_group          = false
        subnet                      = "private_subnet"
        associate_public_ip_address = false
    }

    items_service = {
        availability_zone           = "eu-west-2b"
        vpc_security_group          = false
        subnet                      = "private_subnet"
        associate_public_ip_address = false
    }

    haproxy_1 = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        subnet                      = "public_subnet"
        associate_public_ip_address = true
    }
    
    haproxy_2 = {
        availability_zone           = "eu-west-2a"
        vpc_security_group          = true
        subnet                      = "public_subnet"
        associate_public_ip_address = true
    }
}

ami_image     = "ami-01ec84b284795cbc7"
instance_type = "t2.micro"
key_name      = "london_key"
