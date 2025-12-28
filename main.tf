data "vsphere_datacenter" "datacenter" {
  name = var.Datacenter
}

# --------------------
# Datastore 1 - SSD (OS)
# --------------------
data "vsphere_datastore" "ds1" {
  name          = var.datastore_1
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# --------------------
# Datastore 2 - DATA
# --------------------
data "vsphere_datastore" "ds2" {
  name          = var.datastore_2
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
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
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  num_cpus = var.num_cpus
  memory   = var.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  # --------------------
  # Disk 0 - OS (SSD)
  # --------------------
  disk {
    label            = "disk0"
    size             = var.disk_size1
    datastore_id     = data.vsphere_datastore.ds1.id
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    unit_number      = 0
  }

  # --------------------
  # Disk 1 - DATA
  # --------------------
  disk {
    label            = "disk1"
    size             = var.disk_size2
    datastore_id     = data.vsphere_datastore.ds2.id
    thin_provisioned = true
    unit_number      = 1
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