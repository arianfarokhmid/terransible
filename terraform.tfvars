vsphere_user            = "administrator@vsphere.local"
vsphere_password        = "----"
vsphere_server          = "192.168.7.8"

resource_name           = "test-tf"
vm_count                = 1
num_cpus                = 8
memory                  = 8192

vm_ip                   = ["192.168.7.65"]
ipv4_gateway            = "192.168.7.1"

host_name               = "test-tf"
domain                  = "domain"

# --------------------
# Datastores
# --------------------
datastore_1                  = "SSD-2TB_174"
datastore_2                  = "HDD-4TB_01"

# --------------------
# Disk sizes (GB)
# --------------------
disk_size1              = 50
disk_size2              = 200          

template_vm_name        = "template-beroozresaan"
vsphere_compute_cluster = "Mtyn Cluster-1"
vsphere_network         = "Beroozresaan"

ssh_user                = "support"
ssh_password            = "------"

Datacenter              = "Mtyn DataCenter"

dns_server_list         = ["185.51.200.2", "178.22.122.100"]
ansible_tags            = "create-user,redis-single-node"
