# ssh private key file
variable "private_key_path" {
  type    = string
  default = "<path to private key file>"
}

# ssh public key 
variable "public_key" {
  type    = string
  default = "<public key>"
}

# yandex auth token
variable "auth_token" {
  type    = string
  default = "auth token"
}

# yandex cloud id
variable "cloud_id_variable" {
  type    = string
  default = "<cloud id>"
}

# yandex folder id
variable "folder_id_variable" {
  type    = string
  default = "<folder id>"
}
