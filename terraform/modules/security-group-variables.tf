variable "public_sg_name" {
    type = string
}
variable "private_sg_name" {
    type = string
}
variable "private_sg_name" {
    type = string
}

variable "security_groups" {
    type = map(object({
        desc = string
        vpc_id = string
        ingress = map(object({
            description = string
            from_port = number
            to_port = number
            protocol = string
            cidr_blocks = list(string)
        }))
        egress = map(object({
            description = string
            from_port = number
            to_port = number
            protocol = string
            cidr_blocks = list(string)
        }))
    }))
}