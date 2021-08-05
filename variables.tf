variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "udacity-nd82-project-1"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "westeurope"
}

variable "username" {
  default = "daniel"
}

variable "password" {
  default = "n1NsO34$nT9kF2Qq"
}

variable "packer_image" {
  default = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-project-1-rg/providers/Microsoft.Compute/images/myPackerImage"
}

variable "vm_count" {
  default = "2"
}

variable "server_name" {
  type = list
  default = ["server1", "server2"]
}