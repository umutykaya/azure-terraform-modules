variable "name" {
  description = "Key Vault name."
  type        = string
}

variable "resource_group_name" {
  description = "Target resource group."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID."
  type        = string
}

variable "deployer_object_id" {
  description = "Object ID of the identity running terraform apply."
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU (standard or premium)."
  type        = string
  default     = "standard"
}

variable "purge_protection_enabled" {
  description = "Enable purge protection (set true for prod)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply."
  type        = map(string)
  default     = {}
}
