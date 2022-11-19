# Allocate Elastic IP Address (EIP 1)
# terraform aws allocate elastic ip
resource "aws_eip" "eip_for_nat_gateway_az1" {
  vpc    = true

  tags   = {
    Name = "EIP 1"
  }
}

# Allocate Elastic IP Address (EIP 2)
# terraform aws allocate elastic ip
resource "aws_eip" "eip_for_nat_gateway_az2" {
  vpc    = true

  tags   = {
    Name = "EIP 2"
  }
}

# Create Nat Gateway 1 in Public Subnet 1
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = var.public_subnet_1az_id

  tags   = {
    Name = "Nat Gateway Public Subnet 1"
  }
  # to ensure proper ordering 
  depends_on = [
    var.internet_gateway
  ]
}

# Create Nat Gateway 2 in Public Subnet 2
# terraform create aws nat gateway
resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = var.public_subnet_2az_id

  tags   = {
    Name = "Nat Gateway Public Subnet 2"
  }
  # to ensure proper ordering 
  depends_on = [
    var.internet_gateway
  ]
}

# Create Private Route Table 1 and Add Route Through Nat Gateway 1
# terraform aws create route table
resource "aws_route_table" "private_route_table_1" {
  vpc_id            = var.vpc-id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_1.id
  }

  tags   = {
    Name = "Private Route Table 1"
  }
}

# Associate Private app Subnet 1 with "Private Route Table 1"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private_app_subnet_1_route_table_association" {
  subnet_id         = var.private_app_subnet_1az_id
  route_table_id    = aws_route_table.private_route_table_1.id
}

# Associate Private data Subnet 1 with "Private Route Table 1"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private_data_subnet_1_route_table_association" {
  subnet_id         = var.private_data_subnet_1az_id
  route_table_id    = aws_route_table.private_route_table_1.id
}

# Create Private Route Table 2 and Add Route Through Nat Gateway 2
# terraform aws create route table
resource "aws_route_table" "private_route_table_2" {
  vpc_id            = var.vpc-id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_2.id
  }

  tags   = {
    Name = "Private Route Table 2"
  }
}

# Associate Private app Subnet 2 with "Private Route Table 2"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private_app_subnet_2_route_table_association" {
  subnet_id         = var.private_app_subnet_2az_id
  route_table_id    = aws_route_table.private_route_table_2.id
}

# Associate Private data Subnet 2 with "Private Route Table 2"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private_data_subnet_2_route_table_association" {
  subnet_id         = var.private_data_subnet_2az_id
  route_table_id    = aws_route_table.private_route_table_2.id
}
