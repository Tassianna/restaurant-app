resource "aws_nat_gateway" "nazgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnet["public_subnet"].id
  tags = {
    Name = "natgw"
  }
}