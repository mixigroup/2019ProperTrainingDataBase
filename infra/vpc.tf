resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "db-training"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "db-training-igw"
  }
}

resource "aws_subnet" "main_subnet_1a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-2a"
  tags {
    Name = "db-training-subnet-1a"
  }
}

resource "aws_subnet" "main_subnet_1b" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2b"
  tags {
    Name = "db-training-subnet-1b"
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main_igw.id}"
  }
  tags {
    Name = "db-training-route"
  }
}

resource "aws_route_table_association" "main_route_table_association_1a" {
  subnet_id = "${aws_subnet.main_subnet_1a.id}"
  route_table_id = "${aws_route_table.main_route_table.id}"
}

resource "aws_route_table_association" "main_route_table_association_1b" {
  subnet_id = "${aws_subnet.main_subnet_1b.id}"
  route_table_id = "${aws_route_table.main_route_table.id}"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "db-training-default-sg"
  }
}

resource "aws_security_group" "user" {
  vpc_id = "${aws_vpc.main.id}"
  name = "db-training-sg-judge-user"
}

resource "aws_security_group_rule" "user_allow_mysql" {
  security_group_id = "${aws_security_group.user.id}"

  type = "ingress"
  from_port = 0
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.judge_server.id}"
}

resource "aws_security_group_rule" "user_allow_web" {
  security_group_id = "${aws_security_group.user.id}"

  type = "ingress"
  from_port = 0
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.judge_server.id}"
}

resource "aws_security_group" "judge_server" {
  vpc_id = "${aws_vpc.main.id}"
  name = "db-training-sg-judge-server"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.super.id}"
    ]
  }

  ingress {
    from_port = 0
    to_port = 8080
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.super.id}",
      "${aws_security_group.user.id}"
    ]
  }

  ingress {
    from_port = 0
    to_port = 18080
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.super.id}",
      "${aws_security_group.user.id}"
    ]
  }

  ingress {
    from_port = 0
    to_port = 28080
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.super.id}",
      "${aws_security_group.user.id}"
    ]
  }

  ingress {
    from_port = 0
    to_port = 3306
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.super.id}",
      "${aws_security_group.user.id}"
    ]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    security_groups = [
      "${aws_security_group.super.id}",
      "${aws_security_group.user.id}"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "db-training-judge-server-sg"
  }
}

resource "aws_security_group" "super" {
  vpc_id = "${aws_vpc.main.id}"
  name = "db-training-sg-judge-super"
  tags {
    Name = "db-training-super-sg"
  }
}


output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "security_group_user" {
  value = "${aws_security_group.user.id}"
}
