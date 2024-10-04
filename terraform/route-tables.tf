resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = each.value.cidr_block
    gateway_id = each.value.gateway_id == true ? aws_internet_gateway.igw.id : aws_nat_gateway.nazgw.id
  }

  tags = {
    Name = each.key
  }

  for_each = var.route-tables
}

resource "aws_route_table_association" "route_association" {
  subnet_id      = aws_subnet.subnet[each.value == true ? "public_subnet" : "private_subnet"].id
  route_table_id = aws_route_table.route_table[each.value == true ? "public_route_table" : "private_route_table"].id

  for_each = var.route-associations
}

