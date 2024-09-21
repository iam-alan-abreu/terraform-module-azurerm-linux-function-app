output "default_hostname" {
  value = [for function in azurerm_linux_function_app.default : function.default_hostname]
}

output "kind" {
  value = [for function in azurerm_linux_function_app.default : function.kind]
}

output "default_canary" {
  value = [for function in azurerm_linux_function_app_slot.default_canary : function.default_hostname]
}
