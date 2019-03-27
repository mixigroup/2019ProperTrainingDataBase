resource "aws_iam_user" "iam_users" {
  count = "${length(var.usernames)}"
  name  = "db.${element(var.usernames, count.index)}"
  force_destroy  = true
}

resource "aws_iam_user_login_profile" "login_profiles" {
  depends_on = ["aws_iam_user.iam_users"]

  count   = "${length(var.usernames)}"
  user    = "db.${element(var.usernames, count.index)}"
  pgp_key = "${base64encode(file(var.pgp_public_key_path))}"
  password_reset_required = false
}

resource "aws_iam_group" "iam_group" {
  depends_on = ["aws_iam_user.iam_users"]

  name = "db-training-cloud9-users"
}

resource "aws_iam_user_group_membership" "iam_user_group" {
  depends_on = [
    "aws_iam_user.iam_users",
    "aws_iam_group.iam_group"
  ]

  count = "${length(var.usernames)}"
  user = "db.${element(var.usernames, count.index)}"
  groups = ["${aws_iam_group.iam_group.name}"]
}

resource "aws_iam_group_policy_attachment" "iam_group_policy_attachment" {
  depends_on = ["aws_iam_group.iam_group"]

  group      = "db-training-cloud9-users"
  policy_arn = "arn:aws:iam::aws:policy/AWSCloud9EnvironmentMember"
}

output "users" {
  value = "${aws_iam_user.iam_users.*.name}"
}

output "passwords" {
  value = "${aws_iam_user_login_profile.login_profiles.*.encrypted_password}"
}
