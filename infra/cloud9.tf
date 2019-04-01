resource "aws_cloud9_environment_ec2" "environments" {
  depends_on = [
    "aws_iam_user.iam_users",
    "aws_subnet.main_subnet_1a"
  ]

  count         = "${length(var.usernames)}"
  instance_type = "t2.medium"
  name          = "db.${element(var.usernames, count.index)}"
  description   = "Environment for DB training"
  owner_arn     = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:user/db.${element(var.usernames, count.index)}"
  subnet_id     = "${aws_subnet.main_subnet_1a.id}"
  automatic_stop_time_minutes = 30
}

output "cloud9_environments" {
  value = "${aws_cloud9_environment_ec2.environments.*.id}"
}
