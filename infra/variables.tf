variable "pgp_public_key_path" {
  default = "./tmp/hello.public.gpg"
}

variable "usernames" {
  type = "list"
  default = [
    "example"
  ]
}
