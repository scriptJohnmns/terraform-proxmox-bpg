module "vms" {
  source   = "./modules/vm"
  for_each = var.vms

  name      = each.key
  node_name = var.node_name
  vm_id     = each.value.vm_id

  base_template_id    = var.base_template_id
  cpu_cores           = each.value.cpu_cores
  cpu_type            = each.value.cpu_type
  memory_mb           = each.value.memory_mb
  disk_size           = each.value.disk_size
  disk_datastore      = var.disk_datastore
  cloudinit_datastore = var.cloudinit_datastore

  network_bridge = "vmbr0"
  ipv4_address   = each.value.ipv4_address

  username         = "ubuntu"
  ssh_public_key   = var.ssh_public_key
  ssh_private_key  = var.ssh_private_key
}
