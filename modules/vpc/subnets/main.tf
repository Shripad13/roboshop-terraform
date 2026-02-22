
# SUbnets - 
resource "aws_subnet" "main" {
  count             = length(var.cidr)
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.subnet_name}-${var.env}-${split("-", var.availability_zones[count.index])[2]}"
  }
}


# with above Name , Subnets will be created in AWS 

# With command "terraform console" you can run below command 
#split function-
# > split(",", "foo,bar,baz")
# > split("-", "fo-bar-baz")[1]
# It will print bar, if we give 2 index then it will give baz



# Route tables-

resource "aws_route_table" "main" {
  count = length(var.cidr)

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.subnet_name}-${var.env}-${split("-", var.availability_zones[count.index])[2]}"
  }
}

# ROute Table Association - 

resource "aws_route_table_association" "main" {
  count          = length(var.cidr)
  subnet_id      = aws_subnet.main.*.id[count.index]
  route_table_id = aws_route_table.main.*.id[count.index]

}

# IGW code, IGW only be created for Public Subnet, thats why here addedd condition true/false
resource "aws_internet_gateway" "igw" {

  count = var.subnet_name == "public" ? 1 : 0

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-igw"
  }

}

# Adding Public Route & Public route should only be created for IGW
resource "aws_route" "igw_route" {
  count                  = var.subnet_name == "public" ? length(var.cidr) : 0
  route_table_id         = aws_route_table.main.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.*.id[0] # IGW ID 
}

### Provision NGW - Also NGW only be associated to Public Subnet 

# Below resource is for Elastic IP of NGW
resource "aws_eip" "ngw" {
  count    = var.subnet_name == "public" ? length(var.cidr) : 0
  instance = aws_instance.web.index
  domain   = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  count = var.subnet_name == "public" ? length(var.cidr) : 0

  allocation_id = aws_eip.ngw.*.id[count.index]
  subnet_id     = aws_subnet.main.*.id[count.index]

  tags = {
    Name = "${var.subnet_name}-${var.env}-${split("-", var.availability_zones[count.index])[2]}"
  }

  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route" "igw_route" {
  count                  = var.subnet_name == "public" ? length(var.cidr) : 0
  route_table_id         = aws_route_table.main.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.*.id[count.index] # IGW ID
}

# Adding ROute table of NGW - this route should be created for Web, App & DB Subnets
# Non Public subnet/ Private subnet egress traffic should go to NGW/Internet
resource "aws_route" "ngw_route" {
  count                  = var.subnet_name != "public" ? length(var.cidr) : 0
  route_table_id         = aws_route_table.main.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.ngw_ids[count.index] # NGW ID
}