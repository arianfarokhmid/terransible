data "vsphere_datacenter" "datacenter" {
  name = "Mtyn DataCenter"
}

data "vsphere_datastore" "datastore" {
  name          = var.hard_disk
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

resource "vsphere_virtual_machine" "vm" {
  count            = length(var.vm_ip)
  name             = "${var.resource_name}-${count.index}"
  resource_pool_id = data.vsphere_compute_cluster.MTYN.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = var.num_cpus
  memory   = var.memory

  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size  = var.hard_disk_size
    #size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.host_name}-${count.index}"
        domain    = var.domain

      }
      network_interface {
        ipv4_address = var.vm_ip[count.index]
        ipv4_netmask = 24
      }
      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = var.dns_server_list



    }
  }
}
resource "time_sleep" "wait_1_min" {
  depends_on = [vsphere_virtual_machine.vm]

  create_duration = "1m"
}

resource "null_resource" "after" {
  depends_on = [time_sleep.wait_1_min]
  count      = length(var.vm_ip)
  provisioner "remote-exec" {
    inline = [
      "echo '${var.ssh_password}' | sudo -S apt update",
      #"echo '${var.ssh_password}' | sudo -S apt install lynis -y"
    ]
    connection {
      type     = "ssh"
      user     = var.ssh_user
      password = var.ssh_password
      host     = var.vm_ip[count.index]
      timeout  = "10m"
    }
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"

  content = <<EOT
[cluster_nodes]
%{for idx, ip in var.vm_ip~}
node${idx + 1} ansible_host=${ip}
%{endfor}

[all:vars]
project_dir=/opt/project
ansible_user=${var.ssh_user}
ansible_ssh_pass=${var.ssh_password}
ansible_become_pass=${var.ssh_password}
EOT
}


resource "null_resource" "run_ansible" {
  depends_on = [vsphere_virtual_machine.vm]
  provisioner "local-exec" {
    command = <<EOT
      export ANSIBLE_HOST_KEY_CHECKING=False
      ansible-playbook -i inventory.ini playbook.yml \
        --user ${var.ssh_user} \
        --extra-vars '{"ansible_ssh_pass": "${var.ssh_password}", "ansible_become_pass": "${var.ssh_password}"}' \
        --connection=ssh --tags ${var.ansible_tags}
    EOT
  }
}

