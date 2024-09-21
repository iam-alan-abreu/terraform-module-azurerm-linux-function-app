data "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name
  resource_group_name = var.service_plan_resource_group_name
}

data "azurerm_subnet" "subnet" {
  for_each             = var.function_apps
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.vnet_resource_group_name
}

data "azurerm_subnet" "subnet_privlink" {
  for_each             = var.private_endpoints
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.vnet_resource_group_name
}

data "azurerm_private_dns_zone" "default_dns_zone_app" {
  for_each            = var.private_endpoints
  name                = "privatelink.azurewebsites.net"
  resource_group_name = each.value.vnet_resource_group_name
}