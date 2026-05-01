variable "location" {
  type = string
  default = "swedencentral"
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "docker_image" {
  type = string
}

variable "subscription_id" {
    type = string 
}