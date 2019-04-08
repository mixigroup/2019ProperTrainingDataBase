resource "aws_key_pair" "id_db_training" {
  key_name = "id_db_training" # s3://mixi-db-training/config/keys/id_db_training
  public_key = "${file("./tmp/id_db_training.pub")}"
}

resource "aws_instance" "judge_server" {
  depends_on = [
    "aws_subnet.main_subnet_1b"
  ]

  associate_public_ip_address = true
  ami = "ami-0bbe6b35405ecebdb" # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type (ami-0bbe6b35405ecebdb)
  instance_type = "t2.medium"
  key_name  = "${aws_key_pair.id_db_training.key_name}"
  subnet_id = "${aws_subnet.main_subnet_1b.id}"
  associate_public_ip_address = true
  private_ip = "10.0.1.100"
  vpc_security_group_ids = [
    "${aws_security_group.judge_server.id}"
  ]
  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "db-training"
  }
}

output "judge_server_instance_id" {
  value = "${aws_instance.judge_server.id}"
}
