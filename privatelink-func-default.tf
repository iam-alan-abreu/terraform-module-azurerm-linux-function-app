resource "azurerm_private_endpoint" "default_privateendpoint" {
  for_each            = var.private_endpoints
  name                = "pvt-${local.location}-${local.zone}-${local.product}${local.sub_product}-${each.key}-${local.environment}${local.suffix}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.subnet_privlink[each.key].id

  dynamic "private_dns_zone_group" {
    for_each = (contains(each.value.subresource_names, "sites") ? [1] : [])

    content {
      name                 = each.value.name
      private_dns_zone_ids = [data.azurerm_private_dns_zone.default_dns_zone_app[each.key].id]
    }
  }

  private_service_connection {
    name                           = each.value.name
    private_connection_resource_id = azurerm_linux_function_app.default[each.key].id
    subresource_names              = each.value.subresource_names
    is_manual_connection           = false
  }

  tags = merge(
    { name = "pvt-${local.location}-${local.zone}-${local.product}-${each.key}-${local.environment}${local.suffix}" },
    each.value.tags,
    local.tags
  )
}