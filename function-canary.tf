resource "azurerm_linux_function_app_slot" "default_canary" {
  for_each        = { for function_app, values in var.function_apps : function_app => values if values.enabled_canary }
  name            = "canary"
  function_app_id = azurerm_linux_function_app.default[each.key].id

  virtual_network_subnet_id = data.azurerm_subnet.subnet[each.key].id

  storage_account_name       = azurerm_storage_account.default_storage_account[each.key].name
  storage_account_access_key = azurerm_storage_account.default_storage_account[each.key].primary_access_key

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"                   = "",
    "FUNCTIONS_WORKER_RUNTIME"                   = each.value.function_worker_runtime,
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = each.value.instrumentation_key == null ? "" : each.value.instrumentation_key,
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }

  site_config {
    minimum_tls_version = "1.2"

    cors {
      allowed_origins = each.value.cors_allowed_addresses
    }
    ip_restriction {
      action      = "Allow"
      priority    = 1001
      service_tag = "AppService"
    }
  }

  auth_settings {
    enabled                       = true
    unauthenticated_client_action = "AllowAnonymous"
  }

  tags = each.value.tags == null ? {} : each.value.tags

  lifecycle {
    ignore_changes = [
      app_settings,
      site_config,
    ]
  }
}
