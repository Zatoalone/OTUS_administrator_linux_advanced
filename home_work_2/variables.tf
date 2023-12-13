variable "zone" {
  type    = string
  default = "ru-central1-c"
}

# yandex auth token
variable "auth_token" {
  type    = string
  default = "<auth token>"
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

variable "image_id" {
  type = string
  default = "fd8kd2sk87mj3bn7ccc2" # Centos 8
}

variable "ssh_user"{
  type = string
  default = "cl-user"
}