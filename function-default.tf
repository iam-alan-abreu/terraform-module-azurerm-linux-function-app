resource "azurerm_linux_function_app" "default" {
  for_each            = var.function_apps
  name                = "${local.product}${local.sub_product}-${each.key}-${local.environment}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  service_plan_id     = data.azurerm_service_plan.service_plan.id
  https_only          = true

  functions_extension_version = "~4"
  virtual_network_subnet_id   = data.azurerm_subnet.subnet[each.key].id

  storage_account_name       = azurerm_storage_account.default_storage_account[each.key].name
  storage_account_access_key = azurerm_storage_account.default_storage_account[each.key].primary_access_key

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"                   = "",
    "FUNCTIONS_WORKER_RUNTIME"                   = each.value.function_worker_runtime,
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = each.value.instrumentation_key == null ? "" : each.value.instrumentation_key,
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = each.value.connection_string == null ? "" : each.value.connection_string,
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }

  site_config {
    minimum_tls_version = "1.2"
    always_on           = true

    cors {
      allowed_origins = each.value.cors_allowed_addresses == null ? ["*"] : each.value.cors_allowed_addresses
    }
    app_service_logs {
      disk_quota_mb         = 35
      retention_period_days = 0
    }

    ip_restriction {
      action      = "Allow"
      priority    = 1001
      service_tag = "AppService"
    }
    ip_restriction {
      action      = "Allow"
      priority    = 1000
      service_tag = "AzureDevOps"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  auth_settings {
    enabled                       = true
    unauthenticated_client_action = "AllowAnonymous"
  }

  tags = merge({ "Name" = "func-${local.suffix_name}" }, var.tags, local.tags)

  lifecycle {
    ignore_changes = [
      app_settings,
      sticky_settings,
      site_config["application_stack"]
    ]
  }
}
