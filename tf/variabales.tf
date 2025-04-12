# Params file for variables

variable "image_name" {
  type    = string
  default = "ununtu-22.04"
}

#### VM parameters
variable "server_flavor" {
  type    = string
  default = "m1.small"
}

variable "key_pair" {
  default = "2025-cherepanov"
}

# Network params
variable "security_group" {
  default = "default"
}

variable "network_name" {
  default = "sutdents-net"
}


# export TF_VAR_user_name=
variable "user_name" {
}
# export TF_VAR_password=
variable "password" {
}
