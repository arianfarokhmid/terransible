variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}

variable "datacenter" {
  default = "Datacenter"
}

variable "vms" {
  description = "List of VMs to create with their target host and IP"
  type = list(object({
    name = string   # VM name
    host = string   # ESXi hostname or IP
    ip   = string   # VM IP
    hard_disk  = string
  }))
}

variable "num_cpus" {
  type = number
}
variable "memory" {
  type = number
}
variable "ipv4_gateway" {}
variable "domain" {}
variable "template_vm_name" {}
variable "hard_disk_size" {
  type = number
}
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
variable "dns_server_list" {
  type        = list(string)
  description = "List of DNS servers"
  default     = ["185.51.200.2", "178.22.122.100"]
}
