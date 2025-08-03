#terraform {
#  backend "nexus" {
#    url      = "http://127.0.0.1:8081/repository/"
#    repo     = "terraform" 
#    subpath  = "example"
#    username = "admin"
#    password = "a9bd9cdf-30b9-4ed2-926d-106956962451"
#  }
#}
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
  api_timeout          = 10
}


