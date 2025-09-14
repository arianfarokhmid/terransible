vsphere_user            = "administra@vsphere.local"
vsphere_password        = "-----------"
vsphere_server          = "vcenter.mtyn.test"
datacenter              = "Mtyn DataCenter"

vsphere_compute_cluster = "Mtyn Cluster-1"
vsphere_network         = "VM Network"
hard_disk_size          = 50
template_vm_name        = "DevOps-Template"
domain                  = "localhost"

num_cpus                = 2
memory                  = 4096

ssh_user                = "support"
ssh_password            = "1234"

ipv4_gateway    = "192.168.7.1"
dns_server_list = ["185.51.200.2", "178.22.122.100"]

vms = [
  { name = "test-tf-a", host = "192.168.7.70" , ip = "192.168.10.112" , hard_disk="HDD-10K-R5" },
  { name = "test-tf-b", host = "192.168.7.174", ip = "192.168.10.113" , hard_disk="R5-HDD-15K" },
  { name = "test-tf-c", host = "192.168.7.200", ip = "192.168.10.114" , hard_disk="ROUTAA-STAGE-R5-HDD" }
]