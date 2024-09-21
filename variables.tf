variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Resource group name of the SQL server to be provisioned."
}

variable "resource_group_location" {
  type        = string
  default     = "useast"
  description = "Resource group location of the SQL server to be provisioned."
}

# variable "storage_account_name" {
#   type        = string
#   default     = "foo"
#   description = "Function storage account name."
# }

variable "storage_account_tier" {
  type        = string
  default     = "Standard"
  description = "Function storage account tier."
}

variable "storage_account_replication_type" {
  type        = string
  default     = "LRS"
  description = "Function storage account replication type."
}



variable "service_plan_name" {
  type        = string
  description = "Service plan name."
}

variable "service_plan_resource_group_name" {
  type        = string
  description = "Service plan resource group name."
}

variable "function_apps" {
  type = map(object({
    subnet_name              = string
    vnet_resource_group_name = string
    vnet_name                = string
    function_worker_runtime  = string
    enabled_canary           = bool
    cors_allowed_addresses   = optional(list(string))
    instrumentation_key      = optional(string)
    connection_string        = optional(string)
    tags                     = optional(map(any))
  }))
  default     = {}
  description = "Function apps to be provisioned."
}

variable "private_endpoints" {
  type = map(object({
    name                     = string
    subnet_name              = string
    vnet_name                = string
    vnet_resource_group_name = string
    subresource_names        = list(string)
    tags                     = optional(map(any))
  }))
  default     = {}
  description = "Private Endpoints."
}

# IAC COMMON VARIABLES
variable "name" {
  type        = string
  description = "The name which should be used for this Resource."
}
variable "location" {
  type        = string
  description = "The azure region where the Resource should exist"
}
variable "environment" {
  type        = string
  description = "Tags which should be assigned to the Resource"
}
variable "landingzone" {
  type        = string
  description = "Zone which should be assigned to the Resource"
}
variable "product" {
  type        = string
  description = "Product which should be assigned to the Resource"
}
variable "sub_product" {
  type        = string
  description = "Product which should be assigned to the Resource"
  default     = ""
}
variable "use_suffix" {
  description = "Controls if suffix should be append at name"
  type        = bool
  default     = false
}
variable "suffix" {
  type        = string
  default     = "001"
  description = "The suffix which should be used for this Resource."
}
variable "tags" {
  type        = map(any)
  default     = {}
  description = "The tag which should be used for this Resource Group."
}
