variable "location" {
  description = "Set a Location for creating the resources"
  type = string
}

variable "rg_name" {
  description = "Resource Group name shoud be meaningful"
  type = string
}

variable "vnet_name" {
  description = "vnet"
  type = string
}

variable "vnet_address_range" {
  description = "CIDR"
  type = list(string)
}

variable "subnet_name" {
  description = "subnet"
  type = string
}
variable "subnet_address_range" {
  description = "CIDR"
  type = list(string)
}

variable "nic_name" {
  description = "netwirk interface name"
  type = string
}

variable "nic_ip_config_name" {
  description = "name"
  type = string
}

variable "nic_ip_address_allocation" {
  description = "ip allocation"
  type = string
}

variable "vm_name" {
  description = "virtual machine name"
  type = string
}

variable "vm_size" {
  description = "virtual machine size"
  type = string
}

variable "vm_admin_user" {
  description = "admin_username"
  type = string
}

variable "vm_os_publisher" {
  description = "publisher"
  type = string
}

variable "vm_os_offer" {
  description = "offer"
  type = string
}

variable "vm_os_sku" {
  description = "sku"
  type = string
}

variable "vm_os_version" {
  description = "version"
  type = string
}






