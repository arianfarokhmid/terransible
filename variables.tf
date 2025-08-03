variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "hosts" {
  default = "host0"
}
variable "datacenter" {
  default = "Datacenter"
}

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
variable "vm_ip" {}
variable "ipv4_gateway" {}
variable "host_name" {}
variable "domain" {}
variable "hard_disk" {}
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
variable "Datacenter" {}
variable "dns_server_list" {
  type        = list(string)
  description = "List of DNS servers"
  default     = ["185.51.200.2", "178.22.122.100"]
}
variable "ansible_tags" {
  type        = string
  description = "Comma-separated tags to run in the Ansible playbook"
  default     = ""
}
