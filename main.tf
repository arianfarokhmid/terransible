data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  for_each         = { for vm in var.vms : vm.name => vm }
  name          = each.value.hard_disk
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "MTYN" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_vm_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# one data lookup per VM host
data "vsphere_host" "esxi" {
  for_each      = { for vm in var.vms : vm.name => vm }
  name          = each.value.host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# create VM on correct host
resource "vsphere_virtual_machine" "vm" {
  for_each         = { for vm in var.vms : vm.name => vm }
  name             = each.value.name
  resource_pool_id = data.vsphere_compute_cluster.MTYN.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore[each.key].id
  host_system_id   = data.vsphere_host.esxi[each.key].id

  num_cpus = var.num_cpus
  memory   = var.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = each.value.name
        domain    = var.domain
      }
      network_interface {
        ipv4_address = each.value.ip
        ipv4_netmask = 24
      }
      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = var.dns_server_list
    }
  }
}

# wait for guest customization
# resource "time_sleep" "wait_1_min" {
#   depends_on      = [vsphere_virtual_machine.vm]
#   create_duration = "1m"
# }

# simple remote exec on each VM
# resource "null_resource" "after" {
#   for_each = vsphere_virtual_machine.vm
#   depends_on = [time_sleep.wait_1_min]

#   provisioner "remote-exec" {
#     inline = [
#       "echo '${var.ssh_password}' | sudo -S apt update"
#     ]
#     connection {
#       type     = "ssh"
#       user     = var.ssh_user
#       password = var.ssh_password
#       host     = each.value.clone[0].customize[0].network_interface[0].ipv4_address
#       timeout  = "10m"
#     }
#   }
# }

# run ansible playbook on each VM
# resource "null_resource" "run_ansible" {
#   for_each = vsphere_virtual_machine.vm

#   provisioner "local-exec" {
#     command = <<EOT
#       export ANSIBLE_HOST_KEY_CHECKING=False
#       ansible-playbook -i "${each.value.clone[0].customize[0].network_interface[0].ipv4_address}," add-user.yml \
#         --user ${var.ssh_user} \
#         --extra-vars '{"ansible_ssh_pass": "${var.ssh_password}", "ansible_become_pass": "${var.ssh_password}"}' \
#         --connection=ssh
#     EOT
#   }
# }