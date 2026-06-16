variable "location" {
  description = "Azure region to deploy resources."
  type        = string
  default     = "westeurope"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Short project name used for resource naming."
  type        = string
  default     = "myproject"
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
  }
}