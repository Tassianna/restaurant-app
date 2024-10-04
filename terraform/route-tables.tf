resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = each.value.cidr_block
    gateway_id = each.value.gateway_id
  }

  tags = {
    Name = each.key
  }

  for_each = var.route-tables
}

resource "aws_route_table_association" "route_association" {
  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id

  for_each = var.route-tables
}

