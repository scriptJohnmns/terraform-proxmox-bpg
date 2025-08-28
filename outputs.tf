output "vm_names" {
  value = [for vm in module.vms : vm.name]
}

output "vm_ids" {
  value = [for vm in module.vms : vm.vm_id]
}
