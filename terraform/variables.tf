variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "EC2 Key Pair name"
}

variable "public_key_path" {
  description = "Path to your public key file"
}
