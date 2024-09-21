resource "azurerm_storage_account" "default_storage_account" {
  for_each                 = var.function_apps
  name                     = substr(replace("${var.environment}${local.zone}${local.product}${each.key}", "-", ""), 0, min(24, length(replace("${var.environment}${local.zone}${local.product}${each.key}", "-", ""))))
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  tags = merge({ "Name" = "stg-${local.suffix_name}" }, var.tags, local.tags)
}
