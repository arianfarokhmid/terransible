variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}

variable "resource_name" {}

variable "vm_count" {
  type = number
}

variable "num_cpus" {
  type = number
}

variable "memory" {
  type = number
}

variable "vm_ip" {
  type = list(string)
}

variable "ipv4_gateway" {}
variable "host_name" {}
variable "domain" {}

# --------------------
# Datastores
# --------------------
variable "datastore_1" {
  description = "OS disk datastore (SSD)"
}

variable "datastore_2" {
  description = "Data disk datastore"
}

# --------------------
# Disk sizes (GB)
# --------------------
variable "disk_size1" {
  type = number
}

variable "disk_size2" {
  type = number
}

variable "template_vm_name" {}
variable "vsphere_compute_cluster" {}
variable "vsphere_network" {}

variable "ssh_user" {
  type      = string
  sensitive = true
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

variable "Datacenter" {}

variable "dns_server_list" {
  type        = list(string)
  default     = ["185.51.200.2", "178.22.122.100"]
}

variable "ansible_tags" {
  type    = string
  default = ""
}