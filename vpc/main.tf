provider "aws" {
    region = var.region_name
}

resource "aws_vpc" "main_vpc" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.env_name}-${var.region_name}-vpc"
    }
}

resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "${var.vpc_name}-igw"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main_vpc.id
    count = length(var.cidrs_for_public_subnets)
    cidr_block = var.cidrs_for_public_subnets[count.index]
    map_public_ip_on_launch = true
    availability_zone = "${var.region_name}${var.availabilityzone_suffix[count.index]}"

    tags = {
        Name = "${var.vpc_name}-public-subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main_vpc.id
    count = length(var.cidrs_for_private_subnets)
    cidr_block = var.cidrs_for_private_subnets[count.index]
    availability_zone = "${var.region_name}${var.availabilityzone_suffix[count.index]}"

    tags = {
        Name = "${var.vpc_name}-private-subnet"
    }
}

#locals { ##  Did not want to use locals for now
#  # Combine AZs with public subnet IDs for the for_each loop
#  nat_gateway_config = { for i, az in var.availabilityzone_suffix : az => {
#    public_subnet_id = aws_subnet.public_subnet[i].id
#    private_subnet_id = aws_subnet.private_subnet[i].id
#    }
#  } 
#}

resource "aws_nat_gateway" "main_nat_gw_private" {
    connectivity_type = "private"
    count             = length(var.availabilityzone_suffix)
    subnet_id         = aws_subnet.private_subnet[count.index].id

    tags = {
        Name = "${var.vpc_name}-private-nat-gw"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_igw.id
    }

    tags = {
        Name = "${var.vpc_name}-public-rt"
    }
}

# Associate the public route table with the public subnet

resource "aws_route_table_association" "public_assoc" {
    count = length(aws_subnet.public_subnet)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main_vpc.id
    count = length(var.availabilityzone_suffix)

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main_nat_gw_private[count.index].id
    }

    tags = {
        Name = "${var.vpc_name}-private-rt"
    }
}


# Associate the private route table with the private subnet

resource "aws_route_table_association" "private_assoc" {
    count = length(aws_subnet.private_subnet)
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_rt[count.index].id
}

