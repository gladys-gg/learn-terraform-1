# Specify the Terraform provider
provider "aws" {
    region = "us-east-1" 
}

# Define the VPC
resource "aws_vpc" "gladcohort7-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "gladcohort7-vpc"
    }
}

# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.gladcohort7-vpc.id
    tags = {
        Name = "my-igw"
    }
}

# Create a public subnet
resource "aws_subnet" "my_subnet" {
    vpc_id                  = aws_vpc.gladcohort7-vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "us-east-1a" 
    map_public_ip_on_launch = true
    tags = {
        Name = "my-public-subnet"
    }
}

# Create a route table
resource "aws_route_table" "my_route_table" {
    vpc_id = aws_vpc.gladcohort7-vpc.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
    }

    tags = {
    Name = "my-route-table"
    }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "my_route_table_association" {
    subnet_id      = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.my_route_table.id
}
