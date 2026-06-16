variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the data platform resources will be created."
  default     = "rg-mad-platform"
}

variable "location" {
  type        = string
  description = "The location of the resource group where the data platform resources will be created."
  default     = "westus2"
}

variable "environment" {
  type        = string
  description = "The environment for which the data platform resources will be created."
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "The name of the project for which the data platform resources will be created."
  default     = "mad-platform"
}

variable "subscription_id" {
  type        = string
  description = "The subscription ID for the Azure account."
  default     = "98014c53-83b7-4bfb-a4a4-2e31b0f22465"
}
