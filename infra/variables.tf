variable "pgp_public_key_path" {
  default = "./tmp/hello.public.gpg"
}

variable "SERVER_INSTANCE_TYPE" {
  default = "t2.nano"
}

variable "usernames" {
  type = "list"
  default = [
    "example"
  ]
}
